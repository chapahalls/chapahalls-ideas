# Judge: rodar-backend, 2026-11-27 23:02

Gatilho: push na main de rodar-backend f630043 por HenryFacens. Commit avaliado: f630043.

**Nota do repo: 16 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d0h para 30/11 23h59 · Variação: 0 (era 16/20 em `bdc14e5`)

Desde a rodada anterior (`bdc14e5`) entraram 3 commits, os três respondendo a alertas do júri:
- `332205b`: `GET /rotas` passa a usar `order_by(Rota.id)` (`api/rotas.py:30`), com o teste `test_listagem_de_rotas_e_sempre_ordenada_por_id`. Fecha o alerta do smoke não determinístico: `.[0].id` agora é sempre a rota 1 do seed, que tem NF-e.
- `bf6ea0f`: `evidence/validacao.md` novo. É a primeira validação ponta a ponta publicada do caminho LiveKit, com LLM real e sem contingência: **32/34**, no commit `bdc14e5`, em 3 rodadas documentadas (28/31, 32/34 e 32/34). As falhas foram explicadas com honestidade. O script ganhou a etapa 11 (OCOREN).
- `f630043`: compromisso por escrito de manter o cluster e a access key até 15/12, em `README.md:94` e `infra/README.md`. A mensagem do commit cita os dois arquivos, mas o diff só toca `infra/README.md`. A linha do README já existia antes, o que não muda nada.

**Conferido nesta rodada:**
- `docker compose run --rm test`: **392 passed** em 45 s (eram 391).
- `curl` às 23h02 (-03) em `https://d3fy4m7zwukr3x.cloudfront.net/health`: 200 com `ok: true`, `banco_ok: true` e **`sha: "bdc14e5"`**. É a primeira prova de que um deploy pela CI chegou ao ar, e fecha o alerta da rodada anterior. Continuam `twilio_configurado: false` e `recebedor_modo: rtc`. `/docs` deu 200 e `GET /rotas` devolve a rota 1 primeiro.
- A imagem de `f630043` ainda não estava no ar no momento da leitura. O push foi às 23h01.

## Alertas

- **RISCO (H1, coerência entre a demo e o pitch). A demo pública não liga para o recebedor na aproximação.** `infra/envs/dev/ecs.tf:28` fixa `LIGAR_RECEBEDOR_NA_APROXIMACAO = "false"`. O padrão do código é `true` (`infra/settings.py:106`), e o README promete a ligação (linha 248: "o agente **liga para o recebedor**"; tabela da linha 459: padrão `true`).
  - Esse aviso é a primeira frase do produto ("avisa o recebedor antes da chegada").
  - A própria validação mostra o efeito: com `false`, a rodada 1 deu 28/31, e o bloco 4b-4e nem roda.
  - `/health` não expõe essa flag, então o júri não percebe pela API, só quando a ligação não acontece.
  - **Precisa de humano:** se for de propósito (custo, limite de ligações), declare na seção "Simulado" do README. Se não for, mude para `"true"` e faça o deploy antes de 30/11.
- **RISCO (H1): o aviso de atraso ao recebedor falha cerca de 1 vez em 3 com o LLM real.** A etapa 3d caiu porque o modelo classificou "trânsito parado, vou atrasar 40 min" como `fila`, e não como `atraso`. A 5e2 tem o problema inverso. O documento é honesto, mas a função de "atraso avisa o recebedor com o novo horário" depende de uma classificação livre. Na mão do júri, ou ao vivo em 12/12, ela pode simplesmente não acontecer.
  - Conserto barato e testável: uma regra determinística antes do LLM. Se a rota está `em_transito` e fora da geocerca do destino, a ocorrência é `atraso`. `fila` só vale `aproximando` ou depois da chegada. Junto, um teste para cada fala ambígua.
