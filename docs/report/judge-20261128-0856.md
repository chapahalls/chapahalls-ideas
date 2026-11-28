# Judge: RODAR (projeto), 2026-11-28 08:56

Gatilho: push na main de rodar-backend d8af042 por HenryFacens.
Repositórios avaliados (clonados em ../): rodar-backend d8af042, rodar-web 05d559e, rodar-mobile 91ad99e, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 sem vídeo, S4 com as demos anunciadas quebradas) · Prazo: faltam 2d15h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-0843](judge-20261128-0843.md), 23/40): o total não muda. Só o backend mudou (`62076bd` → `d8af042`, 1 commit `chore`). Web, mobile e keycloak estão no mesmo HEAD.
- **Backend:** o `d8af042` executa quase todo o item 3 do *Maior retorno* anterior na parte do backend:
  - tira "júri", "score.md" e "judge" dos testes e dos docs;
  - na 4c, grava a última doca falada;
  - o smoke do OCOREN passa a usar `dry_run`, sem efeito colateral;
  - o deploy passa a ser imutável por `:sha`.
  O README agora diz 661 testes (425 + 127 + 109). O `repos/rodar-backend/score.md` foi refeito às 08h53 sobre `d8af042`, com 425 testes passando: **17/20** (H1 8, H2 9). Aceito o número.
- **Por que o projeto não sobe:**
  - As duas demos anunciadas continuam quebradas pela quinta rodada seguida, e elas pesam mais em H1 do que qualquer ajuste no backend.
  - A fila na doca está no ar (`62076bd`), mas não foi medida.
  - Em H2, a higiene do backend melhorou, mas os quatro pontos que seguram o 8 estão fora dele: os números entre READMEs, o LiveKit nativo, o `.idea/` e a proteção da `main` do web.

**Conferido às 08h56 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, `sha: "62076bd"`, `llm_upstream: true`, `recebedor_modo: rtc`, `twilio_configurado: false`. **O `d8af042` ainda não está no ar.** É o primeiro deploy pelo caminho novo `register-task-definition`.
- `https://rodar-web-beta.vercel.app/home`: o bundle continua `index-B9aLfjQ1.js`, o mesmo que chama `rodar-backend-five.vercel.app`. Esse `/health` responde `ok: false, banco_ok: false, sha: "dev"`. **O painel em modo API continua sem banco.**
- `https://rodar-web-beta.vercel.app/mobile-web`: 200.
- `https://rodarglobal.github.io/rodar-mobile/`: **404**. A linha 31 do README do mobile ainda o anuncia como "Abrir o app no navegador".
- No mobile, `git ls-files .idea` lista 6 arquivos. O README do mobile ainda diz "33 de 33 etapas" e "554 testes: 318 + 127 + 109".

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link, e o lembrete continua na linha 44 do backend. Sem o vídeo, o projeto é desclassificado. Faltam 2d15h.
- **RISCO S4/H1: as duas demos anunciadas seguem quebradas, pela quinta rodada seguida.** As duas correções dispensam commit:
  - na Vercel, troquem o `VITE_API_BASE_URL` para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy;
  - em `rodarglobal.github.io/rodar-mobile`, que dá 404, liguem a Pages ou troquem o link do README pelo `/mobile-web`.
- **RISCO (backend, infra): o primeiro deploy por revision `:sha` está rodando agora.** Antes de qualquer outro push, confiram que o job `deploy` passou e que o `/health` mostra `sha: "d8af042"`. Se a revision nova não ficar saudável, o rollback está em `infra/README.md`. A partir de 29/11, não mexam mais em pipeline nem em Terraform.
- **RISCO H1 (backend): a fila na doca está no ar sem medição.** `evidence/validacao.md` ainda mostra 5e em 1/4 e 5e2 em 0/4 (`8b3f0d4`). Duas lacunas seguem sem teste:
  - com o atraso já fechado, "tem fila" vai para o atraso;
  - `\bfila\b` casa com "não tem fila".
- **RISCO H1 (mobile), sem mudança:** a voz LiveKit nativa está sem `@livekit/react-native-expo-plugin` e `@config-plugins/react-native-webrtc` no `app.config.ts`, e sem teste em aparelho.
- **Os números ainda não batem, agora de outro jeito.**
  - O backend diz "661: 425 + 127 + 109". O mobile diz "554: 318 + 127 + 109" e "33 de 33".
  - Na rodada anterior, os totais contados foram 145 no web e 130 no mobile, o que dá 425 + 145 + 130 = **700**. A validação dá 32 de **34**.
  - O README do backend (linha 36) ainda diz que o app do motorista "não tem demo web própria", mas o `/mobile-web` responde 200.
