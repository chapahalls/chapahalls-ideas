# Judge: RODAR (projeto), 2026-11-28 10:10

Gatilho: push na main de rodar-web adea4d5 por HenryFacens.
Repositórios avaliados (clonados em ../): rodar-backend 09e6a6b, rodar-web adea4d5, rodar-mobile 91ad99e, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 sem vídeo, S4 com o link do mobile em 404) · Prazo: faltam 2d13h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-0931](judge-20261128-0931.md), 23/40): a nota não muda, mas metade do bloqueio que se repetia há oito rodadas caiu.
- Só o web mudou (`05d559e` → `adea4d5`): 1 commit `fix(api)`, +60/−27 em 10 arquivos. O guard `isCall` passa a aceitar `motivo: "atraso"`, e vieram junto os toasts limitados a 3 e o descarte do aviso de push lembrado.
- `repos/rodar-web/score.md` foi refeito às 10h08 sobre `adea4d5`: **15/20** (H1 8, H2 7). Aceito, porque é do mesmo commit. Ele rodou typecheck, lint (0 avisos), 145/145 testes e o build. O e2e não rodou por falta de Chromium no runner.
- **A Vercel agora aponta para o CloudFront.** O bundle novo `index-B7qoDroS.js` carrega `operations-ChcY7kPI.js`, que chama `https://d3fy4m7zwukr3x.cloudfront.net`. Não há mais referência a `rodar-backend-five.vercel.app`.
- O `adea4d5` era pré-requisito disso: o banco público tem **13 ligações com `motivo: "atraso"`** em 49. Com o bundle antigo, o modo API rejeitaria a resposta inteira (`invalid_response`) assim que conectasse.
- Backend, mobile e keycloak estão no mesmo HEAD. `repos/rodar-backend/score.md` (09h30) e `repos/rodar-mobile/score.md` (01h07) são dos commits atuais. O `repos/rodar-backend/STATUS.md` já foi atualizado para `09e6a6b` (`c893fe9`).

**Conferido às 10h11 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, `llm_upstream: true`, `auth_obrigatoria: true`, `sha: "09e6a6b"`. O deploy contínuo atualizou, e a dúvida da rodada anterior está resolvida.
- O preflight CORS com `Origin: https://rodar-web-beta.vercel.app` devolve `access-control-allow-origin` correto. `/cco/estado`, `/rotas`, `/ligacoes` e `/livekit/config` respondem 200.
- `https://rodar-web-beta.vercel.app/home` e `/mobile-web`: 200.
- `https://rodarglobal.github.io/rodar-mobile/`: **404**, pela nona rodada. O README do mobile (linhas 31 e 261) e o `repos/rodar-mobile/STATUS.md` ainda o anunciam como **Ok**.
- `rodar-backend-five.vercel.app/health`: 503, `banco_ok: false`. Nenhum front chama mais essa API, mas o README do backend ainda diz que "a Vercel (sem banco) também recebe deploy automático". Ela é inofensiva, e o melhor é não citá-la.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link: backend (l.44), web (l.39) e mobile (l.38) ainda têm o comentário-lembrete. Sem o vídeo, o projeto é desclassificado. Faltam 2d13h.
- **RISCO S4/H1: o link da demo do mobile dá 404 (nona rodada).** Ou se liga a Pages (Settings → Pages → Source: GitHub Actions, e `workflow_dispatch` no `demo-pages.yml`), ou se troca o link do README pelo `https://rodar-web-beta.vercel.app/mobile-web`, que responde. A primeira opção não precisa de commit.
- **Precisa de humano, antes de gravar:** abrir `rodar-web-beta.vercel.app`, clicar em **Conectar à API** e confirmar que o painel carrega a frota real e aceita uma ação do CCO. Testei os endpoints com `curl`, não o navegador. Um ponto me deixa em dúvida: `POST /auth/sso` sem e-mail devolve um perfil com papel `driver`, e as ações da central exigem `cco`. Confiram que o painel manda o e-mail do operador.
- **READMEs que a realidade desmente (H2), agora com um item novo:**
  - **web, l.239:** "O deploy usa o modo Demo (sem `VITE_API_BASE_URL`): não chama uma API real". Desde hoje é falso. Desta vez o erro é a favor de vocês: o README pode passar a anunciar o modo API contra o CloudFront;
  - **web, l.33:** "33 de 33 etapas", enquanto o backend diz "3 de 4 rodadas em 34/34";
  - **backend, l.36:** o motorista estaria "sem demo web própria", mas o `/mobile-web` responde 200;
  - **totais de testes:** o backend diz 661 (425/127/109), o mobile 554 (318/127/109), e o web roda 145.
