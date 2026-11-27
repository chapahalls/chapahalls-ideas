# Judge: RODAR (projeto), 2026-11-27 20:48

Gatilho: push na main de rodar-backend e3a8879 por HenryFacens.
Repositórios avaliados: rodar-backend e3a8879, rodar-web e6b1683, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 links e demo) · Prazo: faltam 3d3h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2016](judge-20261127-2016.md), 23/40): só o rodar-backend mudou (2b0eb7e → e3a8879, 1 commit e o merge, 2 arquivos e 10 linhas). O `cors_origins` da IaC trocou o Pages pela Vercel, e o README do backend tirou o link do app do motorista no Pages. Nenhuma linha de `backend/` mudou. O `repos/rodar-backend/score.md` foi refeito às 20h47 para o mesmo commit e ficou em **15/20**. Aceito o número. Os score.md do web (e6b1683) e do mobile (9d7cc33) são dos commits no HEAD e de hoje, então aceito os dois também.

Conferi às 20h48:
- `d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com `banco_ok: true`. `GET /rotas` com `Origin: https://rodar-web-beta.vercel.app` responde 200 com `access-control-allow-origin` igual à origem. **O CORS da rodada anterior está resolvido.**
- `/docs` e `/livekit/config` no CloudFront respondem 200.
- `rodar-web-beta.vercel.app/home` e `/mobile-web` respondem 200. `rodarglobal.github.io/rodar-mobile/` continua em 404.
- `rodar-backend-five.vercel.app/health` continua com `ok: false, banco_ok: false`, e `/rotas` lá dá **500**.

**Achado novo: o painel publicado aponta para a API errada.** O bundle JS servido pela Vercel tem a constante `https://rodar-backend-five.vercel.app` como base da API. Ela vem da variável `VITE_API_BASE_URL` configurada no projeto da Vercel, porque o código lê só `import.meta.env.VITE_API_BASE_URL` (`src/lib/apiConfig.ts:2`). Resultado: no painel no ar, o "Conectar à API" e o "Testar ao vivo (LiveKit)" vão para a Vercel **sem banco**, e não para o CloudFront que acabou de ser liberado no CORS. O README do web também está errado sobre isso: a linha 239 diz "O deploy usa o modo Demo (sem `VITE_API_BASE_URL`)". A correção é trocar a variável no painel da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy. Não exige commit, mas precisa ser feita antes de 30/11, porque um redeploy no congelamento é discutível.

Por isso o H1 do projeto **fica em 6**: a metade do caminho (CORS) foi feita, mas o júri ainda não vê o painel falando com a API real.

**Nenhum README tem link de vídeo. Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** O link ainda é um comentário no backend (linha 44), no web (linha 39) e no mobile. Os tours mudos de 1 min não são o entregável. Faltam 3 dias e 3 horas.
- **RISCO S4/H1: o painel publicado aponta para a API sem banco.** O `VITE_API_BASE_URL` da Vercel é `rodar-backend-five.vercel.app` (`/rotas` dá 500). O CORS do CloudFront já aceita a Vercel. Falta trocar a variável na Vercel e fazer o redeploy, e depois corrigir a linha 239 do README do web.
- **RISCO S4 (demo durante a avaliação): a API roda na conta AWS dev de uma empresa.** Ela precisa ficar no ar até 12/12, de preferência até 15/12. *Precisa de humano:* combinar por escrito com o dono da conta.
- **RISCO S4: links de demo ruins ou contraditórios.**
  - Web, linha 32: o "app do motorista no navegador" ainda aponta para `rodarglobal.github.io/rodar-mobile/` (404). O `/mobile-web` da Vercel funciona e substitui o link.
  - Backend, linha 36: agora diz que o app do motorista "é nativo, sem demo web própria". O web oferece o `/mobile-web`. Os dois READMEs se contradizem, e o backend esconde a única demo pública do lado do motorista.
  - Backend, linhas 3-6: o badge e o primeiro parágrafo ainda mandam para `rodar-backend-five.vercel.app`, que não tem banco.
  - Mobile e keycloak: sem link de demo.
