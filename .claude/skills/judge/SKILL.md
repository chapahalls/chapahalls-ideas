---
name: judge
description: Avalia se uma ideia ou o projeto está dentro das regras do UNMUTE by Agora e quanto pontua na rubrica oficial (HACKATHON.md). Sem argumento, avalia todas as ideias em ideas/ e monta o ranking; com um slug, avalia essa ideia; com "projeto" ou "entrega", faz o checklist pré-submissão do repositório. Use quando perguntarem "está nas regras?", "quanto pontua?", "qual ideia escolher?", "podemos entregar?".
argument-hint: "[<slug da ideia> | todas | projeto]"
---

# Judge

Alvo: $ARGUMENTS

## 1. Escolher o modo

- Vazio ou `todas` → **todas as ideias**: cada `ideas/*.md` exceto `TEMPLATE.md` e `README.md`.
- Um slug ou caminho em `ideas/` → **uma ideia**.
- `projeto`, `entrega`, `repo` → **modo projeto**.

## 2. Delegar ao agente `judge`

Passe ao subagente **judge**: o modo, os arquivos alvo e a data/hora atual (`TZ=America/Sao_Paulo date '+%Y-%m-%d %H:%M'`). Em **todas as ideias**, chame um judge por ideia (podem rodar em paralelo, porque cada um escreve só o próprio `ideas/scores/<slug>.md`). Depois **você** atualiza a tabela *Ranking* de `ideas/README.md` com todas as linhas, para não haver conflito de escrita.

No modo projeto, rode antes `sh scripts/check-rules.sh` e passe a saída ao judge.

## 3. Ranking (modo ideias)

Ordene por nota, depois C1, C2 e C3 (desempate oficial). Atualize o *Status* das ideias para `avaliada`, menos as que já estão `escolhida` ou `descartada`.

## 4. Responder

No máximo ~12 linhas:

- Tabela curta: ideia, nota, alerta principal.
- **Recomendação:** qual ideia seguir e por quê, em uma linha, com base em nota e risco de E2 (Agora funcional). Uma nota alta com E2 em RISCO perde para uma nota um pouco menor sem risco.
- As 3 mudanças de maior retorno da ideia recomendada.
- Modo projeto: FALHAs primeiro, depois o tempo até 12h de 22/11.

Não commite. Se o usuário quiser salvar, use `/commit` (relatório de judge é `docs:`, sem trailers).
