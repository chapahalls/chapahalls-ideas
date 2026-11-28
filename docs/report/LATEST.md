# Judge: RODAR (projeto), 2026-11-28 00:57

Gatilho: push na main de rodar-backend 4d01768 por HenryFacens. Repositórios avaliados: rodar-backend 4d01768, rodar-web 05d559e, rodar-mobile da468ad, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 demos publicadas quebradas) · Prazo: faltam 2d23h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261128-0020](judge-20261128-0020.md), 23/40): a nota não muda, mas a composição muda.
- **Backend (8b3f0d4 → 4d01768):** o commit novo só mexe em comentários, README e evidência. O `repos/rodar-backend/score.md` foi refeito às 00h55 sobre `4d01768`: **17/20** (H1 8, H2 9). Aceito o número. O ganho real é que a correção da 4c **está no ar** (`/health` mostra `sha: 8b3f0d4`) e foi medida contra o CloudFront: **4c foi de 1/4 para 4/4**. A ocorrência de fila na doca segue instável: 5e 1/4, 5e2 0/4.
- **Mobile (9d7cc33 → da468ad):** entraram 115 arquivos (+2996/−811), que o `repos/rodar-mobile/score.md` (sobre `9d7cc33`) **não cobre**. Conferi eu mesmo, ver abaixo.
- **Web e keycloak:** sem mudança.

**Conferido às 00h57 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, `sha: "8b3f0d4"`, `ligar_recebedor_na_aproximacao: true`, `twilio_configurado: false`, `recebedor_modo: rtc`.
- `https://rodar-web-beta.vercel.app/home`: o bundle continua `index-B9aLfjQ1.js`. O chunk `operations-Bi56NYIX.js` ainda tem `https://rodar-backend-five.vercel.app`, e esse `/health` responde `ok: false, banco_ok: false`. **O painel que o júri abre continua sem banco.**
- `https://rodarglobal.github.io/rodar-mobile/`: **404**. Na API do GitHub, o repo tem `has_pages: false`, e o workflow `Demo (GitHub Pages)` em `da468ad` terminou com `failure`. O CI e o Judge do mobile passaram.
- `https://rodar-web-beta.vercel.app/mobile-web`: 200.

**O que entrou no mobile (da468ad):**
- **A favor:**
  - "GPT-Live" e "agent-server" saíram dos locales.
  - Há testes novos da fila offline (`outbox.test.ts`, com 4xx definitivo que não trava a fila), do modo direção, da esfera e da leitura em voz alta, e das claims do Keycloak.
  - O login OIDC + PKCE no realm do `rodar-keycloak` entrou atrás de `EXPO_PUBLIC_AUTH_MODE` (o padrão continua `mock`). O README declara que o backend ainda não valida esse token.
  - O README agora traz impacto em números (IER 2025).
- **Contra:**
  - O README do mobile volta a anunciar `rodarglobal.github.io/rodar-mobile` como "Abrir o app no navegador", e esse link dá 404. O web tinha trocado esse mesmo link morto por `/mobile-web` em 27/11.
  - A voz continua Agora (`EXPO_PUBLIC_VOICE_MODE=agora`, `react-native-agora`), e o backend no ar usa LiveKit (`livekit_configurada: true`). A incompatibilidade continua.
  - Entrou `.idea/` versionado (`avisai-mobile.iml` etc.). É lixo de IDE na raiz que o jurado vê ao abrir o repo.
  - O merge `da468ad` tem a mensagem "Merge branch 'claude/zen-shannon-pz3o4i' into dev", mas está na `main`. É ruído de histórico, sem efeito na regra.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link, e no backend e no mobile os comentários-lembrete continuam lá. Sem o vídeo, o projeto é desclassificado. Faltam 2d23h.
- **RISCO S4/H1: as duas demos que os READMEs anunciam estão quebradas.**
  - O painel na Vercel chama a API sem banco (`rodar-backend-five.vercel.app`, `ok: false`). É o mesmo bundle desde 27/11 23h06. Troquem o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy (sem commit).
  - **Novo:** a demo do mobile no README (`rodarglobal.github.io/rodar-mobile`) dá 404. Liguem Settings → Pages → Source: GitHub Actions e rodem de novo o workflow `Demo (GitHub Pages)` (`workflow_dispatch`, sem commit). Se não subir, troquem o link pelo `/mobile-web` da Vercel. Um link morto na primeira tabela do README custa mais do que não ter link.
- **RISCO H1: a ocorrência de fila na doca falha no ar.** No CloudFront com LLM real, a 5e passou em 1 de 4 rodadas e a 5e2 em 0 de 4. É a etapa que o jurado mais tende a testar ("tem fila aqui"). Além disso, a linha 38 do README do backend diz que a única falha que sobra é a 5e2, mas a tabela da própria evidência mostra a 5e falhando 3 de 4 vezes.
- **Falso positivo da 5e2, sem mudança:** um "beleza, obrigado" com uma ocorrência de fila aberta vira `quantos = "beleza, obrigado"`. Não há teste para esse caso.
- **H1: a voz do app nativo não conecta ao backend** (Agora × LiveKit), sem mudança. A voz real só passa pelo `/mobile-web`.
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **Higiene que o júri vê:**
  - `.idea/` versionado no mobile.
  - Menções a "júri" e "score.md" nos testes do backend e em `infra/README.md`.
  - A `main` do web não tem proteção de branch.
