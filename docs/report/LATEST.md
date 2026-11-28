# Judge: RODAR (projeto), 2026-11-28 11:31

Gatilho: push na main de rodar-web 70a2414 por HenryFacens. Repositórios avaliados (clonados em ../): rodar-backend 09e6a6b, rodar-web 70a2414, rodar-mobile 91ad99e, rodar-keycloak de1817a.

**Nota estimada: 22 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 sem vídeo, S4 com o link do mobile em 404) · Prazo: faltam 2d12h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-1052](judge-20261128-1052.md), 23/40): a nota **cai 1**, de 23 para 22, em H2. Só o web mudou (`18f0e2a` → `70a2414`), com 2 commits:
- `41be659` (docs): o README e o `docs/ARQUITETURA.md` passam a declarar a Routes API. Isso fecha a contradição da l.295 apontada no relatório anterior.
- `70a2414` (a mensagem foge do formato convencional): na Demo, o login agora leva a `/dashboard/mobile-demo`. Entra também a feature `receiver-call` (`ReceiverCallPhone`), um celular **simulado** do recebedor com a transcrição da ligação de escalonamento. Ele abre sozinho no modo integrado, aos 60 min no tour, e por um botão "Simular ligação ao recebedor". Não tem teste.
- `repos/rodar-web/score.md` foi refeito às 11h29 sobre `70a2414`: **14/20** (H1 8, H2 6), cai 1. Aceito, porque é do mesmo commit. Os outros score.md continuam válidos (backend 09e6a6b, mobile 91ad99e, sem commit novo).

**Conferido às 11h32 (-03):**
- **O e2e da CI do web deve estar vermelho na HEAD.** Confirmei por leitura. `src/app/router.tsx:37` manda a Demo para `APP_ROUTES.mobileDemo` (`/dashboard/mobile-demo`, `src/lib/routes.ts:10`). Só que `tests-e2e/smoke.spec.ts:13` ainda espera `toHaveURL(/\/dashboard$/)` e, depois, o heading "Fila de alertas". A API do GitHub não respondeu, então não vi o resultado do job.
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: 200, com `ok`, `banco_ok`, `sha: "09e6a6b"`, `recebedor_modo: "rtc"` e `auth_obrigatoria: true`.
- `/recebedor?ligacao=1`: 200.
- `rodar-web-beta.vercel.app/home` e `/mobile-web`: 200.
- `https://rodarglobal.github.io/rodar-mobile/`: **404**, pela 11ª rodada.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link, e backend, web e mobile ainda têm o comentário-lembrete. Sem o vídeo, o projeto é desclassificado. Faltam 2d12h.
- **RISCO H1/H2 (novo): a CI do web deve estar vermelha na `main`.** O `70a2414` mudou o destino do login sem atualizar o smoke e2e que testa exatamente esse passo. Se ficar assim em 30/11 23h59, o júri vê um X vermelho no último commit, e isso não tem conserto depois de 01/12 (X8). O conserto é esperar `/dashboard/mobile-demo` depois do login, ir para `/dashboard` e então checar a fila. Depois, confirmem o job verde no Actions.
- **RISCO S4/H1: o link da demo do mobile dá 404 (11ª rodada).** Está em `rodar-mobile/README.md` (l.31 e l.261), e `repos/rodar-mobile/STATUS.md` l.49 ainda o marca como **Ok**. Há duas saídas: ligar a Pages (Settings → Pages → GitHub Actions, depois `workflow_dispatch` no `demo-pages.yml`) ou trocar o link por `https://rodar-web-beta.vercel.app/mobile-web`.
- **RISCO H1/H3: o recebedor agora aparece, mas como encenação.** Do jeito que está, o `ReceiverCallPhone` ajuda o vídeo, porque o terceiro ator fica visível em um clique. Só que a transcrição é montada no navegador (`buildCall`, com `Math.random`), e o rótulo "Simulação" só aparece no caso do botão. A sala real em `RECEBEDOR_MODO=rtc` continua sem ninguém que a receba: o painel não mostra nem abre `pagina_recebedor`. Duas regras:
  - não apresentem esse celular como ligação real no vídeo nem no painel;
  - se quiserem a prova real, abram `/recebedor?ligacao=<id>` numa segunda aba durante a gravação, ou ponham um botão "Abrir recebedor" que leia `dados.pagina_recebedor`.
