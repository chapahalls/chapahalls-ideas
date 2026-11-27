# Judge: RODAR (projeto), 2026-11-27 15:30

Gatilho: push na main de rodar-mobile 9d7cc33 por HenryFacens.
Repositórios avaliados: rodar-backend f4a1bbd, rodar-web 97886f0, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 22 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 link) · Prazo: faltam 3d8h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-1526](judge-20261127-1526.md), 22/40): os SHAs são **os mesmos** nos quatro repos, então o código não mudou e a nota não muda. A novidade é o `repos/rodar-mobile/score.md`, refeito às 15h28 para 9d7cc33, com **13/20** (H1 6, H2 7). Antes eu estimava 10/20. Aceito o H2 7. O H1 6 vale para o app sozinho, mas não para o projeto: o judge do repo não pode ler o backend e por isso não viu que a voz real do app não conecta ao backend atual. Conferi de novo às 15h30, e o problema continua (detalhes nos Alertas). No projeto, isso já está descontado em H1, que continua 5.

A nota passa dos 20 por 2 pontos, e só se o vídeo existir. **Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Os READMEs ainda têm o comentário de lembrete no lugar do link: backend linha 40, web linha 38, mobile linha 36. Os tours mudos em MP4 não são o entregável.
- **RISCO S4: os links "Demo no ar" dão 404.** Conferi às 15h30. `https://rodarglobal.github.io/rodar-web/` responde 404, e `https://rodar-web-beta.vercel.app/` responde 200. Os READMEs do backend (linha 33) e do web (linha 31) apontam para o Pages, e nenhum README cita a Vercel. O README do mobile não tem link de demo.
- **H1: a voz do app nativo continua sem conectar ao backend.** O backend devolve `livekit_url`, `identity` e `token` em `POST /sessions` (`backend/app/api/schemas.py:30-32`). O app exige `app_id` da Agora e lança `'POST /sessions retornou sem app_id ou token da Agora'` (`src/features/voice/api/agoraVoiceSession.ts:137-138`). Na prática, o app nativo cai sempre no modo Mock. O score.md do mobile (13/20) não enxerga isso porque avalia o repo sozinho.
- **Backend sem URL pública fixa.** Só existe por quick tunnel, e o `CORS_ORIGENS` padrão só aceita localhost. A demo pública roda toda no modo Demo.
- **RISCO de leitura em X1.** Os três primeiros commits do backend têm o mesmo horário (22/11 02:42:12). As datas cumprem a regra 6.1, mas um jurado pode ler isso como histórico importado. Uma frase no README resolve.
- **Texto antigo na tela do app.** `src/assets/locales/pt-BR.json` ainda mostra "Sessão GPT-Live ativa" e "agent-server indisponível". Isso aparece no vídeo se gravarem o app.
- **Evidência e números contraditórios.** O backend chama `evidence/validacao.md` de "histórica", e o web a apresenta como "validação com a api real". O backend diz 568 testes e o mobile diz 524; o total conferido é 573 (332 + 143 + 98).
- **STATUS desatualizado.**
  - `repos/rodar-backend/STATUS.md` ainda descreve Agora ConvoAI.
  - `repos/rodar-mobile/STATUS.md` marca como Ok a voz em tempo real e o Whisper local. A voz está quebrada contra o backend, e o Whisper não existe mais no código.
  - `repos/rodar-web/STATUS.md` diz que não há deploy, e há deploy na Vercel.

  Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | f4a1bbd | 6 | 8 | **14** | `repos/rodar-backend/score.md` (15h22, mesmo commit) |
