# Judge: rodar-backend, 2026-11-27 20:15

Gatilho: push na main de rodar-backend 2b0eb7e por HenryFacens. Commit avaliado: 2b0eb7e.

**Nota do repo: 15 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d3h para 30/11 23h59

Desde a rodada anterior (`f45b6cc`) entraram 7 commits, todos de infra e README: `3b00ddd`, `5345b5a`, `5f0a4a9`, `d945a7f` e `813d71f`, mais os merges `a0070be` e `2b0eb7e`. São cerca de 1.270 linhas de OpenTofu em `infra/`: ECS Fargate, RDS, ALB, CloudFront, Secrets Manager e ECR. **Nenhuma linha de `backend/` nem de `.github/` mudou.** Por isso a suíte de testes e a CI são as mesmas da rodada anterior, e não rodei os testes de novo. A mudança que conta é o deploy: o maior bloqueio da rodada anterior (URL pública sem banco) caiu.

**O link HTTPS existe e funciona.** README, linha 37 ("Para o júri") e seção "Já em produção: AWS": `https://d3fy4m7zwukr3x.cloudfront.net`. Testei com `curl` em 27/11, por volta das 20h15:
- `/health` dá 200 e `{"ok":true,"banco_ok":true,"livekit_configurada":true,"twilio_configurado":false,"llm_upstream":true,"recebedor_modo":"rtc","auth_obrigatoria":true}`.
- `/docs`, `/rotas`, `/cco/estado`, `/api/metrics` e `/livekit/config` dão 200, com dados do seed.
- `POST /auth/sso` devolve JWT. **O login funciona pela URL pública**, e na rodada anterior ele dava 500.
- `/cco/stream` (SSE) entrega o `event: snapshot` através do CloudFront.
- O CORS responde `access-control-allow-origin: https://rodarglobal.github.io`.

## Alertas

- **RISCO (S5):** o README continua sem link do vídeo. A linha 44 ainda é `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. Faltam 3 dias.
- **RISCO (demo durante a avaliação, S4/item 7.3):** a API roda na **conta AWS dev de uma empresa** (a conta está identificada no README e em `infra/README.md`). Ela precisa ficar no ar até 12/12, e de preferência até 15/12. O código está congelado, mas a infra pode ser mexida. Se alguém da conta desligar o serviço ou mudar o SG compartilhado do VPC endpoint (a "pegadinha de rede" do `infra/README.md`), a demo cai e o júri avalia só pelo vídeo. Isso precisa de um humano: garantir por escrito que ninguém vai mexer nessa conta até lá.
- **Leitura confusa para o júri:** o topo do README, nas linhas 3-6 (badge "deploy vercel" e o primeiro parágrafo), ainda manda para `rodar-backend-five.vercel.app`, que **não tem banco**. A URL boa (CloudFront) só aparece na linha 37. Um jurado com pressa clica no primeiro link e vê o login falhar.
- **Ainda aberto da rodada anterior:** `api/deps.py:32` (`HTTPException(500, str(e))`) continua devolvendo o texto interno do erro. Com o banco no ar o risco é menor, mas ainda existe.
- **Evidência de voz velha:** `evidence/validacao.md` (33/33) é da era Agora e foi feita com o LLM em contingência. O caminho atual (LiveKit com Gemini Live) continua sem prova ponta a ponta, embora o `/health` ao vivo agora mostre `llm_upstream: true` e `livekit_configurada: true`. Não testei a voz: **precisa de humano**.
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md`, sobre `7fe3475`):
  - O Resumo, item 1, e a seção 1 dizem "branch `infra/setup-opentofu-aws` sem PR aberto" e "só HTTP". Isso não vale mais: a infra está na main desde `2b0eb7e`, e o HTTPS via CloudFront (`813d71f`) funciona.
  - Ele também cita o PR #12 como aberto, mas o PR já está mergeado.
  - Os itens que ele marca como Ok batem com o código.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | Agora existe uma **demo pública HTTPS com banco**, e ela responde: login, rotas, estado do CCO, métricas e SSE funcionam na URL do CloudFront, com `banco_ok: true`. Isso tira o H1 do "só local" e o leva ao degrau 7-8 ("demo pública no ar"). O escopo já estava completo para o caminho feliz (rota, voz, aproximação, chegada, estadia pela Lei 11.442, escalonamento com ligação no 3º canal, OCOREN 5.0/3.1), com 379 testes na rodada anterior e o código igual. Não chega a 8 por três motivos: (1) o caminho de voz atual não tem prova ponta a ponta publicada; (2) a telefonia está desligada (`twilio_configurado: false`) e o recebedor atende por página web (`recebedor_modo: rtc`); (3) não dá para ver se o painel e o app no Pages já apontam para essa URL, porque isso é dos outros repos e fica para o projeto. |