- **RISCO (S5), sem mudança:** o README ainda não tem o link do vídeo. A linha 44 continua `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **A validação foi local, não contra a demo pública.** Ela diz `Api http://localhost:8000`. Ela prova o código de `bdc14e5`, não o ambiente do júri, que tem configuração diferente (ver o primeiro alerta). Além disso, as falas passam pelo gateway de texto, não por áudio. O próprio arquivo ressalva isso, e a ressalva está correta.
- **O smoke ainda tem efeito colateral, sem mudança:** cada deploy chama `GET /rotas/1/ocoren` (`ci.yml:121-124`), e isso incrementa `Empresa.ultima_sequencia_ocoren` em produção. É menor, mas continua sendo um GET que muda estado.
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md` continua sobre `7fe3475`):
  - Ele diz que a infra está numa "branch sem PR", só em HTTP. Ela está na main, com HTTPS via CloudFront e deploy pela CI provado.
  - Ele cita 377 testes. Hoje são 392.
  - Ele diz que a voz atual "não tem validação publicada". Agora tem: 32/34.
  - Ele lista `rodarglobal.github.io/rodar-web` como demo, mas o README diz que o painel está só na Vercel.
  - A linha do OpenTofu em `decisoes.md` ("ALB em HTTP", "não chegou ao main") está superada.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | Mantém a nota, agora com mais prova e mais ressalva. A favor: a demo pública HTTPS tem banco e está no commit certo (`sha: bdc14e5` no ar). A validação real no LiveKit com LLM de verdade deu 32/34, e o caminho feliz está completo (rota, voz, chegada, estadia pela Lei 11.442, escalonamento com ligação, OCOREN). Esperava-se que a validação levasse a nota a 8, mas ela revelou dois pontos que seguram a nota em 7. Primeiro, o aviso de atraso ao recebedor depende de uma classificação do LLM que falha cerca de 1 vez em 3. Segundo, o ambiente público desliga a ligação ao recebedor na aproximação (`ecs.tf:28`), que é justamente o que o pitch promete. Também não houve validação contra o CloudFront, e a telefonia continua desligada. |
| H2 | Implementação técnica | 9 | Mantém. A ordem de `GET /rotas` foi corrigida com teste, o deploy pela CI está provado pelo `sha` no ar, e são 392 testes com Postgres real. Isso se soma às camadas `dominio/`, `servicos/` e `portas.py`, ao motor EDI dirigido por layout, à outbox idempotente, à IaC em OpenTofu e à IAM restrita. A rodada anterior disse que a run verde provada levaria a nota a 10, mas esta rodada achou uma divergência de configuração não declarada: a IaC contradiz o padrão documentado numa função central. Também continuam o GET com efeito colateral no smoke, a tag `:latest` mutável e a classificação de ocorrência sem um conjunto de avaliação. Nota 10 é referência de qualidade, e config de produção que contradiz o README não é. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **16/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork. O compromisso por escrito até 15/12 agora vale para a infra também |
| X6 | Sem dado pessoal real | OK | `+5519900000002` (também em `ecs.tf:23`), `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx`. Os e-mails são `.test`, e o seed e a NF-e estão declarados como fictícios |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. A access key da CI só existe nos secrets do Actions |
| Mocks e terceiros | Declarados no README | OK, com ressalva | A seção "Simulado / pré-existente" está completa, mas não declara que a demo pública desliga a ligação ao recebedor na aproximação |
| Link da demo | README | OK | O painel está na Vercel, e a API no CloudFront responde com banco e com o `sha` certo |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS. Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork, criado em 22/11), X3 (LICENSE), X7/X8 (main em dia) e prazo (3d0h). Em S4/S5, deram OK as instruções, as dependências, o link HTTPS da demo e a declaração do que é simulado e de terceiros. Em X6, sem `.env` e sem credenciais.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: há telefones versionados em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi: são fictícios.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S5, S6, a intenção de `LIGAR_RECEBEDOR_NA_APROXIMACAO=false` em produção e a run de `deploy` de `f630043`.

## Maior retorno

1. **Ligar a ligação ao recebedor na aproximação no ambiente público.** Trocar `ecs.tf:28` para `"true"`, aplicar e expor a flag no `/health`, assim como `recebedor_modo`. Se o desligamento for de propósito, declarar no README. É a frase de abertura do pitch, e hoje a demo do júri não faz isso. **Protege H1 7, condição para 8, e o H3 do projeto.**
2. **Regra determinística `atraso`×`fila` mais validação contra o CloudFront.** Classificar pelo estado da rota (em trânsito e fora da geocerca é `atraso`), com um teste por fala ambígua. Depois, rodar `scripts/validar_fluxos.py` contra `https://d3fy4m7zwukr3x.cloudfront.net` e publicar 34/34 com o `sha` do `/health`. **H1 7→8 = +1.**
3. **Link do vídeo no README (linha 44) e `/registrar rodar-backend`.** Tira o RISCO S5 e pesa no H4 do projeto. O STATUS está 10 commits atrás. Se der tempo, trocar o GET do OCOREN no smoke por uma checagem sem efeito colateral e fixar a imagem por `:<sha>` no lugar de `:latest`. **S5 RISCO→OK; H2 9→10 = +1 com o item 1 resolvido.**

## Observações

- Commits ainda são permitidos até 30/11. Entre 01/12 e 12/12 não há push na main, então a imagem no ar fica fixa. Se mudar `ecs.tf`, confira o `/health` depois do `tofu apply`: a flag de ambiente não muda com o deploy da imagem, só com a task definition.
- A honestidade do `evidence/validacao.md` (mostrar 32/34 e explicar a falha, em vez de forçar 34/34 com contingência) é um ponto a favor para um júri de dados e ML. Vale citar no vídeo que a voz foi validada com o LLM real.
