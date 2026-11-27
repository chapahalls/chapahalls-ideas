# Judge: RODAR (projeto), 2026-11-27 16:02

Gatilho: push na main de rodar-backend 7fe3475 por HenryFacens.
Repositórios avaliados: rodar-backend 7fe3475, rodar-web b62e17c, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 22 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 links) · Prazo: faltam 3d7h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-1541](judge-20261127-1541.md), 22/40): só o rodar-backend mudou (f4a1bbd → 7fe3475, com 2 commits e um merge). Entraram três coisas:
- o conector **OCOREN 5.0/3.1** com perfil por parceiro (`335c827`);
- a ligação de verdade para a central no 3º canal do escalonamento (`c3085e3`);
- o anúncio de uma "API em produção" na Vercel (`rodar-backend-five.vercel.app`).

O `repos/rodar-backend/score.md` foi refeito às 15h59 para 7fe3475 e ficou em **14/20** (H1 6, H2 8). Aceito o número: é do mesmo commit e de minutos atrás.

No projeto, a nota não muda. O OCOREN deixa o discurso de "integração" mais concreto (H3), mas não há piloto nem parceiro real. A URL nova do backend cria um problema em H1: ela responde 200 em `/docs` e `/health`, mas dá **500 em todas as rotas que usam o banco**, inclusive o login. Conferi às 16h02: `/rotas` devolve 500. Um jurado que abrir o Swagger e clicar em "Try it out" vê o produto quebrado. Os links do Pages no README do backend (linha 36) continuam dando 404.

**Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** O lugar do link ainda é um comentário no README do backend (linha 44), e o mesmo vale para o web e o mobile. Os tours mudos de 1 min não são o entregável.
- **RISCO S4/H1 (novo): a "API em produção" na Vercel está quebrada.** O README do backend a anuncia em três lugares (linhas 4, 6, 37 e 85). `/health` e `/docs` respondem 200. `/rotas` e as demais rotas com banco respondem 500, porque não há `DATABASE_URL` configurada (o host `db` do compose não existe na Vercel). Sem `/auth/sso`, nenhum fluxo roda por ali. Mesmo com banco, o serverless mata as tarefas de fundo (escalonamento, estadia, ligações), o WebSocket e o SSE longo, que são justamente o "só chama a central quando precisa". Ou liguem um Postgres e troquem para um host de container, ou tirem o link do README antes de 30/11.
- **RISCO S4: links de demo com 404 continuam.** Conferi às 16h02:
  - `https://rodar-web-beta.vercel.app/home` e `/mobile-web` respondem 200;
  - `https://rodarglobal.github.io/rodar-web/` e `https://rodarglobal.github.io/rodar-mobile/` respondem 404.

  O backend (linha 36) aponta os dois links de "Demo no ar" para o Pages. O web (linha 32) ainda aponta o app do motorista para o Pages. O mobile não tem link de demo.
