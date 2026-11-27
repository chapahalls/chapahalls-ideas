# Judge: rodar-backend, 2026-11-27 20:47

Gatilho: push na main de rodar-backend e3a8879 por HenryFacens. Commit avaliado: e3a8879.

**Nota do repo: 15 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d3h para 30/11 23h59 · Variação: 0 (era 15/20 em `2b0eb7e`)

Desde a rodada anterior (`2b0eb7e`) entraram 2 commits: `bbafb23` e o merge `e3a8879`. São 2 arquivos e 10 linhas:
- `infra/envs/dev/variables.tf`: o default de `cors_origins` trocou `https://rodarglobal.github.io` por `https://rodar-web-beta.vercel.app`.
- `README.md`, linha 36 ("Demo no ar"): o painel agora fica só na Vercel. O link do app do motorista no Pages saiu, e o README diz que o app "é nativo, sem demo web própria" e manda para o tour em vídeo.

**Nenhuma linha de `backend/` nem de `.github/` mudou.** A suíte (379 testes) e a CI são as mesmas, e não rodei os testes de novo.

**A mudança já está aplicada na AWS.** Testei com `curl` em 27/11, por volta das 20h47:
- `/health` dá 200 e `banco_ok: true`, `llm_upstream: true`, `livekit_configurada: true`, `twilio_configurado: false`, `recebedor_modo: rtc`, `auth_obrigatoria: true`.
- Preflight `OPTIONS /auth/sso` com `Origin: https://rodar-web-beta.vercel.app` dá 200 com `access-control-allow-origin` igual à origem. O mesmo vale para `GET /rotas`.
- Com `Origin: https://rodarglobal.github.io`, o preflight dá **400** e o GET vem sem o cabeçalho CORS. O Pages foi cortado de propósito.
- `POST /auth/sso` dá 200. `https://rodar-web-beta.vercel.app/login` dá 200. `https://rodarglobal.github.io/rodar-mobile/` dá **404**.

O commit é coerente: ele acompanha a saída do painel do Pages e mantém o CORS restrito. Não muda nada na rubrica deste repo. Os bloqueios da rodada anterior continuam todos abertos.

## Alertas

- **RISCO (S5):** o README continua sem link do vídeo. A linha 44 ainda é `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. Faltam 3 dias.
- **RISCO (demo durante a avaliação, S4/item 7.3):** a API roda na conta AWS dev de uma empresa e precisa ficar no ar até 12/12, de preferência até 15/12. Isso precisa de humano: garantir por escrito que ninguém vai desligar o serviço nem mexer no SG do VPC endpoint até lá.
- **Novo: o app do motorista perdeu a demo pública.** O README tirou o link do Pages, que dá 404, e o CORS não aceita mais `rodarglobal.github.io`. Se o `rodar-mobile` voltar a publicar uma versão web, ela não vai conseguir chamar esta API sem um novo `tofu apply` que inclua a origem. O júri só verá o motorista pelo vídeo de 1 min, e isso é justamente o lado da voz, o diferencial do produto. Fica para o projeto (H1), mas a dependência de CORS está neste repo.
- **Leitura confusa para o júri (sem mudança):** as linhas 3-6 (badge "deploy vercel" e primeiro parágrafo) ainda mandam para `rodar-backend-five.vercel.app`, que **não tem banco**. A URL boa (CloudFront) só aparece na linha 37.
- **Ainda aberto:** `api/deps.py:32` (`HTTPException(500, str(e))`) continua devolvendo o texto interno do erro.
- **Evidência de voz velha:** `evidence/validacao.md` (33/33) é da era Agora e foi feita com o LLM em contingência. O caminho LiveKit com Gemini Live continua sem prova ponta a ponta. **Precisa de humano.**
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md`, sobre `7fe3475`):
  - Ele ainda diz que a infra está numa "branch sem PR" e "só HTTP". A infra está na main com HTTPS via CloudFront desde `2b0eb7e`.
  - Ele cita o PR #12 como aberto, mas o PR já está mergeado.
  - Ele lista `rodarglobal.github.io/rodar-web` e `rodar-mobile` como demos publicadas. Agora o painel está só na Vercel e o Pages do app dá 404.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | Sem mudança. A demo pública HTTPS tem banco e responde: `/health` com `banco_ok: true`, login (`/auth/sso` 200) e CORS liberado para o painel na Vercel. O escopo do caminho feliz está completo: rota, voz, aproximação, chegada, estadia pela Lei 11.442, escalonamento com ligação no 3º canal e OCOREN 5.0/3.1. Não chega a 8 porque (1) a voz atual não tem prova ponta a ponta publicada, (2) a telefonia está desligada (`twilio_configurado: false`) e o recebedor atende pela web, e (3) a demo do motorista saiu do ar. |
