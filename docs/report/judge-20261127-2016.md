# Judge: RODAR (projeto), 2026-11-27 20:16

Gatilho: push na main de rodar-backend 2b0eb7e por HenryFacens.
Repositórios avaliados: rodar-backend 2b0eb7e, rodar-web e6b1683, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 links) · Prazo: faltam 3d3h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-1659](judge-20261127-1659.md), 22/40): só o rodar-backend mudou (f45b6cc → 2b0eb7e, 7 commits). Os commits trazem só infra (OpenTofu: ECS Fargate, RDS, ALB, CloudFront, Secrets Manager) e README. Nenhuma linha de `backend/` mudou. O `repos/rodar-backend/score.md` foi refeito às 20h15 para esse mesmo commit e subiu de 14 para **15/20** (H1 6→7). Aceito o número. Os score.md do web (16h58, e6b1683) e do mobile (15h28, 9d7cc33) são dos commits que estão no HEAD e de hoje, então aceito os dois também.

O que mudou no projeto: **pela primeira vez há um backend público com banco.** Conferi às 20h17:
- `https://d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com `"ok":true,"banco_ok":true,"llm_upstream":true,"livekit_configurada":true,"twilio_configurado":false,"recebedor_modo":"rtc"`;
- `/rotas` responde 200 com as rotas do seed (Mercadão Campinas);
- `rodar-web-beta.vercel.app/home` e `/mobile-web` respondem 200;
- `rodarglobal.github.io/rodar-web/` e `rodarglobal.github.io/rodar-mobile/` continuam em 404;
- `rodar-backend-five.vercel.app/health` continua com `"ok":false,"banco_ok":false`.

O H1 do projeto sobe de 5 para 6. Não sobe mais porque **o painel publicado não usa essa API**: o deploy da Vercel roda no modo Demo (README do web, linha 239), e o CORS do CloudFront só libera `https://rodarglobal.github.io`, que dá 404. Mandei `Origin: https://rodar-web-beta.vercel.app` e a resposta não trouxe `access-control-allow-origin`. Na prática, o júri vê a API real só pelo `/docs` e o produto só em simulação.

**Nenhum README tem link de vídeo. Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** O lugar do link ainda é um comentário no backend (linha 44), no web (linha 39) e no mobile (linha 36). Os tours mudos de 1 min não são o entregável. Faltam 3 dias e 3 horas.
- **RISCO S4/H1: o painel no ar e a API no ar não se falam.** O painel da Vercel está no modo Demo, e o CORS da API só aceita o Pages (que dá 404). Basta incluir `https://rodar-web-beta.vercel.app` em `CORS_ORIGENS` (é infra, não exige commit no código) e publicar um segundo deploy do painel com `VITE_API_BASE_URL` apontando para o CloudFront. Com isso, o júri vê o produto real.
- **RISCO S4 (demo durante a avaliação): a API roda na conta AWS dev de uma empresa.** Ela precisa ficar no ar até 12/12, de preferência até 15/12. *Precisa de humano:* combinar por escrito com o dono da conta que ninguém vai desligar o serviço nem mexer no SG compartilhado do VPC endpoint (a "pegadinha" do `infra/README.md`).
- **RISCO S4: links de demo errados continuam.**
  - Web, linha 32: o "app do motorista no navegador" aponta para `rodarglobal.github.io/rodar-mobile/` (404).
  - Backend, linhas 3-6: o badge e o primeiro parágrafo mandam para `rodar-backend-five.vercel.app`, que não tem banco. A URL boa (CloudFront) só aparece na linha 37.
  - Mobile e keycloak: não têm link de demo.
- **H1: a voz do app nativo não conecta ao backend.** O app pede o `app_id` da Agora e o backend devolve um token LiveKit, então o app cai no modo Mock. A voz real só passa pelo `/mobile-web`, e só com o painel ligado a uma API, o que hoje não acontece no deploy.
- **A voz atual (LiveKit com Gemini Live) não tem prova ponta a ponta.** O `evidence/validacao.md` (33/33) é da era Agora e foi feito com o LLM em contingência. O `/health` mostra `llm_upstream: true`, mas ninguém gravou a conversa. *Precisa de humano.*
- **A ligação telefônica real não está ligada** (`twilio_configurado: false`, `recebedor_modo: rtc`). No vídeo, não chamem de "ligação" o que é uma chamada dentro do navegador.
- **Contagens de testes contraditórias:** o web diz 554 (318 + 127 + 109), o backend diz 615, e o número conferido é **621** (379 + 144 + 98).
- **O 500 ainda expõe o erro interno** (`api/deps.py:32`, `HTTPException(500, str(e))`). Com o banco no ar o risco caiu, mas a correção leva uma linha.
- **Texto antigo na tela do app:** `rodar-mobile/src/assets/locales/pt-BR.json` ainda mostra "Sessão GPT-Live ativa" e "agent-server indisponível".
- **STATUS desatualizado nos três repos de produto:**
  - backend: diz que a infra está numa branch sem PR, só em HTTP, e dá o PR #12 como aberto;
  - mobile: marca como Ok o Whisper local, que já foi removido;
  - web: não registra o seletor de velocidade.

  Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 2b0eb7e | 7 | 8 | **15** | `repos/rodar-backend/score.md` (20h15, mesmo commit). API HTTPS com banco no CloudFront, login funcionando, infra em OpenTofu |
