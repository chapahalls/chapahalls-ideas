# Judge: RODAR (projeto), 2026-11-27 22:34

Gatilho: push na main de rodar-backend bdc14e5 por HenryFacens.
Repositórios avaliados (clonados em ../): rodar-backend bdc14e5, rodar-web 05d559e, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 demo) · Prazo: faltam 3d1h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2154](judge-20261127-2154.md), 23/40): a nota não muda. Mudaram dois repos.
- **rodar-backend** (25dcce7 → bdc14e5), com dois commits. `fbc902f` testa a sequência do OCOREN (1 e 2 persistidos). `bdc14e5` faz o `/health` devolver 503 quando o banco cai e expor o `sha`. O smoke do deploy agora confere o sha, o 503 e um OCOREN autenticado, e o rollback está documentado como comandos. 391 testes passando. O `repos/rodar-backend/score.md` foi refeito às 22h31 sobre bdc14e5 e mantém **16/20** (H1 7, H2 9). Aceito o número.
- **rodar-web** (830d6a4 → 05d559e). O commit que quebrou o lint foi revertido em `3a085b4`. `bac015f` corrige uma regressão real do adaptador do modo API (`payload.channel`) e traz teste de regressão. `05d559e` corrige o cursor do tour e reaplica o aviso de push com `aria-hidden="true"` no `<svg>` da linha 54, que era o erro de lint. **A CI do web deixa de estar vermelha por esse motivo.** O `repos/rodar-web/score.md` é de `bac015f` (21h52), um commit antes do HEAD. Conferi o diff de `05d559e` (3 arquivos de UI, 25 linhas) e aceito os **15/20** (H1 8, H2 7). Não rodei a suíte do web nesta rodada (o ambiente não tem `node_modules`).
- O mobile (9d7cc33) e o keycloak (de1817a) não mudaram. Os score.md deles batem com o HEAD.

**Por que o H2 do projeto continua em 7.** O relatório anterior listava quatro freios: CI do web vermelha, voz do app incompatível com o backend (Agora × LiveKit), `useTrip.ts` com 1489 linhas e o keycloak solto. Só o primeiro saiu. A `main` do web continua sem proteção, e foi isso que deixou o `830d6a4` chegar lá. Com a voz do app religada ou declarada, o H2 do projeto vai a 8.

**Por que o H1 continua em 6.** Conferi às 22h35:
- `d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com `ok: true`, `banco_ok: true`, `llm_upstream: true` e `livekit_configurada: true`, **mas sem o campo `sha`**. A imagem de bdc14e5 ainda não está no ar. Isso é compatível com um deploy em andamento ou com um deploy quebrado. Continua sem prova de que alguma run do `deploy` ficou verde. **Precisa de humano.**
- O bundle de `rodar-web-beta.vercel.app` (agora `index-B9aLfjQ1.js` e os chunks) **ainda tem uma única URL de API: `https://rodar-backend-five.vercel.app`, a API sem banco.** `cloudfront.net` não aparece. Esse é o bloqueio principal do H1, e não exige commit.

**Nenhum README tem link de vídeo. Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Continua como comentário no backend (linha 44), no web (linha 39) e no mobile. Os tours mudos de 1 min não são o entregável. Faltam 3 dias e 1 hora.
- **RISCO S4/H1: o painel publicado ainda chama a API sem banco** (conferido no bundle às 22h35). Troquem o `VITE_API_BASE_URL` na Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy. O CORS da API já aceita essa origem. Depois, a linha 239 do README do web ("O deploy usa o modo Demo, sem `VITE_API_BASE_URL`") precisa contar a verdade.
- **Precisa de humano: nenhuma run do `deploy` do backend tem prova de verde.** O `/health` no ar ainda não mostra `sha`. Confiram em Actions as runs de `25dcce7` e `bdc14e5`. A prova é `"sha": "bdc14e5"` no `/health` do CloudFront.
- **O smoke novo pode dar vermelho falso** (do score do backend): `GET /rotas` não tem `order_by`, e o smoke pega `.[0].id`. Se a primeira rota não tiver NF-e, o OCOREN devolve 409 e o job falha, embora o serviço já esteja atualizado. Além disso, cada deploy incrementa a sequência do OCOREN em produção, porque o GET tem efeito colateral.
- **RISCO S4 (demo durante a avaliação):** a API roda na conta AWS dev de uma empresa, com uma access key fixa nos secrets do GitHub. *Precisa de humano:* garantir por escrito que o serviço e a chave ficam ativos até 12/12, de preferência até 15/12.
- **H1: a voz do app nativo não conecta ao backend** (o app espera Agora, e o backend devolve LiveKit). A voz real só passa pelo `/mobile-web`, que hoje usa a API sem banco.
- **A voz atual (LiveKit com Gemini Live) não tem prova ponta a ponta.** O próprio README do backend já admite que o `evidence/validacao.md` (33/33) é da era Agora. *Precisa de humano.*
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **A `main` do web não tem proteção de branch.** O `830d6a4` chegou à main com o lint quebrado e foi revertido 10 minutos depois. Até 30/11, isso pode se repetir num commit que ninguém revise.
- **Os READMEs dão contagens de testes diferentes:** 625 no backend (com "127 no web, 109 no mobile") e 572 no web ("318 no backend"). O número conferido agora é **634** (391 + 145 + 98).
- **Texto antigo que o júri vê:**
  - "GPT-Live" e "agent-server" na tela do app (`rodar-mobile/src/assets/locales/pt-BR.json`, linhas 229, 263, 474 e 475);
  - a linha 36 do README do backend diz que o app "não tem demo web própria" e esconde o `/mobile-web`, que o README do web já linka.
