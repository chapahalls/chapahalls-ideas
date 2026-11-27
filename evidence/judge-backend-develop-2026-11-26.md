# Judge: rodar-backend (branch `develop`, 3798f34), 2026-11-26 15:08

**Nota estimada: 21 / 40 hoje (25 / 40 provável com o vídeo)** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 4 RISCOS

> **Escopo restrito:** só o `rodar-backend`, branch `develop` (9 commits à frente de `origin/main` cc743fe, 0 atrás). `rodar-web` e `rodar-mobile` **não foram avaliados**. H1-H4 aqui medem a contribuição do backend. A nota do projeto inteiro depende dos fronts, da demo no ar e do vídeo.
> Faltam **4 dias e 9 h** até 30/11 23h59 (UTC−3). Ainda dá para mudar código, mas a prioridade é o que evita desclassificação e sobe H1 e H3.

## Alertas

- **RISCO (S5/X7):** não há link do vídeo de até 3 min. O README tem só o comentário `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->` (linha 40). Sem vídeo, a submissão fica incompleta.
- **RISCO (visibilidade):** o branch padrão no GitHub é `main` (confirmado pela API: `default_branch=main`). O próprio README de `develop` diz "a versão avaliada no Hack Brasil é o último commit de `main`" (linha 15). Não há PR `develop → main` aberto. **Sem merge até 30/11 23h59, o júri vê a versão Agora e todo o trabalho de develop fica invisível.**
- **RISCO (H1, voz):** a migração Agora → LiveKit não tem prova ponta a ponta. `evidence/validacao.md` (33/33) é da era Agora e se declara "anterior à migração". O `voice_agent.py` (221 linhas) não tem teste, `tests/integracoes/` ficou vazio (o `test_agora_rest.py` foi apagado e não ganhou substituto LiveKit), e o CI **nunca rodou** nos commits 774e5c2 e 3798f34, porque o workflow só dispara em push para `main` e em PR.
- **RISCO (demo path):** o "Roteiro da demo" do README quebra no passo 1 com a configuração padrão. Com `AUTH_OBRIGATORIA=true` (padrão do `.env.example`), `POST /rotas/1/reset` devolve **401** (testado localmente). As páginas `/teste` e `/recebedor` não mandam token, e o README manda usá-las com `AUTH_OBRIGATORIA=false` em outra seção.
- **RISCO baixo (X6):** os telefones do seed (`+5511900000001`, `+5519900000002` etc.) são inventados, mas têm **formato válido de celular brasileiro** (DDD + 9 dígitos começando com 9). O Brasil não reserva uma faixa fictícia. `settings.py` usa `+5519900000002` como `recebedor_telefone_e164` padrão: com `RECEBEDOR_MODO=sip` e um trunk real, o sistema discaria para um número que pode existir. Não expõe dado pessoal, então não é FALHA, mas vale trocar.
- **Inconsistência de documentação:** não há ADR para a troca Agora → LiveKit. O `CLAUDE.md` do `rodar-ideas` ainda diz "Agora Conversational AI (voz)" e "plugin Agora fica habilitado". O ADR-0001 lista "Agora, OpenAI, Twilio, tokens" como adaptadores reais. O `HACKATHON.md` cita "Agora é escolha nossa". O commit 774e5c2 ("feature: atualizado do Agora para LiveKit") não segue a convenção (`feat:`) e não tem trailers, então o roadmap não registra o pivot.
- **PLAN.md vazio:** sem `/kickoff`, a fase 1, os critérios de aceite e o demo path estão como `<title>` e `<step>`. Não há critério contra o qual verificar o backend (detalhes abaixo).

## O que foi construído (develop)

**Tamanho:** 7,2 mil linhas em `backend/app`, 3,2 mil em `backend/tests`, **63 rotas HTTP/WS** em 16 routers e 22 migrações Alembic.

**Domínio** (`app/dominio/`, puro e testado):
- **Estadia, Lei 11.442:** `estadia.calcular` com franquia de 5 h, R$ 2,50 por t/h sobre a **capacidade** do veículo, aceleração para demo e formatação em R$ e por voz.
- **Geocerca** de aproximação e chegada (≤ 300 m).
- **Escalonamento do CCO:** canal e prioridade sobem a cada tentativa (`escalonamento.nivel`).
- **Ocorrências:** perguntas por tipo, uma por vez.
- **Contingência sem LLM:** palavras-chave para motorista e recebedor.
- **Fundamentação:** só grava o campo que saiu da fala.
- **Comandos do app por voz** e **documentos fiscais** (mock).

