---
name: judge
description: Avalia se uma ideia ou o projeto está dentro das regras do Hack Brasil 2026 e quanto pontua na rubrica oficial (HACKATHON.md, H1-H4 de 0 a 10, mínimo 20/40 para a final). Sem argumento, avalia todas as ideias em ideas/ e monta o ranking; com um slug, avalia essa ideia; com "projeto" ou "entrega", faz o checklist pré-submissão dos repositórios rodar-backend, rodar-web, rodar-mobile e rodar-keycloak. Também roda na CI (.github/workflows/judge.yml) a cada push na main deles, com relatório em docs/report/. Use quando perguntarem "está nas regras?", "quanto pontua?", "vamos para a final?", "podemos entregar?".
argument-hint: "[<slug da ideia> | todas | projeto]"
---

# Judge

Alvo: $ARGUMENTS

## 1. Escolher o modo

- Vazio ou `todas` → **todas as ideias**: cada `ideas/*.md` exceto `TEMPLATE.md` e `README.md`.
- Um slug ou caminho em `ideas/` → **uma ideia**.
- `projeto`, `entrega`, `repo` → **modo projeto**. Os repositórios de código precisam estar clonados ao lado deste (`../rodar-backend` etc.) ou em `../rodarglobal/`. Se não estiverem, clone com `git clone https://github.com/rodarglobal/<repo>`.

## 2. Delegar ao agente `judge`

Passe ao subagente **judge**: o modo, os arquivos alvo e a data/hora atual (`TZ=America/Sao_Paulo date '+%Y-%m-%d %H:%M'`). Em **todas as ideias**, chame um judge por ideia (podem rodar em paralelo). Depois **você** atualiza a tabela *Ranking* de `ideas/README.md`.

No modo projeto, rode antes `sh scripts/check-rules.sh` e passe a saída ao judge.

## 3. Ranking (modo ideias)

Ordene pela soma, depois H1 e H3 (desempate oficial). Atualize o *Status* das ideias para `avaliada`, menos as que já estão `escolhida` ou `descartada`.

## 4. Responder

No máximo ~12 linhas:

- Tabela curta: ideia ou repo, nota /40, alerta principal.
- **Passa dos 20/40?** Sim ou não, e o que mais ameaça.
- As 3 mudanças de maior retorno.
- Modo projeto: FALHAs primeiro, depois o tempo até 30/11 23h59. Depois do prazo, lembre que os repos estão congelados até 12/12.

Não commite. Se o usuário quiser salvar, use `/commit` (relatório de judge é `docs:`, sem trailers).
