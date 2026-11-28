# Judge: rodar-backend, 2026-11-27 21:52

Gatilho: push na main de rodar-backend 25dcce7 por HenryFacens. Commit avaliado: 25dcce7.

**Nota do repo: 16 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 3 RISCOS · Prazo: faltam 3d2h para 30/11 23h59 · Variação: 0 (era 16/20 em `7c60ad2`)

Desde a rodada anterior (`7c60ad2`) entraram 2 commits:
- `299a419`: inclui `https://rodar-web-beta.vercel.app` no default de `cors_origens` em `settings.py`. Isso conserta o `GET /livekit/config` da demo do painel quando ela aponta para a Vercel, que não tem `CORS_ORIGENS` configurado.
- `25dcce7`: cria o job `deploy` no `ci.yml`. Ele só roda em push na main e depois que lint e testes passam. Faz build e push no ECR com as tags `latest` e sha curto, roda a migração na task separada (`run-task`, espera o fim e exige exit code 0), aplica `update-service --force-new-deployment` em `api` e `voice-agent`, espera `services-stable` e termina com `curl -f` no `/health`. A credencial é de um usuário IAM dedicado com política restrita (`infra/envs/dev/ci.tf`: um repositório ECR, um cluster, `RunTask` só da task de migração, `PassRole` só nas 2 roles). A access key não passa pelo state. Com isso, o risco da rodada anterior de "main e demo descoladas" e "imagem publicada sem migrar" cai bastante.

**Conferido nesta rodada:**
- `docker compose run --rm test`: ruff deu "All checks passed" e o pytest deu **389 passed** em 24 s.
- `curl` às 21h52 (-03): `https://d3fy4m7zwukr3x.cloudfront.net/health` deu 200 com `ok: true`, `banco_ok: true`, `llm_upstream: true`, `livekit_configurada: true`, `twilio_configurado: false`, `recebedor_modo: rtc` e `auth_obrigatoria: true`. `/docs` deu 200.
- Não consegui ver o resultado do job `deploy` deste push, porque não tenho acesso de leitura às runs pela CI. O `/health` também não diz qual commit está no ar.

## Alertas

- **RISCO (S5):** o README ainda não tem o link do vídeo. A linha 44 continua `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. Faltam 3 dias.
- **RISCO (demo durante a avaliação, S4 e item 7.3):** a API roda na conta AWS dev de uma empresa, agora com uma access key fixa nos secrets do GitHub. **Precisa de humano:** garantir por escrito que o serviço fica no ar até 12/12 (de preferência até 15/12) e que ninguém revoga a chave nem derruba o cluster nesse período.
- **Precisa de humano: o primeiro deploy pela CI.** Este é o primeiro push que dispara o job `deploy`. Ele depende de 9 `vars` e 2 `secrets` configurados no repositório. Se faltar algum, o job falha e a demo continua na imagem anterior. Confira em Actions se a run de `25dcce7` terminou verde. Confira também se `POST/GET` do OCOREN respondem no CloudFront, o que prova que a migração `ultima_sequencia_ocoren` rodou.
- **O smoke test é fraco:** `/health` devolve 200 mesmo com `ok: false`, como já se viu na Vercel. Assim, `curl -fsS` no fim do deploy não pega banco fora do ar. Ele também não confirma a versão, porque `/health` não expõe o sha.
- **A tag `:latest` é mutável:** a task definition aponta para `:latest`, então para voltar atrás é preciso repostar uma imagem antiga como `latest`. A tag com sha ajuda, mas o rollback não está documentado como um comando.
- **Evidência de voz velha (sem mudança):** `evidence/validacao.md` (33/33) é da era Agora e usou o LLM em contingência. O caminho LiveKit com Gemini Live continua sem prova ponta a ponta. **Precisa de humano.**
- **Ainda falta o teste da sequência do OCOREN:** nenhum teste confere que duas gerações seguidas persistem 1 e 2 em `Empresa.ultima_sequencia_ocoren`.
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md`, escrito sobre `7fe3475`):
  - Ele diz que a infra está numa "branch sem PR", só em HTTP. Na verdade ela está na main com HTTPS via CloudFront e agora tem deploy pela CI.
  - Ele cita o PR #12 aberto e 377 testes. Hoje são 389.
  - Ele lista `rodarglobal.github.io/rodar-web` e `rodar-mobile` como demos. O painel está só na Vercel (`rodar-web-beta.vercel.app`) e o app não tem demo web.
  - Ele não registra `16d9884`, `301f702`, `299a419` nem `25dcce7`.
  - A linha do `decisoes.md` sobre o OpenTofu ainda diz "ALB em HTTP" e "ainda não chegou ao main". As duas coisas estão superadas.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | Sem mudança. A demo pública HTTPS tem banco e responde (`/health` 200 com `banco_ok: true`, `/docs` 200). O caminho feliz está completo: rota, voz, aproximação, chegada, estadia pela Lei 11.442, escalonamento com ligação no 3º canal e OCOREN 5.0/3.1. O conserto do CORS tira uma quebra visível da demo do painel quando ela usa a Vercel. Não chega a 8 por dois motivos: a voz atual não tem prova ponta a ponta publicada, e a telefonia está desligada (`twilio_configurado: false`), então o recebedor atende pela web. |
