# Judge: RODAR (projeto), 2026-11-28 08:43

Gatilho: push na main de rodar-backend 62076bd por HenryFacens. Repositórios avaliados (clonados em ../): rodar-backend 62076bd, rodar-web 05d559e, rodar-mobile 91ad99e, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 sem vídeo, S4 com as demos anunciadas quebradas) · Prazo: faltam 2d15h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-0110](judge-20261128-0110.md), 23/40): o total não muda. Só o backend mudou (`4d01768` → `62076bd`, 2 commits). Web, mobile e keycloak estão no mesmo HEAD da rodada anterior.
- **Backend:** o `7dcc0c8` corrige o README, que agora cita "5e e 5e2". O `62076bd` implementa o item 2 do *Maior retorno* anterior, na parte de código: depois da chegada, "fila" abre uma ocorrência nova em vez de virar detalhe do atraso, e "ok/beleza/obrigado" deixam de ser gravados, com um teste para cada fala. O `repos/rodar-backend/score.md` foi refeito às 08h42 sobre `62076bd`, com 423 testes passando: **17/20** (H1 8, H2 9). Aceito o número.
- **Por que H1 do projeto não sobe:** a correção só foi provada com LLM fake. O `/health` no ar ainda mostra `sha: "7dcc0c8"`, e a última medição real segue em 5e 1/4 e 5e2 0/4. Além disso, as duas demos anunciadas continuam quebradas pela quarta rodada seguida, e elas pesam mais em H1 do que a fila na doca.

**Conferido às 08h43 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, `sha: "7dcc0c8"`, `llm_upstream: true`, `recebedor_modo: rtc`, `twilio_configurado: false`. **O `62076bd` ainda não está no ar.** O deploy da CI deve estar em andamento.
- `https://rodar-web-beta.vercel.app/home`: o bundle continua `index-B9aLfjQ1.js`, e o chunk `operations-Bi56NYIX.js` ainda chama `https://rodar-backend-five.vercel.app`. Esse `/health` responde `ok: false, banco_ok: false, sha: "dev"`. **O painel que o júri abre em modo API continua sem banco.**
- `https://rodar-web-beta.vercel.app/mobile-web`: 200.
- `https://rodarglobal.github.io/rodar-mobile/`: **404**. O README do mobile ainda o anuncia.
- No mobile, `git ls-files .idea` lista 6 arquivos.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link. O lembrete segue no backend (linha 44). Sem o vídeo, o projeto é desclassificado. Faltam 2d15h.
- **RISCO S4/H1: as duas demos anunciadas seguem quebradas, pela quarta rodada seguida.** As duas correções dispensam commit:
  - na Vercel, troquem o `VITE_API_BASE_URL` para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy;
  - `rodarglobal.github.io/rodar-mobile` dá 404. Liguem a Pages ou troquem o link do README pelo `/mobile-web`.
