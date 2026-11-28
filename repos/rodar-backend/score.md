# Judge: rodar-backend, 2026-11-27 21:25

Gatilho: push na main de rodar-backend 7c60ad2 por HenryFacens. Commit avaliado: 7c60ad2.

**Nota do repo: 16 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d2h para 30/11 23h59 · Variação: +1 (era 15/20 em `e3a8879`)

Desde a rodada anterior (`e3a8879`) entraram 3 commits, com 10 arquivos e +261/-20 linhas. Eles fecham quase toda a lista de dívidas de H2 da rodada passada:
- `16d9884`: `api/deps.py` agora devolve `500 "erro interno"` e registra a exceção no log com `log.exception`, sem vazar `str(e)` para o cliente. A sequência do OCOREN saiu do dict em memória e foi para `Empresa.ultima_sequencia_ocoren`, com `SELECT ... FOR UPDATE` e migração Alembic com `server_default="0"`. Entrou também `tests/test_voice_agent.py`, com 10 testes: metadata, instruções, ferramentas por papel, chamada ao gateway com `respx` e gateway fora do ar sem derrubar a conversa.
- `301f702`: a migração e o seed saíram do `command` da task da API e foram para uma task definition própria (`aws_ecs_task_definition.migrate`), disparada por `infra/envs/dev/migrar.sh`. A ordem do deploy está documentada em `infra/README.md`.
- `7c60ad2`: o badge e o primeiro parágrafo do README agora apontam para o CloudFront com banco. A Vercel sem banco ficou rebaixada a uma ressalva.

**Conferido nesta rodada:**
- Rodei `docker compose run --rm test ruff check --no-cache .` e deu "All checks passed".
- Rodei `pytest` no serviço `test` do Docker Compose (Postgres do compose) e deu **389 passed** em 46 s. O número bate com os 389 do README.
- `curl` às 21h27 (-03) em `https://d3fy4m7zwukr3x.cloudfront.net/health` deu 200, com `banco_ok: true`, `llm_upstream: true`, `livekit_configurada: true`, `twilio_configurado: false`, `recebedor_modo: rtc` e `auth_obrigatoria: true`. `/docs` também deu 200.
- `rodar-backend-five.vercel.app/health` deu 200, mas com `ok: false` e `banco_ok: false`. Continua sem banco.

## Alertas