| H2 | Implementação técnica | 8 | O que já existia: `dominio/`, `servicos/`, `portas.py` com fakes, motor EDI que trata o layout como dado, outbox idempotente, JWT com papel `cco`, Alembic e CI com Postgres real. O que entrou agora soma: infra 100% em IaC (OpenTofu), state remoto com lock, segredos no Secrets Manager com `ignore_changes` e nenhum valor versionado, RDS privado com `deletion_protection` e snapshot final, health check de container, e CloudFront sem cache repassando `Authorization`. A justificativa está documentada em `infra/README.md`. Não sobe para 9 porque nada do que estava aberto foi resolvido: (1) `voice_agent.py` sem teste; (2) o 500 com `str(e)` em `deps.py:32`; (3) a `_SEQUENCIA` do OCOREN em memória (`servicos/edi.py:51`); (4) `alembic upgrade && seed` no `CMD` de cada task, o que é frágil com mais de uma réplica; (5) o pipeline de deploy da AWS é manual (push no ECR e `force-new-deployment`), enquanto a CI ainda publica na Vercel sem banco. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. O README traz 11h40 e 5h09 (IER 2025), 91% sem estadia (CNTA 2025) e R$ 525 por entrega, com fonte. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **15/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026, não é fork. O README explica a origem no UNMUTE |
| X2 | Sem código anterior não público | OK, precisa de humano | A declaração está no README. O `infra/README.md` cita uma stack anterior (`contigency_analisys_backend/infra`) que foi **decomissionada**, não copiada. O Tofu é novo (`3b00ddd`, "scaffold"). Um humano pode confirmar que nada desse código antigo entrou |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público hoje. Manter até 15/12 |
| X6 | Sem dado pessoal real | OK | `+5519900000002` e `+55119000000xx` são placeholders sequenciais, os e-mails são `.test`, e o seed está declarado como fictício. Aparecem ao vivo em `/rotas` sem login (leituras abertas, já declarado no README) |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `terraform.tfvars` versionado. Só o `.tfvars.example`, e os secrets do Tofu são placeholders. O ID da conta AWS está no README: não é segredo, mas não precisava estar lá |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa. A AWS dev, o Twilio placeholder e a Vercel sem banco estão declarados |
| Link da demo | README | OK | O HTTPS do CloudFront funciona com banco e login (ver acima). Os links do painel (Pages e `rodar-web-beta.vercel.app`, que dá 200) e do app também estão lá |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS.
- X1, X3, X4, X6 (credenciais), X7/X8 e prazo (3d3h) deram OK. S4/S5 passaram, inclusive o link HTTPS da demo, exceto o vídeo.
- RISCO 1: o README não tem link do vídeo de até 3 min.
- RISCO 2: há telefones em `.env.example`, `settings.py:36`, `seed.py:36` e `test_auth.py`. Conferi: são fictícios.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S4 (se o painel e o app no Pages usam a URL do CloudFront e se a demo fica no ar até 12/12), S5 e S6.

## Maior retorno

1. **Validação ponta a ponta no stack atual, contra a URL do CloudFront.** Rodar `scripts/validar_fluxos.py` com LiveKit e Gemini Live reais (o `/health` já mostra `llm_upstream: true`). Substituir `evidence/validacao.md` com data, commit e URL, e incluir um passo do OCOREN. Isso vira a prova de "nada quebra na mão do júri". **H1 7→8 = +1.**
2. **Trocar o topo do README para a URL que funciona.** Pôr o badge e o primeiro parágrafo no CloudFront, rebaixar ou remover a Vercel sem banco, e incluir a linha do vídeo na linha 44. Junto, fazer o deploy na AWS a partir da CI (push no ECR e `update-service`), para que a main e a demo não se descolem até 30/11. Protege o H1 7 e o S4/S5 do projeto. **H2 8→8,5** pela CI de deploy, e no projeto H4/S5 deixa de ser RISCO.
3. **Fechar as dívidas do H2:** um teste mínimo do `voice_agent.py` com fakes, 500 genérico em `deps.py:32` (logar `str(e)` e devolver "erro interno"), a sequência do OCOREN persistida e a migração fora do `CMD` (task one-off ou lock do Alembic). **H2 8→9 = +1.**

## Observações

- Não há congelamento antes de 30/11, então commits ainda são permitidos. Depois de 01/12, a infra pode ser mantida no ar, mas sem commits no repositório.
- Na rodada anterior, o README chamava o host de "intencional pelo custo". Isso deixou de ser problema, porque agora há um host com banco. A seção da Vercel ainda ocupa muito espaço para algo que o júri não deveria usar.
- O README continua com mais de 500 linhas. "Para o júri" está bem posicionado, mas o contrato de API poderia ir para `backend/docs/`.
- A dependência de uma conta corporativa de terceiros não está nas regras e não afeta a nota. É um risco operacional da demo, e convém ter um plano B: o vídeo cobre o caso de a demo cair (item 7.3).