- **H1: a voz do app nativo continua sem conectar ao backend.** O app pede o `app_id` da Agora (`src/features/voice/api/agoraVoiceSession.ts:137-138`) e o backend devolve token LiveKit. O app cai no modo Mock. A voz real só passa pelo `/mobile-web`, e só com um backend configurado, que hoje não existe em URL pública funcional.
- **`/health` diz `"ok": true` com o banco fora.** Por isso o deploy quebrado parece saudável.
- **RISCO de leitura em X1.** Os três primeiros commits do backend têm o mesmo horário. No web, o `69afff2` soma cerca de 15 mil linhas. As datas cumprem a regra 6.1, mas falta uma frase no README dizendo que nada anterior a 04/11 entrou.
- **Texto antigo na tela do app.** `rodar-mobile/src/assets/locales/pt-BR.json` ainda mostra "Sessão GPT-Live ativa" e "agent-server indisponível".
- **Números contraditórios.** O README do backend diz "568 testes: 332 no backend, 127 no web, 109 no mobile". Os score.md conferiram 377 no backend, 144 no web e 98 no mobile: **619 no total**. Corrijam para o número conferido.
- **STATUS desatualizado** em `repos/rodar-backend/STATUS.md` (25/11, `b353d12`): ainda descreve Agora ConvoAI e marca OCOREN como promessa. O do mobile (25/11, `28e1569`) marca como Ok a voz em tempo real. Rodem `/registrar` no backend e no mobile.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 7fe3475 | 6 | 8 | **14** | `repos/rodar-backend/score.md` (15h59, mesmo commit). Entrou o OCOREN e a ligação do 3º canal; a URL pública dá 500 |
| rodar-web | b62e17c | 7 | 7 | **14** | `repos/rodar-web/score.md` (15h40, mesmo commit) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual. Eu daria H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto, sem score.md. A CI faz login PKCE real, mas nenhum repo usa o Keycloak (o login segue MOCK). O README não tem dependências, terceiros, demo nem vídeo |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | A demo HTTPS está no ar (`rodar-web-beta.vercel.app/home`, 200) e mostra o caminho feliz completo no modo Demo, com o escalonamento push → painel → ligação. O backend implementa o fluxo inteiro, agora com o OCOREN, e passa 377 testes. A nota não sobe por quatro motivos: a demo pública é toda simulada; a única URL pública do backend dá 500 em tudo que usa banco; dois READMEs ainda levam a 404; a voz do app nativo não conecta ao backend. *Precisa de humano:* com os links certos e o backend no ar com banco, a nota provável é 6; com um vídeo da voz real e da estadia fechando, 7 |
| H2 | Implementação técnica | 7 | O motor de EDI do OCOREN é bom design: layout como dado, validação de sobreposição e perfil por parceiro. O backend tem portas e adaptadores, migrações, outbox idempotente, JWT com papel e CI com Postgres. O web tem TypeScript strict e contrato validado. O mobile tem camadas claras e outbox SQLite. Há CI nos quatro repos. A nota não sobe porque: o mobile ficou incompatível depois da troca de provedor de voz; o backend foi para um host serverless que não suporta tarefas de fundo, WS e SSE, sem config versionada; o `/health` não checa o banco; o `voice_agent.py` e o e2e não têm teste; `useTrip.ts` tem 1489 linhas; o Keycloak está solto |
| H3 | Impacto | 7 | A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% sem estadia). O benefício está em R$ (R$ 525 por entrega, cerca de R$ 113 mil por mês numa frota de 50), como estimativa declarada. O OCOREN dá base real à tese de "vendemos a integração" do ADR-0001: o produto gera o arquivo padrão que transportadora e embarcador trocam. Não sobe para 8 porque não há piloto, usuário real nem parceiro homologado |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, e por enquanto só há tours mudos. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **22/40** | Igual ao relatório anterior. Passa dos 20 por 2 pontos, e só se o vídeo existir |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK (RISCO de leitura) | 1º commit em 22/11 nos repos de produto e em 26/11 no keycloak. Ver o alerta sobre os commits do backend e o commit grande do web |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE (21-22/11) é posterior à abertura. O `hfoletto/edi-proceda` (MIT) foi declarado como referência, não copiado |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivar antes de 15/12 |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios (`+55119000000xx`, `+5519900000002`, `+5511999999999`). Os e-mails são `.test`. Os CNPJs e as chaves de NF-e do OCOREN são declarados fictícios. O SVG do keycloak e o mockup do web são falsos positivos. Nenhum `.env` versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5), e há links de demo com 404 ou 500 (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | A Vercel publica a cada push na main, no web e agora no backend. Desliguem merges automáticos e CI que escreva nos repos de código nesse período |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença em 12/12 |
| X10 | Enquadramento | OK | Doca, estadia e fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha (integração entre sistemas) |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS, 11 RISCOS.
- Nenhum README tem link do vídeo (4).
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
| S4 | Demo HTTPS no ar | **RISCO**. Ponham `https://rodar-web-beta.vercel.app/home` no painel. Tirem os links do Pages e o da API na Vercel enquanto ela der 500 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado), com o link nos READMEs e no painel. Roteiro: a doca em uma frase; o dado de 11h40 na Grande SP; a voz real pelo `/mobile-web`; o recebedor avisado; o escalonamento push → painel → ligação; a Task assumida no CCO; a estadia fechando em R$; o OCOREN gerado em um clique, como prova de "integração". Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile. Isso tira o risco de X7. **H4 3→6 = +3; H1 5→6 = +1.**
2. **Backend no ar de verdade, ou fora do README.** O mínimo é um Postgres gerenciado com `DATABASE_URL`, `alembic upgrade head` e o seed, com o `/health` checando o banco. O certo é um container (Fly, Render, Railway), porque as tarefas de fundo, o WS e o SSE não sobrevivem no serverless. Depois, `CORS_ORIGENS` para a Vercel do web e o painel no modo API. Se não der até 30/11, tirem o link "API em produção" do README. **H1 +1 (somado ao item 1, 6→7); protege S4.**
3. **Acabar com os 404 e as contradições, num mesmo commit por repo.**
   - No backend (linha 36), troquem os dois links do Pages por `rodar-web-beta.vercel.app/home` e `/mobile-web`.
   - No web (linha 32), troquem o link do app do motorista por `/mobile-web`.
   - No mobile, ponham o link da demo e declarem que o app nativo roda no modo Mock e que a voz real é a do `/mobile-web` (ou religuem a voz ao LiveKit).
   - Corrijam os testes para 619 e expliquem em uma frase os commits de 22/11.

   **H1 protegido; H2 7→8 = +1 se a voz do app for religada.**

## Observações

- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live, para evitar contradição na final.
- No pitch, cabe "geramos OCOREN no padrão de mercado". Não cabe "integramos com TOTVS ou Intelipost": não há SFTP nem parceiro homologado, e o README declara isso com honestidade.
- O web pede permissão de notificação ao carregar o painel. Concedam a permissão antes de gravar para o pop-up não aparecer no vídeo.
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- Dúvidas sobre reaproveitar a entrega do UNMUTE vão para oi@hackbrasil.com. Isso não afeta a nota.
- De 01/12 a 12/12, nada de commit: só slides, roteiro, ensaio e a demo no ar.