- **RISCO H1 (backend): a correção da fila na doca não foi medida no ar.** Faltam o deploy do `62076bd` e rodadas de `validar_fluxos.py` contra o CloudFront. O score do backend aponta mais duas lacunas: com o atraso já **fechado**, "tem fila" cai no ramo `complemento` e repete o sintoma; e o regex `\bfila\b` casa com "não tem fila". Até medir, não gravem a fila falada.
- **RISCO H1 (mobile), sem mudança:** a voz LiveKit nativa está sem `@livekit/react-native-expo-plugin` e `@config-plugins/react-native-webrtc` no `app.config.ts`, e sem teste em aparelho.
- **Os números ainda não batem.** O backend diz "659 testes: 423 + 127 + 109". O mobile diz "554: 318 + 127 + 109" e "33 de 33 etapas". Os reais são 423 + 145 + 130 = **698**, e a validação dá 32-33 de **34**. O README do backend ainda diz que o app do motorista "não tem demo web própria", mas o `/mobile-web` existe e responde 200. Um jurado de dados que cruzar os links vê a divergência.
- **Higiene:** o teste novo do backend (`test_contingencia.py:284`) volta a citar `score.md`. Somado aos outros 6 pontos nos testes e ao `infra/README.md`, o júri simulado aparece no código entregue. Seguem também o `.idea/` versionado no mobile e a `main` do web sem proteção.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` descreve `4d01768`: cita 413 testes (são 423) e diz que o falso positivo "beleza, obrigado" não tem teste. `repos/rodar-mobile/STATUS.md` ainda é de `28e1569`, com Agora e Whisper. Rodem `/registrar rodar-backend` e `/registrar rodar-mobile`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 62076bd | 8 | 9 | **17** | `repos/rodar-backend/score.md` (08h42, mesmo commit, 423 testes rodados). A AWS ainda está em `7dcc0c8` |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (sobre `bac015f`). O diff até `05d559e` só mexe no tour e já foi conferido na rodada anterior. *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, H1 é 7 (14/20) |
| rodar-mobile | 91ad99e | 5 | 7 | **12** | `repos/rodar-mobile/score.md` (01h07, mesmo commit). A demo dá 404, e a voz LiveKit está sem plugin nativo e sem prova em aparelho |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto (não há score.md). O mobile só o usa atrás de flag, e o backend não valida o token. Faltam no README a demo, as dependências e os terceiros |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | O backend público está no ar com banco e LLM, a 4c tem 4/4 contra a AWS, e o `/mobile-web` responde. Mas o jurado que segue os READMEs encontra o painel sem banco e a demo do mobile em 404, e a fila na doca continua sem prova no ar: o `62076bd` ainda não foi publicado nem medido. *Precisa de humano:* com a Vercel apontando para o CloudFront, o link do mobile vivo, a 5e/5e2 em pelo menos 3/4 no ar e o vídeo mostrando a voz real, a nota provável é 7 |
| H2 | Implementação técnica | 7 | A correção nova do backend é o padrão certo: uma regra por estado da rota na borda da ferramenta, com teste no domínio e na API e um teste por fala descartada. A camada de voz do mobile trocou de provedor sem mudar o contrato, e há 698 testes no total. O que segura: o LiveKit nativo sem plugin Expo, o `.idea/` versionado, "score.md" nos testes (uma menção nova), a `main` do web sem proteção, o keycloak que ninguém valida e os números divergentes entre os READMEs |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média e 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem a estadia). O benefício está estimado em R$ por entrega, e o OCOREN amarra o produto ao TMS. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo de 3 min não existe, e os tours de 1 min são Mock. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo e as duas demos funcionando, a nota provável é 27/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11, público) está declarada |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Públicos e sem fork. Não arquivem nem tornem privados antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones do backend seguem o padrão fictício `9000000xx`. Os do web são exemplo de formato E.164 (`+5511999999999`). O alerta no SVG do keycloak é falso positivo. O commit novo não traz dado pessoal |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). As duas demos anunciadas estão quebradas (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cada push na main do backend faz deploy na AWS. De 01/12 a 12/12, nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmem no painel e garantam a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. Não vendam o "modo direção" do mobile como segurança do motorista |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 10 RISCOS.**
- Nenhum dos quatro READMEs tem o link do vídeo (4 RISCOS).
- No keycloak faltam o link da demo, a seção de dependências e a separação de terceiros (3 RISCOS).
- Os possíveis telefones do backend e do web são fictícios, e o do SVG do keycloak é falso positivo (3 RISCOS). Conferi à mão.
- Deram OK nos quatro: X1, X3, X4, X6 (sem `.env` e sem credenciais) e X7/X8 (main em dia com o remote).
- O script não vê duas coisas: ele dá OK ao link de demo do mobile porque o link está no texto, mas o link dá 404; e não vê a URL de API no bundle da Vercel. Conferi as duas com `curl`.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: submeter backend, web e mobile e **não** submeter o rodar-keycloak, ou completar o README dele |
| S4 | Demo HTTPS no ar | **RISCO**. No painel: `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` para o CloudFront. Não ponham o `github.io/rodar-mobile` enquanto der 404. Testem em aba anônima |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** O roteiro, para um júri que nunca viu uma doca:
   - a doca em uma frase, com o dado de 11h40 em CD na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado na aproximação e a doca preenchida (4c, 4/4);
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN em um clique.

   A fila falada só entra se o item 2 der pelo menos 3/4 no ar.
2. **Pôr as demos de pé e provar a fila no ar, hoje (28/11).** **H1 6→7 = +1.**
   - Vercel, sem commit: `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy. Confiram que o chunk `operations-*.js` deixou de citar `rodar-backend-five`.
   - Mobile, sem commit: liguem a Pages e rodem de novo o `Demo (GitHub Pages)`. Se não subir até 29/11, troquem o link pelo `/mobile-web`.
   - Backend: cubram o atraso fechado e a negação ("não tem fila"), cada um com teste. Esperem o `/health` mostrar o novo `sha`, rodem `validar_fluxos.py` 4 vezes contra o CloudFront e publiquem a tabela.
3. **Coerência e higiene, um commit por repo, até 29/11.** **H2 7→8 = +1.**
   - Um só número nos READMEs: 423 + 145 + 130 = 698 testes, e "32-33 de 34" (ou o número novo do item 2) no lugar de "33 de 33". No backend, citem o `/mobile-web` como demo do motorista.
   - Mobile: os plugins LiveKit/WebRTC e uma conversa real no celular, ou a declaração no README de que o nativo roda em Mock e a voz real é o `/mobile-web`. Tirem o `.idea/`.
   - Backend: tirem "júri" e "score.md" dos testes e do `infra/README.md`. Web: liguem a proteção da `main`.

## Observações

- O time levou menos de 8 horas para transformar o *Maior retorno* em código, com causa raiz e teste. Falta fechar o ciclo da mesma forma que na 3d e na 4c: medir no ar. Para um júri de dados e ML, a tabela de rodadas por etapa vale um slide na final.
- Com 4 amostras, diferenças de 1/4 são ruído. Para dizer "estável", rodem de 8 a 10 vezes por versão.
- A troca Agora → LiveKit continua sem `/adr`. O `CLAUDE.md` e o ADR-0001 ainda dizem "Agora Conversational AI".
- O smoke do deploy ainda faz um GET que incrementa a sequência do OCOREN em produção.
- Ordem sugerida: no dia 28, o item 2 (primeiro as partes sem commit) e o teste da voz no celular; no dia 29, o item 3 e a gravação; no dia 30, só os links do vídeo, a conferência do `/health`, do bundle da Vercel e do link do mobile, e um `validar_fluxos.py` final. No último dia, nada de mexer na voz.
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro e ensaio, com a demo (Vercel e AWS) no ar até o fim da avaliação e os repos públicos até 15/12. A CI que publica a cada push precisa ficar parada nesse período.
