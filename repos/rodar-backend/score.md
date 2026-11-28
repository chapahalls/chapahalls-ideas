# Judge: rodar-backend, 2026-11-28 09:18

Gatilho: push na main de rodar-backend a51e4e3 por HenryFacens. Commit avaliado: a51e4e3.

**Nota do repo: 18 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 2d14h para 30/11 23h59 · Variação: **+1** (era 17/20 em `8b303db`)

Desde a rodada anterior (`8b303db`) entrou 1 commit, **`a51e4e3` (docs(evidence), 2 arquivos, +129/−4)**. Ele não toca em `backend/` nem na CI: só `evidence/validacao.md` e uma linha do README. Ele fecha os dois RISCOS de H1 da rodada anterior.

**Conferido nesta rodada:**
- Li o diff inteiro de `8b303db..a51e4e3`. Como não há mudança de código, não rodei os testes de novo: continuam os 425 da rodada anterior.
- Às 09h18 (-03), o `/health` em `https://d3fy4m7zwukr3x.cloudfront.net/health` devolveu `ok: true`, `banco_ok: true`, `llm_upstream: true`, `auth_obrigatoria: true` e **`sha: "8b303db"`**. **O deploy por revision `:sha` funcionou.** O código no ar é o mesmo do HEAD, porque `a51e4e3` só mexe em documentação.
- O painel `https://rodar-web-beta.vercel.app/login` responde 200.
- A nova `evidence/validacao.md` traz 4 rodadas de `validar_fluxos.py` contra o CloudFront, com LLM e LiveKit reais e o sha `8b303db` no ar:
  - 3d: 4/4. 4c: 4/4. **5e: 3/4. 5e2: 4/4.** Totais: 34, 34, 34 e 33 de 34.
  - A falha da 5e tem diagnóstico por evento do banco (rota 27): o LLM não chamou ferramenta no primeiro turno e abriu a fila certa no segundo.
  - Uma 5ª tentativa quebrou antes da 3d, com `TypeError` num `GET /ligacoes`, e foi excluída. **Isso está declarado**, o que é bom.
- Conferi `deve_abrir_fila_separada` (`app/dominio/ocorrencias.py:147`) e o uso dela em `app/servicos/tasks.py:283-297`. **As duas lacunas apontadas antes continuam no código, sem teste.**

## Alertas

- **RISCO (S5), sem mudança: o README ainda não tem o link do vídeo de até 3 min.** É o único entregável deste repo que ainda está em aberto.
- **O README exagera um pouco.**
  - A linha "Ver sem instalar nada" diz "**34/34** direto contra a AWS". Esse é o melhor resultado das 4 rodadas, e uma delas deu 33/34.
  - A mesma linha diz que a 5e agora é "determinista por estado da rota". Não é: a falha que sobrou vem justamente de o LLM não chamar a ferramenta.
  - Um jurado de dados/ML vai ler o 34/34 como escolha do melhor caso. Escreva "3 de 4 rodadas em 34/34, 1 em 33/34", que é o que a própria evidência mostra. A frase do README fica mais fraca que a evidência, e não o contrário.
- **Lacunas da correção da fila, sem mudança e sem teste:**
  - **Atraso já fechado:** "tem fila" depois de um atraso fechado cai no ramo `complemento` (`aberta is None`, `tasks.py:283`), que não passa por `deve_abrir_fila_separada`.
  - **Negação:** `_FILA_NA_DOCA = r"\bfila\b|..."` casa com "não tem fila" e "sem fila".
