# Judge: RODAR (projeto), 2026-11-27 16:50

Gatilho: push na main de rodar-backend f45b6cc por HenryFacens.
Repositórios avaliados: rodar-backend f45b6cc, rodar-web b62e17c, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 22 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 links) · Prazo: faltam 3d7h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-1602](judge-20261127-1602.md), 22/40): só o rodar-backend mudou (7fe3475 → f45b6cc, PR #12, commit `f3cc6ac`). Entraram três coisas:
- o `/health` agora checa o banco (`SELECT 1`) e tem 2 testes novos;
- o README avisa que a API na Vercel não tem banco e que nenhum login funciona ali;
- o README tem uma frase sobre os três commits de 22/11 com o mesmo segundo.

O `repos/rodar-backend/score.md` foi refeito às 16h47 para f45b6cc e ficou em **14/20** (H1 6, H2 8). Aceito o número: é do mesmo commit e de 3 minutos atrás. Os score.md do web (15h40, b62e17c) e do mobile (15h28, 9d7cc33) são dos commits que estão no HEAD e de hoje. Aceito os dois.

No projeto, a nota não muda. O commit resolve dois itens da lista anterior: o `/health` que mentia e o risco de leitura em X1. Os dois são de texto e de diagnóstico. **O júri continua sem nenhum backend no ar que rode um fluxo.** Conferi às 16h50:
- `/health` responde 200 com `"ok":false,"banco_ok":false`;
- `/rotas` responde 500.

Os dois links do Pages no README do backend (linha 36) continuam dando 404.

**Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** O lugar do link ainda é um comentário no README do backend (linha 44), e o mesmo vale para o web e o mobile. Os tours mudos de 1 min não são o entregável.
- **RISCO S4/H1: a API pública na Vercel continua sem banco.** Ela dá 500 em todas as rotas com banco, inclusive `POST /auth/sso`. O README agora diz isso com todas as letras e chama a escolha de "intencional pelo custo". A honestidade evita a acusação de enganar o júri, mas um jurado que não instala nada (7.4) não vê o backend funcionar. O badge "deploy" (linha 4) e a linha "API em produção" (linha 37) ainda convidam a clicar.
- **RISCO (vazamento de erro):** o 500 do `/auth/sso` devolve `psycopg.OperationalError: failed to resolve host 'db'` no corpo (`api/deps.py:32`, `HTTPException(500, str(e))`). Isso aparece no Swagger público.
- **RISCO S4: links de demo com 404 continuam.** Conferi às 16h50:
  - `https://rodar-web-beta.vercel.app/home`, `/dashboard` e `/mobile-web` respondem 200;
  - `https://rodarglobal.github.io/rodar-web/` e `https://rodarglobal.github.io/rodar-mobile/` respondem 404.

  O backend (linha 36) aponta os dois links de "Demo no ar" para o Pages. O web (linha 32) aponta o app do motorista para o Pages. O mobile não tem link de demo.
- **H1: a voz do app nativo continua sem conectar ao backend.** O app pede `app_id` da Agora (`agoraVoiceSession.ts:137-138`) e o backend devolve token LiveKit, então o app cai no modo Mock. A voz real só passa pelo `/mobile-web`, e só com um backend que hoje não está no ar. O caminho LiveKit + Gemini Live também não tem validação ponta a ponta publicada (o README declara isso).
- **A ligação telefônica real não está ligada no ar:** o `/health` ao vivo mostra `twilio_configurado: false` e `recebedor_modo: rtc`. No vídeo, não chamem de "ligação" o que for chamada no app.
- **Números contraditórios, agora com um número novo errado.** O README do backend (linha 40) diz "615 testes: 379 no backend, 127 no web, 109 no mobile". Os números conferidos são 379, 144 e 98: **621 no total**.
- **Texto antigo na tela do app:** `rodar-mobile/src/assets/locales/pt-BR.json` ainda mostra "Sessão GPT-Live ativa" e "agent-server indisponível".
- **STATUS desatualizado:**
  - `repos/rodar-backend/STATUS.md` (`7fe3475`) ainda dá o PR #12 como aberto e fala em 332 testes;
  - `repos/rodar-mobile/STATUS.md` (`28e1569`) marca como Ok o Whisper local, que já foi removido.

  Rodem `/registrar` nos dois.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | f45b6cc | 6 | 8 | **14** | `repos/rodar-backend/score.md` (16h47, mesmo commit). 379 testes passaram; a URL pública dá 500 |
| rodar-web | b62e17c | 7 | 7 | **14** | `repos/rodar-web/score.md` (15h40, mesmo commit) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual. Eu daria H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto, sem score.md, sem mudança desde a rodada anterior. Nenhum repo usa o Keycloak (o login segue MOCK). O README não tem dependências, terceiros, demo nem vídeo |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | A demo HTTPS está no ar (`rodar-web-beta.vercel.app/home`, 200) e mostra o caminho feliz completo no modo Demo, com o escalonamento push → painel → ligação. O backend implementa o fluxo inteiro, com OCOREN, e passa 379 testes. A nota não sobe por quatro motivos: (1) a demo pública é toda simulada; (2) a única URL pública do backend dá 500 em tudo que usa banco, o que agora está declarado mas não resolvido; (3) dois READMEs ainda levam a 404; (4) a voz do app nativo não conecta ao backend. *Precisa de humano:* com os links certos e o backend no ar com banco, a nota provável é 6. Com um vídeo da voz real e da estadia fechando, 7 |
| H2 | Implementação técnica | 7 | O backend tem portas e adaptadores, migrações, outbox idempotente, JWT com papel, um motor EDI que trata o layout como dado e CI com Postgres. O `/health` agora diz a verdade e tem teste. O web tem TypeScript strict e contrato validado. O mobile tem camadas claras e outbox SQLite. Há CI nos quatro repos. A nota não sobe porque: o mobile ficou incompatível com o backend depois da troca de provedor de voz (Agora → LiveKit); o backend está num host serverless que não segura tarefas de fundo, WS e SSE, e não tem `vercel.json`; o 500 expõe o erro interno; o `voice_agent.py` e o fluxo ponta a ponta não têm teste; `useTrip.ts` tem 1489 linhas; o Keycloak está solto |
| H3 | Impacto | 7 | A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% sem estadia). O benefício está em R$ (R$ 525 por entrega), como estimativa declarada. O OCOREN dá base real à tese de "vendemos a integração" (ADR-0001). Não sobe para 8 porque não há piloto, usuário real nem parceiro homologado |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, e por enquanto só há tours mudos de 1 min. Com um vídeo que explique a doca do zero para um júri sem ninguém de logística, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **22/40** | Igual ao relatório anterior. Passa dos 20 por 2 pontos, e só se o vídeo existir. Sem o vídeo, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | 1º commit em 22/11 nos repos de produto e em 26/11 no keycloak. **Neste push**, o README do backend passou a explicar os três commits de 22/11 com o mesmo segundo. Ainda falta uma frase igual no web sobre o `69afff2`, que soma cerca de 15 mil linhas |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE (21-22/11) é posterior à abertura, e o backend agora declara isso. O `hfoletto/edi-proceda` (MIT) foi declarado como referência |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivar antes de 15/12 |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios e sequenciais (`+5519900000002`, `+55119000000xx`, `+5511999999999` em mensagens de validação). Os e-mails são `.test`. CNPJs e NF-e do OCOREN são declarados fictícios. O SVG do keycloak e o mockup do web são falsos positivos. Nenhum `.env` versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5), e há links de demo com 404 ou 500 (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | A Vercel publica a cada push na main do web e do backend. Nesse período, desliguem os merges automáticos e qualquer CI que escreva nos repos de código |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha (integração entre sistemas) |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS, 11 RISCOS.
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- Licença, visibilidade, credenciais, main em dia e prazo (3d7h) estão OK nos quatro.

O script não pega links de demo que existem mas dão 404 ou 500. Isso eu conferi à mão.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. O HACKATHON.md lista três repos. Se o keycloak entrar, precisa de README completo |
| S4 | Demo HTTPS no ar | **RISCO**. Ponham `https://rodar-web-beta.vercel.app/home` no painel. Tirem os links do Pages, e o da API na Vercel enquanto ela der 500 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3; H1 5→6 = +1.** Roteiro:
   - a doca em uma frase e o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` e o recebedor avisado;
   - o escalonamento push → painel → chamada e a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Backend no ar de verdade, num container (Fly, Render ou Railway) com Postgres gerenciado**, seguindo o caminho que o próprio README já descreve na linha 92. Depois, configurem `CORS_ORIGENS` para a Vercel do web e liguem o painel no modo API. Se não der até 30/11, tirem o badge e a linha "API em produção" do README e troquem o `str(e)` do `deps.py:32` por uma mensagem genérica. **H1 +1 (somado ao item 1, 6→7); protege S4.**
3. **Acabar com os 404 e as contradições, num commit por repo:**
   - no backend (linha 36), troquem os dois links do Pages por `rodar-web-beta.vercel.app/home` e `/mobile-web`, e corrijam a linha 40 para 621 testes (379 + 144 + 98);
   - no web (linha 32), troquem o link do app do motorista por `/mobile-web`;
   - no mobile, ponham o link da demo e declarem que o app nativo roda no modo Mock e que a voz real é a do `/mobile-web`, ou religuem a voz ao LiveKit.

   **H1 protegido; H2 7→8 = +1 se a voz do app for religada.**

## Observações

- O README do backend explica bem por que a Vercel é o host errado. Isso conta a favor em H2 se o time falar disso na final, mas um jurado que só abre a URL não lê o README.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live, para evitar contradição na final.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- O web pede permissão de notificação ao carregar o painel. Concedam a permissão antes de gravar, para o pop-up não aparecer no vídeo.
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- De 01/12 a 12/12, nada de commit: só slides, roteiro, ensaio e a demo no ar.
