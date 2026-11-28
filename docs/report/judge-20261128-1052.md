# Judge: RODAR (projeto), 2026-11-28 10:52

Gatilho: push na main de rodar-web 18f0e2a por HenryFacens. Repositórios avaliados (clonados em ../): rodar-backend 09e6a6b, rodar-web 18f0e2a, rodar-mobile 91ad99e, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 sem vídeo, S4 com o link do mobile em 404) · Prazo: faltam 2d13h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-1010](judge-20261128-1010.md), 23/40): a nota não muda. Entraram polimento no web e um achado novo que mexe no roteiro do vídeo.
- Só o web mudou (`adea4d5` → `18f0e2a`), com 3 commits e +74/−15 em 6 arquivos:
  - `042e3d1`: o toast ficou opaco;
  - `15ddd39`: a fila de alertas mostra uma linha por viagem, com teste novo;
  - `18f0e2a`: no modo API, o traçado é ajustado à via pela Routes API do Google. É só visual e não tem teste.
- `repos/rodar-web/score.md` foi refeito às 10h50 sobre `18f0e2a`: **15/20** (H1 8, H2 7), com 146/146 testes, typecheck, lint e build. Aceito, porque é do mesmo commit. Os outros score.md também são dos HEADs atuais (backend 09h30, mobile 01h07).
- **Achado novo, registrado pelo time em `85f85b5`** (`repos/rodar-backend/STATUS.md` l.19 e l.91, `repos/rodar-web/STATUS.md` l.96, `repos/rodar-backend/decisoes.md`). Com `RECEBEDOR_MODO=rtc`, a ligação ao recebedor só cria uma sala LiveKit e um link `pagina_recebedor`. Ninguém recebe esse link: não há SMS nem WhatsApp, e o painel não o mostra. Por isso, no backend local, a ligação termina `nao_atendida`. É o momento central do pitch ("avisa o recebedor").
- O commit cita `rodar-backend@eb1977e`, que **não existe** no clone do backend. Ou é local, ou está numa branch sem push. O diagnóstico vale mesmo assim, porque o código confirma.

**Conferido às 10h53 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health` responde `ok`, `banco_ok`, `sha: "09e6a6b"`, `recebedor_modo: "rtc"` e `ligar_recebedor_na_aproximacao: true`.
- `/recebedor?ligacao=1`: 200. A página que o recebedor abre existe e está no ar.
- `/ligacoes` público: 49 ligações, 48 `respondida` e 1 `atraso`/`nao_atendida`. Na produção, o histórico que o júri veria está quase todo atendido, o que sugere atendimento feito pelas rodadas de validação. Uma ligação **nova** feita ao vivo durante a gravação cai no problema acima, se ninguém abrir o link.
- Vercel: o bundle novo `index-OQn5saLx.js` ainda usa `operations-ChcY7kPI.js`, que aponta para o CloudFront. `/home` e `/mobile-web` respondem 200.
- `https://rodarglobal.github.io/rodar-mobile/`: **404**, pela décima rodada.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link: backend (l.44), web (l.39) e mobile (l.38) ainda têm o comentário-lembrete. Sem o vídeo, o projeto é desclassificado. Faltam 2d13h.
- **RISCO S4/H1: o link da demo do mobile dá 404 (décima rodada).** `rodar-mobile/README.md` l.31 e l.261, e `repos/rodar-mobile/STATUS.md` l.49 marcam esse link como **Ok**. Há duas saídas:
  - ligar a Pages (Settings → Pages → Source: GitHub Actions, depois `workflow_dispatch` no `demo-pages.yml`), sem commit;
  - trocar o link por `https://rodar-web-beta.vercel.app/mobile-web`, que responde.
- **RISCO H1/H3 (novo): o aviso ao recebedor não chega a ninguém se for ao vivo.** É a frase do produto ("avisa o recebedor antes da chegada"), e no modo `rtc` o link da sala fica só no evento. Para o vídeo, há três saídas, da mais barata para a mais cara:
  - abrir manualmente `https://d3fy4m7zwukr3x.cloudfront.net/recebedor?ligacao=<id>` numa segunda aba e gravar o recebedor atendendo. Não precisa de commit;
  - um botão "Abrir recebedor" no web que lê `dados.pagina_recebedor` do evento `ligacao_recebedor`, igual ao "Abrir operador" que já existe em `LiveAlerts.tsx`. Leva um commit e um teste;
  - `RECEBEDOR_MODO=sip` com tronco. Fica fora de alcance até 30/11.

  Decidam até 29/11 e registrem com `/registrar`. A primeira saída basta para o vídeo. A segunda é a que o júri vê na demo sem precisar de roteiro.
