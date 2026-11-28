# Judge: RODAR (projeto), 2026-11-28 09:19

Gatilho: push na main de rodar-backend a51e4e3 por HenryFacens.
Repositórios avaliados (clonados em ../): rodar-backend a51e4e3, rodar-web 05d559e, rodar-mobile 91ad99e, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 sem vídeo, S4 com duas demos anunciadas quebradas) · Prazo: faltam 2d14h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-0900](judge-20261128-0900.md), 23/40): o total não muda, mas o backend deixou de ser problema.
- Só o backend mudou (`8b303db` → `a51e4e3`). É 1 commit `docs(evidence)`: `evidence/validacao.md` e uma linha do README. Nada em `backend/` nem na CI.
- `repos/rodar-backend/score.md` foi refeito às 09h18 sobre `a51e4e3`: **18/20** (H1 9, H2 9), +1. Aceito: é do mesmo commit, e eu conferi o `/health` de novo.
- Dois RISCOS da rodada anterior caíram:
  - o deploy por `:sha` funcionou, e a AWS está no código do HEAD;
  - a fila na doca foi medida contra a AWS: 5e em 3/4 e 5e2 em 4/4.
- Web, mobile e keycloak estão no mesmo HEAD. As duas demos quebradas, que são o que o júri vê, continuam iguais.

