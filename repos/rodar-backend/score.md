# Judge: rodar-backend, 2026-11-27 22:31

Gatilho: push na main de rodar-backend bdc14e5 por HenryFacens. Commit avaliado: bdc14e5.

**Nota do repo: 16 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d1h para 30/11 23h59 · Variação: 0 (era 16/20 em `25dcce7`)

Desde a rodada anterior (`25dcce7`) entraram 2 commits, os dois respondendo a alertas do júri:
- `fbc902f`: adiciona `test_duas_geracoes_seguidas_avancam_e_persistem_a_sequencia_1_e_2` em `tests/api/test_api_edi.py`. O teste confere `Empresa.ultima_sequencia_ocoren` em 0, 1 e 2 e confere o intercâmbio `001` e `002` no registro 000. Fecha o alerta "falta o teste da sequência do OCOREN".
- `bdc14e5`:
  - `/health` agora devolve **503** quando `ok` é falso e expõe `sha`, que vem de `GIT_SHA` por build-arg no `Dockerfile` e em `settings.git_sha`.
  - O smoke do job `deploy` confere três coisas: o `sha` no ar igual ao do commit, o 503 pelo `curl -f` e um `GET /rotas/{id}/ocoren` autenticado, que prova que a migração rodou.
  - O rollback está documentado como comandos em `infra/README.md`: repostar o manifesto `:<sha>` como `latest`, rodar `update-service` e conferir o sha.
  - O health check do ECS passa a reciclar a task quando o banco cai.
  - Tudo coberto por testes novos em `test_health.py`.

**Conferido nesta rodada:**
- `docker compose run --rm test`: **391 passed** em 47 s (eram 389).
- `curl` às 22h31 (-03) em `https://d3fy4m7zwukr3x.cloudfront.net/health`: 200 com `ok: true`, `banco_ok: true`, `llm_upstream: true`, `livekit_configurada: true`, `twilio_configurado: false`, `recebedor_modo: rtc` e `auth_obrigatoria: true`. `/docs` deu 200. **A resposta ainda não tem o campo `sha`**, então a imagem de `bdc14e5` ainda não está no ar. O push foi às 22h30 e o job `deploy` provavelmente ainda estava rodando. Não tenho acesso de leitura às runs.

## Alertas

- **RISCO (S5):** o README ainda não tem o link do vídeo. A linha 44 continua `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. Faltam 3 dias.
- **Precisa de humano: confirmar a run de `deploy` de `bdc14e5`.** Ela tem de estar verde, e `GET /health` no CloudFront tem de mostrar `"sha": "bdc14e5"`. Até isso acontecer, não há prova de que algum deploy pela CI passou. A rodada anterior (`25dcce7`) também ficou sem confirmação, e a ausência de `sha` no ar é compatível com as duas hipóteses: deploy em andamento ou deploy quebrado.
- **O smoke novo pode dar vermelho falso:**
  - `GET /rotas` faz `select(Rota)` sem `order_by` (`api/rotas.py:27`), e o smoke usa `.[0].id`. No Postgres, a ordem sem `ORDER BY` não é garantida e muda depois de `UPDATE`, que acontece a toda mudança de status de rota.
  - Uma rota criada por `POST /rotas` não tem `nfe_chave`, e para ela o OCOREN devolve **409**, como o próprio teste `test_sem_chave_de_nfe_e_409` mostra. Se o júri ou o time criarem uma rota na demo e ela vier primeiro, o job falha.
  - O serviço já terá sido atualizado nesse ponto, então a demo não cai. Mas a CI fica vermelha e esconde o sinal de verdade.
  - Conserto: `order_by(Rota.id)` no `listar` ou filtrar no `jq` por uma rota com NF-e.
- **O smoke tem efeito colateral:** cada deploy chama `GET /rotas/{id}/ocoren`, e isso incrementa `Empresa.ultima_sequencia_ocoren` em produção. É inofensivo na demo, mas um GET que muda estado é um cheiro de design. O júri de dados e produto pode estranhar a sequência pulando se olhar o arquivo.
- **RISCO (demo durante a avaliação, S4 e item 7.3), sem mudança:** a API roda na conta AWS dev de uma empresa, com uma access key fixa nos secrets do GitHub. **Precisa de humano:** ter por escrito que o serviço fica no ar até 12/12 (de preferência até 15/12) e que ninguém revoga a chave.
- **Evidência de voz velha, sem mudança:** `evidence/validacao.md` (33/33) é da era Agora e usou o LLM em contingência. O caminho LiveKit com Gemini Live continua sem prova ponta a ponta publicada. **Precisa de humano.**
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md` ainda está sobre `7fe3475`):
  - Ele diz que a infra está numa "branch sem PR", só em HTTP. Ela está na main, com HTTPS via CloudFront e deploy pela CI.
  - Ele cita 377 testes. Hoje são 391.
  - Ele lista `rodarglobal.github.io/rodar-web` e `rodar-mobile` como demos. O README diz que o painel está só na Vercel.
  - Ele não registra `16d9884`, `301f702`, `299a419`, `25dcce7`, `fbc902f` nem `bdc14e5`.
  - A linha do OpenTofu no `decisoes.md` ("ALB em HTTP", "não chegou ao main") está superada.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | Sem mudança. A demo pública HTTPS tem banco e responde (`/health` 200 com `banco_ok: true`, `/docs` 200). O caminho feliz está completo: rota, voz, aproximação, chegada, estadia pela Lei 11.442, escalonamento com ligação no 3º canal e OCOREN 5.0/3.1. Os commits desta rodada protegem o H1 até 12/12, mas não mostram nada novo ao júri. Não chega a 8 por dois motivos: a voz atual não tem prova ponta a ponta publicada, e a telefonia está desligada (`twilio_configurado: false`), então o recebedor atende pela web. |