- **RISCO (S5):** o README continua sem o link do vídeo. A linha 44 ainda é `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. Faltam 3 dias.
- **RISCO (demo durante a avaliação, S4 e item 7.3):** a API roda na conta AWS dev de uma empresa e precisa ficar no ar até 12/12, de preferência até 15/12. **Precisa de humano:** garantir por escrito que ninguém vai desligar o serviço até lá.
- **Novo risco operacional, de deploy:** a API não migra mais sozinha. Se alguém publicar uma imagem com `16d9884` ou posterior sem rodar `./migrar.sh` antes, a coluna `ultima_sequencia_ocoren` não existe e o OCOREN quebra. Não consigo ver qual imagem está no ar. **Precisa de humano:** confirmar que `migrar.sh` já rodou contra o `rumolog-dev-db` e que `POST/GET` do OCOREN responde no CloudFront.
- **A main e a demo podem se descolar:** a CI ainda publica automaticamente só na Vercel, que não tem banco. O deploy da AWS, o que o júri usa, é manual. Até 30/11, todo push na main precisa de um deploy manual, ou a demo mostra código antigo.
- **Evidência de voz velha (sem mudança):** `evidence/validacao.md` (33/33) é da era Agora e foi feita com o LLM em contingência. O caminho LiveKit com Gemini Live continua sem prova ponta a ponta. O novo `test_voice_agent.py` cobre só a parte sem sala. **Precisa de humano.**
- **Falta teste do que mudou:** nenhum teste confere que a sequência do OCOREN sobe de 1 em 1 e sobrevive entre chamadas. A suíte do EDI passa, mas não verifica o valor persistido.
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md`, escrito sobre `7fe3475`):
  - Ele diz que a infra está numa "branch sem PR" e "só HTTP". Na verdade, ela está na main com HTTPS via CloudFront desde `2b0eb7e`.
  - Ele cita o PR #12 como aberto e 377 testes. O PR já foi mergeado, e hoje são 389 testes.
  - Ele lista `rodarglobal.github.io/rodar-web` e `rodar-mobile` como demos. Hoje o painel está na Vercel e o Pages do app dá 404.
  - Ele não registra `16d9884` (500 genérico, sequência persistida, teste do worker) nem `301f702` (migração em task separada).

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | Sem mudança. A demo pública HTTPS tem banco e responde (`/health` 200 com `banco_ok: true`, `/docs` 200). O caminho feliz está completo: rota, voz, aproximação, chegada, estadia pela Lei 11.442, escalonamento com ligação no 3º canal e OCOREN 5.0/3.1. Não chega a 8 por três motivos: a voz atual não tem prova ponta a ponta publicada; a telefonia está desligada (`twilio_configurado: false`) e o recebedor atende pela web; e o deploy manual com migração separada pode deixar o OCOREN quebrado no ar sem ninguém ver. |
| H2 | Implementação técnica | 9 | Sobe 1, porque fechou 4 das 5 dívidas apontadas na rodada anterior: `deps.py` sem vazamento e com log, sequência do OCOREN persistida com lock de linha e migração própria, `voice_agent.py` testado com fakes e `respx` (inclusive a falha do gateway) e migração fora do `command` da API, como task de uma vez só. Isso soma-se a camadas `dominio/`, `servicos/` e `portas.py`, motor EDI que trata o layout como dado, outbox idempotente, JWT com papel `cco`, CI com Postgres real (389 testes, ruff limpo) e IaC em OpenTofu. Não é 10 porque o deploy da AWS ainda é manual (a CI publica na Vercel sem banco) e a sequência nova não tem teste próprio. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **16/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026. Não é fork |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público hoje. Precisa continuar assim até 15/12 |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` são placeholders sequenciais. Os e-mails são `.test` e o seed está declarado como fictício |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. `migrar.sh` lê tudo de `tofu output` e do perfil AWS local |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa |
| Link da demo | README | OK | O CloudFront agora está no topo e responde com banco |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS. Deram OK: X1, X3, X4, X6 (credenciais), X7/X8 e prazo (3d2h). Em S4/S5, deram OK as instruções, as dependências, o link HTTPS da demo e a declaração do que é simulado e de terceiros.
- RISCO 1: o README não tem o link do vídeo de até 3 min.
- RISCO 2: há telefones em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi: são fictícios.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S4 (demo no ar até 12/12 numa conta AWS de terceiros) e S5/S6.

## Maior retorno

1. **Validação ponta a ponta no stack atual, contra o CloudFront.** Rodar `scripts/validar_fluxos.py` com LiveKit e Gemini Live reais e trocar o `evidence/validacao.md` por um novo, com data, commit, URL e um passo do OCOREN. É a única prova escrita da voz enquanto o app do motorista não tem demo web. **H1 7→8 = +1.**
2. **Deploy da AWS na CI:** push no ECR, `migrar.sh` e depois `update-service` a cada push na main, com um smoke test de `/health` e do OCOREN no fim. Tirar o deploy automático da Vercel ou marcá-lo como não usado. Isso impede que a demo do júri fique em código antigo ou sem migração até 30/11. **Protege o H1 7. H2 9→9,5.**
3. **Vídeo no README (linha 44) e um teste da sequência do OCOREN** (duas gerações seguidas dão 1 e 2, persistidas). O primeiro tira o RISCO S5, e o vídeo pesa no H4 do projeto. O segundo fecha a última brecha do H2. **S5 RISCO→OK; H2 sem regressão.**

## Observações

- Commits ainda são permitidos até 30/11. Entre 01/12 e 12/12, a infra pode ficar no ar, mas sem commits no repositório.
- O `CMD` do `backend/Dockerfile` ainda migra e roda o seed. Para Docker local e Vercel, tudo bem. Na AWS ele é sobrescrito pelo `command` da task, e o README da infra explica isso.
- O ID da conta AWS no `STATUS.md` e no `infra/README.md` não é segredo, mas não precisava estar lá.
- A dependência de uma conta corporativa de terceiros não afeta a nota. É um risco operacional, coberto pelo vídeo se a demo cair (item 7.3).
