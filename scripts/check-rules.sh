#!/bin/sh
# Checagem mecânica das regras do UNMUTE by Agora (ver HACKATHON.md).
# Cobre só o que dá para checar do terminal; a pontuação e o resto ficam com o agente `judge`.
#
# Uso: sh scripts/check-rules.sh        (sai com 1 se houver FALHA)
# Sem dependências além de git e grep; usa curl só para ver se o repo no GitHub é público.

cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 2

fails=0; warns=0
ok()   { printf '  OK     %s\n' "$*"; }
warn() { printf '  RISCO  %s\n' "$*"; warns=$((warns + 1)); }
fail() { printf '  FALHA  %s\n' "$*"; fails=$((fails + 1)); }

# Arquivos versionados, sem docs e sem este próprio script.
tracked() { git ls-files 2>/dev/null | grep -v -e '^scripts/check-rules\.sh$'; }
code_files() { tracked | grep -v -E '\.(md|txt)$|^\.claude/|^\.github/|^evidence/|^ideas/|^docs/'; }

echo "== D4 · Repositório e README"
if [ ! -f README.md ]; then
  fail "README.md não existe"
else
  if grep -qiE '^#+ .*(como rodar|executar|execução|rodando|run|getting started|quickstart|instala)' README.md; then
    ok "README tem seção de execução"
  else
    fail "README sem seção de instruções de execução (ex.: '## Como rodar')"
  fi
  if grep -qiE '^#+ .*(depend|requisitos|requirements|pré-requisitos|stack)' README.md; then
    ok "README lista dependências"
  else
    fail "README sem seção de dependências/requisitos"
  fi
  if git tag -l | grep -qvE '^phase/[0-9]+-' 2>/dev/null || grep -qiE '(vers[aã]o entregue|delivered version|release|v[0-9]+\.[0-9]+)' README.md; then
    ok "versão entregue identificável (tag de release ou versão no README)"
  else
    fail "sem identificação da versão entregue: crie uma tag (ex.: git tag -a v1.0-entrega) e cite no README"
  fi
fi
[ -f LICENSE ] || [ -f LICENSE.md ] || warn "sem LICENSE: o regulamento não exige, mas sem licença o código público não é reutilizável"

echo "== E2 · Uso funcional da Agora"
agora_hits=$(code_files | xargs -r grep -l -i -E 'agora-rtc|agora-rtm|agora_rtc|agora_rtm|agora-access-token|agora-token|agora_token|AgoraRTC|RtcTokenBuilder|agora\.io/|api\.agora\.io|conversational-ai|agora-agent|agora_realtime|agora-electron|react-native-agora|agora_rtc_engine' 2>/dev/null | head -5)
if [ -n "$agora_hits" ]; then
  ok "código referencia SDK/API da Agora:"; printf '         %s\n' $agora_hits
  warn "referência no código não prova uso funcional: precisa aparecer funcionando na demo e no vídeo (checagem humana)"
else
  fail "nenhuma referência a SDK/API da Agora no código: E2 desclassifica"
fi

echo "== E7 · Credenciais e dados pessoais"
env_tracked=$(tracked | grep -E '(^|/)\.env($|\.)' | grep -v '\.env\.example$')
[ -n "$env_tracked" ] && fail ".env versionado: $env_tracked" || ok "nenhum .env versionado"
secret_re='(sk-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]{10,}|ghp_[A-Za-z0-9]{30,}|AIza[0-9A-Za-z_-]{30,}|(app_?certificate|certificate|secret|api_?key|token|password)["'"'"' ]*[:=][ ]*["'"'"'][A-Za-z0-9_\-]{16,}["'"'"'])'
secrets=$(tracked | xargs -r grep -n -I -i -E "$secret_re" 2>/dev/null | grep -v -i -E 'example|placeholder|your_|xxxx|<' | cut -c1-120 | head -10)
if [ -n "$secrets" ]; then
  fail "possíveis credenciais em arquivos versionados (revise e troque a chave se for real):"
  printf '%s\n' "$secrets" | sed 's/^/         /'
else
  ok "nenhum padrão de credencial encontrado"