| H2 | Implementação técnica | 9 | Mantém, agora mais firme. Três das quatro ressalvas da rodada anterior foram resolvidas com teste: `/health` com 503 e `sha`, o rollback documentado como comando e o teste da sequência do OCOREN. Isso se soma às camadas `dominio/`, `servicos/` e `portas.py`, ao motor EDI dirigido por layout, à outbox idempotente, a 391 testes com Postgres real, à IaC em OpenTofu e à IAM de menor privilégio. Não chega a 10 por três motivos. Primeiro, não há prova de nenhuma run de `deploy` verde (o `sha` ainda não aparece no ar). Segundo, o smoke depende da ordem não determinística de `GET /rotas` e faz um GET com efeito colateral. Terceiro, a `:latest` mutável continua: foi mitigada e documentada, mas não removida. Nota 10 exige prova, não promessa. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **16/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork, segundo o script. Precisa continuar assim até 15/12 |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx`. Os e-mails são `.test`, e o seed e a NF-e estão declarados como fictícios |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. A access key da CI só existe nos secrets do Actions |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa. O `/auth/sso` sem senha está declarado como login simulado |
| Link da demo | README | OK | O topo aponta para o painel na Vercel, e a API no CloudFront responde com banco |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS. Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE), X7/X8 (main em dia) e prazo (3d1h). Em S4/S5, deram OK as instruções, as dependências, o link HTTPS da demo e a declaração do que é simulado e de terceiros. Em X6, sem `.env` e sem credenciais.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: há telefones versionados em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi: são fictícios.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S4 (demo no ar até 12/12 numa conta AWS de terceiros), S5, S6 e o resultado da run de `deploy` de `bdc14e5`.

## Maior retorno

1. **Validação ponta a ponta no stack atual, contra o CloudFront.** Rodar `scripts/validar_fluxos.py` com LiveKit e Gemini Live reais e trocar `evidence/validacao.md` por um novo com data, commit (o `sha` do `/health` agora serve para isso), URL e um passo do OCOREN. É a única prova escrita da voz enquanto o app do motorista não tem demo web. **H1 7→8 = +1.**
2. **Confirmar a run verde e tornar o smoke determinístico.** Conferir em Actions a run de `bdc14e5` e conferir `"sha": "bdc14e5"` no CloudFront. Pôr `order_by(Rota.id)` em `GET /rotas`, ou filtrar no `jq` uma rota com NF-e, para que uma rota criada na demo não derrube o job com 409. Opcional: trocar o GET do OCOREN no smoke por uma checagem sem efeito colateral, por exemplo o `alembic current` na task de migração. Com a primeira run verde provada, o H2 vai a 10. **H2 9→10 = +1, e protege o H1 7 até 12/12.**
3. **Link do vídeo no README (linha 44).** Tira o RISCO S5 deste repo e pesa no H4 do projeto. Junto, rodar `/registrar rodar-backend`, porque o STATUS está 7 commits atrás e diz "infra sem PR, só HTTP". **S5 RISCO→OK; H4 do projeto.**

## Observações

- Commits ainda são permitidos até 30/11. Entre 01/12 e 12/12 não há push na main, então a imagem no ar fica fixa. A última run antes do congelamento precisa estar verde e com o `sha` certo no `/health`. Isso agora é verificável por qualquer pessoa, o que é um ganho real.
- A Vercel do backend, que não tem banco, passa a responder 503 em `/health`. Isso é mais honesto que o 200 com `ok: false`, mas mantenha o CloudFront como o único link de API para o júri.
- Com o health check do ECS sobre `/health`, uma queda do RDS por mais de 90 s recicla as tasks em loop. É aceitável (sem banco a API não serve), mas pode gerar ruído nos alarmes da conta AWS da empresa.
- O `Dockerfile` ainda tem `alembic upgrade head && python -m app.seed` no `CMD`. O `301f702` move a migração para uma task separada na AWS. Vale conferir que a task definition da `api` sobrescreve o comando, senão a migração roda duas vezes por deploy. Com o `alembic` idempotente isso é inofensivo, mas contradiz o `infra/README.md`.
- A access key fixa não expira. Depois de 15/12, vale revogá-la e apagar o usuário IAM de deploy.
