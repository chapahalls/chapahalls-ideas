#!/bin/sh
# Checagem mecânica das regras do Hack Brasil 2026 (ver HACKATHON.md).
# Cobre só o que dá para checar do terminal; a pontuação (H1-H4) e o resto ficam com o agente `judge`.
#
# Uso: sh scripts/check-rules.sh <repo> [<repo> ...]   (caminhos de clones locais dos repositórios entregues)
#      sh scripts/check-rules.sh                          (sem argumento: procura ../rodar-backend, ../rodar-web, ../rodar-mobile
#                                                          e ../rodarglobal/<repo>; senão, checa o repositório atual)
# Sai com 1 se houver FALHA. Usa git, grep e (opcional) curl para a API pública do GitHub.

OPEN=1793836800      # 2026-11-04 21:00 -03 (fim da sessão de abertura): repos e commits só depois disso (X1)
DEADLINE=1796093999  # 2026-11-30 23:59:59 -03: fim das submissões (X7)
FINAL=1797044400     # 2026-12-12 00:00 -03: fim do congelamento (X8)
PUBLIC_UNTIL="15/12/2026"

fails=0; warns=0
ok()   { printf '  OK     %s\n' "$*"; }
warn() { printf '  RISCO  %s\n' "$*"; warns=$((warns + 1)); }
fail() { printf '  FALHA  %s\n' "$*"; fails=$((fails + 1)); }

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
if [ "$#" -eq 0 ]; then
  for r in rodar-backend rodar-web rodar-mobile; do
    for base in "$root/.." "$root/../rodarglobal"; do
      [ -d "$base/$r/.git" ] && { set -- "$@" "$base/$r"; break; }
    done
  done
  [ "$#" -eq 0 ] && set -- "$root"
fi

now=$(date +%s)