**Conferido às 09h19 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, `llm_upstream: true`, `auth_obrigatoria: true`, **`sha: "8b303db"`**. É o código do HEAD, porque `a51e4e3` só mexe em documentação.
- `https://rodar-web-beta.vercel.app/home`: 200. O bundle ainda é `index-B9aLfjQ1.js`, e o chunk `operations-Bi56NYIX.js` ainda chama `rodar-backend-five.vercel.app`. Essa API responde `ok: false, banco_ok: false, sha: "dev"`. **O painel em modo API está sem banco pela sétima rodada seguida.**
- `https://rodar-web-beta.vercel.app/mobile-web`: 200.
- `https://rodarglobal.github.io/rodar-mobile/`: **404**. O README do mobile ainda o anuncia.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link. Sem ele, o projeto é desclassificado. Faltam 2d14h.
- **RISCO S4/H1: as duas demos anunciadas seguem quebradas, pela sétima rodada.** Agora isso é o maior freio da nota, porque o backend está pronto. As duas correções dispensam commit:
  - na Vercel, `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy. Confiram que o bundle deixou de ser `index-B9aLfjQ1.js`;
  - no mobile, ligar a Pages (Settings → Pages → Source: GitHub Actions e `workflow_dispatch`) ou trocar o link do README pelo `/mobile-web`.
- **O README do backend promete mais que a evidência (novo).**
  - A linha "Ver sem instalar nada" diz "34/34". Isso foi em 3 das 4 rodadas, e a outra deu 33/34.
  - A mesma linha diz que a 5e é "determinista por estado da rota". A falha que sobrou vem de o LLM não chamar a ferramenta, ou seja, não é determinista.
  - Jurados de dados/ML vão ler isso como escolha do melhor caso. Escrevam "3 de 4 rodadas em 34/34, 1 em 33/34".
- **RISCO H1 (backend), menor:**
  - a correção da fila ainda tem duas lacunas sem teste: o atraso já fechado (`tasks.py:283`) e a negação ("não tem fila", "sem fila");
  - uma tentativa de validação quebrou com `TypeError` num `GET /ligacoes` e foi excluída sem investigação. Está declarado, mas, se a causa foi um 5xx da API, o júri pode ver a mesma falha.
- **RISCO H1 (mobile), sem mudança:** a voz LiveKit nativa está sem os plugins Expo (`@livekit/react-native-expo-plugin`, `@config-plugins/react-native-webrtc`) e sem teste em aparelho.
- **Os números não batem entre os READMEs, sem mudança:**
  - o backend diz 661 testes, o mobile diz 554 e "33 de 33";
  - a contagem real é perto de 700 (425 + 145 + 130), e a validação nova dá 33 ou 34 de 34;
  - o README do backend ainda diz que o motorista "não tem demo web própria", mas o `/mobile-web` responde.
- **Higiene, sem mudança:** o `.idea/` está versionado no mobile, e a `main` do web está sem proteção.
- **STATUS desatualizado:**
  - `repos/rodar-backend/STATUS.md` descreve `4d01768`: 413 testes, 5e "instável", sem o `dry_run` e sem o deploy por `:sha`;
  - `repos/rodar-mobile/STATUS.md` é de `28e1569`, da época do Agora e do Whisper local.
  - Rodem `/registrar` nos dois.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | a51e4e3 | 9 | 9 | **18** | `repos/rodar-backend/score.md` (09h18, mesmo commit). `/health` em `8b303db` = código do HEAD |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (sobre `bac015f`; o diff até `05d559e` só mexe no tour). *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, H1 é 7 (14/20) |
| rodar-mobile | 91ad99e | 5 | 7 | **12** | `repos/rodar-mobile/score.md` (01h07, mesmo commit) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto (não há score.md). O mobile só o usa atrás de flag, e o backend não valida o token |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | A API pública está no código atual, com banco, LLM e auth, e tem 4 rodadas medidas contra a AWS (3d e 4c em 4/4, 5e em 3/4, 5e2 em 4/4). O `/mobile-web` responde. Mas o jurado que segue os links encontra o painel em modo API sem banco e a demo do mobile em 404. A voz nativa não tem prova, e o vídeo não existe. Das três condições para o 7 da rodada anterior, uma foi cumprida (a fila medida no ar). *Precisa de humano:* com a Vercel apontando para o CloudFront, o link do mobile vivo e o vídeo mostrando a voz real, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend está no nível de referência: deploy travado por `:sha` com smoke que compara o sha, `dry_run`, 425 testes e uma evidência com diagnóstico por evento do banco. O que segura o 8 está fora dele: o LiveKit nativo sem plugin, o `.idea/` versionado, a `main` do web sem proteção, o keycloak que ninguém valida, três totais de testes diferentes e agora um README que diz "determinista" sobre um LLM que falhou 1 em 4 vezes. Falta uma avaliação do LLM versionada, e isso pesa para um júri de dados/ML |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média e 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem a estadia). O benefício está estimado em R$ por entrega, e o OCOREN liga o produto ao TMS. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, e os tours de 1 min são Mock. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo, as duas demos de pé e os números alinhados, a nota provável é 27-28/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11, público) está declarada |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Não arquivem nem tornem privados antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones do backend seguem o padrão fictício `9000000xx`. O do web é exemplo de formato E.164 e mockup com CPF zerado. O do SVG do keycloak é falso positivo (path). A evidência nova só cita ids de rota, motorista e evento |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). Duas demos anunciadas estão quebradas (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cada push na main do backend faz deploy. De 01/12 a 12/12, nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmem no painel e garantam a presença em 12/12 |
| X10 | Enquadramento | OK | Doca, estadia e fluxo de informação entre motorista, recebedor e CCO. Não vendam o "modo direção" como segurança do motorista |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 10 RISCOS.**
- Nenhum dos quatro READMEs tem o link do vídeo (4 RISCOS).
- No keycloak faltam o link da demo, a seção de dependências e a separação de terceiros (3 RISCOS).
- Os possíveis telefones do backend e do web são fictícios, e o do SVG do keycloak é falso positivo (3 RISCOS).
- Deram OK: X1, X3, X4, X6 (sem `.env` nem credenciais) e X7/X8 (main em dia).
- O script não pega duas coisas, e conferi as duas com `curl`: o link do mobile dá 404, e o chunk da Vercel chama a API sem banco.

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

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** O backend está estável no ar, então já dá para gravar hoje. O roteiro:
   - a doca em uma frase, com os 11h40 em CD na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado e a doca preenchida;
   - o escalonamento até o CCO;
   - a estadia em R$ e o OCOREN.
2. **Pôr as duas demos de pé hoje (28/11), sem commit.** **H1 6→7 = +1.**
   - Vercel: trocar o `VITE_API_BASE_URL` para o CloudFront e fazer o redeploy.
   - Mobile: ligar a Pages ou trocar o link pelo `/mobile-web`.
3. **Coerência e higiene, um commit por repo, até 29/11.** **H2 7→8 = +1.**
   - Backend: "3 de 4 rodadas em 34/34" no lugar de "34/34" e de "determinista", o `/mobile-web` citado e, se der, os testes do atraso fechado e da negação da fila.
   - Um só total de testes nos três READMEs.
   - Mobile: os plugins LiveKit/WebRTC com teste no celular, ou a declaração de que o nativo roda em Mock. Tirar o `.idea/`.
   - Web: ligar a proteção da `main`.

## Observações

- O backend chegou a 18/20 e está à frente do resto. Mais commits nele quase não mudam a nota do projeto. O que sobe a nota agora é o vídeo, a Vercel e o link do mobile. Evitem mexer em pipeline e Terraform a partir de 29/11.
- A troca Agora → LiveKit continua sem `/adr`. O `CLAUDE.md` e o ADR-0001 ainda dizem "Agora Conversational AI".
- Ordem sugerida:
  - dia 28: Vercel e Pages (sem commit), teste da voz no celular e começo da gravação;
  - dia 29: o item 3 e o vídeo final;
  - dia 30: só os links do vídeo e a conferência final (`/health`, bundle, link do mobile).
- De 01/12 a 12/12, nenhum commit nem redeploy, e a CI que publica a cada push fica parada. A demo fica no ar até o fim da avaliação, e os repos ficam públicos até 15/12.
