# Judge: RODAR (projeto), 2026-11-27 15:41

Gatilho: push na main de rodar-web b62e17c por HenryFacens.
Repositórios avaliados: rodar-backend f4a1bbd, rodar-web b62e17c, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 22 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 links) · Prazo: faltam 3d8h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-1530](judge-20261127-1530.md), 22/40): só o rodar-web mudou (97886f0 → b62e17c, com 5 commits). Três mudanças:
- o GitHub Pages saiu e a Vercel ficou como único deploy;
- o link "Demo no ar" do README do web agora funciona;
- entrou o escalonamento push → painel → ligação na Demo, com notificação real do navegador.

O `repos/rodar-web/score.md` foi refeito às 15h40 para b62e17c e subiu de 13 para **14/20** (H1 7). Aceito esse número no escopo do repo.

No projeto, H1 continua 5. A correção resolve só um dos quatro motivos que seguravam a nota, e nem isso por inteiro:
- o README do web ainda manda o "app do motorista no navegador" para um 404;
- o README do backend ainda aponta os dois links da demo para páginas 404.

Os outros três motivos não mudaram: a demo pública é simulada, o backend só existe por túnel e a voz do app nativo não conecta ao backend. A nota está mais perto de 6, mas um jurado que clicar no link errado ainda vê "Site not found".

**Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** O lugar do link ainda é um comentário nos READMEs: backend linha 40, web linha 39, mobile linha 36. Os tours mudos em MP4 (cerca de 1 min, modo Demo) não são o entregável.
- **RISCO S4: ainda há links de demo com 404.** Conferi às 15h41:
  - `https://rodar-web-beta.vercel.app/home` e `/mobile-web` respondem 200;
  - `https://rodarglobal.github.io/rodar-web/` e `https://rodarglobal.github.io/rodar-mobile/` respondem 404.

  Onde estão os links quebrados:
  - README do backend, linha 33: os dois links apontam para o Pages;
  - README do web, linha 32: o segundo link (app do motorista) aponta para o Pages;
  - README do mobile: não tem link de demo.
- **H1: a voz do app nativo continua sem conectar ao backend.** O mobile e o backend não mudaram. O backend devolve `livekit_url`, `identity` e `token` em `POST /sessions`. O app exige o `app_id` da Agora (`src/features/voice/api/agoraVoiceSession.ts:137-138`) e por isso cai no modo Mock. A voz real hoje só passa pelo `/mobile-web` com LiveKit, e só com um backend configurado.
- **Backend sem URL pública fixa.** Só existe por quick tunnel, e o `CORS_ORIGENS` padrão só aceita localhost. O deploy da Vercel roda sem `VITE_API_BASE_URL`, ou seja, todo no modo Demo.
- **RISCO de leitura em X1.** Os três primeiros commits do backend têm o mesmo horário (22/11 02:42:12). No web, o `69afff2` soma cerca de 15 mil linhas. As datas cumprem a regra 6.1, mas uma frase no README explicando a origem (UNMUTE, 21-22/11, depois da abertura) evita a leitura de "histórico importado".
- **Texto antigo na tela do app.** `rodar-mobile/src/assets/locales/pt-BR.json` ainda mostra "Sessão GPT-Live ativa" e "agent-server indisponível". Isso aparece no vídeo se gravarem o app.
- **Números contraditórios.** O README do web diz "554 testes: 318 no backend, 127 no web, 109 no mobile". O backend diz 568 e o mobile diz 524. O conferido nos score.md é **574** (332 + 144 + 98). A validação de 33/33 é chamada de "histórica" no backend e de "com a api real" no web.
- **STATUS desatualizado** nos três repos de produto:
  - o do backend ainda descreve Agora ConvoAI;
  - o do mobile marca como Ok a voz em tempo real e o Whisper local;
  - o do web diz "não há deploy" e fala em 127 testes.

  Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | f4a1bbd | 6 | 8 | **14** | `repos/rodar-backend/score.md` (15h22, mesmo commit) |