- **STATUS desatualizado:** o do backend está sobre `7fe3475` e ainda fala em "branch sem PR" e 377 testes; o do mobile está sobre `28e1569` e dá o Whisper local como entregue. O do web foi atualizado (`bac015f`). Rodem `/registrar rodar-backend` e `/registrar rodar-mobile`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | bdc14e5 | 7 | 9 | **16** | `repos/rodar-backend/score.md` (22h31, mesmo commit). 391 testes; `/health` com 503 e sha; sha ainda não está no ar |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (21h52, sobre `bac015f`, um commit antes; diff de `05d559e` conferido). *Ressalva do projeto:* com o deploy chamando a API sem banco, H1 7 (14/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual, H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto, sem score.md e sem mudança. Nenhum repo o usa (o login segue MOCK) |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sem mudança. O painel em HTTPS mostra o caminho feliz completo no modo Demo: aproximação, aviso, estadia e escalonamento. A API no CloudFront responde com banco e publica o OCOREN. A nota não chega a 7 por três motivos: (1) o painel publicado chama a API sem banco (bundle conferido às 22h35); (2) a voz do app nativo não conecta ao backend; (3) a voz atual não tem prova ponta a ponta. *Precisa de humano:* com o `VITE_API_BASE_URL` no CloudFront, o sha de bdc14e5 no ar e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend é referência (9 no repo): portas e adaptadores, motor EDI dirigido por layout, outbox idempotente, 391 testes com Postgres real, OpenTofu, deploy pela CI com migração checada, `/health` honesto com sha e rollback documentado. A CI do web volta a passar no lint. O que segura o projeto em 7: o mobile é incompatível com o backend (Agora × LiveKit), a `main` do web não tem proteção (o `830d6a4` provou isso), `useTrip.ts` tem 1489 linhas e o keycloak está solto |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está em R$ (R$ 525 por entrega, cerca de R$ 113 mil por mês numa frota de 50), como estimativa declarada. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Igual ao relatório anterior. Passa dos 20 por 3 pontos, mas só se o vídeo existir. Sem ele, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | O 1º commit é de 22/11 nos repos de produto e de 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11) está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Públicos e sem fork hoje. Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios (`+5519900000002`, `+5511900000001`, `+5511999999999` como exemplo de formato). Os e-mails são `.test`, o CPF do mockup é zerado e o alerta no SVG do keycloak é falso positivo |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Todo push na main do backend faz deploy na AWS. De 01/12 a 12/12: nada de push, merge nem redeploy em nenhum repo |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 11 RISCOS.**
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- X1, X3 (LICENSE), X4 (público), X6 (credenciais), X7/X8 (main em dia) e o prazo (3d1h) estão OK nos quatro.

O script não vê a URL de API no bundle nem as runs do `deploy`. A URL eu conferi à mão. As runs e o OCOREN com login precisam de humano.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: **não** submeter o rodar-keycloak |
| S4 | Demo HTTPS no ar | **RISCO**. No painel: `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` para o CloudFront e confirmem o sha e o OCOREN no ar. Garantam a conta AWS até 12/12 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy** (sem commit). Depois, confirmar `"sha": "bdc14e5"` (ou o último) no `/health` e testar ao vivo o "Conectar à API", o `/mobile-web` e um OCOREN. **H1 6→7 = +1**, e o vídeo passa a mostrar o produto real.
3. **Voz do app resolvida e `main` do web protegida.** No mobile, religar a voz ao LiveKit ou declarar no README que o app nativo roda em Mock e linkar o `/mobile-web` como demo do motorista (isso também tira o RISCO de link de demo do mobile). No web, ligar a proteção da `main` com o job de CI obrigatório. Com a CI do web já verde, são os dois itens que faltam para **H2 7→8 = +1**.

## Observações

- O backend está fazendo exatamente o que o júri pediu, e com teste. Mas o H1 do projeto depende hoje de uma variável na Vercel, não de código: o retorno do item 2 é maior que o de qualquer commit novo no backend.
- O smoke do deploy faz um GET que muda estado (incrementa a sequência do OCOREN). Na demo é inofensivo; se o júri abrir dois OCOREN seguidos e vir a sequência pulando, o time deve saber explicar.
- O `Dockerfile` ainda roda `alembic upgrade head && python -m app.seed` no `CMD`, embora a migração tenha ido para uma task separada. Confirmem que a task definition da `api` sobrescreve o comando.
- A access key fixa não expira. Depois de 15/12, revoguem a chave e apaguem o usuário IAM de deploy.
- A dependência de uma conta AWS corporativa de terceiros não está nas regras e não afeta a nota. É risco operacional: se a demo cair, o júri avalia pelo vídeo e pelo código (item 7.3).
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem a troca para LiveKit + Gemini Live num `/adr`.
- O `PLAN.md` ainda tem o *Demo path* e as fases como template vazio. O roteiro do vídeo deveria sair dali.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
