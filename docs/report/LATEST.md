# Judge: RODAR (projeto), 2026-11-27 21:54

Gatilho: push na main de rodar-backend 25dcce7 por HenryFacens.
Repositórios avaliados (clonados em ../): rodar-backend 25dcce7, rodar-web 830d6a4, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 demo) · Prazo: faltam 3d2h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2143](judge-20261127-2143.md), 23/40): só o rodar-backend mudou, com dois commits (7c60ad2 → 25dcce7).
- `299a419` põe `https://rodar-web-beta.vercel.app` no default de CORS da API. Isso só ajuda quando o painel chama o CloudFront, e hoje o painel publicado ainda não chama.
- `25dcce7` cria o job `deploy` no `ci.yml`. Depois de lint e testes, ele publica a imagem no ECR, roda a migração numa task separada e confere o exit code, atualiza `api` e `voice-agent`, espera os serviços estabilizarem e faz um smoke no `/health`. A credencial é um usuário IAM com permissão mínima (`infra/envs/dev/ci.tf`). Com isso, saem dois alertas do relatório anterior: "migração da AWS manual" e "main e demo descoladas no backend".

O `repos/rodar-backend/score.md` foi refeito às 21h52 sobre 25dcce7 e ficou em **16/20** (H1 7, H2 9). Aceito o número. Os score.md do web (830d6a4, 21h41) e do mobile (9d7cc33, 15h28) são de hoje e batem com o HEAD. Aceito os dois. O keycloak não mudou (de1817a).

**A nota do projeto não muda.** O H2 do projeto ficava em 7 por cinco motivos. O deploy manual da AWS saiu da lista. Os outros quatro continuam: o mobile é incompatível com o backend (Agora × LiveKit), a CI da main do web está vermelha, `useTrip.ts` tem 1489 linhas e o keycloak está solto. Com a CI do web verde e a voz do app religada ou declarada, o H2 do projeto vai para 8.

Conferi às 21h55:
- `d3fy4m7zwukr3x.cloudfront.net/health` respondeu 200 com `ok: true`, `banco_ok: true`, `llm_upstream: true`, `livekit_configurada: true`, `twilio_configurado: false`, `recebedor_modo: rtc` e `auth_obrigatoria: true`.
- O `openapi.json` do CloudFront publica `/rotas/{rota_id}/ocoren`, e a rota responde 401 sem login, ou seja, existe e está protegida. Não deu para provar que a migração `ultima_sequencia_ocoren` rodou, porque isso exige login de CCO. **Precisa de humano.**
- O bundle de `rodar-web-beta.vercel.app` (`index-CY8SIDdr.js` e os chunks) **ainda tem uma única URL de API: `https://rodar-backend-five.vercel.app`, a API sem banco.** `cloudfront.net` não aparece. Esse continua sendo o bloqueio principal do H1.
- Não consegui ver se a primeira run do job `deploy` terminou verde (o `gh` não tem token nesta CI), e o `/health` não informa qual commit está no ar.

**Nenhum README tem link de vídeo. Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Ele continua como comentário no backend (linha 44), no web (linha 39) e no mobile (linha 36). Os tours mudos de 1 min não são o entregável. Faltam 3 dias e 2 horas.
- **RISCO S4/H1: o painel publicado continua chamando a API sem banco.** Conferi no bundle às 21h55. Troquem o `VITE_API_BASE_URL` na Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy (não exige commit). O CORS do backend já aceita essa origem desde `299a419`. Depois, corrijam a linha 239 do README do web, que diz que a variável não existe.
- **A CI da main do rodar-web continua vermelha (830d6a4).** O Biome acusa `lint/a11y/noSvgWithoutTitle` em `TaskPushNotifications.tsx:54`. A correção leva uma linha: `aria-hidden="true"`. Liguem também a proteção da `main` com o job obrigatório.
- **Novo, precisa de humano: a primeira run do job `deploy` do backend.** Ela depende de 9 `vars` e 2 `secrets`. Se falhou, a AWS continua na imagem anterior. Confiram em Actions se a run de 25dcce7 ficou verde e gerem um OCOREN no CloudFront com login de CCO.
- **O smoke do deploy é fraco.** O `/health` devolve 200 mesmo com `ok: false` e não expõe o sha. Um deploy com banco fora do ar passaria como verde.
- **RISCO S4 (demo durante a avaliação):** a API roda na conta AWS dev de uma empresa, agora com uma access key fixa nos secrets do GitHub. *Precisa de humano:* garantir por escrito que o cluster e a chave ficam ativos até 12/12, de preferência até 15/12.
- **H1: a voz do app nativo não conecta ao backend** (o app espera Agora e o backend devolve LiveKit). A voz real só passa pelo `/mobile-web`, que hoje usa a API sem banco.
- **A voz atual (LiveKit com Gemini Live) não tem prova ponta a ponta.** O `evidence/validacao.md` (33/33) é da era Agora. *Precisa de humano.*
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **Os READMEs dão contagens de testes diferentes:** 625 no backend, 572 no web e 524 no mobile. O número conferido é **632** (389 + 145 + 98). A linha 40 do backend ainda diz "127 no web, 109 no mobile".
- **Texto antigo e contradições que o júri vê:**
  - "GPT-Live" e "agent-server" na tela do app (`rodar-mobile/src/assets/locales/pt-BR.json`, linhas 229, 263, 474 e 475);
  - a linha 36 do README do backend diz que o app "não tem demo web própria" e esconde o `/mobile-web`;
  - o README do web diz "1 s = 1 min", mas o código usa 2 s = 1 min.