**Serviços e fluxos:**
- O CCO publica e atribui a rota (`RouteAssigned`).
- Retirada com geocerca.
- Na aproximação, o agente avisa e **liga para o recebedor** (`ReceiverNotified`).
- Chegada com **dupla prova de GPS** (celular + rastreador simulado, divergência acima de 500 m).
- Task do CCO com escalonamento: 3 tentativas e, sem resposta, ligação ao recebedor.
- Resposta do recebedor ("doca 4 em 40 min") registrada como prova e repassada por voz.
- Chamados persistidos com lembretes.
- Descarga encerra a estadia com o valor final.
- Métricas e ranking de recebedores (`/api/metrics`, `/api/receivers`).
- Outbox idempotente (`POST /events`, 409 se repetido).
- SSE `/cco/stream` e WebSocket `/ws`.

**Novo em develop (9 commits):**
- **Falas offline (82d1c4d, 78ccf45):** `POST /rotas/{id}/falas-offline` recebe WAV/M4A com `idempotencyKey`, transcreve por STT OpenAI-compatível, passa ao agente com o horário em que a fala foi dita (UTC corrigido) e devolve `aviso_motorista`. Uma fala por vez por rota. Tem 120 linhas de teste.
- **Autorização por rota (555db92):** `exigir_acesso_rota` e `exigir_acesso_sessao` garantem que o motorista só age na própria rota (claim `driverId`, 403) e que as ações da central exigem o papel `cco`. Cobertura em `test_auth.py`, com +108 linhas.
- **LiveKit no lugar da Agora (774e5c2):**
  - `integracoes/livekit.py` faz dispatch, remove, `send_control` por data channel, discagem SIP e consulta de presença.
  - `voice_agent.py` é o worker LiveKit Agents com `inference.RealtimeModel` (Gemini Live). As ferramentas e as transcrições passam pelo gateway `/v1/voice/tool`, `/v1/voice/turn` e `/v1/voice/context`.
  - Uma migração renomeia `agora_canal` para `livekit_room`, e o `docker-compose` ganhou o serviço `voice-agent`.
- **Teste ao vivo (3798f34):** `GET /livekit/config` e `POST /livekit/token` (token de 60 min, despacho do agente por `roomConfig`). O worker entra em **modo demo** (prompt `demo_ao_vivo`, sem rota e sem ferramentas) quando o despacho chega sem sessão. Também traz o cadastro de operador (`POST /usuarios`).
- **README (7e95150):** seção "Para o júri", "Por que importa" com números e fontes (IER/SETCESP, CNTA, ANTT), cálculo de R$ 525 por entrega e glossário.

**Testes, rodados por mim:**

| O quê | Resultado |
|---|---|
| `ruff check .` (develop) | All checks passed |
| `pytest -q` (develop), contra Postgres 16 local (`avisai_test`) | **304 passed**, 71 warnings (chave HMAC curta nos testes), 27,9 s |
| `pytest -q` (`origin/main`, extraída com `git archive`) | 299 passed |
| API local (uvicorn, seed, `AUTH_OBRIGATORIA=true`) | `/health` 200, `/teste` 200, `/rotas` 200, `/api/metrics` 200, **`POST /rotas/1/reset` 401** |
| `scripts/validar_fluxos.py` contra a API local | 2/3: publicação e SSO OK. Parou em "Agente LiveKit despachado" (503, sem credenciais LiveKit). **Sem credenciais não dá para validar a voz.** |
| Worker de voz e LiveKit real | **não rodado** (precisa de chave LiveKit e Inference). Precisa de humano |

O README diz "**318 testes** no backend". O número real é **304**: o júri pode conferir, então corrija.

## O que falta

