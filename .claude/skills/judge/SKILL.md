---
name: judge
description: Avalia se uma ideia, um repositório de código ou o projeto está dentro das regras do Hack Brasil 2026 e quanto pontua na rubrica oficial (HACKATHON.md, H1-H4 de 0 a 10, mínimo 20/40 para a final). Sem argumento, avalia todas as ideias em ideas/ e monta o ranking; com um slug, avalia essa ideia; com rodar-backend, rodar-web ou rodar-mobile, avalia só esse repositório (repos/<repo>/score.md); com "projeto" ou "entrega", faz o checklist pré-submissão dos repositórios rodar-backend, rodar-web, rodar-mobile e rodar-keycloak e atualiza o STATUS.md da raiz. Na CI (.github/workflows/judge.yml), cada push na main de um repo de código roda o judge do repo e depois o do projeto. Use quando perguntarem "está nas regras?", "quanto pontua?", "vamos para a final?", "podemos entregar?".
argument-hint: "[<slug da ideia> | todas | rodar-backend | rodar-web | rodar-mobile | projeto]"
---

# Judge

Alvo: $ARGUMENTS

## 1. Escolher o modo

- Vazio ou `todas` → **todas as ideias**: cada `ideas/*.md` exceto `TEMPLATE.md` e `README.md`.
- Um slug ou caminho em `ideas/` → **uma ideia**.
- `rodar-backend`, `rodar-web`, `rodar-mobile` (ou `backend`, `web`, `mobile`) → **modo repositório**: só esse repo, com o `repos/<repo>/` deste. O repo precisa estar clonado ao lado (`../<repo>`); senão, clone.
- `projeto`, `entrega` → **modo projeto**. Os repositórios de código precisam estar clonados ao lado deste (`../rodar-backend` etc.) ou em `../rodarglobal/`. Se não estiverem, clone com `git clone https://github.com/rodarglobal/<repo>`.

## 2. Delegar ao agente `judge`

Passe ao subagente **judge**: o modo, os arquivos alvo e a data/hora atual (`TZ=America/Sao_Paulo date '+%Y-%m-%d %H:%M'`). Em **todas as ideias**, chame um judge por ideia (podem rodar em paralelo). Depois **você** atualiza a tabela *Ranking* de `ideas/README.md`.

No modo repositório, rode antes `sh scripts/check-rules.sh ../<repo>` e passe a saída ao judge. Ele escreve `repos/<repo>/score.md`.

No modo projeto, rode antes `sh scripts/check-rules.sh` e passe a saída ao judge. Ele lê os `repos/*/score.md` e `repos/*/STATUS.md`, escreve o relatório em `docs/report/` e reescreve o `STATUS.md` da raiz.

## 3. Ranking (modo ideias)

Ordene pela soma, depois H1 e H3 (desempate oficial). Atualize o *Status* das ideias para `avaliada`, menos as que já estão `escolhida` ou `descartada`.

## 4. Responder

No máximo ~12 linhas:

- Tabela curta: ideia ou repo, nota (/40, ou /20 no modo repositório), alerta principal.
- **Passa dos 20/40?** Sim ou não, e o que mais ameaça.
- As 3 mudanças de maior retorno.
- Modo projeto: FALHAs primeiro, depois o tempo até 30/11 23h59. Depois do prazo, lembre que os repos estão congelados até 12/12.

Não commite. Se o usuário quiser salvar, use `/commit` (relatório de judge é `docs:`, sem trailers). Na `main`, um `repos/<repo>/score.md` novo dispara a CI, que refaz o judge do projeto.
