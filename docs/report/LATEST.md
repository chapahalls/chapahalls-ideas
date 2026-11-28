# Judge: RODAR (projeto), 2026-11-28 01:10

Gatilho: push na main de rodar-mobile 91ad99e por HenryFacens. Repositórios avaliados: rodar-backend 4d01768, rodar-web 05d559e, rodar-mobile 91ad99e, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 sem vídeo, S4 com as demos anunciadas quebradas) · Prazo: faltam 2d22h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-0057](judge-20261128-0057.md), 23/40): o total não muda. Só o mobile mudou (`da468ad` → `91ad99e`).
- **Mobile:** o commit `91ad99e` (35 arquivos, +1229/−1456) troca a voz real de Agora (`react-native-agora`) por LiveKit (`@livekit/react-native`). Assim, **o app passa a falar o mesmo protocolo do backend no ar** (`livekit_configurada: true`). Isso fecha, no código, a incompatibilidade Agora × LiveKit que o relatório anterior apontou. Só que nada prova que funciona: o `app.config.ts` não tem o plugin Expo do LiveKit nem o do WebRTC, e o próprio commit diz que a voz "não pôde ser testada em dispositivo real". O `repos/rodar-mobile/score.md` foi refeito às 01h07 sobre `91ad99e`: **12/20** (H1 5, H2 7). Aceito o número, que bate com a ressalva de projeto da rodada anterior.
- **Backend:** sem mudança (`4d01768`). O score.md é das 00h55, sobre o mesmo commit: **17/20**.
- **Web:** o score.md é de `bac015f`, e o HEAD é `05d559e`. Conferi o diff: é um único `fix(tour)` (o cursor do tutorial não teleporta mais), mais a reaplicação do contraste do aviso de push. Não muda a nota do repo.
- **Keycloak:** sem mudança e sem score.md próprio.

**Conferido às 01h10 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: 200, `ok: true`, `banco_ok: true`, `sha: "4d01768"`, `livekit_configurada: true`, `twilio_configurado: false`, `recebedor_modo: rtc`, `ligar_recebedor_na_aproximacao: true`. **A AWS está em dia com o HEAD do backend.**
- `https://rodar-web-beta.vercel.app/home`: 200, mas o bundle continua `index-B9aLfjQ1.js`. O chunk `operations-Bi56NYIX.js` ainda chama `https://rodar-backend-five.vercel.app`, e esse `/health` responde `ok: false, banco_ok: false, sha: "dev"`. **O painel que o júri abre em modo API continua sem banco.**
- `https://rodar-web-beta.vercel.app/mobile-web`: 200.
- `https://rodarglobal.github.io/rodar-mobile/`: **404 "Site not found · GitHub Pages"**. O README do mobile ainda o anuncia como "Abrir o app no navegador", na primeira linha útil da tabela "Para o júri".
- No mobile, `git ls-files .idea` ainda lista 6 arquivos (`avisai-mobile.iml` etc.).

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link. O comentário-lembrete continua no mobile (linha 38), no backend (linha 44) e no web (linha 39). Sem o vídeo, o projeto é desclassificado. Faltam 2d22h.
- **RISCO S4/H1: as duas demos anunciadas seguem quebradas.** É o terceiro relatório seguido com o mesmo alerta, e as duas correções dispensam commit:
  - o painel da Vercel chama a API sem banco (`rodar-backend-five.vercel.app`). Troquem o `VITE_API_BASE_URL` para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy;
  - `rodarglobal.github.io/rodar-mobile` dá 404. Ou liguem a Pages (Settings → Pages → Source: GitHub Actions) e rodem de novo o `Demo (GitHub Pages)`, ou troquem o link do README pelo `/mobile-web` da Vercel, que já responde 200.