| rodar-web | b62e17c | 7 | 7 | **14** | `repos/rodar-web/score.md` (15h40, mesmo commit). Antes era 13. Há 144 testes, e o build e o typecheck passam |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* contra o backend atual, a voz real não conecta. Eu daria H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto, sem score.md. A CI faz login PKCE real, mas nenhum repo usa o Keycloak (o login segue MOCK). Faltam dependências, terceiros, demo e vídeo no README |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | A demo HTTPS está no ar (`rodar-web-beta.vercel.app`, 200), agora com um deploy só, e o README do web aponta para ela. O caminho feliz completo aparece no modo Demo, com o novo escalonamento push → painel → ligação. O backend implementa o fluxo inteiro, com 332 testes. A nota não sobe por quatro motivos: dois READMEs ainda levam a 404; a demo pública é toda simulada; o backend só existe por túnel; a voz do app nativo não conecta ao backend. *Precisa de humano:* com todos os links certos, a nota provável é 6; com um vídeo da voz real e da estadia fechando, 7 |
| H2 | Implementação técnica | 7 | O backend tem portas e adaptadores, migrações, outbox idempotente, JWT com papel e CI com Postgres. O web tem TypeScript strict, contrato validado e notificação push bem defendida. O mobile tem camadas claras e outbox SQLite. São 574 testes, com CI nos quatro repos. A nota não sobe por cinco motivos: o mobile ficou incompatível depois da troca de provedor de voz; há três SDKs de voz; `useTrip.ts` tem 1489 linhas; não há e2e; o vocabulário `panel`/`painel` e `call`/`ligacao` está duplicado no web. O Keycloak também está solto |
| H3 | Impacto | 7 | A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% sem estadia). O benefício está em R$: R$ 525 por entrega e cerca de R$ 113 mil por mês numa frota de 50, como estimativa declarada. Não há piloto, e a integração com TMS que o ADR-0001 diz vender existe só no plano |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, e por enquanto só há tours mudos. Com um vídeo que explique a doca, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **22/40** | Igual ao relatório anterior. Passa dos 20 por 2 pontos e depende do vídeo |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK (RISCO de leitura) | 1º commit em 22/11 nos repos de produto e em 26/11 no keycloak. Ver o alerta sobre os commits do backend e o commit grande do web |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE (21-22/11) é posterior à abertura. Tenham a resposta pronta |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivar antes de 15/12 |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios (`+55119000000xx`, `+5519900000002`, `+5511999999999`). Os e-mails são `.test` e o CPF do mockup é zerado. O SVG do keycloak é falso positivo. Nenhum `.env` versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5), e há links de demo com 404 (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | O deploy da Vercel publica a cada push na main. Desliguem merges automáticos e qualquer CI que escreva nos repos de código nesse período |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença em 12/12 |
| X10 | Enquadramento | OK | O problema é doca, estadia e fluxo de informação. A voz é acessibilidade, não segurança |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS, 11 RISCOS.
- Nenhum README tem link do vídeo (4).
- O mobile e o keycloak não têm link de demo (2).
- O keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- Licença, visibilidade, credenciais e main em dia estão OK nos quatro.

O script não pega os links de demo que existem mas dão 404. Isso eu conferi à mão.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. O HACKATHON.md lista três repos. Se o keycloak entrar, precisa de README completo |
| S4 | Demo HTTPS no ar | **RISCO**. A Vercel funciona e já está no README do web. Ponham `https://rodar-web-beta.vercel.app/home` no painel e tirem os links do Pages |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos três READMEs e no painel. Roteiro:
   - a doca em uma frase;
   - o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` com LiveKit;
   - o recebedor avisado;
   - o escalonamento push → painel → ligação;
   - a Task assumida no CCO;
   - a estadia fechando em R$.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile. Isso tira o risco de X7. **H4 3→6 = +3; H1 5→6 = +1.**
2. **Acabar com os 404.**
   - No backend (linha 33), troquem os dois links do Pages por `rodar-web-beta.vercel.app/home` e `/mobile-web`.
   - No web (linha 32), troquem o link do app do motorista por `/mobile-web`.
   - No mobile, ponham o link da demo.

   Nos mesmos commits:
   - unifiquem os testes em 574;
   - marquem a validação como "histórica" no web;
   - expliquem em uma frase os commits de 22/11.

   **H1 protegido e mais perto de 6; H2 protegido.**
3. **Religar a voz do app ao LiveKit**, ou declarar no README do mobile que o app nativo roda no modo Mock e que a voz real é a do `/mobile-web`. Junto, publiquem o backend numa URL fixa, com o painel no modo API. **H1 +1; H2 7→8 = +1.**

## Observações

- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live, para evitar contradição na final.
- O web pede permissão de notificação ao carregar o painel, sem gesto do usuário. Na gravação, isso pode aparecer como um pop-up do navegador. Concedam a permissão antes de gravar.
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- Dúvidas sobre reaproveitar a entrega do UNMUTE vão para oi@hackbrasil.com. Isso não afeta a nota.
- De 01/12 a 12/12, nada de commit: só slides, roteiro, ensaio e a demo no ar.
