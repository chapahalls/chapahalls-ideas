# Judge: RODAR (projeto), 2026-11-27 15:26

Gatilho: push na main de rodar-backend f4a1bbd por HenryFacens.
Repositórios avaliados: rodar-backend f4a1bbd · rodar-web 97886f0 · rodar-mobile 9d7cc33 · rodar-keycloak de1817a.

**Nota estimada: 22 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 link) · Prazo: faltam 3d8h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-1517](judge-20261127-1517.md), 22/40): os SHAs avaliados são **os mesmos** nos quatro repos. Nada mudou no código, então a nota não muda. A única novidade é o `repos/rodar-backend/score.md`, refeito para f4a1bbd (15h22). Ele confirma os 14/20 que eu tinha estimado (H1 6, H2 8) e acrescenta um risco de leitura em X1, descrito abaixo. O `repos/rodar-mobile/score.md` continua "ainda não avaliado", então mantenho a estimativa de 10/20 que conferi no mesmo commit 9d7cc33.

A nota passa dos 20 por 2 pontos, e só se o vídeo existir. **Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Os READMEs dos três repos de produto ainda guardam o comentário `<!-- Vídeo de 3 min ... antes de 30/11 -->` (backend, linha 40; web, linha 38; mobile, linha 36). Os tours mudos de 1 min em MP4 não são o entregável.
- **RISCO S4: os links "Demo no ar" dão 404.** Conferi de novo às 15h26: `rodarglobal.github.io/rodar-web/` e `rodarglobal.github.io/rodar-mobile/` respondem 404. Esses links estão no README do backend (linha 33) e no do web (linha 31). Já `https://rodar-web-beta.vercel.app` (`/`, `/dashboard` e `/mobile-web`) responde 200, mas esse endereço não aparece em nenhum README.
- **H1: a voz do app nativo não conecta ao backend atual.** O backend usa LiveKit e `POST /sessions` devolve `livekit_url`, `identity` e `token`. O mobile continua com `react-native-agora` e espera `app_id` (`src/features/voice/api/agoraVoiceSession.ts:138`). O diferencial do pitch não funciona no app.
- **Backend sem URL pública fixa.** Ele só existe por quick tunnel do cloudflared, e o `CORS_ORIGENS` padrão só tem localhost. A demo pública roda toda no modo Demo, com dados simulados.
- **RISCO de leitura em X1 (novo, vem do score.md do backend).** Os três primeiros commits do rodar-backend têm o mesmo horário, `2026-11-22 02:42:12 -0300`, e o README diz que o projeto "começou como AvisAI no UNMUTE by Agora (21–22/11)", com as tags `v1.0-entrega` a `v1.3-entrega`. As datas cumprem a regra 6.1, porque são depois de 04/11 21h. Mesmo assim, um jurado pode ler isso como "histórico importado". Uma frase no README resolve: nenhum código anterior a 04/11 entrou, e o trabalho de 21/11 foi commitado a partir de 22/11.
- **Evidência contraditória.** O README do backend chama `evidence/validacao.md` (33/33) de "histórica, anterior à troca do provedor de voz". O README do web (linha 32) apresenta o mesmo arquivo como "validação ponta a ponta com a api real". Um jurado que leia os dois vê a contradição.
- **As contagens de testes não batem** entre os READMEs: o backend diz 568 e o mobile diz 524. O total conferido é 573 (332 + 143 + 98).
- **STATUS desatualizado.** O `repos/rodar-backend/STATUS.md` (25/11) ainda descreve Agora ConvoAI, com `agora_rest.py` e `tokens.py`, e 299 testes. Hoje são LiveKit e 332 testes. O `repos/rodar-mobile/STATUS.md` marca a voz em tempo real como **Ok**, mas ela está quebrada contra o backend atual. Rodem `/registrar` nos dois.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | f4a1bbd | 6 | 8 | **14** | `repos/rodar-backend/score.md` (15h22, mesmo commit): 332 testes passaram e o ruff está limpo. Faltam deploy fixo e uma validação ponta a ponta com LiveKit |
| rodar-web | 97886f0 | 6 | 7 | **13** | `repos/rodar-web/score.md` (15h14, mesmo commit) |
| rodar-mobile | 9d7cc33 | 4 | 6 | **10** | estimativa do judge projeto, conferida em 9d7cc33 (98 testes). O score.md ainda não foi gerado |
| rodar-keycloak | de1817a | 4 | 6 | **10** | estimativa do judge projeto. O CI faz login PKCE real, mas nenhum repo o usa (o login segue MOCK) |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | A demo HTTPS está no ar (`rodar-web-beta.vercel.app`, 200 em `/`, `/dashboard` e `/mobile-web`) e mostra o caminho feliz completo no modo Demo. O backend implementa o fluxo inteiro e tem 332 testes verdes. A nota fica em 5 por quatro motivos: os READMEs levam a 404, a demo pública é simulada, o backend só existe por túnel e a voz do app nativo não conecta. *Precisa de humano:* com o link certo, a nota provável é 6; com um vídeo que mostre a voz real e a estadia fechando, 7 |
| H2 | Implementação técnica | 7 | O backend usa portas e adaptadores, com fakes nos testes, migrações, outbox idempotente, JWT com papel e dono da rota, e CI com Postgres real. O front tem TypeScript strict e contrato validado. São 573 testes e há CI nos quatro repos. Perde pontos porque a troca de provedor de voz deixou o mobile incompatível, porque há três SDKs de voz no projeto, porque o Keycloak está solto e porque o `voice_agent.py` não tem teste |
| H3 | Impacto | 7 | O problema da doca cabe em uma frase e tem fonte brasileira: IER 2025, com 5h09 de média e 11h40 em CD na Grande SP, e CNTA 2025, com 91% sem estadia. O benefício está em R$: R$ 525 por entrega e cerca de R$ 113 mil por mês numa frota de 50, como estimativa declarada. Não há piloto, e a integração com TMS, que é o que o ADR-0001 diz vender, existe só como plano |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Hoje só há tours mudos e READMEs com glossário. Com um vídeo que explique a doca, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **22/40** | Igual ao relatório anterior. Passa dos 20 por pouco, e tudo depende do vídeo |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork nem histórico importado | OK (RISCO de leitura) | 1º commit em 22/11 nos três de produto e em 26/11 no keycloak. Ver o alerta sobre os commits com o mesmo horário no backend |
| X2 | Sem código privado anterior | OK, precisa de humano | Origem declarada (UNMUTE, 21–22/11, depois da abertura). Tenham a resposta pronta |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivar nem fechar antes de 15/12 |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK | Telefones fictícios (`+55119000000xx`, `+5519900000002`, `+5511999999999`), e-mails `.test`. O SVG do keycloak é falso positivo. Nenhum `.env` versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Faltam o vídeo (S5) e o link certo da demo (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Desliguem merges automáticos e qualquer CI que escreva nos repos de código nesse período |
| X9 | Time de 1 a 4, todos na final | precisa de humano | Quatro pessoas. Confirmar no painel e a presença em 12/12 |
| X10 | Enquadramento | OK | O problema é doca, estadia e fluxo de informação. "Mãos no volante" deve continuar como acessibilidade, não como segurança |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS e 11 RISCOS.
- Nenhum README tem o link do vídeo: 4 RISCOS, um por repo.
- Os READMEs do mobile e do keycloak não têm link da demo.
- O keycloak não tem seção de dependências e não separa o que é de terceiros.
- Os telefones e o SVG apontados são falsos positivos, como em X6.
- X1, X3, X4, X6 (credenciais) e X7/X8 (main em dia) estão OK nos quatro.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. O HACKATHON.md lista três repos. Se o keycloak entrar, ele precisa de links e da seção de terceiros |
| S4 | Demo HTTPS no ar | **RISCO**. A Vercel funciona e os READMEs apontam para 404. Ponham a Vercel no painel |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos READMEs e no painel. A sequência:
   - a doca em uma frase;
   - o dado de 11h40 na Grande SP;
   - a voz real (pelo `/mobile-web` com LiveKit, que funciona hoje);
   - o recebedor avisado;
   - a Task no CCO;
   - a estadia fechando em R$.

   Isso tira o risco de X7: **H4 3→6 = +3**, e **H1 5→6 = +1**.
2. **Trocar os links `rodarglobal.github.io` pela Vercel** nos READMEs do backend e do web, e pôr o link no mobile. Nos mesmos commits:
   - corrigir "validação com a api real" no web;
   - unificar a contagem de testes em 573;
   - pôr no backend a frase sobre os commits de 22/11.

   São 15 minutos, e isso evita o 404 e as contradições que o júri de dados confere: **H1 +1, H2 protegido**.
3. **Religar a voz do app ao LiveKit**, já que o backend entrega `livekit_url`, `identity` e `token`. Se não der até 30/11, declarem no README do mobile que o app nativo está no modo Mock e que a voz real é a do `/mobile-web`. Junto, publiquem o backend numa URL fixa (Render, Fly ou Railway) com o painel no modo API: **H1 +1, H2 7→8 = +1**.

## Observações

- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem a troca para LiveKit + Gemini Live num `/adr`. Isso não muda a nota online, mas evita contradição na final.
- O Keycloak deve ser apresentado como "identidade pronta para o setup", não como o login do produto.
- Se houver dúvida sobre reaproveitar a entrega do UNMUTE, a pergunta vai para oi@hackbrasil.com. Isso não está no HACKATHON.md e não afeta a nota.
- De 01/12 a 12/12, nada de commit: só slides, roteiro, ensaio e a Vercel (e o backend, se publicado) no ar.
