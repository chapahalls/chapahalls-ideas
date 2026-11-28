# Judge: RODAR (projeto), 2026-11-28 09:00

Gatilho: push na main de rodar-backend 8b303db por HenryFacens.
Repositórios avaliados (clonados em ../): rodar-backend 8b303db, rodar-web 05d559e, rodar-mobile 91ad99e, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 sem vídeo, S4 com as demos anunciadas quebradas) · Prazo: faltam 2d14h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-0856](judge-20261128-0856.md), 23/40): o total não muda.
- Só o backend mudou (`d8af042` → `8b303db`). É 1 commit `fix(ci)`, e só o `.github/workflows/ci.yml` mudou (+6/−4). Web, mobile e keycloak estão no mesmo HEAD.
- O commit confirma o RISCO da rodada anterior: o primeiro deploy por revision `:sha` falhou. O `register-task-definition` não leu o JSON de `file:///dev/stdin`. A correção passa o JSON como texto.
- `repos/rodar-backend/score.md` foi refeito às 08h59 sobre `8b303db`: **17/20** (H1 8, H2 9). Aceito, porque o código em `backend/` é idêntico ao da rodada anterior (425 testes).

**Conferido às 09h00 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, `llm_upstream: true`, **`sha: "62076bd"`**. Nem `d8af042` nem `8b303db` estão no ar. A falha deixou o serviço na revision anterior, então a demo da API não caiu.
- `https://rodar-web-beta.vercel.app/home`: o bundle continua `index-B9aLfjQ1.js`, e a API que ele chama (`rodar-backend-five.vercel.app/health`) responde `ok: false, banco_ok: false, sha: "dev"`. **O painel em modo API continua sem banco, pela sexta rodada seguida.**
- `https://rodar-web-beta.vercel.app/mobile-web`: 200.
- `https://rodarglobal.github.io/rodar-mobile/`: **404**. O README do mobile ainda o anuncia.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link. Sem o vídeo, o projeto é desclassificado. Faltam 2d14h.
- **RISCO S4/H1: as duas demos anunciadas seguem quebradas, pela sexta rodada seguida.** As duas correções dispensam commit:
  - na Vercel, `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy;
  - no mobile, ligar a Pages ou, se o link mudar no README, apontar para o `/mobile-web`.
- **RISCO (backend, infra): o deploy por `:sha` ainda não teve nenhuma execução bem-sucedida.** Esta é a segunda tentativa. Antes de qualquer outro push, confiram o job `deploy` de `8b303db` e o `/health` com `sha: "8b303db"`. Se falhar de novo, voltem ao `force-new-deployment` em vez de tentar uma terceira variação. A partir de 29/11, nada de pipeline nem Terraform.
- **RISCO H1 (backend), sem mudança:** a correção da fila na doca está no ar desde `62076bd`, mas sem medição. A evidência publicada ainda mostra 5e em 1/4 e 5e2 em 0/4. Seguem sem teste o atraso já fechado e a negação ("não tem fila").
- **RISCO H1 (mobile), sem mudança:** a voz LiveKit nativa está sem os plugins Expo (`@livekit/react-native-expo-plugin`, `@config-plugins/react-native-webrtc`) e sem teste em aparelho.
- **Os números não batem entre os READMEs, sem mudança:**
  - o backend diz 661 testes (425 + 127 + 109);
  - o mobile diz 554 e "33 de 33";
  - a contagem real é perto de 700, e a validação dá 32 de 34.
  - O README do backend ainda diz que o motorista "não tem demo web própria", mas o `/mobile-web` responde.
- **Higiene, sem mudança:** o `.idea/` continua versionado no mobile, e a `main` do web continua sem proteção.
- **STATUS desatualizado:**
  - `repos/rodar-backend/STATUS.md` descreve `4d01768`: cita 413 testes e não registra o `dry_run`, o deploy por `:sha` nem a falha dele.
  - `repos/rodar-mobile/STATUS.md` é de `28e1569`, da época do Agora.
  - Rodem `/registrar` nos dois.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 8b303db | 8 | 9 | **17** | `repos/rodar-backend/score.md` (08h59, mesmo commit). A AWS ainda está em `62076bd` |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (sobre `bac015f`; o diff até `05d559e` só mexe no tour). *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, H1 é 7 (14/20) |
| rodar-mobile | 91ad99e | 5 | 7 | **12** | `repos/rodar-mobile/score.md` (01h07, mesmo commit) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto (não há score.md). O mobile só o usa atrás de flag, e o backend não valida o token |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | O backend público está no ar com banco e LLM, a 4c tem 4/4 contra a AWS, e o `/mobile-web` responde. Mas o jurado que segue os READMEs encontra o painel sem banco e a demo do mobile em 404. O que está na AWS está dois commits atrás do HEAD, e a fila na doca não foi medida. *Precisa de humano:* com a Vercel apontando para o CloudFront, o link do mobile vivo, a 5e/5e2 em pelo menos 3/4 no ar e o vídeo mostrando a voz real, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend segue forte, e o deploy falhou para o lado seguro, sem derrubar o serviço. Por outro lado, o pipeline foi mudado sem ensaio e quebrou na primeira execução. O que segura o 8 está fora do backend: o LiveKit nativo sem plugin, o `.idea/` versionado, a `main` do web sem proteção, o keycloak que ninguém valida e três totais de testes diferentes |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média e 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem a estadia). O benefício está estimado em R$ por entrega, e o OCOREN amarra o produto ao TMS. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, e os tours de 1 min são Mock. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo, as duas demos funcionando e os números alinhados, a nota provável é 27-28/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11, público) está declarada |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Não arquivem nem tornem privados antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones do backend seguem o padrão fictício `9000000xx`. O do web é exemplo de formato E.164. O do SVG do keycloak é falso positivo. O commit novo só mexe na CI |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). As demos anunciadas estão quebradas (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cada push na main do backend faz deploy. De 01/12 a 12/12, nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmem no painel e garantam a presença em 12/12 |
| X10 | Enquadramento | OK | Doca, estadia e fluxo de informação entre motorista, recebedor e CCO. Não vendam o "modo direção" como segurança do motorista |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 10 RISCOS.**
- Nenhum dos quatro READMEs tem o link do vídeo (4 RISCOS).
- No keycloak faltam o link da demo, a seção de dependências e a separação de terceiros (3 RISCOS).
- Os possíveis telefones do backend e do web são fictícios, e o do SVG do keycloak é falso positivo (3 RISCOS).
- Deram OK: X1, X3, X4, X6 (sem `.env` nem credenciais) e X7/X8 (main em dia).
- O script não pega duas coisas, e conferi as duas com `curl`: o link do mobile dá 404, e o bundle da Vercel chama a API sem banco.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Submetam backend, web e mobile e **não** o rodar-keycloak, ou completem o README dele |
| S4 | Demo HTTPS no ar | **RISCO**. No painel, ponham `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`, depois de apontar o `VITE_API_BASE_URL` para o CloudFront. Não ponham o `github.io/rodar-mobile` enquanto der 404 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** O roteiro:
   - a doca em uma frase, com os 11h40 em CD na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado e a doca preenchida;
   - o escalonamento até o CCO;
   - a estadia em R$ e o OCOREN.
2. **Pôr as demos de pé hoje (28/11), primeiro o que dispensa commit.** **H1 6→7 = +1.**
   - Vercel: trocar o `VITE_API_BASE_URL` e fazer o redeploy. Confiram que o bundle deixou de ser `index-B9aLfjQ1.js`.
   - Mobile: ligar a Pages.
   - Backend: confirmar `sha: "8b303db"` no `/health`. Se falhar, voltar ao `force-new-deployment`. Depois, cobrir o atraso fechado e a negação da fila com testes e medir a 5e/5e2 de 4 a 8 vezes contra o CloudFront.
3. **Coerência e higiene em web e mobile, um commit por repo, até 29/11.** **H2 7→8 = +1.**
   - Um só total de testes e a medição real (32 de 34) nos três READMEs. No backend, citar o `/mobile-web`.
   - Mobile: os plugins LiveKit/WebRTC com teste no celular, ou a declaração de que o nativo roda em Mock. Tirar o `.idea/`.
   - Web: ligar a proteção da `main`.

## Observações

- Três commits seguidos no backend (`62076bd`, `d8af042`, `8b303db`) não chegaram ao júri: a AWS segue em `62076bd`. O esforço que sobe a nota agora está no vídeo, na Vercel e no mobile, não no pipeline.
- A troca Agora → LiveKit continua sem `/adr`. O `CLAUDE.md` e o ADR-0001 ainda dizem "Agora Conversational AI".
- Ordem sugerida:
  - dia 28: as correções sem commit (Vercel e Pages), o deploy do backend confirmado e o teste da voz no celular;
  - dia 29: o item 3 e a gravação;
  - dia 30: só os links do vídeo e a conferência final (`/health`, bundle, link do mobile).
- De 01/12 a 12/12, nenhum commit nem redeploy, e a CI que publica a cada push fica parada. A demo fica no ar até o fim da avaliação, e os repos ficam públicos até 15/12.
