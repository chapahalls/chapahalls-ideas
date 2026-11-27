# Judge: RODAR (projeto), 2026-11-27 16:59

Gatilho: push na main de rodar-web e6b1683 por HenryFacens.
Repositórios avaliados: rodar-backend f45b6cc, rodar-web e6b1683, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 22 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 links) · Prazo: faltam 3d7h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-1650](judge-20261127-1650.md), 22/40): só o rodar-web mudou (b62e17c → e6b1683, 3 commits, 47 linhas). A mudança mexe só na velocidade do modo Demo:
- o relógio simulado passou de 1 s = 1 min para 2 s = 1 min;
- os Controles da demo ganharam o seletor 0.5x/1x/2x (`DemoControls.tsx`, `setSpeed` validado contra `SIMULATION_SPEED_OPTIONS`).

O `repos/rodar-web/score.md` foi refeito às 16h58 para e6b1683 e continua em **14/20** (H1 7, H2 7). Aceito o número, porque é do mesmo commit e de 1 minuto atrás. Os score.md do backend (16h47, f45b6cc) e do mobile (15h28, 9d7cc33) são dos commits que estão no HEAD e de hoje, então aceito os dois também.

No projeto, a nota não muda. O seletor de velocidade ajuda quem for gravar o vídeo e o jurado que abrir a Demo, mas não resolve nenhum item da lista anterior. Conferi às 16h59:
- `rodar-web-beta.vercel.app/home` e `/mobile-web` respondem 200;
- `rodarglobal.github.io/rodar-web/` e `rodarglobal.github.io/rodar-mobile/` respondem 404;
- `rodar-backend-five.vercel.app/health` responde `"ok":false,"banco_ok":false,"twilio_configurado":false,"recebedor_modo":"rtc"`;
- `/rotas` responde 500.

**Nenhum README tem link de vídeo. Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** No backend (linha 44) e no web (linha 39), o lugar do link ainda é um comentário, e o mobile está igual. Os tours mudos de 1 min não são o entregável. Faltam 3 dias e 7 horas.
- **RISCO S4/H1: a API pública na Vercel continua sem banco.** Ela devolve 500 em todas as rotas que usam o banco, inclusive `POST /auth/sso`. O README declara isso, mas um júri que não instala nada (7.4) não vê o backend funcionando. O 500 também mostra no corpo o `psycopg.OperationalError` (`api/deps.py:32`).
- **RISCO S4: links de demo com 404 continuam.** O web aponta o "app do motorista no navegador" (linha 32) para `rodarglobal.github.io/rodar-mobile/`, que dá 404, e o backend aponta os dois links de "Demo no ar" (linha 36) para o Pages. Trocar pelos endereços da Vercel (`/home` e `/mobile-web`) leva 2 minutos.
- **H1: a voz do app nativo não conecta ao backend.** O app pede o `app_id` da Agora e o backend devolve um token LiveKit, então o app cai no modo Mock. A voz real só passa pelo `/mobile-web`, e só com um backend que hoje não está no ar.
- **A ligação telefônica real não está ligada no ar** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" o que for uma chamada dentro do app.
- **Três contagens de testes diferentes:**
  - o README do web (linha 35) diz "554 testes: 318 no backend, 127 no web, 109 no mobile";
  - o README do backend diz "615: 379 + 127 + 109";
  - os números conferidos são 379, 144 e 98, ou seja, **621** no total.

  Um jurado de dados vê essa contradição no primeiro clique.
- **Texto antigo na tela do app:** `rodar-mobile/src/assets/locales/pt-BR.json` ainda mostra "Sessão GPT-Live ativa" e "agent-server indisponível".
- **STATUS desatualizado:**
  - `repos/rodar-backend/STATUS.md` dá o PR #12 como aberto;
  - `repos/rodar-mobile/STATUS.md` marca como Ok o Whisper local, que já foi removido;
  - `repos/rodar-web/STATUS.md` não registra o seletor de velocidade.

  Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | f45b6cc | 6 | 8 | **14** | `repos/rodar-backend/score.md` (16h47, mesmo commit). 379 testes passaram, mas a URL pública dá 500 |