- **RISCO H1 (web), sem mudança:** a Routes API segue sem cache negativo. Em `FleetMap.tsx:123`, o `catch` apaga a entrada, e a consulta se repete a cada atualização no modo API. Agora o próprio README contradiz isso, porque diz "nunca por tick".
- **Precisa de humano, antes de gravar:** abrir `rodar-web-beta.vercel.app`, clicar em **Conectar à API** e confirmar a frota real e uma ação do CCO. Com `auth_obrigatoria: true`, confirmem também que o `POST /auth/sso` devolve o papel `cco`.
- **READMEs que a realidade desmente (H2):**
  - web l.239 ("o deploy usa o modo Demo, não chama API real"): continua falso;
  - backend l.36 (o motorista estaria "sem demo web própria"): continua falso;
  - os totais de testes não batem (backend 661, mobile 554 contra 133 no STATUS, web 146);
  - **a l.295 do web foi corrigida** (`41be659`).
- **Sem mudança:**
  - o contrato API↔web segue sem teste (quarto score seguido);
  - a voz LiveKit nativa do mobile está sem plugin e sem prova em aparelho;
  - a 5e do backend falha 1 em 4, e o `ChamadoCCO` duplicado nunca escala;
  - o `.idea/` está versionado no mobile;
  - a `main` do web está sem proteção.
- **STATUS desatualizado:**
  - `repos/rodar-web/STATUS.md` para em `18f0e2a` e diz que o e2e "passou";
  - `repos/rodar-mobile/STATUS.md` l.49 marca como **Ok** um link em 404.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 09e6a6b | 9 | 9 | **18** | `repos/rodar-backend/score.md` (mesmo commit) |