| rodar-web | e6b1683 | 7 | 7 | **14** | `repos/rodar-web/score.md` (16h58, mesmo commit). 144 testes, demo na Vercel no modo Demo |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual. Eu daria H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto: não há score.md e o repo não mudou. Nenhum repo usa o Keycloak (o login segue MOCK), e o README não tem dependências, terceiros, demo nem vídeo |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Há duas coisas no ar em HTTPS. O painel (`rodar-web-beta.vercel.app/home`) mostra o caminho feliz completo no modo Demo, com o escalonamento push → painel → chamada e o ritmo ajustável. A API (`d3fy4m7zwukr3x.cloudfront.net`) responde com banco: login, rotas, estado do CCO, métricas e SSE. O backend implementa o fluxo inteiro, com OCOREN, e passa 379 testes. A nota não chega a 7 por quatro motivos: (1) o painel publicado não chama a API publicada (modo Demo e CORS só para o Pages); (2) dois READMEs ainda levam a 404 ou à Vercel sem banco; (3) a voz do app nativo não conecta ao backend; (4) não há prova ponta a ponta da voz atual. *Precisa de humano:* com o painel em modo API contra o CloudFront e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | No backend: portas e adaptadores, migrações, outbox idempotente, JWT com papel, um motor EDI que trata o layout como dado e CI com Postgres. Agora soma infra 100% em IaC (state remoto com lock, segredos no Secrets Manager, RDS privado com proteção contra exclusão). No web: TypeScript strict e contrato validado. No mobile: camadas claras e outbox SQLite. Há CI nos quatro repos. A nota não sobe porque: o mobile ficou incompatível com o backend depois da troca de Agora para LiveKit; o deploy da AWS é manual, enquanto a CI ainda publica na Vercel sem banco; o 500 expõe o erro interno; não há teste do `voice_agent.py`, de UI nem e2e; o `useTrip.ts` tem 1489 linhas; o Keycloak está solto |
| H3 | Impacto | 7 | A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% dos motoristas não recebem estadia). O benefício está em R$ (R$ 525 por entrega), como estimativa declarada. O OCOREN dá base real à tese de "vendemos a integração" (ADR-0001). Não sobe para 8 porque não há piloto, usuário real nem parceiro homologado |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, só os tours mudos de 1 min. Com um vídeo que explique a doca do zero para um júri sem ninguém de logística, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Um ponto acima do relatório anterior (H1 5→6). Passa dos 20 por 3 pontos, e só se o vídeo existir. Sem ele, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | O 1º commit é de 22/11 nos repos de produto e de 26/11 no keycloak. Ainda falta no web uma frase sobre o `69afff2`, que soma cerca de 15 mil linhas, como a que o backend já tem |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE (21 e 22/11) é posterior à abertura e está declarada. O `infra/README.md` cita uma stack anterior (`contigency_analisys_backend/infra`), descrita como desativada e não copiada. O Tofu é novo (`3b00ddd`). Um humano deve confirmar que nada desse código antigo entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios e sequenciais (`+5519900000002`, `+55119000000xx`, e `+5511999999999` como exemplo de formato). Os e-mails são `.test` e o CPF do mockup é zerado. O SVG do keycloak é falso positivo. Nenhum `.env`, `tfstate` ou `tfvars` versionado. O seed aparece ao vivo em `/rotas`, e é fictício |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5), e há links de demo com 404 (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | A Vercel publica a cada push na main do web e do backend. Nesse período, desliguem os merges automáticos e qualquer CI que escreva nos repos de código. A infra na AWS pode ser mantida sem commit |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e confirmar a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha (integração entre sistemas) |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS e 11 RISCOS.
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- Licença, visibilidade, credenciais, main em dia e prazo (3d3h) estão OK nos quatro.

O script não pega links que existem mas dão 404, nem CORS. Conferi os dois à mão.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. O HACKATHON.md lista três repos. Se o keycloak entrar, precisa de um README completo |
| S4 | Demo HTTPS no ar | **RISCO**. Ponham `https://rodar-web-beta.vercel.app/home` no painel e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Tirem os links do Pages e da API na Vercel sem banco. Garantam a conta AWS até 12/12 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, e o recebedor avisado;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Ligar o painel publicado à API publicada.** Incluam `https://rodar-web-beta.vercel.app` (ou um segundo domínio da Vercel) em `CORS_ORIGENS` no Secrets Manager/ECS e publiquem um deploy do painel com `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net`, mantendo o modo Demo como plano B. Rodem `scripts/validar_fluxos.py` contra essa URL com a voz atual e troquem o `evidence/validacao.md`. **H1 6→7 = +1** (e o vídeo passa a mostrar o produto real, o que ajuda o H4).
3. **Acabar com os 404 e as contradições, num commit por repo:**
   - backend, topo do README: badge e primeiro parágrafo no CloudFront; Vercel sem banco rebaixada; `deps.py:32` com 500 genérico;
   - web, linha 32: link do app do motorista para `/mobile-web`; linha 35: 621 testes (379 + 144 + 98);
   - mobile: link da demo (`/mobile-web`) e uma declaração de que o app nativo roda no modo Mock e a voz real é a do `/mobile-web`, ou religar a voz ao LiveKit.

   **H1 protegido; H2 7→8 = +1 se a voz do app for religada.**

## Observações

- A dependência de uma conta AWS corporativa de terceiros não está nas regras e não afeta a nota. É um risco operacional: se a demo cair, o júri avalia pelo vídeo e pelo código (item 7.3). Mais um motivo para o vídeo mostrar a API real.
- O ID da conta AWS aparece no README e em `infra/README.md`. Não é segredo, mas não precisava estar lá.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live, para não haver contradição na final.
- Gravem a Demo em 2x ou cortem a gravação: a 1x, uma chegada e uma estadia inteiras não cabem em 3 min.
- O web pede permissão de notificação ao carregar o painel. Concedam a permissão antes de gravar.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- De 01/12 a 12/12, nenhum commit: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