- **Precisa de humano, antes de gravar:** abrir `rodar-web-beta.vercel.app`, clicar em **Conectar à API** e confirmar que o painel carrega a frota real e aceita uma ação do CCO. Conferir também que `POST /auth/sso` recebe o e-mail do operador. Sem e-mail, ele devolve o papel `driver`, e as ações da central exigem `cco`.
- **RISCO H1 (web, novo):** em `18f0e2a`, uma falha da Routes API tira a entrada do cache. A consulta é refeita a cada `updateTrucks` e a cada frame "dirty". Se a chave não tiver a Routes API habilitada, ou se a cota acabar, o painel em modo API dispara requisições em sequência. É justamente a tela que vai no vídeo. O conserto tem uma linha (guardar a falha no `catch`, conforme o score do web). Também vale conferir antes de gravar se o ícone do caminhão fica sobre o traçado ajustado.
- **READMEs que a realidade desmente (H2), agora com um item novo:**
  - **web, l.295 (novo):** "Não há Routes API". Desde `18f0e2a` é falso. O `CLAUDE.md` e o `docs/INTEGRACAO-BACKEND.md` do web foram atualizados, mas o README não;
  - **web, l.239:** "O deploy usa o modo Demo (sem `VITE_API_BASE_URL`): não chama uma API real". É falso desde a troca na Vercel;
  - **backend, l.36:** o motorista estaria "sem demo web própria", mas o `/mobile-web` responde 200;
  - **web "33 de 33" contra backend "34/34"**, e os totais de testes não batem: backend 661, mobile 554 (o STATUS do mobile diz 133), web 146.
- **RISCO H2 (web), sem mudança:** o contrato API↔web segue sem teste. Nada falha se o `isCall` voltar a rejeitar `'atraso'`. É o terceiro score seguido que pede isso.
- **RISCO H1 (mobile), sem mudança:** a voz LiveKit nativa está sem os plugins Expo e nunca rodou num aparelho (o próprio STATUS diz isso).
- **RISCO H1 (backend), sem mudança:** a 5e falha 1 em 4 (declarado). Somam-se o `ChamadoCCO` duplicado em `on_chegada`, que nunca escala (registrado em `decisoes.md`), e o atraso fechado e a negação da fila, que seguem sem teste.
- **Higiene, sem mudança:** o `.idea/` está versionado no mobile, e a `main` do web está sem proteção.
- **STATUS desatualizado:**
  - `repos/rodar-mobile/STATUS.md` l.49 marca "Ver o app sem instalar" como **Ok** com o link em 404;
  - `repos/rodar-web/STATUS.md` para em `042e3d1` (145 testes) e ainda diz que a demo publicada "roda no modo Demo" (l.57). Não registra `15ddd39` nem `18f0e2a`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 09e6a6b | 9 | 9 | **18** | `repos/rodar-backend/score.md` (09h30, mesmo commit). Ressalva do projeto: o aviso ao recebedor em `rtc` não chega a ninguém sem o link aberto à mão. Fica como risco, sem tirar ponto, porque o score do repo é do mesmo commit e o histórico público está atendido |
