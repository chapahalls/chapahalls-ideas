# Judge: rodar-backend (branch `develop`, b6aad53), promessas x entregue, 2026-11-26 17:20

**Nota estimada: 21 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 4 RISCOS

> **Escopo restrito:** só o `rodar-backend`, branch `develop` em b6aad53 ("feat: rota cancelada e geocodificação"). Está 10 commits à frente de `origin/main` (cc743fe) e 0 atrás. `rodar-web` e `rodar-mobile` ficaram fora; só aparecem quando o backend depende deles. H1-H4 medem a parte do backend.
> **Foco desta rodada:** o que foi prometido e não foi feito, e o que falta implementar.
> **Tempo:** `TZ=America/Sao_Paulo date` = qui 26/11/2026 16:59. Faltam **4 dias e 7 h** até 30/11 23h59.
> **Rodada anterior:** [`judge-backend-develop-2026-11-26.md`](judge-backend-develop-2026-11-26.md) (3798f34, 21/40).

## Alertas

- **RISCO (S5/X7):** o vídeo de 3 min continua sem link. O README tem só o comentário da linha 40.
- **RISCO (visibilidade):** não há PR `develop → main` aberto (confirmado pela API REST, 0 PRs abertos). O branch padrão é `main`, e o README diz que "a versão avaliada é o último commit de `main`". Sem o merge, os 10 commits de develop (LiveKit, falas offline, autorização por rota, cancelamento, geocodificação) **ficam invisíveis para o júri**.
- **RISCO (H1, voz):** o CI **nunca rodou** em 774e5c2, 3798f34 e b6aad53. A última execução é de 26/11 01:23 (PR #7). A voz LiveKit segue sem prova ponta a ponta: `evidence/validacao.md` (33/33) é da Agora.
- **RISCO (demo path):** `POST /rotas/1/reset`, o passo 1 do "Roteiro da demo", continua dando 401 com o `.env.example` padrão (`AUTH_OBRIGATORIA=true`, e `api/rotas.py:65` exige `exigir_acesso_rota`).
- **NOVO: número errado no README (credibilidade, H3).** O README diz que uma espera de 11h40 tem "7 h além da franquia" e dá "**R$ 525 de estadia, calculada por este backend**". Não tem: 11h40 − 5h = **6h40**, e o próprio `estadia.calcular` devolve **R$ 500,00**. Rodei com 30 t: 11h40 dá 6,6667 h e R$ 500,0; R$ 525 só sai com 12h. Os "R$ 113 mil/mês" saem do valor errado (o certo é ~R$ 108 mil). Um júri de dados/economia confere isso em 10 segundos, e nenhum teste cobre esse valor.
- **NOVO: afirmação de LGPD falsa.** O README (linha 450) e o `RODAR-CONTEXT.md` dizem "não guardamos áudio, só a transcrição". Desde 82d1c4d, `servicos/falas_offline.py:92` grava cada fala offline (WAV/M4A) em `data/falas_offline/` (volume do Compose) e **nunca apaga** o arquivo. O único `unlink` (linha 106) é para a entrega duplicada. Não é X6, porque o seed é fictício, mas é uma afirmação que o código desmente.
- **RISCO baixo (X6):** os telefones `+55119000000xx` e `+55199000000xx` em `seed.py`, `settings.py:36`, `.env.example:44` e nos testes têm formato válido de celular brasileiro. Não há mudança desde a última rodada.
- **Divergência no código:** o README (linha 124) lista o "token LiveKit" entre as ações limitadas ao dono da rota. Mas `servicos/livekit.py:29-35` (`sala_para`) aceita **qualquer sala** que tenha nome válido, então um motorista logado pede `rodar-rota-2` e entra na sala de outra rota.

## Promessas x entregue

Legenda: **FEITO** (com a prova), **PARCIAL** (o que falta), **NÃO FEITO**. ⚠ marca uma afirmação pública (README ou docs do backend) que o código não sustenta.

### PLAN.md (rodar-ideas)

| Promessa | Status | Prova / o que falta |
|---|---|---|
| Demo path de 3 passos | **NÃO FEITO** | Ainda `<step>`. O único roteiro real é o do README do backend, e ele quebra no passo 1 (401) |
| Fases 1-2 com critérios de aceite | **NÃO FEITO** | `<title>` / `<checkable criterion>`; sem `/kickoff` |
| Parking lot: TMS (EDI OCOREN), rastreador, ERP, gerenciadora de risco, YMS/portuário | **NÃO FEITO** (esperado, é parking lot) | Não há código. `app/integracoes/` só tem infra (LiveKit, Twilio, OpenAI LLM/STT, Nominatim, túnel) |
| Parking lot: telefonia real ao recebedor | **PARCIAL** | `DiscadorSIP` (LiveKit SIP) existe, com teste contra fake (`tests/servicos/test_recebedor.py::test_sip_livekit_cria_participante_para_numero_do_recebedor`, `::test_falha_ao_criar_sip_faz_fallback_para_rtc`). Sem trunk nem número real |
| Conectores em `app/integracoes/` | divergência | O plano em `rodar-web` (`docs/PLANO-CONECTORES-TMS.md`, commit 4e4f1e6, só no branch `claude/ecstatic-ptolemy-iawjeu`) propõe `app/conectores/`, webhook `POST /integracoes/webhooks/{chave}` e `edi_proceda.py`. Nenhum desses existe no backend |

### ADR-0001

| Promessa | Status | Prova / o que falta |
|---|---|---|
| Base em portas e adaptadores, cada porta com adaptador real e fake | **FEITO** | `portas.py` tem 7 portas (LiveKitGateway, LLM, Transcritor, Relogio, Voz, Discador, Geocodificador). Os fakes estão em `tests/fakes.py` (FakeLiveKit, FakeLLM, FakeTranscritor, RelogioFixo, FakeGeocodificador). Voz e Discador usam o FakeLiveKit por baixo |
| "Antes de 30/11, só vale um conector demonstrável" (OCOREN, responsável Lucas) | **NÃO FEITO** | Nenhuma linha de código, só o plano no rodar-web |
| "Só chamar de integração o que for adaptador executável" | **FEITO no backend** | O README do backend não promete TMS nem conector. Atenção ao vídeo e aos slides |
| "O ADR muda o discurso (README, vídeo, painel)": integração como o que se vende, mais as três dores | **PARCIAL** | "Por que importa" cobre o caminhoneiro (11h40, 91%) e o financeiro (estadia em R$). **Falta a dor do dono** (R$ 146/h do caminhão parado, o CCO que vive de ligação) e a frase "o que vendemos é a integração". Nada de setup ou TMS no README |
| Consequences: "adaptadores reais: Agora, OpenAI, Twilio, tokens" | desatualizado | Agora saiu. Hoje são LiveKit, OpenAI (LLM e STT), Twilio, Nominatim e túnel. Não há ADR da troca Agora → LiveKit |

### ideas/rodar.md e RODAR-CONTEXT.md

| Promessa | Status | Prova / o que falta |
|---|---|---|
| Voz real com o motorista | **PARCIAL** | O worker LiveKit Agents com Gemini Live existe (`voice_agent.py`, 221 linhas), mas **sem teste e sem validação ao vivo** depois da migração |
| Aproximação: avisa o recebedor e o CCO | **FEITO** (código) | `tests/api/test_fluxos_viagem.py::test_aproximacao_liga_para_o_recebedor_por_padrao` |
| Chegada: Task e estadia (5 h, R$ 2,50 por t·h, sobre a capacidade) | **FEITO** | `dominio/estadia.py` e `tests/dominio/test_estadia.py` |
| Insiste com o CCO e, sem resposta, liga para o recebedor e registra a prova | **FEITO** (código) / **PARCIAL** (ao vivo) | `servicos/tasks.py:loop_escalonamento` e `test_recebedor.py::test_resposta_do_recebedor_vai_para_task_e_motorista`. Ao vivo depende do LiveKit, que não foi provado |
| "Na demo, a estadia calculada em R$" | **FEITO**, ⚠ com o número errado no README | O backend calcula certo. O README publica R$ 525, e o backend dá R$ 500 para 11h40 |
| Contingência local do LLM "para a demo não travar" | **PARCIAL** ⚠ | Só vale no gateway de texto (`conversa.py`). A voz Gemini Live **não tem contingência**: se o LiveKit Inference falhar, a voz cai. A seção "Simulado" (linha 449) sugere o contrário. A linha 412 diz certo |
| Fila offline | **FEITO** | Outbox `POST /events` com 409 em repetição (`test_compat.py`) e falas offline (`test_falas_offline.py`) |
| "512 testes" / "33/33" | desatualizado | O backend tem **330** testes coletados, e o README diz 318. O 33/33 é da Agora e está declarado como "histórico" |
| CI com lint e testes | **PARCIAL** | O workflow existe (ruff + pytest + Postgres), mas só dispara em `push: main` e em PR. Os 3 últimos commits nunca passaram por ele |
| Terceiros declarados | **PARCIAL** | Faltam na seção "Simulado / pré-existente": **Nominatim/OpenStreetMap** (só aparece nas linhas 204 e 397), **STT OpenAI `gpt-4o-mini-transcribe`** das falas offline e o **modo demo** do `POST /livekit/token` (agente sem rota e sem ferramentas) |
| LGPD: "só a transcrição é guardada" | **⚠ FALSO** | O áudio offline fica no disco para sempre (`falas_offline.py:92`) |
| Métricas da seção 6.2 da arquitetura | **PARCIAL** | 9 de 10 em `servicos/metricas.py`. "Estadia cobrada" não existe (é decisão de produto). A "latência da voz" só mede o gateway de texto (`conversa.py:233`): na voz Gemini Live, `latencia_voz_ms` fica **sem amostras** |
| Demo pública HTTPS | **PARCIAL** | Os fronts estão no Pages em **modo Demo (mock)**, e isso precisa de humano para conferir. O backend não tem URL fixa (quick tunnel), então o júri nunca toca nele |

### README do backend

| Afirmação | Status | Prova / o que falta |
|---|---|---|
| Roteiro da demo, passos 1-6 | **PARCIAL** ⚠ | O passo 1 dá 401 com a config padrão. Os passos 2-6 dependem do LiveKit, sem evidência |
| "Saem 3 notificações ao CCO (push, painel, ligação)" (linha 109) | **⚠ NÃO SUSTENTADO** | `tasks.py:135-156` só grava 3 eventos `notificacao_cco` com o rótulo do canal. **Nenhum push é enviado e ninguém liga para o CCO** no escalonamento. A cascata Twilio → RTC existe, mas só no `POST /cco/rotas/{id}/ligar` manual |
| Dono da rota também vale para o "token LiveKit" (linha 124) | **⚠ NÃO SUSTENTADO** | `sala_para` aceita qualquer sala |
| "Segredo do LLM" (linhas 37 e 125) | **PARCIAL** | `LLM_SHARED_SECRET=` vem vazio no `.env.example:22`. Com ele vazio, `/v1/voice/tool` e `/v1/chat/completions` ficam abertos (`api/llm.py:27,55`) |
| "O worker chama `/v1/chat/completions`" (linhas 99, 298 e 394) | **⚠ desatualizado** | O worker chama `/v1/voice/tool`, `/v1/voice/turn` e `/v1/voice/context` (`voice_agent.py:47,131,159`), e **essas 3 rotas não estão na tabela "Contrato de API"**. `POST /chat/completions` (sem `/v1`) também não está documentada |
| "554 testes: 318 no backend" | desatualizado (para menos) | São 330 |
| Cancelamento de rota e geocodificação (b6aad53) | **FEITO** | `test_cancelamento_rota.py`, `test_geocodificacao.py` e `tests/integracoes/test_nominatim.py` (o primeiro teste de adaptador em `tests/integracoes/`) |
| Fluxos 1-10 (retirada, atraso, aproximação, chegada, chamados, pedidos, ocorrência aprofundada, documentos, dupla prova GPS) | **FEITO** (código e teste) | `test_fluxos_viagem.py`, `test_ocorrencia_aprofundada.py`, `test_chamados.py`, `test_central_metricas_gps.py`, `test_comandos_app.py` |
| Porta 8787 | **FEITO** | `docker-compose.yml:28` |
| Rotas documentadas x reais | quase igual | As 66 rotas reais batem com as tabelas, com estas exceções: as 3 rotas `/v1/voice/*` e `POST /chat/completions` existem e não estão documentadas, e `GET /sessions/{id}` está sugerida na tabela e não existe |
| `evidence/rastreabilidade.md` | **⚠ desatualizado** | **15 dos 70 testes citados não existem mais** (`test_agora_rest.py`, `test_tokens.py`, `test_agora_payload.py`, `test_recebedor.py::test_plano_a_*` etc.). Ainda cita `AgoraRest` e `agora_payload` |
| `backend/docs/PERFIS-DEMO.md` | **⚠ contradiz** | Diz "token fictício… não há assinatura, autenticação ou autorização real". O README e `infra/auth.py` emitem JWT HS256 assinado e exigido |
| Trailers `Next:` e TODO/FIXME | nenhum | `git log` não tem nenhum trailer de roadmap além de `Co-Authored-By`/`Claude-Session`, e não há TODO, FIXME nem `NotImplementedError` no código |

## O que falta implementar até 30/11, por retorno

Esforço: **P** (≤ 2 h), **M** (meio dia a 1 dia), **G** (≥ 1,5 dia). São 4 dias para 4 pessoas, e o backend é do Lucas.

| # | O quê | Critério | Esforço |
|---|---|---|---|
| 1 | **Vídeo de 3 min com o link no README.** Abre com o caminhão parado em 1 frase; mostra a voz real, o recebedor avisado, o contador em R$ e o CCO só na exceção | H4 2→6, fecha S5/X7 | M (humano) |
| 2 | **Corrigir as afirmações falsas do README** (1 commit): R$ 525 → R$ 500 (ou usar 12h de espera) e 113 mil → ~108 mil; "3 notificações push/painel/ligação" → "3 tentativas registradas no painel"; a linha 124 (token LiveKit); `/v1/chat/completions` → `/v1/voice/*` na tabela; 318 → 330; Nominatim, STT e modo demo na seção Simulado; esclarecer que a contingência não cobre a voz; e PERFIS-DEMO.md | protege H1/H3 (credibilidade) | P |
| 3 | **Apagar o áudio offline depois de transcrever** (`unlink` em `processar`, mais 1 teste) ou declarar a retenção | torna verdade "não guardamos áudio" | P |
| 4 | **Provar a voz LiveKit ponta a ponta:** credenciais, `make validar`, nova `evidence/validacao.md` (LiveKit) e o roteiro do README com token ou `AUTH_OBRIGATORIA=false` explícito | H1 5→6 | M |
| 5 | **PR `develop → main`**: o CI roda pela 1ª vez nos 3 commits; merge commit, sem squash, só depois do item 4 | sem isso, develop vale 0 | P |
| 6 | **Backend numa URL HTTPS fixa** (ou túnel nomeado) e uma instância do painel com `VITE_API_BASE_URL` apontando para ela, no ar até o fim da avaliação | H1 6→7 | M/G |
| 7 | **Conector EDI OCOREN mínimo** (ADR-0001): `integracoes/ocoren.py` que gera chegada, espera e descarga em largura fixa a partir dos eventos, `GET /rotas/{id}/ocoren`, testes e "formato simplificado, não homologado com TMS" declarado no README; mostrar no vídeo | H3 7→8; torna verdade o "vendemos integração" | M |
| 8 | **Ligar o nível `ligacao` do escalonamento à cascata Twilio → RTC que já existe** (`chamadas_agente`), em vez de só gravar o rótulo, se quiserem manter a frase do README | H1 (robustez do fluxo) | P/M |
| 9 | **Segurança barata:** `sala_para` restrita a `rodar-rota-{driverId}` (ou à sala própria), `LLM_SHARED_SECRET` obrigatório com `AUTH_OBRIGATORIA=true` e CI em `push: [main, develop]` | H2 7→8 (com o 10) | P |
| 10 | **Higiene:** remover `.idea/`; atualizar `rastreabilidade.md` (15 referências quebradas); 1 teste do `voice_agent`/`integracoes/livekit.py` com fake | H2 | P/M |
| 11 | No `rodar-ideas`, que não é submetido: `/kickoff` mínimo no `PLAN.md` (fase "submissão" com os itens 1, 4, 5 e 6 como critérios) e `/adr` da troca Agora → LiveKit | processo, verifier | P |

**Ordem realista:** quinta, itens 2, 3, 9 e 10. Sexta, item 4, e o item 7 em paralelo (Lucas). Sábado, itens 5 e 6. Domingo, gravar o vídeo (item 1) e não commitar nada depois das 23h59 de 30/11.

## Pontuação (só backend)

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | O domínio está completo e testado (330 testes; cancelamento e geocodificação agora fecham o ciclo do CCO). Mas o backend não está no ar, a voz LiveKit não tem prova, o roteiro dá 401 no passo 1 e o develop não está em `main`. As duas afirmações que o código desmente (o escalonamento "push/ligação" e o R$ 525) **ameaçam o 5**: um jurado que conferir cai para 4 |
| H2 | Implementação técnica | 7 | Portas e adaptadores, com o primeiro teste de adaptador (`test_nominatim.py`), Alembic, outbox idempotente, autorização por rota e worker LiveKit com ferramentas no gateway. Pesam contra: o worker sem teste, o CI que não roda em develop, a sala LiveKit aberta, o segredo do LLM vazio, `.idea/` commitado e as 15 referências mortas na rastreabilidade |
| H3 | Impacto | 7 | Dor com evidência brasileira e valor em R$, enquadramento de logística pura. Não sobe porque não há conector (o "o que vendemos" do ADR-0001 não existe), nem usuário real ou piloto, e o número de destaque do README está **errado** |
| H4 | Comunicação (vídeo) | 2 | **Precisa de humano.** Não há vídeo. O README é bom (frase, glossário, números), mas o critério é o vídeo. Com um vídeo que mostre a voz real e o contador, a nota provável é 6 |
| | **Total** | **21/40** | **Diferença para a rodada anterior: 0.** O b6aad53 adicionou funcionalidade testada, mas nada que o júri veja. Os achados novos (R$ 525, áudio guardado) pesam contra a credibilidade. Com os itens 1, 2, 4, 5 e 6, a faixa vai para **26-28**; com o OCOREN, para 27-29 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo novo, sem histórico importado | OK | Criado em 22/11, não é fork. Tenha a resposta pronta sobre as tags do UNMUTE |
| X2 | Sem código privado anterior | precisa de humano | Igual à rodada anterior |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | `private=false` |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK (RISCO baixo) | Os telefones têm formato válido. O áudio offline guardado não é dado real na demo, mas contradiz o README |
| X7 | Submissão completa | RISCO | Falta o vídeo; o painel precisa de humano |
| X8 | Sem commit de 01/12 a 12/12 | precisa de humano | Nenhuma automação commita. Não mergear nada nesse período |
| X9 | Time 1-4 | precisa de humano | 4 autores no histórico |
| X10 | Trilha | OK | Doca, estadia, recebedor e CCO |

## Submissão (modo projeto)

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha | precisa de humano |
| S3 | Link do repo | OK, mas `main` não tem o develop |
| S4 | Demo HTTPS | precisa de humano: Pages em modo mock, backend sem URL fixa |
| S5 | Vídeo ≤ 3 min | **FALTA** |
| S6 | Aceite do regulamento | precisa de humano |

Saída resumida do `scripts/check-rules.sh`, informada pelo chamador e conferida no `check-backend.txt` do scratchpad: **0 FALHA, 2 RISCO**. Os riscos são o README sem link do vídeo e os telefones com formato válido em seed, settings, `.env.example` e testes.

## Maior retorno

1. **Vídeo de 3 min, com o link no README:** H4 2→6 = **+4** (fecha S5).
2. **Voz LiveKit provada, PR para `main` e backend no ar em HTTPS com um painel em modo API:** H1 5→7 = **+2**.
3. **Conector OCOREN mínimo, com teste e no vídeo, e README sem as afirmações falsas:** H3 7→8 = **+1**. Corrigir o R$ 525 e o "push/ligação" ao CCO custa 1 h e evita perder 1 ponto em H1 ou H3.

## Observações

- **Como chequei:** 330 testes coletados (`pytest --collect-only`). O valor da estadia saiu de `estadia.calcular` direto, com 30 t: 11h40 dá R$ 500,00; 12h dá R$ 525,00; 4h dá R$ 0. As rotas foram extraídas dos decorators em `app/api/*.py` e `main.py` (66 rotas). O CI e os PRs vieram da API REST do GitHub. Nada foi escrito nos repositórios de código, e o `git status` do backend está limpo.
- **"R$ 323 numa espera de 4h"** (ADR-0001 e `rodar.md`) é custo, não estadia: o backend dá R$ 0 para 4h, porque a espera fica dentro da franquia. No vídeo, diga "custo de R$ 323 que ninguém cobra", não "estadia de R$ 323".
- **Os números dos fronts** ficaram fora do escopo. Confiram se o web, o mobile ou os slides repetem o R$ 525.
- `respx` está em `requirements-dev.txt`, mas nenhum teste usa.
- `requirements-dev.txt` não inclui `requirements.txt`: `pip install -r requirements-dev.txt` sozinho quebra os testes (sem alembic). O CI instala os dois, então não quebra lá.
- **Congelamento:** a partir de 01/12, nenhum commit nem merge nos três repositórios.