- **RISCO H2 (web):** a segunda quebra seguida de contrato API↔web foi corrigida sem teste de regressão. Nada falha se o `isCall` voltar a rejeitar `'atraso'`. O backend ainda vai mudar nas próximas 60h.
- **RISCO H1 (mobile), sem mudança:** a voz LiveKit nativa está sem os plugins Expo (`@livekit/react-native-expo-plugin`, `@config-plugins/react-native-webrtc`) e nunca rodou num aparelho (o próprio STATUS diz isso).
- **RISCO H1 (backend), sem mudança:** a 5e falha 1 em 4 (declarado). O atraso fechado e a negação da fila seguem sem teste.
- **Higiene, sem mudança:** o `.idea/` está versionado no mobile, e a `main` do web está sem proteção.
- **STATUS desatualizado:**
  - `repos/rodar-mobile/STATUS.md` marca "Ver o app sem instalar" como **Ok** com o link do github.io, que dá 404;
  - `repos/rodar-web/STATUS.md` para em `bac015f` e não registra o `adea4d5` nem a troca do `VITE_API_BASE_URL` na Vercel. Rodem `/registrar rodar-web`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 09e6a6b | 9 | 9 | **18** | `repos/rodar-backend/score.md` (09h30, mesmo commit) |
| rodar-web | adea4d5 | 8 | 7 | **15** | `repos/rodar-web/score.md` (10h08, mesmo commit). A ressalva da rodada anterior ("14 enquanto o deploy apontar para a API sem banco") **cai**, porque o deploy aponta para o CloudFront |
| rodar-mobile | 91ad99e | 5 | 7 | **12** | `repos/rodar-mobile/score.md` (01h07, mesmo commit) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto (não há score.md). O mobile só o usa atrás de flag, e o backend não valida o token dele |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sobe por dentro, mas não muda de faixa. Agora o painel público fala com a API real: o CloudFront está no HEAD, com banco, LLM, auth e CORS para a Vercel. O `adea4d5` evita que as 13 ligações `atraso` derrubem o modo API. O `/mobile-web` responde, e há 4 rodadas medidas contra a AWS. Não chega a 7 por três motivos. O link da demo do mobile dá 404 no README que o júri lê. A voz nativa não tem prova em aparelho. E não há vídeo que mostre a voz real, que é o que o júri, sem instalar nada, usa para dar 7. *Precisa de humano:* com o link do mobile vivo, o "Conectar à API" confirmado no navegador e o vídeo, a nota provável é 7 |
| H2 | Implementação técnica | 7 | Sem mudança. O backend está no nível de referência. A correção do web atravessa guard, tipos, adapter e i18n de forma coerente, mas sem teste, e é a segunda regressão de contrato seguida. O 8 continua preso fora do backend: o LiveKit nativo sem plugin, o `.idea/` versionado, a `main` do web sem proteção, o keycloak que ninguém valida e quatro números de testes e etapas que não batem entre os READMEs |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média e 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem a estadia). O benefício está estimado em R$ por entrega, e o OCOREN liga o produto ao TMS. O aviso de atraso ao recebedor, agora visível no painel, reforça o fluxo de informação motorista→recebedor→CCO. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, e os tours de 1 min são Mock. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo, o link do mobile corrigido e os READMEs alinhados, a nota provável é 27-28/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11, público) está declarada |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Não arquivem nem tornem privados antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones do backend seguem o padrão fictício `9000000xx`, e os e-mails usam `.test`. O do web é exemplo de formato E.164, e o mockup tem CPF zerado. O do SVG do keycloak é falso positivo (path). O `/ligacoes` público devolve só números `+55199000000xx` |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O link da demo do mobile dá 404 (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cada push na main do backend faz deploy, e a Vercel do web também. De 01/12 a 12/12, nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmem no painel e garantam a presença em 12/12 |
| X10 | Enquadramento | OK | Doca, estadia e fluxo de informação entre motorista, recebedor e CCO. Não vendam o "modo direção" como segurança do motorista |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 10 RISCOS**, os mesmos da rodada anterior.
- Nenhum dos quatro READMEs tem o link do vídeo (4 RISCOS).
- No keycloak faltam o link da demo, a seção de dependências e a separação de terceiros (3 RISCOS).
- Os possíveis telefones do backend e do web são fictícios, e o do SVG do keycloak é falso positivo (3 RISCOS).
- Deram OK: X1, X3, X4, X6 (sem `.env` nem credenciais) e X7/X8 (main em dia).
- O script não pega o link do mobile em 404 nem a URL da API no bundle da Vercel. Conferi os dois com `curl`.
- Ficam para checagem humana: X2, X9, X10, S1, S3, S4, S5 e S6.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Submetam backend, web e mobile e **não** o rodar-keycloak, ou completem o README dele |
| S4 | Demo HTTPS no ar | **RISCO**, menor que antes. No painel, ponham `https://rodar-web-beta.vercel.app/home` (agora com o modo API contra o CloudFront), `https://rodar-web-beta.vercel.app/mobile-web` para o motorista e `https://d3fy4m7zwukr3x.cloudfront.net/docs` para a API. Não ponham o `github.io/rodar-mobile` enquanto der 404 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Desde hoje, o painel da Vercel mostra os dados reais do CloudFront, então o vídeo pode ser gravado inteiro sobre URLs públicas. O roteiro:
   - a doca em uma frase, com os 11h40 em CD na Grande SP;
   - a voz real pelo `/mobile-web`, com o recebedor avisado e a doca preenchida;
   - o painel em modo API recebendo o aviso de atraso e o escalonamento até o CCO;
   - a estadia em R$ e o OCOREN.
2. **Matar o 404 do mobile hoje**, ligando a Pages sem commit ou trocando o link pelo `/mobile-web`, e confirmar o "Conectar à API" no navegador. **H1 6→7 = +1.**
3. **Coerência e um teste, um commit por repo, até 29/11.** **H2 7→8 = +1.**
   - Um só número de testes e etapas nos três READMEs.
   - Web: a l.239 passa a dizer que o deploy usa o CloudFront. Entra um teste de contrato do snapshot do backend, com `aproximacao`, `cco_sem_resposta` e `atraso` passando por `isCall` e `projectSnapshot`. E a proteção da `main` é ligada.
   - Backend: trocar "sem demo web própria" pelo `/mobile-web` e parar de citar a Vercel sem banco.
   - Mobile: os plugins LiveKit/WebRTC com teste no celular, ou a declaração de que o nativo roda em Mock. Tirar o `.idea/`.

## Observações

- **Este foi o melhor commit das últimas rodadas para o que o júri vê**, mesmo sem mover a nota. Junto com a troca da variável na Vercel, ele resolveu o alerta mais antigo do relatório. Repararam o contrato antes de virar a chave, em vez de descobrir a quebra com o júri. Falta agora o equivalente do lado do mobile (o 404) e o vídeo.
- O modo API continua opcional ("Conectar à API"), e o painel abre na Demo. Isso é seguro para a avaliação, mas o júri só vê o produto real se clicar no botão. No vídeo, mostrem o clique. No painel de submissão, uma frase como "clique em Conectar à API para ver a operação real" ajuda.
- A troca Agora → LiveKit continua sem `/adr`. O `CLAUDE.md` e o ADR-0001 ainda dizem "Agora Conversational AI".
- Ordem sugerida:
  - dia 28: Pages do mobile, confirmação do modo API no navegador, teste da voz no celular e começo da gravação;
  - dia 29: o item 3 e o vídeo final. Nada de pipeline nem Terraform;
  - dia 30: só os links do vídeo e a conferência final (`/health`, bundle da Vercel apontando para o CloudFront, link do mobile).
- De 01/12 a 12/12, nenhum commit nem redeploy, e a CI que publica a cada push fica parada. Não mexam nas variáveis da Vercel nem da AWS nesse período. A demo fica no ar até o fim da avaliação, e os repos ficam públicos até 15/12.