check_repo() {
  dir=$1
  cd "$dir" || { fail "não achei $dir"; return; }
  name=$(basename "$(git rev-parse --show-toplevel)")
  echo
  echo "######## $name ($dir)"

  tracked() { git ls-files 2>/dev/null | grep -v -e 'check-rules\.sh$'; }
  code_files() { tracked | grep -v -E '\.(md|txt)$|^\.claude/|^\.github/|^evidence/|^ideas/|^docs/'; }

  echo "== X1 · Repositório novo (criado e com commits depois de 04/11 21h)"
  [ "$(git rev-parse --is-shallow-repository 2>/dev/null)" = "true" ] && \
    git fetch -q --depth=5000 origin 2>/dev/null
  first=$(git log --reverse --format='%ct %h %s' 2>/dev/null | head -1)
  first_ts=${first%% *}
  if [ -z "$first_ts" ]; then
    fail "sem commits"
  elif [ "$first_ts" -lt "$OPEN" ]; then
    fail "primeiro commit anterior à abertura: $first"
  else
    ok "primeiro commit em $(date -d "@$first_ts" '+%d/%m/%Y %H:%M' 2>/dev/null || echo "$first_ts")"
  fi
  old=$(git log --format='%ct %h %s' 2>/dev/null | awk -v o="$OPEN" '$1 < o' | head -3)
  [ -n "$old" ] && { fail "commits anteriores a 04/11 21h (histórico importado?):"; printf '         %s\n' "$old"; }
  [ "$(git rev-parse --is-shallow-repository 2>/dev/null)" = "true" ] && \
    warn "clone ainda raso: a data do primeiro commit pode não ser a real"

  echo "== X4 · Público no GitHub (e não é fork)"
  remote=$(git remote get-url origin 2>/dev/null)
  slug=$(printf '%s' "$remote" | sed -n -E 's#.*github\.com[:/]([^/]+/[^/.]+)(\.git)?$#\1#p')
  if [ -z "$slug" ]; then
    fail "remote não é GitHub: a entrega exige repositório público no GitHub"
  elif command -v curl >/dev/null 2>&1; then
    meta=$(curl -s "https://api.github.com/repos/$slug")
    case "$meta" in
      *'"full_name"'*)
        ok "github.com/$slug está público (manter até $PUBLIC_UNTIL)"
        printf '%s' "$meta" | grep -q '"fork": *true' && fail "é fork: desclassifica (item 6.1)"
        created=$(printf '%s' "$meta" | sed -n -E 's/.*"created_at": *"([^"]+)".*/\1/p' | head -1)
        if [ -n "$created" ]; then
          cts=$(date -d "$created" +%s 2>/dev/null)
          [ -n "$cts" ] && [ "$cts" -lt "$OPEN" ] && fail "repo criado em $created, antes da abertura" || ok "repo criado em $created"
        fi ;;
      *'Not Found'*) fail "github.com/$slug não está acessível sem login (privado?)" ;;
      *) warn "não consegui checar github.com/$slug pela API (limite ou rede)" ;;
    esac
  fi

  echo "== X3 · Licença"
  if ls LICENSE* >/dev/null 2>&1; then ok "tem $(ls LICENSE* | head -1)"; else warn "sem LICENSE: não é exigida, mas é recomendada (item 6.6)"; fi

  echo "== S4/S5 · README para o júri (que pode não instalar nada)"
  if [ ! -f README.md ]; then
    fail "README.md não existe"
  else
    grep -qiE '^#+ .*(como rodar|rodar localmente|executar|execução|rodando|run|getting started|quickstart|instala)' README.md \
      && ok "README tem instruções de execução" || warn "README sem seção de execução"
    grep -qiE '^#+ .*(depend|requisitos|requirements|pré-requisitos|stack)' README.md \
      && ok "README lista dependências" || warn "README sem seção de dependências"
    grep -qiE 'https://[^ )]*(demo|vercel|netlify|render|fly\.dev|railway|pages\.dev|github\.io|onrender)' README.md \
      && ok "README tem link de demo HTTPS" || warn "README sem link da demo no ar: o júri avalia pela demo e pelo vídeo (itens 7.3, 7.4)"
    grep -qiE '(youtu\.?be|vimeo|loom\.com|drive\.google)' README.md \
      && ok "README tem link de vídeo" || warn "README sem link do vídeo de até 3 min"
    grep -qiE 'simula|mock|fictíci|fake|simulated' README.md \
      && ok "README declara o que é simulado" || warn "README não diz o que é simulado ou mockado"
    grep -qiE 'preexist|pré-exist|pre-exist|terceiros|third.party' README.md \
      && ok "README declara componentes de terceiros" || warn "README não separa o que é de terceiros"
  fi

  echo "== X6 · Credenciais e dados pessoais reais"
  env_tracked=$(tracked | grep -E '(^|/)\.env($|\.)' | grep -v -E '\.env\.(example|sample)$')
  [ -n "$env_tracked" ] && fail ".env versionado: $env_tracked" || ok "nenhum .env versionado"
  secret_re='(sk-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]{10,}|ghp_[A-Za-z0-9]{30,}|AIza[0-9A-Za-z_-]{30,}|(app_?certificate|certificate|secret|api_?key|token|password)["'"'"' ]*[:=][ ]*["'"'"'][A-Za-z0-9_\-]{16,}["'"'"'])'
  secrets=$(tracked | xargs -r grep -n -I -i -E "$secret_re" 2>/dev/null | grep -v -i -E 'example|placeholder|your_|xxxx|<|test|mock|fake|dummy' | cut -c1-120 | head -10)
  if [ -n "$secrets" ]; then
    fail "possíveis credenciais versionadas (revise e troque a chave se for real):"
    printf '%s\n' "$secrets" | sed 's/^/         /'
  else
    ok "nenhum padrão de credencial encontrado"
  fi
  pii=$(tracked | xargs -r grep -n -I -E '[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}|\(?[0-9]{2}\)? ?9[0-9]{4}-?[0-9]{4}' 2>/dev/null | cut -c1-120 | head -5)
  [ -n "$pii" ] && { warn "possíveis CPF/telefone versionados (precisam ser fictícios):"; printf '%s\n' "$pii" | sed 's/^/         /'; }

  echo "== X7/X8 · Prazo e congelamento"
  git fetch -q origin 2>/dev/null
  branch=$(git rev-parse --abbrev-ref HEAD)
  if git rev-parse -q --verify "origin/$branch" >/dev/null; then
    ahead=$(git rev-list --count "origin/$branch..HEAD")
    [ "$ahead" -gt 0 ] && fail "$ahead commit(s) locais não enviados: o júri só vê o GitHub" || ok "$branch em dia com o remote"
  fi
  late=$(git log --all --format='%ct %h %s' 2>/dev/null | awk -v d="$DEADLINE" -v f="$FINAL" '$1 > d && $1 < f' | head -3)
  [ -n "$late" ] && { fail "commits no período congelado (01/12 a 12/12) podem desclassificar:"; printf '         %s\n' "$late"; }
  [ -n "$(git status --porcelain)" ] && warn "há mudanças não commitadas"
  cd "$root" || exit 2
}

for d in "$@"; do check_repo "$d"; done

echo
echo "== Prazo"
left=$(( (DEADLINE - now) / 60 ))
if [ "$left" -le 0 ]; then
  if [ "$now" -lt "$FINAL" ]; then warn "submissão encerrada; repositórios congelados até a final (12/12): nenhum commit"
  else ok "submissão encerrada; congelamento terminou"; fi
elif [ "$left" -lt 1440 ]; then
  warn "faltam $((left / 60))h$((left % 60))m para 30/11 23h59: só o que evita desclassificação e o que sobe H1/H3"
else
  ok "faltam $((left / 1440))d$(( (left % 1440) / 60 ))h para 30/11 23h59"
fi

echo "== Checagem humana (o script não vê)"
cat <<'EOF'
  [ ] X9  time de 1 a 4 no painel (hackbrasil.com/painel), todos com 18+; na final, todos presentes
  [ ] X10 problema e público dentro de Logística & automação (caminhão parado na doca, fluxo de informação)
  [ ] S1  nome, frase e descrição no painel
  [ ] S3  link dos três repositórios no painel
  [ ] S4  demo HTTPS funcionando e no ar até o fim da avaliação; abre em aba anônima
  [ ] S5  vídeo ≤ 3 min, sem login, mostrando o produto funcionando
  [ ] S6  aceite do regulamento por quem envia
  [ ] X2  nada copiado de código privado anterior a 04/11; código aberto copiado com a origem na mensagem do commit
EOF

echo
echo "Resultado: $fails FALHA(s), $warns RISCO(s)"
[ "$fails" -eq 0 ]