- **STATUS desatualizado nos três repos de produto.** No backend, ele fala em "branch sem PR, só HTTP" e 377 testes, e não registra `299a419` nem `25dcce7`. No web, dá o lint como 0 avisos. No mobile, dá o Whisper local como Ok. Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 25dcce7 | 7 | 9 | **16** | `repos/rodar-backend/score.md` (21h52, mesmo commit). 389 testes passando e ruff limpo; deploy pela CI |
| rodar-web | 830d6a4 | 7 | 7 | **14** | `repos/rodar-web/score.md` (21h41, mesmo commit). *Ressalva do projeto:* com o deploy chamando a API sem banco, H1 6 (13/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual, H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto: não há score.md e o repo não mudou. Nenhum repo o usa (o login segue MOCK) |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sem mudança. O painel em HTTPS mostra o caminho feliz completo no modo Demo: aproximação, aviso, estadia e escalonamento. A API no CloudFront responde com banco, publica a rota do OCOREN e agora é atualizada pela CI. A nota não chega a 7 por três motivos: (1) o painel publicado chama a API sem banco, conferido no bundle às 21h55; (2) a voz do app nativo não conecta ao backend; (3) a voz atual não tem prova ponta a ponta. *Precisa de humano:* com o `VITE_API_BASE_URL` no CloudFront e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend é referência (9 no repo): portas e adaptadores, motor EDI orientado a dado, outbox idempotente, 389 testes com Postgres real, OpenTofu e, agora, deploy contínuo com migração checada e IAM de menor privilégio. O que segura o projeto em 7: o mobile é incompatível com o backend (Agora × LiveKit), a CI do web está vermelha no último commit e não bloqueia merge, `useTrip.ts` tem 1489 linhas e o keycloak está solto |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está em R$ (R$ 525 por entrega, cerca de R$ 113 mil por mês numa frota de 50), como estimativa declarada. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Igual ao relatório anterior. Passa dos 20 por 3 pontos, mas só se o vídeo existir. Sem ele, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | O 1º commit é de 22/11 nos repos de produto e de 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11) está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | O script não checou pela API. Hoje estão públicos. Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios (`+5519900000002`, `+5511900000001`, `+5511999999999` como exemplo de formato). Os e-mails são `.test`, o CPF do mockup é zerado e o alerta no SVG do keycloak é falso positivo |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Cuidado novo: todo push na main do backend agora faz deploy na AWS. De 01/12 a 12/12, nada de push, merge nem redeploy em nenhum repo |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 15 RISCOS.**
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- O X4 não foi checado pela API do GitHub nos quatro (4).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- X1, X3 (LICENSE), X6 (credenciais), X7/X8 (main em dia) e o prazo (3d2h) estão OK nos quatro.

O script não vê a URL de API no bundle, a run do `deploy` nem a CI vermelha do web. A URL e o lint eu conferi à mão. A run e o OCOREN com login precisam de humano.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: **não** submeter o rodar-keycloak |
| S4 | Demo HTTPS no ar | **RISCO**. No painel: `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` para o CloudFront e confirmem o OCOREN no ar. Garantam a conta AWS até 12/12 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy.** Não exige commit, e o CORS já está pronto (`299a419`). Depois, confirmar a run verde do `deploy` e testar ao vivo o "Conectar à API", o `/mobile-web` e um OCOREN. **H1 6→7 = +1**, e o vídeo passa a mostrar o produto real.
3. **CI do web verde e voz do app resolvida.** Num commit no web: `aria-hidden="true"` no `<svg>` de `TaskPushNotifications.tsx:54` e o README corrigido (linha 239, relógio em 2 s = 1 min, 632 testes). Depois, ligar a proteção da `main`. No mobile, religar a voz ao LiveKit ou declarar no README que o app nativo roda em Mock e linkar o `/mobile-web` como demo. Com o deploy da AWS já na CI, esses dois itens são o que falta para **H2 7→8 = +1**.

## Observações

- O deploy pela CI é um ganho real, mas tem um efeito colateral: até 30/11, todo push na main do backend troca a imagem que o júri vê. Testem local (`docker compose run --rm test`) antes de cada push. O último push antes do congelamento precisa sair verde.
- Para endurecer o deploy (sem efeito na nota do projeto agora): `/health` com 503 quando `ok: false`, sha da imagem no `/health` e rollback documentado como um comando. Detalhes no `repos/rodar-backend/score.md`.
- A access key fixa não expira. Depois de 15/12, revoguem a chave e apaguem o usuário `rumolog-dev-ci-deploy`.
- A dependência de uma conta AWS corporativa de terceiros não está nas regras e não afeta a nota. É risco operacional: se a demo cair, o júri avalia pelo vídeo e pelo código (item 7.3).
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem a troca para LiveKit + Gemini Live num `/adr`.
- O `PLAN.md` ainda tem o *Demo path* como template vazio. O roteiro do vídeo deveria sair dali.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