| H2 | Implementação técnica | 8 | Sem mudança. Camadas `dominio/`, `servicos/` e `portas.py` com fakes, motor EDI que trata o layout como dado, outbox idempotente, JWT com papel `cco`, Alembic, CI com Postgres real e infra 100% em OpenTofu (Secrets Manager, RDS privado, CloudFront). O CORS agora vem da IaC e foi aplicado, o que está certo. Não sobe para 9 porque continuam abertos: `voice_agent.py` sem teste, o `str(e)` em `deps.py:32`, a `_SEQUENCIA` do OCOREN em memória (`servicos/edi.py:51`), a migração no `CMD` de cada task, e o deploy da AWS manual enquanto a CI publica na Vercel sem banco. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **15/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026, não é fork. A origem no UNMUTE está explicada no README |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README. A stack antiga citada em `infra/README.md` foi decomissionada, não copiada |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público hoje. Manter até 15/12 |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os do `test_auth.py` são placeholders sequenciais. Os e-mails são `.test` e o seed está declarado como fictício |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. O ID da conta AWS no README não é segredo, mas não precisava estar lá |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa |
| Link da demo | README | OK | O CloudFront (API) e a Vercel (painel) respondem. O app do motorista ficou sem demo web, só com o tour em vídeo |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS.
- X1, X3, X4, X6 (credenciais), X7/X8 e prazo (3d3h) deram OK. S4/S5 passaram, inclusive o link HTTPS da demo e a declaração de simulados e terceiros.
- RISCO 1: o README não tem link do vídeo de até 3 min.
- RISCO 2: há telefones em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi: são fictícios.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S4 (demo no ar até 12/12 na conta AWS de terceiros) e S5/S6.

## Maior retorno

1. **Validação ponta a ponta no stack atual, contra o CloudFront.** Rodar `scripts/validar_fluxos.py` com LiveKit e Gemini Live reais e substituir `evidence/validacao.md`, com data, commit, URL e um passo do OCOREN. Com a demo do motorista fora do ar, essa evidência é a única prova escrita da voz. **H1 7→8 = +1.**
2. **Topo do README e vídeo.** Trocar o badge e o primeiro parágrafo (linhas 3-6) para o CloudFront e rebaixar a Vercel sem banco. Pôr o link do vídeo na linha 44. Mover o deploy da AWS para a CI (push no ECR e `update-service`), para a main e a demo não se descolarem até 30/11. Protege o H1 7 e tira o RISCO S5. **H2 8→8,5** pela CI de deploy.
3. **Fechar as dívidas do H2:** teste mínimo do `voice_agent.py` com fakes, 500 genérico em `deps.py:32` (logar o erro e devolver "erro interno"), sequência do OCOREN persistida e migração fora do `CMD`. **H2 8→9 = +1.**

## Observações

- Commits ainda são permitidos até 30/11. Entre 01/12 e 12/12, a infra pode ser mantida no ar, mas sem commits no repositório.
- Se o time decidir publicar o app do motorista na web (Expo web) antes de 30/11, a origem precisa entrar em `cors_origins` e passar por um `tofu apply`. Se não, o roteiro do vídeo tem que mostrar a voz do motorista, porque o júri não vai conseguir testá-la.
- A dependência de uma conta corporativa de terceiros não afeta a nota. É um risco operacional, coberto pelo vídeo se a demo cair (item 7.3).