| rodar-web | 97886f0 | 6 | 7 | **13** | `repos/rodar-web/score.md` (15h14, mesmo commit) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit), com 98 testes, typecheck limpo e lint com 0 erros. *Ressalva do projeto:* contra o backend atual, a voz real não conecta. Eu daria H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto, sem score.md. A CI faz login PKCE real, mas nenhum repo usa o Keycloak (o login segue MOCK). Faltam dependências, terceiros, demo e vídeo no README |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | A demo HTTPS está no ar (`rodar-web-beta.vercel.app`, 200) e mostra o caminho feliz completo no modo Demo. O backend implementa o fluxo inteiro, com 332 testes verdes. A nota não sobe por quatro motivos: os READMEs levam a 404, a demo pública é simulada, o backend só existe por túnel e a voz do app nativo não conecta ao backend. *Precisa de humano:* com o link certo, a nota provável é 6; com um vídeo da voz real e da estadia fechando, 7 |
| H2 | Implementação técnica | 7 | O backend tem portas e adaptadores, migrações, outbox idempotente, JWT com papel e CI com Postgres. O web tem TypeScript strict e contrato validado. O mobile tem camadas claras e outbox SQLite. São 573 testes, com CI nos quatro repos. Perde pontos por quatro motivos: o mobile ficou incompatível depois da troca de provedor de voz; há três SDKs de voz no projeto; `useTrip.ts` tem 1489 linhas; `voice_agent.py` não tem teste. O Keycloak também está solto |
| H3 | Impacto | 7 | A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% sem estadia). O benefício está em R$: R$ 525 por entrega e cerca de R$ 113 mil por mês numa frota de 50, como estimativa declarada. Não há piloto, e a integração com TMS que o ADR-0001 diz vender existe só no plano |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, e por enquanto só há tours mudos. Com um vídeo que explique a doca, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **22/40** | Igual ao relatório anterior. Passa dos 20 por pouco e depende do vídeo |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK (RISCO de leitura) | 1º commit em 22/11 nos repos de produto e em 26/11 no keycloak. Ver o alerta sobre os commits com o mesmo horário |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE (21-22/11) é posterior à abertura. Tenham a resposta pronta |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivar antes de 15/12 |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios (`+55119000000xx`, `+5519900000002`, `+5511999999999`, `+55 00 0000-0000`). E-mails `.test`. O SVG do keycloak é falso positivo. Nenhum `.env` versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Faltam o vídeo (S5) e o link certo da demo (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Desliguem merges automáticos e CI que escreva nos repos de código nesse período |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença em 12/12 |
| X10 | Enquadramento | OK | O problema é doca, estadia e fluxo de informação. "Mãos no volante" é acessibilidade, não segurança |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS, 11 RISCOS.
- Nenhum README tem link do vídeo (4).
- O mobile e o keycloak não têm link de demo (2).
- O keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones e o SVG apontados são fictícios ou falsos positivos (3).
- Licença, visibilidade, credenciais e main em dia estão OK nos quatro.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. O HACKATHON.md lista três repos. Se o keycloak entrar, precisa de README completo |
| S4 | Demo HTTPS no ar | **RISCO**. A Vercel funciona, mas os READMEs apontam para um 404. Ponham a Vercel no painel |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos READMEs e no painel. Roteiro:
   - a doca em uma frase;
   - o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` com LiveKit, que funciona hoje;
   - o recebedor avisado;
   - a Task no CCO;
   - a estadia fechando em R$.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales. Isso tira o risco de X7. **H4 3→6 = +3; H1 5→6 = +1.**
2. **Trocar os links `rodarglobal.github.io` pela Vercel** nos READMEs do backend e do web e pôr o link no mobile. Nos mesmos commits:
   - unificar os testes em 573;
   - marcar a validação como "histórica" no web;
   - explicar os commits de 22/11 no backend.

   **H1 +1 (protege contra o 404); H2 protegido.**
3. **Religar a voz do app ao LiveKit**, ou declarar no README do mobile que o app nativo roda no modo Mock e que a voz real é a do `/mobile-web`. Junto, publicar o backend numa URL fixa, com o painel no modo API. **H1 +1; H2 7→8 = +1.**

## Observações

- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live, para evitar contradição na final.
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- Dúvidas sobre reaproveitar a entrega do UNMUTE vão para oi@hackbrasil.com. Isso não afeta a nota.
- De 01/12 a 12/12, nada de commit: só slides, roteiro, ensaio e a demo no ar.