- **STATUS desatualizado:** o do backend está sobre `7fe3475` (diz que a infra está numa "branch sem PR" e que são 377 testes). O do mobile está sobre `28e1569` (cita o Whisper local, que já foi removido). Rodem `/registrar rodar-backend` e `/registrar rodar-mobile`. O `repos/rodar-mobile/score.md` é de `9d7cc33`, e o próximo push no mobile vai refazê-lo.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 4d01768 | 8 | 9 | **17** | `repos/rodar-backend/score.md` (00h55, mesmo commit). A correção da 4c está no ar e foi medida (4/4) |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (sobre `bac015f`). *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, H1 é 7 (14/20) |
| rodar-mobile | da468ad | 6 | 7 | **13** | `repos/rodar-mobile/score.md` é de `9d7cc33` e está velho. Conferi o diff e mantenho a estimativa: os testes e o login OIDC sobem H2, e o `.idea/` e a incompatibilidade de voz o seguram. *Ressalva do projeto:* com a demo em 404 e a voz sem conectar, H1 é 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto. Agora o mobile o usa como opção (`EXPO_PUBLIC_AUTH_MODE=keycloak`), mas o padrão é mock e o backend não valida o token. O que o júri vê não muda |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | O backend público está no ar com banco e com a correção da 4c, medida em 4/4. Mas o jurado que clica nos links dos READMEs encontra: (1) o painel na API sem banco; (2) a demo do mobile em 404; (3) a fila na doca falhando em 3 a 4 de 4 rodadas. Fica em 6. *Precisa de humano:* com a Vercel no CloudFront, a Pages do mobile no ar e o vídeo, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend é o ponto alto: as guardas determinísticas na borda das ferramentas foram medidas no ambiente real, e o time recusou uma heurística que contaminaria os dados. O mobile ganhou testes de fila offline e um OIDC limpo atrás de flag. O que segura o projeto: o mobile continua incompatível com a voz do backend, o `.idea/` está versionado, a `main` do web não tem proteção, o keycloak não é validado por ninguém e os testes do backend citam a banca |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está estimado em R$ (R$ 525 por entrega). O OCOREN amarra o produto à integração. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo e as duas demos funcionando, a nota provável é 27/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Públicos e sem fork. Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones seguem o padrão fictício `9000000xx` ou são exemplo de formato (`+5511999999999`). Os usuários de teste do Keycloak são fictícios. O alerta no SVG do keycloak é falso positivo. O e-mail de autor nos commits não é dado da demo |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). As duas demos anunciadas estão quebradas (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Todo push na main do backend faz deploy na AWS, e no mobile publica a Pages. De 01/12 a 12/12: nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O "modo direção" do mobile é recurso de produto. Não o vendam como segurança do motorista no pitch |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 10 RISCOS.**
- Nenhum README tem o link do vídeo (4 RISCOS).
- O keycloak não tem link de demo nem as seções de dependências e de terceiros (3 RISCOS).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3 RISCOS).
- Estão OK nos quatro: X1, X3, X4, X6 (sem `.env` e sem credenciais) e X7/X8 (main em dia).
- O mobile passou a ter o link de demo, e por isso caiu um RISCO em relação à rodada anterior. Só que o script não testa se o link responde, e ele dá 404. Também não vê a URL de API no bundle da Vercel. Conferi os dois à mão.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: **não** submeter o rodar-keycloak, ou completar o README dele (dependências, terceiros, demo) |
| S4 | Demo HTTPS no ar | **RISCO**. No painel: `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` para o CloudFront. Não ponham o `github.io/rodar-mobile` enquanto der 404 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos quatro READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado na aproximação (a 4c já preenche a doca 4/4);
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   **Não gravem a etapa "fila na doca" falada** enquanto a 5e falhar 3 de 4 vezes. Se precisarem dela, usem o botão do painel.
2. **As duas demos funcionando, sem commit.** **H1 6→7 = +1.**
   - Vercel: `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy. Confiram que o chunk `operations-*.js` não cita mais `rodar-backend-five`.
   - Mobile: liguem a Pages (Source: GitHub Actions) e rodem de novo o `Demo (GitHub Pages)`. Confiram o 200.
   - Depois, no backend: a regra determinística de `fila` depois da chegada, o descarte de "ok/beleza/obrigado" com testes e 4 rodadas novas no CloudFront.
3. **Fechar a incompatibilidade de voz e a higiene em um commit por repo, até 29/11.** **H2 7→8 = +1.**
   - No mobile, religuem a voz ao LiveKit, ou declarem no README que o app nativo roda em Mock e que a voz real é o `/mobile-web`. Tirem o `.idea/` e ponham no `.gitignore`.
   - No backend, tirem "júri" e "score.md" dos testes e do `infra/README.md` e corrijam a linha 38 ("as falhas que sobram: 5e e 5e2").
   - No web, liguem a proteção da `main`.

## Observações

- A medição da 4c (de 1/4 para 4/4 no ar, conferida no banco) é a melhor prova de H1 que o projeto tem hoje. Para um júri de dados e ML, a tabela de rodadas por etapa vale um slide na final.
- Com 4 amostras, 1/4 contra 2/4 na 5e é ruído. Para afirmar melhora, rodem de 8 a 10 vezes por versão.
- O login Keycloak no mobile só vale como argumento de H2 se o backend validar o token. Hoje o README diz que não valida. Até 30/11, não vale o risco de ligar isso no caminho da demo.
- Ordem sugerida: dia 28, item 2 (a parte sem commit primeiro) e a regra da fila; dia 29, item 3 e a gravação; dia 30, só os links do vídeo, a conferência do `/health`, do bundle da Vercel e da Pages, e um `validar_fluxos.py` final. Nada de mexer na voz no último dia.
- O smoke do deploy ainda faz um GET que incrementa a sequência do OCOREN em produção.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz, mas o backend usa LiveKit. Registrem a troca num `/adr`. É essa divergência que mantém o mobile quebrado.
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel, AWS e Pages) no ar. A CI que publica a cada push precisa ficar parada nesse período.