| rodar-web | 18f0e2a | 8 | 7 | **15** | `repos/rodar-web/score.md` (10h50, mesmo commit) |
| rodar-mobile | 91ad99e | 5 | 7 | **12** | `repos/rodar-mobile/score.md` (01h07, mesmo commit) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto (não há score.md). O mobile o usa só atrás de flag, e o backend não valida o token dele |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sem mudança. O painel público fala com a API real no HEAD (CloudFront com banco, LLM, auth e CORS), o `/mobile-web` responde e a página `/recebedor` está no ar. Os três commits deixam o painel mais legível. Não chega a 7 por quatro motivos. O link do mobile dá 404 no README. A voz nativa não tem prova em aparelho. Não há vídeo. E o aviso ao recebedor, a primeira promessa do produto, não tem caminho na interface: o link da sala não aparece em lugar nenhum. *Precisa de humano:* com o link do mobile vivo, o recebedor atendendo no vídeo e o "Conectar à API" confirmado, a nota provável é 7 |
| H2 | Implementação técnica | 7 | Sem mudança. O backend está no nível de referência. O ajuste à via ficou bem isolado na apresentação e documentado no contrato, e `15ddd39` veio com teste. O 8 continua preso fora do backend: `18f0e2a` sem teste e com cache negativo faltando, contrato API↔web sem teste, LiveKit nativo sem plugin, `.idea/` versionado, keycloak que ninguém valida, `ChamadoCCO` duplicado e cinco afirmações dos READMEs que o código desmente |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média e 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem a estadia). O benefício está estimado em R$ por entrega, e o OCOREN liga o produto ao TMS. O achado do recebedor é um risco aqui também: se o vídeo não mostrar o recebedor sendo avisado, o fluxo motorista→recebedor fica só no discurso. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, e os tours de 1 min são Mock. Com um vídeo que explique a doca do zero, mostre a voz real e o recebedor atendendo e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo, o link do mobile corrigido, o recebedor visível e os READMEs alinhados, a nota provável é 27-28/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11, público) está declarada |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Não arquivem nem tornem privados antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones do backend seguem o padrão fictício `9000000xx`, e os e-mails usam `.test`. O `+5511999999999` do web é exemplo de E.164, e o mockup tem CPF zerado. O do SVG do keycloak é falso positivo. O `/ligacoes` público só traz números fictícios |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O link da demo do mobile dá 404 (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cada push na main faz deploy (AWS no backend, Vercel no web). De 01/12 a 12/12, nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmem no painel e garantam a presença em 12/12 |
| X10 | Enquadramento | OK | Doca, estadia e fluxo de informação entre motorista, recebedor e CCO. Não vendam o "modo direção" como segurança do motorista |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 10 RISCOS**, os mesmos da rodada anterior.
- Nenhum dos quatro READMEs tem o link do vídeo (4 RISCOS).
- No keycloak faltam o link da demo, a seção de dependências e a separação de terceiros (3 RISCOS).
- Os possíveis telefones do backend e do web são fictícios, e o do SVG do keycloak é falso positivo (3 RISCOS).
- Deram OK: X1, X3, X4, X6 (sem `.env` nem credenciais) e X7/X8 (main em dia com o remote).
- O script não pega o link do mobile em 404, a URL da API no bundle da Vercel nem o link do recebedor. Conferi os três com `curl`.
- Ficam para checagem humana: X2, X9, X10, S1, S3, S4, S5 e S6.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Submetam backend, web e mobile e **não** o rodar-keycloak, ou completem o README dele |
| S4 | Demo HTTPS no ar | **RISCO**. No painel, ponham `https://rodar-web-beta.vercel.app/home` (modo API contra o CloudFront), `https://rodar-web-beta.vercel.app/mobile-web` para o motorista e `https://d3fy4m7zwukr3x.cloudfront.net/docs` para a API. Não ponham o `github.io/rodar-mobile` enquanto der 404 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** O roteiro, todo sobre URLs públicas:
   - a doca em uma frase, com os 11h40 em CD na Grande SP;
   - a voz real pelo `/mobile-web`;
   - **o recebedor atendendo** em `/recebedor?ligacao=<id>`, aberto numa segunda aba se o botão não existir;
   - o painel em modo API recebendo o atraso e o escalonamento até o CCO;
   - a estadia em R$ e o OCOREN.
2. **Tornar o fluxo do recebedor visível e matar o 404 do mobile.** **H1 6→7 = +1.**
   - Ligar a Pages ou trocar o link pelo `/mobile-web`.
   - Botão "Abrir recebedor" no web, lendo `pagina_recebedor`, com um teste.
   - Cache negativo na Routes API.
   - Confirmar o "Conectar à API" no navegador.
3. **Coerência e testes, um commit por repo, até 29/11.** **H2 7→8 = +1.**
   - Web: l.239 e l.295 do README atualizadas (CloudFront e Routes API), teste de contrato do snapshot (`aproximacao`, `cco_sem_resposta`, `atraso` por `isCall` e `projectSnapshot`) e proteção da `main`.
   - Backend: citar o `/mobile-web`, decidir o `ChamadoCCO` duplicado e unificar os números de testes e etapas.
   - Mobile: os plugins LiveKit/WebRTC testados no celular, ou a declaração de que o nativo roda em Mock. Tirar o `.idea/`.

## Observações

- **O achado do recebedor é a descoberta mais importante desde a troca do CloudFront**, e foi bom tê-la registrado sem sair corrigindo dois repos de uma vez. Só que ela não pode ficar "para decisão do time" além de 29/11. O vídeo depende dela.
- O commit `85f85b5` deste repo cita `rodar-backend@eb1977e`, que não está no remote. Se for trabalho local, ele não conta para o júri até o push. Se não houver código nele, tirem a referência.
- Três commits de polimento no `FleetMap` em 40 minutos melhoram a tela do vídeo, mas cada um pode quebrá-la. Congelem o mapa depois da gravação.
- O modo API continua opcional ("Conectar à API"), e o painel abre na Demo. No vídeo, mostrem o clique. No painel de submissão, uma frase como "clique em Conectar à API para ver a operação real" ajuda.
- A troca Agora → LiveKit continua sem `/adr`. O `CLAUDE.md` e o ADR-0001 ainda dizem "Agora Conversational AI".
- Ordem sugerida:
  - dia 28: Pages do mobile, decisão sobre o recebedor, confirmação do modo API no navegador e teste da voz no celular;
  - dia 29: o botão do recebedor, o item 3 e o vídeo final;
  - dia 30: só os links do vídeo e a conferência final (`/health`, bundle da Vercel, link do mobile, `/recebedor`).
- De 01/12 a 12/12, nenhum commit nem redeploy, e a CI que publica a cada push fica parada. Não mexam nas variáveis da Vercel nem da AWS (inclusive `RECEBEDOR_MODO`) nesse período. A demo fica no ar até o fim da avaliação, e os repos ficam públicos até 15/12.
