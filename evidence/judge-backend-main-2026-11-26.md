# Judge: rodar-backend (branch `main`, c298ec7), 2026-11-26 17:38

**Nota estimada: 21 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 3 RISCOS

> **Escopo restrito:** só o `rodar-backend`, branch `main` em c298ec7 ("Merge pull request #9 from rodarglobal/develop"). `main` = develop 0b7172a + merge commit, sem squash. `rodar-web` e `rodar-mobile` ficaram fora; só aparecem quando o backend depende deles. H1-H4 medem a parte do backend.
> **Tempo:** `TZ=America/Sao_Paulo date` = qui 26/11/2026 17:38. Faltam **4 dias e 6 h** até 30/11 23h59.
> **Rodadas anteriores:** [`judge-backend-develop-2026-11-26.md`](judge-backend-develop-2026-11-26.md) (3798f34, 21/40) e [`judge-backend-promessas-2026-11-26.md`](judge-backend-promessas-2026-11-26.md) (b6aad53, 21/40).
> **Novo desde b6aad53:** o commit 59fb518 traz três mudanças: estadia por hora ou fração, prefixos de sala reservados no token de demo e apagamento do áudio offline depois da transcrição. Ele entrou por PR #8 (feature → develop) e PR #9 (develop → main), com merge commits.

## Alertas