| rodar-web | 70a2414 | 8 | 6 | **14** | `repos/rodar-web/score.md` (11h29, mesmo commit). Cai 1: CI provavelmente vermelha e feature nova sem teste |
| rodar-mobile | 91ad99e | 5 | 7 | **12** | `repos/rodar-mobile/score.md` (mesmo commit) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto (não há score.md). O mobile o usa só atrás de flag, e o backend não valida o token dele |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sem mudança. O painel público fala com a API real (CloudFront com banco, LLM e auth), o `/mobile-web` e o `/recebedor` estão no ar, e agora a Demo abre direto no celular do motorista com o recebedor visível. Não chega a 7 por quatro motivos. O link do mobile dá 404. A voz nativa não tem prova. Não há vídeo. E o recebedor da demo é encenação: a sala real que o backend cria não chega a ninguém. *Precisa de humano:* com o link do mobile vivo, a CI verde, o recebedor real atendendo no vídeo e o "Conectar à API" confirmado, a nota provável é 7 |
| H2 | Implementação técnica | 6 | Cai 1. O backend continua no nível de referência, e a `receiver-call` está bem isolada e reaproveita `buildCall`/`CallLog`. Só que a CI, um dos pontos fortes do projeto, deve ter quebrado no web por um teste que ninguém atualizou. A feature nova veio sem teste, e o que se pedia antes continua aberto: o contrato API↔web, o cache negativo, o LiveKit nativo, o `.idea/` e o `ChamadoCCO` duplicado. Volta a 7 com o smoke corrigido e verde |
| H3 | Impacto | 7 | Sem mudança. A doca parada tem fonte brasileira: IER 2025 (5h09 de média e 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem a estadia). O benefício está estimado em R$ por entrega, e o OCOREN liga o produto ao TMS. O celular do recebedor deixa o fluxo motorista→recebedor→CCO mais concreto para quem nunca viu uma doca, mas como simulação, não como prova. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Com um vídeo que explique a doca do zero, mostre a voz real e o recebedor e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **22/40** | Passa dos 20 por 2 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo, a CI verde, o link do mobile corrigido e o recebedor real visível, a nota provável é 27-28/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiros commits em 22/11, e o keycloak em 26/11 |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11, público) está declarada |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | O script não alcançou a API do GitHub (4 RISCOS de checagem). As demos respondem. Não arquivem nem tornem privados antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | No backend, os telefones seguem o padrão `9000000xx` e os e-mails são `.test`. No web, `+5511999999999` é exemplo de E.164 e o mockup tem CPF zerado. Os nomes e a placa do celular do recebedor são fictícios, e o SVG do keycloak é falso positivo |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5), e o link do mobile dá 404 (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cada push faz deploy (AWS e Vercel). De 01/12 a 12/12, nada de push, merge ou redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmem no painel |
| X10 | Enquadramento | OK | Doca, estadia e fluxo de informação entre motorista, recebedor e CCO. Não vendam o "modo direção" como segurança do motorista |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 14 RISCOS** (eram 10).
- Os 4 novos são X4 por repo: a API do GitHub não respondeu na CI. É falha da checagem, não dos repos.
- Nenhum dos quatro READMEs tem o link do vídeo (4).
- No keycloak faltam a seção de dependências, o link da demo e a separação de terceiros (3).
- Os telefones possíveis do backend e do web são fictícios, e o do SVG do keycloak é falso positivo (3).
- Deram OK: X1, X3, X7/X8 (main em dia com o remote), sem `.env` e sem credenciais.
- O script não pega o 404 do mobile nem a CI vermelha do web. Conferi o primeiro com `curl` e a segunda por leitura.
- Ficam para checagem humana: X2, X9, X10, S1, S3, S4, S5 e S6.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Submetam backend, web e mobile e **não** o rodar-keycloak, ou completem o README dele |
| S4 | Demo HTTPS no ar | **RISCO**. No painel: `https://rodar-web-beta.vercel.app/home`, `https://rodar-web-beta.vercel.app/mobile-web` e `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Não usem o `github.io/rodar-mobile` enquanto der 404 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** O roteiro:
   - a doca em uma frase, com os 11h40 em CD na Grande SP;
   - a voz real pelo `/mobile-web`;
   - o recebedor: o real em `/recebedor?ligacao=<id>` numa segunda aba, ou o celular simulado com o rótulo "simulação";
   - o painel em modo API com o atraso e o escalonamento;
   - a estadia em R$ e o OCOREN.
2. **CI do web verde e smoke corrigido, já.** Atualizem o `tests-e2e/smoke.spec.ts` para o novo destino do login, confirmem o job no Actions e ponham um teste unitário mínimo do `ReceiverCallPhone`, ou do redirecionamento por modo. **H2 6→7 = +1.** De quebra, isso protege o último commit de 30/11.
3. **Matar o 404 do mobile e tornar o recebedor real visível.** **H1 6→7 = +1.**
   - Ligar a Pages ou trocar o link pelo `/mobile-web`.
   - No `ReceiverCallPhone` do modo API, ou num botão "Abrir recebedor", usar `dados.pagina_recebedor`.
   - Cache negativo da Routes API, em uma linha.
   - Confirmar o "Conectar à API" no navegador.

## Observações

- O `ReceiverCallPhone` é a resposta certa para um júri que não vai instalar nada, e o pitch fica melhor com ele. O risco é o júri achar que a ligação ao recebedor funciona e depois ver no código que é `Math.random`. Mantenham o rótulo "Simulação" em todos os caminhos, não só no do botão.
- Dois commits de produto por hora, mexendo no login e na tela do vídeo, já quebraram a CI uma vez hoje. Depois da gravação, congelem `MobileDemoAppPage`, `FleetMap` e `receiver-call`. Façam o último push com a CI verde e com folga antes das 23h59 de 30/11.
- A mensagem de `70a2414` não segue o `/commit`, então não deixa trailer no roadmap.
- Sem mudança desde o relatório anterior:
  - a troca Agora → LiveKit continua sem `/adr`;
  - o `CLAUDE.md` e o ADR-0001 ainda dizem "Agora Conversational AI";
  - a referência a `rodar-backend@eb1977e` em `85f85b5` aponta para um commit que não está no remote.
- De 01/12 a 12/12, nada de commit, redeploy ou mudança nas variáveis da Vercel e da AWS (inclusive `RECEBEDOR_MODO`). A demo fica no ar até o fim da avaliação, e os repos ficam públicos até 15/12.