- **H1: a voz do app nativo não conecta ao backend** (o app espera Agora e o backend devolve LiveKit). A voz real só passa pelo `/mobile-web`, e hoje ele aponta para a API sem banco.
- **A voz atual (LiveKit com Gemini Live) não tem prova ponta a ponta.** O `evidence/validacao.md` (33/33) é da era Agora. *Precisa de humano.*
- **Ligação telefônica real desligada** (`twilio_configurado: false`, `recebedor_modo: rtc`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **Contagens de testes contraditórias:** o backend diz 615 (379 + 127 + 109), o web diz 554 (318 + 127 + 109), e o número conferido é **621** (379 + 144 + 98).
- **O 500 ainda expõe o erro interno** (`rodar-backend/backend/app/api/deps.py:32`, `HTTPException(500, str(e))`).
- **Texto antigo na tela do app:** `rodar-mobile/src/assets/locales/pt-BR.json` ainda mostra "Sessão GPT-Live ativa" e "agent-server indisponível".
- **STATUS desatualizado nos três repos de produto:**
  - backend: diz que a infra está numa branch sem PR, só em HTTP, com o PR #12 aberto, e lista demos no Pages;
  - mobile: marca como Ok o Whisper local, que foi removido, e fala em 86 testes (são 98);
  - web: não registra o seletor de velocidade nem o `VITE_API_BASE_URL` da Vercel.

  Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | e3a8879 | 7 | 8 | **15** | `repos/rodar-backend/score.md` (20h47, mesmo commit). CORS para a Vercel aplicado na AWS e conferido |
| rodar-web | e6b1683 | 7 | 7 | **14** | `repos/rodar-web/score.md` (16h58, mesmo commit). *Ressalva do projeto:* o deploy aponta o modo API para a Vercel sem banco, e o README diz que não há `VITE_API_BASE_URL`. Se não for corrigido, H1 6 (13/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual. Eu daria H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto: não há score.md e o repo não mudou. Nenhum repo usa o Keycloak (o login segue MOCK), e o README não tem dependências, terceiros, demo nem vídeo |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Há duas coisas no ar em HTTPS. O painel (`rodar-web-beta.vercel.app/home`) mostra o caminho feliz completo no modo Demo, com escalonamento e ritmo ajustável. A API (`d3fy4m7zwukr3x.cloudfront.net`) responde com banco e agora aceita o painel no CORS. O backend implementa o fluxo inteiro, com OCOREN, e passa 379 testes. A nota não chega a 7 porque: (1) o painel publicado chama a API errada (`rodar-backend-five.vercel.app`, `/rotas` em 500); (2) dois READMEs levam a 404 ou à API sem banco; (3) a voz do app nativo não conecta ao backend; (4) não há prova ponta a ponta da voz atual. *Precisa de humano:* com o `VITE_API_BASE_URL` da Vercel no CloudFront e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | Sem mudança. Backend com portas e adaptadores, migrações, outbox idempotente, JWT com papel, motor EDI com layout como dado, CI com Postgres e infra 100% em OpenTofu (o CORS agora vem da IaC). Web em TypeScript strict com contrato validado. Mobile com camadas claras e outbox SQLite. CI nos quatro repos. Não sobe porque: o mobile ficou incompatível com o backend (Agora × LiveKit); a configuração do deploy do painel diverge do README; o deploy da AWS é manual; o 500 expõe o erro; não há teste de `voice_agent.py`, de UI nem e2e; `useTrip.ts` tem 1489 linhas; o Keycloak está solto |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está em R$ (R$ 525 por entrega), como estimativa declarada. O OCOREN dá base à tese da integração (ADR-0001). Não sobe para 8 sem piloto, usuário real ou parceiro |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, só tours mudos de 1 min. Com um vídeo que explique a doca do zero para um júri sem ninguém de logística, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Igual ao relatório anterior. Passa dos 20 por 3 pontos, e só se o vídeo existir. Sem ele, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | O 1º commit é de 22/11 nos repos de produto e de 26/11 no keycloak. O backend explica os três commits no mesmo segundo. Falta no web uma frase igual sobre o `69afff2` (cerca de 15 mil linhas) |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE (21 e 22/11) é posterior à abertura e está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Telefones fictícios e sequenciais (`+5519900000002`, `+5511900000001`; `+5511999999999` é exemplo de formato). E-mails `.test`, CPF do mockup zerado, SVG do keycloak é falso positivo. Nenhum `.env`, `tfstate` ou `tfvars` versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). Há links de demo com 404 e o painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | A Vercel publica a cada push na main do web e do backend, e a CI do rodar-ideas dispara a cada push. De 01/12 a 12/12, nada de merge nem de redeploy. Façam a troca do `VITE_API_BASE_URL` antes de 30/11 |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS e 11 RISCOS.
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros, e o Keycloak é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- Licença, visibilidade, credenciais, main em dia e prazo (3d3h) estão OK nos quatro.

O script não pega links que existem mas dão 404, nem CORS, nem a URL de API embutida no bundle. Conferi os três à mão.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. O HACKATHON.md lista três repos. Minha recomendação: **não** submeter o rodar-keycloak, porque nenhum outro repo o usa e o README dele está incompleto. Se ele entrar, precisa de seções de dependências e de terceiros, declarando o Keycloak como componente de terceiros |
| S4 | Demo HTTPS no ar | **RISCO**. Ponham `https://rodar-web-beta.vercel.app/home` no painel e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` da Vercel para o CloudFront. Tirem dos READMEs os links do Pages e da API sem banco. Garantam a conta AWS até 12/12 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, e o recebedor avisado;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Trocar o `VITE_API_BASE_URL` do projeto da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy.** O CORS já está pronto, e isso não exige commit. Testem "Conectar à API" e "Testar ao vivo" no `/mobile-web` publicado e refaçam o `evidence/validacao.md` com a voz atual. Corrijam a linha 239 do README do web. **H1 6→7 = +1**, e o vídeo passa a mostrar o produto real.
3. **Acabar com os 404 e as contradições, num commit por repo:**
   - backend: badge e primeiro parágrafo no CloudFront; linha 36 apontando para o `/mobile-web` em vez de "sem demo web própria"; `deps.py:32` com 500 genérico; 621 testes;
   - web: linha 32 com o `/mobile-web` no lugar do Pages; linha 35 com 621 testes;
   - mobile: link da demo (`/mobile-web`) e a declaração de que o app nativo roda no modo Mock, ou religar a voz ao LiveKit.

   **H1 protegido; H2 7→8 = +1 se a voz do app for religada.**

## Observações

- A dependência de uma conta AWS corporativa de terceiros não está nas regras e não afeta a nota. É um risco operacional: se a demo cair, o júri avalia pelo vídeo e pelo código (item 7.3).
- O ID da conta AWS aparece no README e em `infra/README.md`. Não é segredo, mas não precisava estar lá.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live.
- O `PLAN.md` ainda tem o *Demo path* e as fases como template vazio (`<step>`). Não afeta a nota, mas o verifier não tem o que conferir, e o roteiro do vídeo deveria sair dali.
- Gravem a Demo em 2x ou cortem: a 1x, uma chegada e uma estadia inteiras não cabem em 3 min.
- Concedam a permissão de notificação do painel antes de gravar.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