- **Higiene:** no backend, a pendência está resolvida, e o `grep` por "júri"/"score.md" volta vazio no código. Seguem o `.idea/` versionado no mobile e a `main` do web sem proteção.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` descreve `4d01768`. Ele cita 413 testes (são 425) e dá como abertos o "beleza, obrigado" e o smoke do OCOREN, que já foram resolvidos. `repos/rodar-mobile/STATUS.md` é de `28e1569`, da época do Agora e do Whisper. Rodem `/registrar rodar-backend` e `/registrar rodar-mobile`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | d8af042 | 8 | 9 | **17** | `repos/rodar-backend/score.md` (08h53, mesmo commit, 425 testes rodados). A AWS ainda está em `62076bd` |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (sobre `bac015f`; o diff até `05d559e` só mexe no tour). *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, H1 é 7 (14/20) |
| rodar-mobile | 91ad99e | 5 | 7 | **12** | `repos/rodar-mobile/score.md` (01h07, mesmo commit). A demo dá 404, e a voz LiveKit está sem plugin nativo e sem prova em aparelho |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto (não há score.md). O mobile só o usa atrás de flag, e o backend não valida o token. Faltam no README a demo, as dependências e os terceiros |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | O backend público está no ar com banco e LLM, a 4c tem 4/4 contra a AWS, e o `/mobile-web` responde. Mas o jurado que segue os READMEs encontra o painel sem banco e a demo do mobile em 404. A fila na doca já está no ar, mas sem medição. *Precisa de humano:* com a Vercel apontando para o CloudFront, o link do mobile vivo, a 5e/5e2 em pelo menos 3/4 no ar e o vídeo mostrando a voz real, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend está mais limpo: deploy auditável por sha, smoke sem efeito colateral e com teste, nenhuma menção ao júri simulado no código. O que segura o 8 está nos outros repos: o LiveKit nativo sem plugin Expo, o `.idea/` versionado, a `main` do web sem proteção, um keycloak que ninguém valida e três totais de testes diferentes entre os READMEs |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média e 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem a estadia). O benefício está estimado em R$ por entrega, e o OCOREN amarra o produto ao TMS. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo de 3 min não existe, e os tours de 1 min são Mock. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo, as duas demos funcionando e os números alinhados, a nota provável é 27-28/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11, público) está declarada |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Públicos e sem fork. Não arquivem nem tornem privados antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones do backend seguem o padrão fictício `9000000xx` e usam domínio `.test`. Os do web são exemplo de formato E.164 (`+5511999999999`). O alerta no SVG do keycloak é falso positivo. O commit novo não traz dado pessoal |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). As duas demos anunciadas estão quebradas (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cada push na main do backend faz deploy na AWS. De 01/12 a 12/12, nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmem no painel e garantam a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. Não vendam o "modo direção" do mobile como segurança do motorista |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 10 RISCOS.**
- Nenhum dos quatro READMEs tem o link do vídeo (4 RISCOS).
- No keycloak faltam o link da demo, a seção de dependências e a separação de terceiros (3 RISCOS).
- Os possíveis telefones do backend e do web são fictícios, e o do SVG do keycloak é falso positivo (3 RISCOS). Conferi à mão.
- Deram OK: X1, X3, X4 e X7/X8 (main em dia com o remote).
- O script não pega duas coisas, e conferi as duas com `curl`:
  - ele dá OK ao link de demo do mobile porque o link está no texto, mas o link dá 404;
  - ele não vê a URL de API dentro do bundle da Vercel.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: submeter backend, web e mobile e **não** submeter o rodar-keycloak, ou completar o README dele |
| S4 | Demo HTTPS no ar | **RISCO**. No painel, ponham `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` para o CloudFront. Não ponham o `github.io/rodar-mobile` enquanto der 404. Testem em aba anônima |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** O roteiro, para um júri que nunca viu uma doca:
   - a doca em uma frase, com o dado de 11h40 em CD na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado na aproximação e a doca preenchida (4c, 4/4);
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN em um clique.

   A fila falada só entra se o item 2 der pelo menos 3/4 no ar.
2. **Pôr as demos de pé e medir a fila no ar, hoje (28/11).** **H1 6→7 = +1.**
   - Vercel, sem commit: `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy. Confiram que o bundle deixou de ser `index-B9aLfjQ1.js` e não cita mais `rodar-backend-five`.
   - Mobile, sem commit: liguem a Pages e rodem de novo o `Demo (GitHub Pages)`. Se não subir até 29/11, troquem o link pelo `/mobile-web`.
   - Backend: confiram que o `d8af042` subiu. Depois, cubram o atraso fechado e a negação ("não tem fila"), cada um com teste. Esperem o `/health` mostrar o novo `sha`, rodem `validar_fluxos.py` 4 a 8 vezes contra o CloudFront e publiquem a tabela.
3. **Coerência e higiene nos outros repos, um commit por repo, até 29/11.** **H2 7→8 = +1.**
   - Um só número nos READMEs: contem de novo os testes do web e do mobile e usem o mesmo total nos três. Troquem "33 de 33" pela medição real (32 de 34, ou o número do item 2). No backend, citem o `/mobile-web` como demo do motorista.
   - Mobile: ou entram os plugins LiveKit/WebRTC com uma conversa real no celular, ou o README declara que o nativo roda em Mock e que a voz real é o `/mobile-web`. Tirem o `.idea/`.
   - Web: liguem a proteção da `main`.

## Observações

- O time fechou a parte de backend do item 3 anterior em 13 minutos, sem quebrar teste. Para subir a nota do projeto, o esforço agora precisa ir para web, mobile e vídeo, e não para o backend, que já está em 17/20.
- Com 4 amostras, diferenças de 1/4 são ruído. Para dizer "estável", rodem de 8 a 10 vezes por versão. Para um júri de dados e ML, a tabela por etapa vale um slide na final.
- A troca Agora → LiveKit continua sem `/adr`. O `CLAUDE.md` e o ADR-0001 ainda dizem "Agora Conversational AI".
- Ordem sugerida:
  - dia 28: o item 2, primeiro as partes sem commit, e o teste da voz no celular;
  - dia 29: o item 3 e a gravação;
  - dia 30: só os links do vídeo, a conferência do `/health`, do bundle da Vercel e do link do mobile, e um `validar_fluxos.py` final. No último dia, nada de mexer na voz nem na infra.
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro e ensaio. A demo (Vercel e AWS) fica no ar até o fim da avaliação, e os repos ficam públicos até 15/12. A CI que publica a cada push precisa ficar parada nesse período.