**Contra PLAN.md e ADRs:**
- O `PLAN.md` está no template (sem `/kickoff`): fase 1 `<title>`, critérios `<checkable criterion>`, demo path `<step>`. **Não existe critério de aceite a verificar.** O `/phase` e o verifier não têm o que provar. O único "demo path" real é o roteiro do README do backend.
- **ADR-0001, item 5:** "só chamamos de integração o que existir como adaptador executável". Hoje **não há nenhum conector de mercado** (OCOREN/Proceda, rastreador, ERP, YMS). O próprio ADR diz que "antes de 30/11 só vale um conector demonstrável" e que prometer integração sem conector "pesa contra H1 e H3". O backend não tem `app/integracoes/` de mercado, só de infraestrutura (LiveKit, Twilio, OpenAI, túnel).
- **Não há ADR da troca Agora → LiveKit.** O pivot de tecnologia de voz é exatamente o caso de `/adr` (regra 5 do CLAUDE.md). Falta também atualizar o `CLAUDE.md` e o ADR-0001 do `rodar-ideas` (seção Consequences).

**Contra o demo path (roteiro do README):**
1. O passo 1 (`curl -X POST .../rotas/1/reset`) dá 401 com o `.env.example` padrão. O README precisa mandar um token ou instruir `AUTH_OBRIGATORIA=false` nesse roteiro.
2. Os passos 2-6 dependem de LiveKit Cloud com Inference (Gemini Live). Não há gravação, log nem `evidence/` mostrando esses passos funcionando depois da migração.
3. O backend **não tem URL pública fixa**: é um quick tunnel do cloudflared que "muda se reiniciar". A "Demo no ar" do README aponta para o `rodar-web` e o `rodar-mobile` no GitHub Pages **em modo Demo (mock)**, então o júri nunca toca neste backend.
4. O modelo `google/gemini-3.8-live` e a voz `Charon` precisam existir na conta LiveKit Inference. Não deu para checar. Precisa de humano.

**Higiene em develop:**
- `.idea/` foi commitado: 6 arquivos de IDE que apontam para `../rodar-web` e `../rodar-mobile`.
- `evidence/rastreabilidade.md` ainda cita `agora_payload`, `AgoraRest` e `tests/integracoes/test_agora_rest.py`, que não existem mais.
- Há dois geradores de token LiveKit: `integracoes/livekit.token` (SDK) e `servicos/livekit.token_participante` (JWT manual).
- O LICENSE cita "Jeferson, Henry e Lucas" e não cita o Eduardo. Não é eliminatório.

## Pontos pedidos

| # | Pergunta | Resposta |
|---|---|---|
| a | A troca Agora → LiveKit tem ADR? | **Não.** `docs/adr/` só tem a 0001, que ainda cita a Agora. O `CLAUDE.md` do `rodar-ideas` ("Agora Conversational AI", plugin `agora@agora-skills`) e o `HACKATHON.md` ("Agora é escolha nossa") estão desatualizados. Também há inconsistência entre repos: o `CLAUDE.md` do mobile diz "roda no Expo Go" e "voz mock", e o README do backend diz que `@livekit/react-native` "não roda no Expo Go" e exige dev build. Decidir via `/adr` e alinhar. |
| b | Develop precisa ir para `main`? | **Sim, antes de 30/11 23h59**, se a voz LiveKit for a que vocês vão mostrar. O branch padrão é `main`, o README diz que a versão avaliada é `main` e os links do README apontam para `blob/main/...`. Como fazer: abra o PR `develop → main` (isso roda o CI pela primeira vez nos commits LiveKit), espere o verde e faça **merge commit** (sem squash, regra 4). **Mas só faça o merge depois de provar a voz LiveKit ponta a ponta.** Hoje `main` (Agora) tem uma validação 33/33 e `develop` (LiveKit) não tem nenhuma. Se a voz LiveKit não funcionar ao vivo até ~29/11, a escolha é um ADR: ficar na Agora em `main` ou mergear declarando a limitação. |
| c | O link de demo HTTPS responde? | **Não deu para checar.** O proxy desta sessão bloqueia `rodarglobal.github.io` (HTTP 403 do proxy, não do site), e a API `/pages` do GitHub também está bloqueada aqui. Os tours `tour.mp4` no GitHub (web e mobile) e `blob/main/evidence/validacao.md` respondem **200**. O repo está público, não é fork, tem licença MIT e foi criado em 2026-11-22T03:57Z. **Precisa de humano:** abrir as duas URLs do Pages numa aba anônima. Lembrete: essa demo é dos fronts em modo mock e não exercita este backend. |
| d | O README declara LiveKit como terceiro e o simulado da voz? | **Em parte.** LiveKit Cloud (RTC, Agents, Inference, SIP), Gemini Live via LiveKit Inference, Twilio, LLM OpenAI-compatível e cloudflared estão declarados (linhas 25, 69-74 e 443). O recebedor por página web (RTC) no lugar do telefone e a contingência sem LLM também estão. **Falta declarar:** (1) o **modo demo** do `POST /livekit/token`, em que o agente conversa sem rota, sem ferramentas e sem gravar nada (está só na mensagem do commit 3798f34); (2) que a validação 33/33 é da Agora e que **não há validação LiveKit** (o link diz "histórica", mas a seção "Simulado" não diz); (3) o Gemini Live como componente de terceiro na lista "Simulado / pré-existente", que hoje cita só "LiveKit Cloud (… Inference …)". |