| H2 | Implementação técnica | 9 | Mantém. Fechou a dívida principal da rodada anterior: o deploy da AWS agora está na CI, com a ordem certa (testes, imagem, migração com checagem do exit code, update-service, espera ficar estável, smoke) e uma política IAM de menor privilégio bem justificada no `ci.tf`. Isso se soma às camadas `dominio/`, `servicos/` e `portas.py`, ao motor EDI que trata o layout como dado, à outbox idempotente, a 389 testes com Postgres real e ruff limpo, e à IaC em OpenTofu. Não chega a 10 porque o smoke não detecta `ok: false` nem a versão, a imagem usa `:latest` mutável, a sequência do OCOREN segue sem teste e ainda não há prova de que o primeiro deploy pela CI passou. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **16/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026, 05h42 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK, precisa de humano | O script não conseguiu checar pela API (limite ou rede). O repositório está público hoje e precisa continuar assim até 15/12 |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx`. Os e-mails são `.test` e o seed está declarado como fictício |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. A access key da CI só existe nos secrets do Actions, e `ci.tf` evita de propósito `aws_iam_access_key` no state |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa |
| Link da demo | README | OK | O CloudFront está no topo e responde com banco |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 3 RISCOS. Deram OK: X1 (primeiro commit em 22/11), X3 (LICENSE), X7/X8 (main em dia) e prazo (3d2h). Em S4/S5, deram OK as instruções, as dependências, o link HTTPS da demo e a declaração do que é simulado e de terceiros. Em X6, sem `.env` e sem credenciais.
- RISCO X4: não foi possível checar pela API do GitHub.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: há telefones em `.env.example:42`, `settings.py:36`, `seed.py:36` e `test_auth.py:12`. Conferi: são fictícios.

Checagens humanas pendentes: X2, X4, X9, X10, S1, S3, S4 (demo no ar até 12/12 numa conta AWS de terceiros), S5/S6 e o resultado da primeira run do job `deploy`.

## Maior retorno

1. **Validação ponta a ponta no stack atual, contra o CloudFront.** Rodar `scripts/validar_fluxos.py` com LiveKit e Gemini Live reais e trocar `evidence/validacao.md` por um novo com data, commit, URL e um passo do OCOREN. É a única prova escrita da voz enquanto o app do motorista não tem demo web. **H1 7→8 = +1.**
2. **Endurecer o deploy que acabou de entrar.** Fazer `/health` devolver 503 quando `ok: false` e expor o `sha` da imagem (por exemplo, uma variável `GIT_SHA` no build). No smoke, conferir esse sha e chamar um `GET` do OCOREN. Documentar o rollback como um comando (repostar `:<sha>` como `latest` e fazer `update-service`). Junto, adicionar o teste da sequência do OCOREN (duas gerações dão 1 e 2, persistidas). **H2 9→10 = +1, e protege o H1 7 até 12/12.**
3. **Vídeo no README (linha 44) e confirmar a primeira run verde do `deploy`.** O vídeo tira o RISCO S5 e pesa no H4 do projeto. A run verde garante que o júri vê o código de `25dcce7`, e não a imagem antiga. **S5 RISCO→OK; protege o H1.**

## Observações

- Commits ainda são permitidos até 30/11. Entre 01/12 e 12/12 não há push na main, então o job `deploy` não dispara e a imagem no ar fica fixa. Isso é bom para a estabilidade, mas a última imagem antes do congelamento precisa estar verde.
- A access key fixa não expira. Depois de 15/12, vale revogá-la e apagar o usuário `rumolog-dev-ci-deploy`.
- O default de CORS em `settings.py` agora inclui uma origem de produção. Funciona para a Vercel temporária, mas o lugar certo é `CORS_ORIGENS` no ambiente. O comentário no código explica isso.
- O ID da conta AWS em `STATUS.md`, `decisoes.md` e `infra/README.md` não é segredo, mas não precisava estar lá.
- A Vercel sem banco continua com deploy automático e aparece no README como temporária. Se o júri cair nela, vê `ok: false`. O README já avisa, mas vale manter o CloudFront como o único link para o júri.