| rodar-web | e6b1683 | 7 | 7 | **14** | `repos/rodar-web/score.md` (16h58, mesmo commit). 144 testes, demo na Vercel no ar |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual. Eu daria H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto: não há score.md e o repo não mudou desde a rodada anterior. Nenhum repo usa o Keycloak (o login segue MOCK), e o README não tem dependências, terceiros, demo nem vídeo |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | A demo HTTPS está no ar (`rodar-web-beta.vercel.app/home`, 200) e mostra o caminho feliz completo no modo Demo, com o escalonamento push → painel → ligação. Agora ela também tem um ritmo ajustável (0.5x/1x/2x). O backend implementa o fluxo inteiro, com OCOREN, e passa 379 testes. A nota não sobe por quatro motivos: (1) a demo pública é toda simulada; (2) a única URL pública do backend dá 500 em tudo que usa banco; (3) dois READMEs levam a 404; (4) a voz do app nativo não conecta ao backend. *Precisa de humano:* com os links corrigidos e o backend no ar com banco, a nota provável é 6. Com um vídeo da voz real e da estadia fechando, 7 |
| H2 | Implementação técnica | 7 | No backend: portas e adaptadores, migrações, outbox idempotente, JWT com papel, um motor EDI que trata o layout como dado e CI com Postgres. No web: TypeScript strict e contrato validado, e a mudança nova segue o padrão (constante no config, setter validado). No mobile: camadas claras e outbox SQLite. Há CI nos quatro repos. A nota não sobe porque: o mobile ficou incompatível com o backend depois da troca de Agora para LiveKit; o backend roda num host serverless sem banco e sem `vercel.json`; o 500 expõe o erro interno; não há teste do `voice_agent.py`, de UI nem e2e; o `useTrip.ts` tem 1489 linhas; o Keycloak está solto |
| H3 | Impacto | 7 | A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% dos motoristas não recebem estadia). O benefício está em R$ (R$ 525 por entrega), como estimativa declarada. O OCOREN dá base real à tese de "vendemos a integração" (ADR-0001). Não sobe para 8 porque não há piloto, usuário real nem parceiro homologado |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, só os tours mudos de 1 min. Com um vídeo que explique a doca do zero para um júri sem ninguém de logística, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **22/40** | Igual ao relatório anterior. Passa dos 20 por 2 pontos, e só se o vídeo existir. Sem ele, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | O 1º commit é de 22/11 nos repos de produto e de 26/11 no keycloak. Ainda falta no web uma frase sobre o `69afff2`, que soma cerca de 15 mil linhas, como a que o backend já tem |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE (21 e 22/11) é posterior à abertura e está declarada. O `hfoletto/edi-proceda` (MIT) está declarado como referência |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios e sequenciais (`+5519900000002`, `+55119000000xx`, e `+5511999999999` como exemplo de formato). Os e-mails são `.test` e o CPF do mockup é zerado. O SVG do keycloak é falso positivo. Nenhum `.env` versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5), e há links de demo com 404 ou 500 (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | A Vercel publica a cada push na main do web e do backend. Nesse período, desliguem os merges automáticos e qualquer CI que escreva nos repos de código |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e confirmar a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha (integração entre sistemas) |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS e 11 RISCOS.
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- Licença, visibilidade, credenciais, main em dia e prazo (3d7h) estão OK nos quatro.

O script não pega links de demo que existem mas dão 404 ou 500, então conferi esses à mão.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. O HACKATHON.md lista três repos. Se o keycloak entrar, precisa de um README completo |
| S4 | Demo HTTPS no ar | **RISCO**. Ponham `https://rodar-web-beta.vercel.app/home` no painel. Tirem os links do Pages e, enquanto der 500, também o da API na Vercel |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3; H1 5→6 = +1.** Gravem a Demo em 1x ou 2x com o seletor novo. Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` e o recebedor avisado;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Pôr o backend no ar de verdade.** O ideal é um container (Fly, Render ou Railway) com Postgres gerenciado. O mínimo é uma `DATABASE_URL` de um Postgres gratuito na Vercel, com migração e seed. Depois, configurem `CORS_ORIGENS` e liguem o painel no modo API. Se não der até 30/11, tirem o badge e a linha "API em produção" e troquem o `str(e)` do `deps.py:32` por uma mensagem genérica. **H1 +1 (somado ao item 1, 6→7); protege S4.**
3. **Acabar com os 404 e as contradições, num commit por repo:**
   - web, linha 32: link do app do motorista para `/mobile-web`;
   - web, linha 35, e backend, linha 40: 621 testes (379 + 144 + 98);
   - backend, linha 36: links do Pages para `/home` e `/mobile-web`;
   - mobile: link da demo e uma declaração de que o app nativo roda no modo Mock e a voz real é a do `/mobile-web`, ou religar a voz ao LiveKit.

   **H1 protegido; H2 7→8 = +1 se a voz do app for religada.**

## Observações

- O seletor de velocidade é uma boa decisão de demo, mas a 1x a Demo agora anda na metade do ritmo anterior. Para mostrar uma chegada e uma estadia inteiras em 3 minutos, gravem em 2x ou cortem a gravação.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live, para não haver contradição na final.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- O web pede permissão de notificação ao carregar o painel. Concedam a permissão antes de gravar, para o pop-up não aparecer no vídeo.
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- De 01/12 a 12/12, nenhum commit: só slides, roteiro, ensaio e manter a demo no ar.