## Pontuação (só backend)

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | O caminho feliz do domínio funciona e está coberto: 304 testes verdes, API sobe, seed OK e publicação/SSO validados contra a API real. Mas o backend **não está no ar** (quick tunnel), a demo pública é mock dos fronts, a voz LiveKit **não tem prova ponta a ponta** depois da migração, e o roteiro do README dá 401 no passo 1 com a configuração padrão. |
| H2 | Implementação técnica | 7 | Portas e adaptadores claros (`portas.py`, container com fakes), domínio puro, Alembic, outbox idempotente, SSE/WS, autorização por rota, CI com ruff e pytest+Postgres, e o worker LiveKit Agents com ferramentas auditadas no gateway, que é uma integração não trivial. Pesam contra: worker e adaptador LiveKit **sem teste** (`tests/integracoes/` vazio), CI que não rodou nos commits LiveKit, `LLM_SHARED_SECRET` vazio por padrão (`/v1/voice/tool` fica aberto a quem acertar o id sequencial da sessão), `POST /livekit/token` que aceita **qualquer sala** (um motorista logado pode pedir token para `rodar-rota-2` e ouvir a rota de outro, contornando a autorização de 555db92), `.idea/` commitado e dois geradores de token. |
| H3 | Impacto | 7 | Dor com evidência brasileira e benefício em R$: 5h09/11h40 (IER/SETCESP), 91% sem estadia (CNTA), R$ 525 por entrega **calculado pelo próprio backend** e ~R$ 113 mil/mês numa frota de 50 (estimativa declarada). O enquadramento é logística pura (doca, recebedor, CCO). Não chega a 8 porque não há usuário real nem piloto, e o "produto é integração" do ADR-0001 ainda **não tem nenhum conector** executável. |
| H4 | Comunicação (vídeo) | 2 | **Precisa de humano.** Não há vídeo de 3 min no README. O README é bom, com frase de uma linha, glossário e números, mas o critério é o vídeo. Com um vídeo que mostre a voz real (LiveKit) e o contador de estadia, a nota provável é **6**. |
| | **Total** | **21/40** (25 com o vídeo) | Passa dos 20 por pouco hoje. Com o vídeo, fica numa faixa segura. |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo novo, sem histórico importado | OK | Primeiro commit em 22/11/2026 02:42 (−03), repo criado em 2026-11-22T03:57Z, não é fork. Observação: o README diz que o projeto "começou como AvisAI no hackathon UNMUTE by Agora (21–22/11/2026)", com tags `v1.0-entrega`… `v1.3-entrega` de 22/11 e 3 commits no mesmo segundo (02:42:12). É depois de 04/11 e o histórico está completo, então vale pela letra, mas um jurado pode perguntar. Tenha a resposta pronta. |
| X2 | Sem código privado anterior ao evento | precisa de humano | O código do UNMUTE é de 21-22/11, depois da abertura de 04/11. Se algum trecho foi escrito em outro repo antes de 22/11 02:42 e entrou "pronto" no primeiro commit, confirme que esse repo era público ou que tudo foi escrito em 21-22/11. |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | `private=false` pela API do GitHub. Manter. |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK (RISCO baixo) | Nomes e e-mails `.test` inventados, declarados no README. Os telefones `+55119000000xx` e `+55199000000xx` têm formato de celular válido. Sugestão: usar um número claramente impossível, ou vazio por padrão em `settings.py`. |
| X7 | Submissão completa até 30/11 | RISCO | Falta o vídeo (S5). Painel: precisa de humano. |
| X8 | Nenhum commit de 01/12 a 12/12 | precisa de humano | Não há automação que commite. O "Graph Update" é do GitHub e não é commit. Não mergear PR nenhum nesse período. |
| X9 | Time 1-4, todos na final | precisa de humano | 4 autores no histórico (Lucas, Henry, Jeferson, Eduardo), mais commits via Claude/bot. |
| X10 | Enquadramento na trilha | OK | Doca, estadia, recebedor e CCO. O fluxo de acidente que orienta ligar 192/193 é periférico: não o coloque no pitch. |