- **RISCO (S5/X7):** o vídeo de 3 min continua sem link. O README tem só o comentário da linha 40.
- **RISCO (H1, voz):** a voz LiveKit continua sem prova ponta a ponta. `evidence/validacao.md` (33/33) é da Agora e o README a chama de "histórica". Não há credenciais nesta sessão para validar.
- **RISCO (demo path):** o passo 1 do "Roteiro da demo" (`curl -X POST localhost:8000/rotas/1/reset`) **ainda dá 401** com `AUTH_OBRIGATORIA=true`, que é o padrão do `.env.example`. Testei na API local (uvicorn + seed): `/health` 200, `/teste` 200, `POST /rotas/1/reset` **401**.
- **NOVO, RISCO de custo e de disponibilidade da demo:** `/auth/sso` é login sem senha (simulado e declarado), e `POST /livekit/token` só exige login. Então qualquer pessoa com a URL pública consegue tokens sem limite, e cada sala nova despacha um agente Gemini Live (`roomConfig.agents`). Não há limite por IP nem de salas simultâneas. Se alguém abusar durante a avaliação, os créditos do LiveKit Inference acabam e a voz cai na frente do júri.
- **RISCO baixo (X6):** os telefones `+55119000000xx` e `+55199000000xx` (seed, `settings.py`, `.env.example:44`, testes) têm formato válido de celular brasileiro. Nada mudou aqui.
- **RESOLVIDO: visibilidade.** O develop está em `main` (PR #9, merge commit). O CI rodou em `push` para `main` (c298ec7): **success, `ruff` limpo e 334 passed**, o mesmo resultado local.

## O que mudou desde a última rodada

| Item | Antes (b6aad53) | Agora (c298ec7) | A correção está certa? |
|---|---|---|---|
| Estadia 11h40, 30 t | R$ 500,00, e o README dizia R$ 525 | **R$ 525,00** em `estadia.calcular`, com o teste `test_estadia.py::test_hora_ou_fracao_arredonda_pra_cima` (7 h, `R$ 525,00`) | **Sim.** `math.ceil(round(excedente, 6))` segue o "por tonelada/hora **ou fração**" do art. 11, §5º. Conferi os valores: 5h00 dá R$ 0; 5h01 dá R$ 75; 6h00 dá R$ 75; 6h01 dá R$ 150; 11h40 e 12h00 dão R$ 525. Com isso, os "R$ 113 mil/mês" também ficam certos (525 × 50 × 52/12 ≈ R$ 113,7 mil). **Bônus:** o `rodar-web` (`src/utils/stay.ts`) já usava `Math.ceil`, então front e back agora dão o mesmo número. Ressalva de texto: o README diz "tem 7 h além da franquia". São 6h40, **cobradas** como 7 h. Um jurado de economia pode notar. |
| Áudio offline | gravado e nunca apagado; README dizia "não guardamos áudio" | `caminho.unlink()` depois da transcrição bem-sucedida, com 3 asserções nos testes (apagado no sucesso, apagado na duplicata, mantido na falha). O README de LGPD foi reescrito | **Parcial.** O código está certo para o caminho com STT. Mas o README diz que "o arquivo só persiste se a transcrição falhar", e ele **também persiste quando não há transcritor**: sem `LLM_API_KEY`, que é o padrão do `.env.example:18`, o status vira `sem_transcricao` e o arquivo fica (`falas_offline.py:138-140`; o teste `test_sem_transcritor_guarda_o_audio_sem_texto` confirma). Também não há TTL, e o `reset` da rota não limpa `data/falas_offline/`. Correção: 1 linha no README, ou um `unlink` também em `sem_transcricao`. |
| Token de demo (`POST /livekit/token`) | aceitava qualquer sala, inclusive `rodar-rota-2` | 400 para salas que começam com `rodar-rota-`, `rodar-recebedor-` ou `rodar-operador-` (`servicos/livekit.py:36`), com teste parametrizado (3 casos) | **Fecha a brecha que importava.** Todas as salas de sessão real do backend usam esses 3 prefixos (`sessoes.canal_*`), e o worker só entra em modo com ferramentas se o despacho trouxer `session_id` na metadata. O token de demo não traz metadata, então não dá para injetar sessão. Testei as variantes: `RODAR-ROTA-2`, `Rodar-rota-2`, `rodar_rota_2` e `rodar-rota2` passam, mas abrem **outra** sala, porque o LiveKit compara o nome exato (vale um humano confirmar na doc). ` rodar-rota-2` com espaço é barrada, por causa do `strip()`. **Brechas que sobram:** (1) as salas de demo dos outros (`rodar-demo-{papel}-{sub}`) não são reservadas, e um usuário logado entra na conversa de demo de outro, sem dado de rota; (2) o abuso de custo descrito nos Alertas; (3) como o SSO não tem senha, qualquer um faz login como CCO e pega um token legítimo por `GET /token`. Isso está declarado como simulado, mas a frase "motorista só na própria rota" só vale com login real. |
| Terceiros no README | faltavam Nominatim, STT e o modo demo | **Os três declarados** (linhas 74-75, 450 e 451) | **Sim.** |
| CI em `main` | nunca tinha rodado nos commits LiveKit | Rodou em PR #8, PR #9 e push para `main`: todos verdes | **Sim, compatível.** O workflow usa Python 3.12, instala `requirements.txt` e `requirements-dev.txt`, roda `ruff check .` e `pytest -q` contra `postgres:16-alpine`. Rodei o mesmo localmente (Python 3.12, os dois requirements, ruff 0.8.4, Postgres 16): **334 passed**, igual ao log do CI (334 passed, 41,5 s). O workflow continua sem disparar em push direto para `develop`, mas o fluxo agora passa por PR. |

## Pontos pedidos

| # | Pergunta | Resposta |
|---|---|---|
| a | 11h40 com 30 t dá R$ 525 no código, com teste? | **Sim.** `test_hora_ou_fracao_arredonda_pra_cima` verifica 7 h, `525.0` e `"R$ 525,00"`. Conferi direto em `estadia.calcular` |
| b | O áudio offline é apagado e o README de LGPD bate? | **É apagado depois do STT.** O README não bate em um caso: sem transcritor (padrão sem `LLM_API_KEY`), o áudio fica para sempre. Ajuste "só persiste se a transcrição falhar" para "se a transcrição falhar ou não houver STT configurado" |
| c | Bloquear prefixos resolve "token restrito ao dono da rota"? | **Para as salas reais, sim.** Maiúsculas e prefixos parecidos abrem outra sala, sem agente com ferramentas. Sobram as salas de demo alheias, que não são reservadas, e o custo sem limite. A linha 126 ainda lista "token LiveKit" entre as ações do dono da rota, o que vale para `GET /token`; a linha 451 explica o `POST`. Melhor dizer "`GET /token`" na 126 |
| d | O README ainda diz 318 testes, push+ligação, `/v1/chat/completions`? Faltam Nominatim e STT? | **318: ainda** (linha 36; o real é **334**). **"3 notificações (push, painel, ligação)": ainda** (linha 111), mas `tasks.py` só grava 3 eventos com o rótulo do canal, e a linha 449 diz que "push/telefonia reais para a central continuam fora do escopo", ou seja, o próprio README se contradiz. **`/v1/chat/completions` como rota do worker: ainda** (linhas 101 e 396; a 300 é a tabela). O worker chama `/v1/voice/tool`, `/v1/voice/turn` e `/v1/voice/context`, e essas 3 rotas **continuam fora da tabela**. **Nominatim e STT: corrigidos** |
| e | O passo 1 do roteiro ainda dá 401? | **Sim.** Testado: 401 |
| f | `LLM_SHARED_SECRET` ainda vazio por padrão? | **Sim.** `.env.example:22` vazio e `settings.py:51` com `""`. A API só avisa no log, e `/health` mostra `"llm_protegido": false`. Com segredo vazio, `/v1/voice/tool`, `/turn`, `/context` e `/v1/chat/completions` aceitam qualquer chamada que acerte o id sequencial da sessão (`x-avisai-sessao`). O worker manda `rodar-local` quando está vazio, então exigir o segredo com `AUTH_OBRIGATORIA=true` não quebra nada que não esteja configurado |
| g | O CI em `main` é compatível com o local? | **Sim.** Mesmo Python, mesmos requirements, mesmo ruff e Postgres 16, e o mesmo resultado: 334 passed |

## Promessas x entregue (reconferido em `main`)

Legenda: **FEITO**, **PARCIAL**, **NÃO FEITO**. **CORRIGIDO** = mudou desde b6aad53. ⚠ = afirmação pública que o código não sustenta.

### PLAN.md e ADR-0001 (rodar-ideas)

| Promessa | Status | Prova / o que falta |
|---|---|---|
| Demo path e fases com critérios de aceite | **NÃO FEITO** | O `PLAN.md` ainda tem 8 placeholders (`<step>`, `<title>`, `<checkable criterion>`) |
| Portas e adaptadores, com real e fake | **FEITO** | Igual à rodada anterior |
| "Antes de 30/11, só vale um conector demonstrável" (OCOREN) | **NÃO FEITO** | Nenhum conector de mercado. `app/integracoes/` só tem infraestrutura |
| Discurso de integração mais as 3 dores | **PARCIAL** | Falta a dor do dono e a frase "o que vendemos é a integração" |
| ADR da troca Agora → LiveKit | **NÃO FEITO** | `docs/adr/` só tem a 0001 |

### ideas/, RODAR-CONTEXT.md e README

| Promessa | Status | Prova / o que falta |
|---|---|---|
| Estadia em R$ (R$ 525 por entrega) | **FEITO, CORRIGIDO** | O código e o teste dão R$ 525, igual ao web. Só falta ajustar o texto "7 h além" |
| LGPD: "só a transcrição fica" | **PARCIAL, CORRIGIDO em parte** | O áudio é apagado com STT e fica sem STT (padrão). O README omite o segundo caso |
| Token LiveKit restrito ao dono da rota | **PARCIAL, CORRIGIDO em parte** | As salas reais estão protegidas. As salas de demo alheias não. O SSO sem senha está declarado |
| Terceiros declarados (Nominatim, STT, modo demo) | **FEITO, CORRIGIDO** | README, linhas 74-75, 450 e 451 |
| CI com lint e testes no que o júri vê | **FEITO, CORRIGIDO** | Verde em `main`, 334 passed |
| Develop visível em `main` | **FEITO, CORRIGIDO** | PR #9, com merge commit |
| Voz real com o motorista (LiveKit) | **PARCIAL** | O worker existe, sem teste e sem validação ao vivo |
| Roteiro da demo, passos 1-6 | **PARCIAL** ⚠ | O passo 1 dá 401, e os passos 2-6 dependem do LiveKit, sem evidência |
| "3 notificações ao CCO (push, painel, ligação)" | **⚠ NÃO SUSTENTADO** | Sem mudança. A linha 111 contradiz a 449 |
| "O worker chama `/v1/chat/completions`" | **⚠ desatualizado** | Sem mudança. `/v1/voice/*` continua fora do contrato de API |
| "318 testes no backend" | **⚠ desatualizado** | São 334 |
| Segredo do LLM | **PARCIAL** | Vazio por padrão |
| Contingência sem LLM "para a demo não travar" | **PARCIAL** | Cobre só o gateway de texto; a voz Gemini Live não tem contingência |
| Métrica de latência da voz | **PARCIAL** | Fica sem amostras com o Gemini Live |
| Backend em URL HTTPS fixa | **NÃO FEITO** | Quick tunnel. A demo pública são os fronts em modo mock: precisa de humano, porque o proxy desta sessão não alcança o Pages (`000`) |
| `evidence/rastreabilidade.md` | **⚠ desatualizado** | Sem mudança: ainda há 15 referências à Agora e testes que não existem mais |
| `backend/docs/PERFIS-DEMO.md` | **⚠ contradiz** | Ainda diz "não há assinatura, autenticação ou autorização real" (linha 27) |
| `.idea/` fora do git | **NÃO FEITO** | 6 arquivos versionados |
| Fluxos 1-10, cancelamento e geocodificação | **FEITO** | Igual à rodada anterior, cobertos pelos 334 testes |

## O que falta implementar até 30/11, por retorno

Esforço: **P** (≤ 2 h), **M** (meio dia a 1 dia), **G** (≥ 1,5 dia).

| # | O quê | Critério | Esforço |
|---|---|---|---|
| 1 | **Vídeo de 3 min com o link no README.** Abrir com o caminhão parado em 1 frase; mostrar a voz real, o recebedor avisado, o contador chegando a R$ 525 e o CCO só na exceção | H4 2→6, fecha S5/X7 | M (humano) |
| 2 | **Provar a voz LiveKit ponta a ponta:** credenciais, `make validar`, nova `evidence/validacao.md` (LiveKit) e o link do README apontando para ela | H1 5→6 | M |
| 3 | **Backend numa URL HTTPS fixa** (túnel nomeado ou VM) e uma instância do painel com `VITE_API_BASE_URL` apontando para ela, no ar até o fim da avaliação | H1 6→7 | M/G |
| 4 | **Limitar `POST /livekit/token`** (por IP/identidade e N salas simultâneas) antes de publicar a URL. Sem isso, o item 3 expõe os créditos do Inference | protege H1 (a demo não cai) | P |
| 5 | **Um commit de README:** passo 1 com token (`TOKEN=$(curl -s -X POST .../auth/sso -d '{"email":"…cco…"}' …)`) ou `AUTH_OBRIGATORIA=false` explícito; 318 → 334; linha 111 → "3 tentativas registradas no painel"; `/v1/voice/*` na tabela e nas linhas 101 e 396; "6h40, cobradas como 7 h"; o caso sem STT na LGPD; a linha 126 → "`GET /token`"; o `PERFIS-DEMO.md` | protege H1/H3 (credibilidade) | P |
| 6 | **Conector EDI OCOREN mínimo** (ADR-0001), com teste, endpoint de download e "formato simplificado, não homologado" declarado; mostrar no vídeo | H3 7→8 | M |
| 7 | **Segurança e higiene baratas:** `LLM_SHARED_SECRET` obrigatório com `AUTH_OBRIGATORIA=true`; reservar também `rodar-demo-` para o dono (ou gerar o nome da sala de demo com sufixo aleatório); `unlink` em `sem_transcricao`; remover `.idea/`; atualizar `rastreabilidade.md`; 1 teste do worker/adaptador LiveKit com fake | H2 7→8 | P/M |
| 8 | Ligar o nível `ligacao` do escalonamento à cascata Twilio → RTC, se quiserem manter a frase do README (senão, item 5 basta) | H1 (fluxo) | P/M |
| 9 | No `rodar-ideas`: `/kickoff` mínimo no `PLAN.md` e `/adr` da troca Agora → LiveKit | processo | P |

**Ordem realista:** quinta à noite, itens 5 e 7. Sexta, itens 2 e 4, com o item 6 em paralelo. Sábado, item 3 e PR para `main` com merge commit. Domingo, gravar o vídeo (item 1) e **não commitar depois de 30/11 23h59**.

## Pontuação (só backend)

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | O domínio está completo e testado (334 testes verdes no CI de `main`), e o trabalho de develop agora é visível. Mas o backend não está no ar (quick tunnel), a voz LiveKit não tem prova e o roteiro do README dá 401 no passo 1. A frase "push, painel, ligação" continua desmentida pelo código e pelo próprio README. Saiu um risco (R$ 525 errado), mas nada do que o júri **vê funcionando** mudou |
| H2 | Implementação técnica | 7 | O CI agora roda e está verde no que o júri vê, a sala de demo está protegida com teste e o áudio é apagado com teste. Isso consolida o 7, mas não chega a 8: `LLM_SHARED_SECRET` vazio, worker e adaptador LiveKit sem teste, token sem limite de uso, `.idea/` versionado e rastreabilidade com 15 referências mortas |
| H3 | Impacto | 7 | O número de destaque (R$ 525) agora é verdadeiro, segue o "ou fração" da lei e bate com o painel. A dor tem evidência brasileira e o enquadramento é de logística pura. Não sobe porque não há conector (o "o que vendemos" do ADR-0001), nem usuário real ou piloto |
| H4 | Comunicação (vídeo) | 2 | **Precisa de humano.** Não há vídeo. Com um vídeo que mostre a voz real e o contador, a nota provável é 6 |
| | **Total** | **21/40** | **Diferença para a rodada anterior (21/40): 0 ponto.** Mas o 21 agora é **firme**: antes ele dependia de um merge que não tinha acontecido e tinha dois números públicos que o código desmentia. Com os itens 1-5, a faixa vai para **26-28**; com o OCOREN, para 27-29 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo novo, sem histórico importado | OK | Criado em 22/11, não é fork (API). Tenham a resposta pronta sobre as tags do UNMUTE |
| X2 | Sem código privado anterior | precisa de humano | Igual às rodadas anteriores |
| X3 | Licença | OK | MIT. O LICENSE não cita o Eduardo, o que não é eliminatório |
| X4 | Público até 15/12 | OK | `private=false` |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK (RISCO baixo) | Telefones com formato válido. O áudio offline sem STT fica no disco, mas o seed é fictício |
| X7 | Submissão completa | RISCO | Falta o vídeo; o painel precisa de humano |
| X8 | Sem commit de 01/12 a 12/12 | precisa de humano | Nenhuma automação commita. O "Graph Update" (evento `dynamic`) é do GitHub, não é commit |
| X9 | Time 1-4 | precisa de humano | 4 autores |
| X10 | Trilha | OK | Doca, estadia, recebedor e CCO |

## Submissão (modo projeto)

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano (a frase está no README) |
| S2 | Trilha | precisa de humano |
| S3 | Link do repo | **OK**: `main` agora tem todo o trabalho |
| S4 | Demo HTTPS | precisa de humano: o proxy desta sessão não alcança o Pages; a demo é dos fronts em mock e o backend não tem URL fixa |
| S5 | Vídeo ≤ 3 min | **FALTA** |
| S6 | Aceite do regulamento | precisa de humano |

Saída resumida do `scripts/check-rules.sh` em `main`, informada pelo chamador: **0 FALHA, 2 RISCO**. Os riscos são o README sem link do vídeo e os telefones `+55119000000xx`/`+55199000000xx`.

## Maior retorno

1. **Vídeo de 3 min, com o link no README:** H4 2→6 = **+4** (fecha S5).
2. **Voz LiveKit provada e backend no ar em HTTPS, com token limitado e um painel em modo API:** H1 5→7 = **+2**.
3. **Conector OCOREN mínimo, com teste e no vídeo:** H3 7→8 = **+1**. O commit de README (item 5) custa 1 h e protege H1 e H3.

## Observações

- **Como chequei:** venv no scratchpad com Python 3.12, `requirements.txt` + `requirements-dev.txt` e ruff 0.8.4. `ruff check .` limpo; `pytest -q` contra o Postgres 16 do sistema (`avisai_test`): **334 passed, 71 warnings** (chave HMAC curta nos testes), 30,8 s. API local com `AUTH_OBRIGATORIA=true` sobre `avisai_demo`: rodei `alembic upgrade head` (aplicou `20261126_cancelada_geo`) e o seed, e conferi `/health` 200 e `reset` 401. Valores da estadia e variantes de sala testados direto nas funções. CI, PRs e branch padrão vieram da API do GitHub.
- **Limpeza:** apaguei o venv, removi os `.pyc` cpython-312 que eu gerei (ignorados pelo git) e **parei o Postgres 16** (`pg_ctlcluster 16 main stop`). O banco local `avisai_demo` ficou migrado e semeado. O `git status` do backend está limpo, e nada foi escrito nos repositórios de código.
- **Valor da tarifa:** o texto da lei traz R$ 1,38 por t/h com correção anual. O README usa R$ 2,50 com link da ANTT. Confirmem que a fonte é de 2025/2026, porque um jurado de economia pode perguntar.
- **Demo acelerada:** com o arredondamento, o contador salta de R$ 0 para R$ 75 logo depois das 5 h e depois sobe R$ 75 por hora começada. No vídeo, narrem "hora começada conta inteira, como manda a lei", para não parecer bug.
- **"R$ 323 numa espera de 4h"** (ADR-0001 e `rodar.md`) é custo, não estadia: o backend dá R$ 0 para 4h. No pitch, digam "custo que ninguém cobra".
- **Congelamento:** a partir de 01/12, nenhum commit nem merge nos três repositórios.