- **RISCO H1 (novo, mobile): a voz nativa foi reescrita a 2 dias do prazo e não tem prova em aparelho.** Faltam `@livekit/react-native-expo-plugin` e `@config-plugins/react-native-webrtc` em `plugins` do `app.config.ts`. Sem eles, o `expo prebuild` do Dev Build não faz o `LiveKitReactNative.setup` que o Android exige. O fallback para Mock (`livekitVoiceSession.ts`) evita que o app quebre, mas então o motorista "conversa" com uma voz simulada. Precisa de um humano com celular antes de qualquer gravação.
- **RISCO H1: a fila na doca falha no ar** (backend, sem mudança): 5e em 1/4 e 5e2 em 0/4 contra o CloudFront com LLM real. O falso positivo "beleza, obrigado" → `quantos` continua sem teste. Não gravem essa etapa falada.
- **Credibilidade dos números (novo, mobile):** a tabela "Para o júri" do README do mobile diz "validação ponta a ponta com a API real: **33 de 33 etapas**" e "554 testes: 318 no backend, 127 no web, 109 no mobile". A evidência atual do backend dá 32-33 de **34**, e hoje são 413 + 145 + 130. Um jurado de dados que abrir o link vai ver o número não bater. O backend também diz 649 no total. Os três READMEs precisam do mesmo número.
- **A ligação telefônica real está desligada** (`twilio_configurado: false`, `recebedor_modo: rtc`). No vídeo, digam "chamada pelo navegador", não "ligação".
- **Higiene que o júri vê:** `.idea/` versionado no mobile, "júri"/"score.md" em 6 testes do backend e em `infra/README.md`, `main` do web sem proteção, frase da tag `v0.1.0-entrega` inexistente no README do mobile.
- **STATUS desatualizado:** o `repos/rodar-mobile/STATUS.md` (de `28e1569`) dá como Ok a `AgoraVoiceSession` e o Whisper local, que já não existem, e fala em 86 testes (são 130). O `repos/rodar-backend/STATUS.md` está sobre `4d01768`, mas ainda diz que a 5e2 é "a única etapa que falha de forma repetida". Rodem `/registrar rodar-mobile`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 4d01768 | 8 | 9 | **17** | `repos/rodar-backend/score.md` (00h55, mesmo commit). A AWS está no `sha` do HEAD |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (sobre `bac015f`). Conferi o diff até `05d559e` (só o tour), e ele não muda a nota. *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, H1 é 7 (14/20) |
| rodar-mobile | 91ad99e | 5 | 7 | **12** | `repos/rodar-mobile/score.md` (01h07, mesmo commit). A demo dá 404, a voz LiveKit está sem plugin nativo e sem teste em aparelho, e o vídeo do repo é Mock. Em H2: 130 testes, lint zerado e camada de voz isolada |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto (não há score.md). O mobile só o usa atrás de flag (o padrão é mock), e o backend não valida o token. Faltam no README a demo, as dependências e os terceiros |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | O backend público está no ar com banco, no `sha` do HEAD. A 4c foi medida em 4/4 contra o CloudFront, e o `/mobile-web` responde. Mas o jurado que segue os READMEs encontra o painel sem banco, a demo do mobile em 404 e a fila na doca falhando em 3 a 4 de 4 rodadas. A migração para LiveKit alinha o app ao backend, mas sem prova em aparelho não conta como "funciona". *Precisa de humano:* com a Vercel apontando para o CloudFront, o link do mobile vivo e o vídeo mostrando a voz real, a nota provável é 7 |
| H2 | Implementação técnica | 7 | A melhor parte é o backend: guardas determinísticas na borda das ferramentas, medidas no ambiente real, e uma heurística que contaminaria os dados recusada com justificativa. O mobile trocou de provedor de voz num commit só, sem mexer no contrato `VoiceSession`, o que prova o isolamento da camada, e tem 130 testes. O que segura: o LiveKit nativo está sem o plugin Expo (uma integração mal configurada até prova em contrário), há arquivos de IDE versionados, "júri" nos testes do backend, a `main` do web sem proteção, um keycloak que ninguém valida e números de teste diferentes nos READMEs |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média e 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem a estadia). O benefício está estimado em R$ por entrega, e o OCOREN amarra o produto à integração com o TMS. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo de 3 min não existe, e os tours de 1 min são Mock. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo e as duas demos funcionando, a nota provável é 27/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11, público) está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Públicos e sem fork. Não arquivem nem tornem privados antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones seguem o padrão fictício `9000000xx` ou são exemplo de formato E.164 (`+5511999999999`). O CPF do mockup do web é zerado, e o alerta no SVG do keycloak é falso positivo. O diff do mobile não traz dado pessoal |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). As duas demos anunciadas estão quebradas (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cada push na main do backend faz deploy na AWS e, no mobile, publica a Pages. De 01/12 a 12/12, nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmem no painel e garantam a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. Não vendam o "modo direção" do mobile como segurança do motorista no pitch |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 10 RISCOS.**
- Nenhum dos quatro READMEs tem o link do vídeo (4 RISCOS).
- No keycloak faltam o link da demo, a seção de dependências e a separação de terceiros (3 RISCOS).
- Os possíveis telefones/CPF do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3 RISCOS). Conferi à mão.
- Deram OK nos quatro: X1, X3, X4, X6 (sem `.env` e sem credenciais) e X7/X8 (main em dia com o remote).
- O script não vê dois problemas: ele dá OK ao link de demo do mobile só porque o link está no texto, e o link responde 404. Ele também não vê a URL de API no bundle da Vercel. Conferi os dois com `curl`.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: submeter backend, web e mobile e **não** submeter o rodar-keycloak, ou completar o README dele (dependências, terceiros, demo) |
| S4 | Demo HTTPS no ar | **RISCO**. No painel: `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` para o CloudFront. Não ponham o `github.io/rodar-mobile` enquanto der 404. Testem em aba anônima |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro para um júri que nunca viu uma doca:
   - a doca em uma frase, com o dado de 11h40 em CD na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront (é o caminho de voz real que funciona hoje), com o recebedor avisado na aproximação e a doca preenchida (4c, 4/4);
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   **Não gravem a fila na doca falada** nem o app nativo com voz LiveKit sem antes testá-lo no celular.
2. **Pôr as duas demos de pé, sem commit, hoje (28/11).** **H1 6→7 = +1.**
   - Vercel: `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy. Confiram que o chunk `operations-*.js` deixou de citar `rodar-backend-five`.
   - Mobile: liguem a Pages e rodem de novo o `Demo (GitHub Pages)`. Se não subir até 29/11, troquem o link do README pelo `/mobile-web`.
   - Depois, no backend: abrir uma `fila` nova na borda depois da chegada, descartar "ok/beleza/obrigado" com testes e medir 4 vezes no CloudFront.
3. **Fechar a voz nativa e a coerência dos números, um commit por repo, até 29/11.** **H2 7→8 = +1.**
   - Mobile: adicionem os plugins `@livekit/react-native-expo-plugin` e `@config-plugins/react-native-webrtc`, gerem o Dev Build e façam uma conversa real no celular. Se falhar até 29/11, declarem no README que o nativo roda em Mock e que a voz real é o `/mobile-web`. Tirem o `.idea/` do git.
   - READMEs: um só número de testes nos três (413 + 145 + 130 = 688) e a validação como "32-33 de 34; falham 5e e 5e2", no lugar de "33 de 33".
   - Backend: tirar "júri" dos testes e do `infra/README.md`. Web: ligar a proteção da `main`.

## Observações

- A migração Agora → LiveKit é a decisão certa, porque o backend já usava LiveKit e o app não conversava com ele. Mas ela muda a pilha descrita no `CLAUDE.md` e no ADR-0001, que ainda dizem "Agora Conversational AI". Registrem a troca com `/adr`. Fazer a migração a 2 dias do prazo, sem prova em aparelho, é o tipo de risco que só vale se for testada hoje.
- A medição da 4c (de 1/4 para 4/4 no ar, conferida no banco) continua sendo a melhor prova de H1 do projeto. Para um júri de dados e ML, a tabela de rodadas por etapa vale um slide na final.
- Com 4 amostras, 1/4 contra 2/4 na 5e é ruído. Para afirmar melhora, rodem de 8 a 10 vezes por versão.
- O smoke do deploy ainda faz um GET que incrementa a sequência do OCOREN em produção.
- O login Keycloak só vale como argumento de H2 se o backend validar o token. Até 30/11, não o ponham no caminho da demo.
- Ordem sugerida: no dia 28, o item 2 (primeiro a parte sem commit) e o teste da voz LiveKit no celular; no dia 29, o item 3 e a gravação; no dia 30, só os links do vídeo, a conferência do `/health`, do bundle da Vercel e do link do mobile, e um `validar_fluxos.py` final. No último dia, nada de mexer na voz.
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar até o fim da avaliação e os repos públicos até 15/12. A CI que publica a cada push precisa ficar parada nesse período.