fi
if code_files | xargs -r grep -q -E 'process\.env|os\.environ|getenv|import\.meta\.env' 2>/dev/null && [ ! -f .env.example ]; then
  warn "o código lê variáveis de ambiente mas não há .env.example: quem clonar não sabe o que configurar"
fi
pii=$(tracked | xargs -r grep -n -I -E '[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}|\(?[0-9]{2}\)? ?9[0-9]{4}-?[0-9]{4}' 2>/dev/null | cut -c1-120 | head -5)
[ -n "$pii" ] && { warn "possíveis CPF/telefone em arquivos versionados:"; printf '%s\n' "$pii" | sed 's/^/         /'; }

echo "== E5 / E8 · Declarações no README"
if [ -f README.md ]; then
  grep -qiE 'preexist|pré-exist|pre-exist|reutiliz|já existia|third.party|terceiros' README.md \
    && ok "README declara componentes preexistentes/terceiros" \
    || fail "README não identifica componentes preexistentes vs. feito no hackathon (E5)"
  grep -qiE 'simula|mock|fictíci|fake|simulated' README.md \
    && ok "README menciona simulações/mocks" \
    || warn "README não fala de simulações: se algo for simulado ou mockado, declare (E8); se nada for, diga isso"
fi

echo "== E4 · Repositório público e atualizado"
remote=$(git remote get-url origin 2>/dev/null)
if [ -z "$remote" ]; then
  fail "sem remote 'origin': a entrega exige repositório público (GitHub ou equivalente)"
else
  slug=$(printf '%s' "$remote" | sed -n -E 's#.*github\.com[:/]([^/]+/[^/.]+)(\.git)?$#\1#p')
  if [ -n "$slug" ] && command -v curl >/dev/null 2>&1; then
    code=$(curl -s -o /dev/null -w '%{http_code}' "https://api.github.com/repos/$slug")
    case "$code" in
      200) ok "github.com/$slug está público" ;;
      404) fail "github.com/$slug não está acessível sem login (privado?): torne público antes da entrega" ;;
      *)   warn "não consegui checar se github.com/$slug é público (HTTP $code)" ;;
    esac
  else
    warn "remote não é GitHub ou sem curl: confira à mão se $remote é público"
  fi
  git fetch -q origin 2>/dev/null
  branch=$(git rev-parse --abbrev-ref HEAD)
  if git rev-parse -q --verify "origin/$branch" >/dev/null; then
    ahead=$(git rev-list --count "origin/$branch..HEAD")
    [ "$ahead" -gt 0 ] && fail "$ahead commit(s) locais não enviados: a banca só vê o que está no remote" || ok "branch $branch em dia com o remote"
  else
    fail "branch $branch não existe no remote"
  fi
  [ -n "$(git status --porcelain)" ] && warn "há mudanças não commitadas"
fi

echo "== E3 · Prazo (22/11/2026 12:00 Brasília)"
deadline=1795359600  # 2026-11-22T12:00:00-03:00
now=$(date +%s)
left=$(( (deadline - now) / 60 ))
if [ "$left" -le 0 ]; then
  fail "prazo de submissão encerrado"
elif [ "$left" -lt 180 ]; then
  warn "faltam $((left / 60))h$((left % 60))m: só corrija o que evita desclassificação e o que sobe C1/C2"
else
  ok "faltam $((left / 60))h$((left % 60))m"
fi

echo "== Checagem humana (o script não vê)"
cat <<'EOF'
  [ ] E1  equipe de 3 a 5, todos inscritos, aprovados e presentes nos dois dias
  [ ] D1  descrição no OS: problema, público-alvo, solução, uso da Agora
  [ ] D2  apresentação com até 10 slides (PDF, PPT/PPTX ou Canva)
  [ ] D3  vídeo narrado de até 2 min, interação real + integração Agora, link acessível em aba anônima
  [ ] E6  licenças de bibliotecas, modelos, vozes e imagens respeitadas
  [ ] Pitch de 3 min + demo de 2 min ensaiados; vídeo pronto como plano B
EOF

echo
echo "Resultado: $fails FALHA(s), $warns RISCO(s)"
[ "$fails" -eq 0 ]