- **A ferramenta de validação quebrou uma vez.** O `TypeError` num `GET /ligacoes` foi tratado como erro de transporte, mas ninguém investigou se a causa foi um 5xx da API. Se foi a API, o júri pode ver essa falha na mão dele.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` ainda descreve `4d01768`.
  - Ele cita 413 testes. São 425.
  - Ele diz que a 5e/5e2 está instável (5e em 1/4) e que o falso positivo "beleza, obrigado" está em aberto. As duas coisas foram resolvidas e medidas.
  - Ele trata o smoke com efeito colateral no OCOREN como risco. Isso foi resolvido em `d8af042` (`dry_run`).
  - `decisoes.md` não registra o deploy por revision `:sha` (nem a falha e a correção dele) nem o `dry_run`.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 9 | Sobe de 8. A barra da rodada anterior foi cumprida: o `/health` está no sha atual do código (`8b303db`), e a evidência mostra 4 rodadas contra o CloudFront com 3d e 4c em 4/4, 5e em 3/4 e 5e2 em 4/4, cada falha com diagnóstico de banco. A demo pública responde com banco, LLM e auth ligada. Não chega a 10 por três motivos: a 5e ainda falha 1 em 4 vezes, uma tentativa de validação quebrou sem investigação, e "nada quebra na mão do júri" ainda não está provado para a voz com pessoas reais (o próprio arquivo diz que o texto não substitui ASR e barge-in). |
| H2 | Implementação técnica | 9 | Mantém. Uma das quatro barreiras para o 10 caiu: o deploy por revision `:sha` agora tem execução bem-sucedida comprovada, com falha segura e smoke que compara o sha. Ficam três: as duas lacunas da fila sem teste e nenhuma avaliação do LLM versionada ou publicada. Para um júri de dados/ML, a taxa de acerto do modelo medida por script é o que falta para "referência". |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo falta no README. |
| | **Total** | **18/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork. O compromisso de manter a infra no ar até 15/12 está escrito em `infra/README.md` |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx` e são fictícios. A evidência nova só cita ids de rota, de motorista e de evento |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. O commit novo é só documentação |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa, inclusive o SSO mock |
| Link da demo | README | OK | A API no CloudFront responde 200 com banco no sha `8b303db`, e o painel na Vercel responde 200 |
| Link do vídeo | README | RISCO | Ausente |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- **0 FALHAS e 2 RISCOS.**
- Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE) e X7/X8 (main em dia). Em S4/S5, deram OK as instruções, as dependências, a demo HTTPS e a declaração do que é simulado e de terceiros. Em X6, não há `.env` nem credenciais.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: telefones em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi e são fictícios.

## Maior retorno

1. **Link do vídeo de 3 min no README "Para o júri".**
   - Tira o último RISCO de entregável deste repo e é a base do H4 do projeto.
   - **S5 RISCO→OK.** É o item mais barato e o único que pode custar a submissão.
2. **Fechar as duas lacunas da fila, cada uma com um teste, num commit pequeno de código.**
   - Fazer `deve_abrir_fila_separada` valer também no ramo `complemento`, para o caso de o atraso já estar fechado.
   - Ignorar "não tem fila" e "sem fila".
   - Depois, rodar `validar_fluxos.py` uma vez contra o CloudFront para confirmar que nada regrediu.
   - Junto com o item 3, **H2 9→10 = +1**. Sozinho, protege o H1 9 contra uma fala comum do motorista ("aqui não tem fila não").
3. **Avaliação do LLM versionada, com resultado publicado.**
   - Um conjunto pequeno de falas ("tem fila", "não tem fila", "trânsito parado", "doca 2... não, doca 4", "beleza, obrigado"), cada uma com a ferramenta e o campo esperados.
   - Um job manual ou script contra o LLM real, com a taxa de acerto em `evidence/`.
   - Incluir o caso da 5e: a ferramenta chamada no primeiro turno.
   - É a prova de que o comportamento do modelo é medido, que é o que um júri de dados/ML procura. **H2 9→10 = +1**, junto com o item 2.

## Observações

- **A mudança de nota (+1) vem de evidência, não de código novo.** O time mediu o que tinha corrigido, contra a produção, e declarou a falha que sobrou e a tentativa descartada. Essa honestidade conta. Agora alinhe a frase do README a ela.
- A partir de 29/11, nada de pipeline nem Terraform. O deploy por `:sha` está funcionando: não mexa mais nele.
- O item 2 é a última mudança de código razoável. Se não couber em 29/11, deixe como está: H1 9 com a fila estável vale mais que uma correção de última hora.
- Em 30/11, só três coisas: o link do vídeo, conferir que o `/health` mostra o último `sha` e uma rodada final de `validar_fluxos.py`. Não mexa na voz no último dia.
- De 01/12 a 12/12 não pode haver commit (X8). A imagem no ar em 30/11 é a que o júri vê.