## Submissão (modo projeto)

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase, descrição | precisa de humano (o README já tem a frase de uma linha) |
| S2 | Trilha | precisa de humano (README: Logística & automação) |
| S3 | Link do repo backend | OK (público), mas **o branch padrão `main` não tem o trabalho de develop** |
| S4 | Demo HTTPS no ar | precisa de humano: o proxy bloqueou o Pages. A demo é dos fronts em modo mock, e o backend não tem URL pública fixa. |
| S5 | Vídeo ≤ 3 min sem login | **FALTA** (nenhum link no README) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar o vídeo de 3 min com a voz LiveKit real e linkar no README** (abre com o caminhão parado na doca em uma frase, depois o motorista fala, o recebedor é avisado, o contador de estadia chega a R$ 525 e o CCO só é chamado na exceção): **H4 2→6 = +4**, e fecha S5/X7.
2. **Provar a voz LiveKit ponta a ponta e só então mergear develop em main por PR com merge commit:**
   - rodar `make validar` com credenciais LiveKit e commitar a nova `evidence/validacao.md`;
   - corrigir o roteiro do README (token ou `AUTH_OBRIGATORIA=false` explícito);
   - de preferência, subir o backend numa URL HTTPS fixa e apontar uma instância do painel para ela (`VITE_API_BASE_URL`), para o júri ver dado real e não mock.

   **H1 5→7 = +2.** Sem o merge, todo o develop vale 0 para o júri.
3. **Um conector de mercado executável, conforme o ADR-0001:** um adaptador `integracoes/ocoren.py` que exporta chegada, espera e descarga como arquivo EDI OCOREN (Proceda), com teste e um endpoint de download mostrado no vídeo. Isso torna verdadeiro o "vendemos integração": **H3 7→8 = +1**, e ajuda H1.

Extra, barato (H2 7→8 = +1):
- restringir `POST /livekit/token` à sala do próprio usuário;
- exigir `LLM_SHARED_SECRET` quando `AUTH_OBRIGATORIA=true`;
- adicionar um teste do adaptador LiveKit com `respx`;
- remover `.idea/`;
- corrigir "318" para o número real de testes;
- registrar o `/adr` da troca Agora → LiveKit.

## Observações

- **Contagem de testes:** README de develop diz 318 no backend e 554 no total, mas o backend tem 304. O README de `main` diz 299, que bate com `main`.
- **CI e develop:** o workflow (`on: push: [main]` e `pull_request`) não roda em push para `develop`. Os dois commits LiveKit entraram em develop direto, sem PR. Rodei localmente e passaram (304 testes, ruff limpo), mas o selo de CI que o júri vê não os cobre.
- **Ambiente desta avaliação:** usei um Postgres 16 local (cluster do sistema, ligado e desligado por mim) e um venv no scratchpad. Nada foi escrito nos repositórios de código. Removi os `__pycache__` gerados, que já eram ignorados pelo git.
- **PLAN.md vazio:** com 4 dias de prazo, um `/kickoff` mínimo (fase = "submissão", critérios = vídeo, merge em main, validação LiveKit e demo no ar) daria ao verifier o que checar e ao time uma lista de pronto.
- **Nvoip:** o `HACKATHON.md` levanta a hipótese do Nvoip Pro para a ligação real ao recebedor. Com LiveKit SIP já implementado (`DiscadorSIP`), um trunk SIP da Nvoip seria o caminho, mas fica para depois de 30/11.
- **Congelamento:** a partir de 01/12, nenhum commit nem merge em nenhum branch dos três repos até 12/12.
