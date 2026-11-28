# Judge: RODAR (projeto), 2026-11-27 21:43

Gatilho: push na main de rodar-web 830d6a4 por HenryFacens.
Repositórios avaliados (clonados em ../): rodar-backend 7c60ad2, rodar-web 830d6a4, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 demo) · Prazo: faltam 3d2h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2134](judge-20261127-2134.md), 23/40): só o rodar-web mudou, com um commit (2368b3c → 830d6a4). Ele deixa o aviso "ativar notificações" mais visível (borda âmbar, sino com `animate-ping`) e **quebra o lint da CI**. O `<svg>` de `src/features/tasks/components/TaskPushNotifications.tsx:54` não tem `<title>` nem `aria-hidden`, e o Biome acusa `lint/a11y/noSvgWithoutTitle`. Conferi a linha. O lint é o primeiro passo do `ci.yml`, então typecheck, testes, build e e2e não rodam na CI para este commit, e o último commit do repo aparece com X vermelho para o júri.

O `repos/rodar-web/score.md` foi refeito às 21h41 para 830d6a4 e ficou em **14/20** (H2 8→7). Aceito o número. Os score.md do backend (7c60ad2, 21h25) e do mobile (9d7cc33, 15h28) são de hoje e dos commits no HEAD. Aceito os dois. O keycloak não mudou (de1817a).

**A nota do projeto não muda.** O H2 do projeto já estava em 7 e não subiu para 8 por causa do mobile incompatível com o backend, do deploy manual da AWS e do `useTrip.ts` com 1489 linhas. A CI vermelha no web reforça o 7, mas não derruba para 6: o código e os 145 testes continuam ali e passam localmente, segundo o score.md do repo. Se a CI ficar vermelha até 30/11, o H2 do projeto passa a correr risco real de 6.

Conferi às 21h44:
- O bundle publicado em `rodar-web-beta.vercel.app` ainda tem uma única URL de API: `https://rodar-backend-five.vercel.app`, a API **sem banco**. `cloudfront.net` não aparece. O bloqueio principal de H1 segue igual.
- `d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com `banco_ok: true`, `llm_upstream: true`, `livekit_configurada: true`, `twilio_configurado: false`, `recebedor_modo: rtc` e `auth_obrigatoria: true`.
- `rodar-web-beta.vercel.app/mobile-web` responde 200.

**Nenhum README tem link de vídeo. Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Ele ainda é um comentário no backend (linha 44), no web (linha 39) e no mobile (linha 36). Os tours mudos de 1 min não são o entregável. Faltam 3 dias e 2 horas.
- **RISCO S4/H1: o painel publicado continua chamando a API sem banco.** Conferido no bundle às 21h44. Troquem o `VITE_API_BASE_URL` na Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy (não exige commit). Depois, corrijam a linha 239 do README do web, que diz que a variável não existe.
- **Novo: CI vermelha na main do rodar-web (830d6a4).** A correção leva uma linha: `aria-hidden="true"` no `<svg>` (o `<span>` pai é decorativo). Aproveitem para trocar por `motion-safe:animate-ping`. A CI não impediu o merge: liguem a proteção da `main` com o job obrigatório até 30/11.
- **Risco operacional: a migração da AWS é manual** (`migrar.sh`, desde `301f702`). Se ela não rodou, o OCOREN quebra no ar. *Precisa de humano:* gerar um OCOREN no CloudFront com login de CCO e confirmar o 200.
- **A main e a demo podem se descolar.** A CI publica sozinha só na Vercel sem banco. A AWS é publicada à mão.
- **RISCO S4 (demo durante a avaliação):** a API roda na conta AWS dev de uma empresa. Ela precisa ficar no ar até 12/12, de preferência até 15/12. *Precisa de humano:* combinar por escrito.
- **H1: a voz do app nativo não conecta ao backend** (o app espera Agora e o backend devolve LiveKit). A voz real só passa pelo `/mobile-web`, que hoje aponta para a API sem banco.
- **A voz atual (LiveKit com Gemini Live) não tem prova ponta a ponta.** O `evidence/validacao.md` (33/33) é da era Agora. *Precisa de humano.*
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **Os READMEs seguem dando contagens de testes diferentes:** 625 no backend, 572 no web e 524 no mobile. O número conferido é **632** (389 + 145 + 98).
- **Texto antigo e contradições que o júri vê:**
  - "GPT-Live" e "agent-server" na tela do app (`rodar-mobile/src/assets/locales/pt-BR.json`, linhas 229, 263, 474 e 475);
  - a linha 36 do README do backend esconde o `/mobile-web`;
  - o README do web diz "1 s = 1 min", mas o código usa 2 s = 1 min (`SIM_MINUTES_PER_SECOND = 0.5`).
- **STATUS desatualizado nos três repos de produto:**
  - backend: diz "branch sem PR, só HTTP" e fala em 377 testes;
  - web: dá o lint com 0 avisos como Ok, mas em 830d6a4 há 1 erro, e não registra o e2e;
  - mobile: dá como Ok o Whisper local, que foi removido, e fala em 86 testes.

  Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 7c60ad2 | 7 | 9 | **16** | `repos/rodar-backend/score.md` (21h25, mesmo commit) |
| rodar-web | 830d6a4 | 7 | 7 | **14** | `repos/rodar-web/score.md` (21h41, mesmo commit). H2 8→7 pela CI vermelha. *Ressalva do projeto:* com o deploy chamando a API sem banco, H1 6 (13/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual, H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto: não há score.md e o repo não mudou. Nenhum repo o usa (o login segue MOCK) |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sem mudança. O painel em HTTPS mostra o caminho feliz completo no modo Demo: aproximação, aviso, estadia e escalonamento. A API no CloudFront responde com banco e implementa o fluxo inteiro, com OCOREN. A nota não chega a 7 por três motivos: (1) o painel publicado chama a API sem banco, conferido no bundle às 21h44; (2) a voz do app nativo não conecta ao backend; (3) não há prova ponta a ponta da voz atual, e o OCOREN no ar depende de uma migração manual não confirmada. *Precisa de humano:* com o `VITE_API_BASE_URL` no CloudFront e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend é referência (9 no repo): portas e adaptadores, motor EDI orientado a dado, outbox idempotente, lock de linha na sequência do OCOREN, OpenTofu e CI com Postgres real. O web tem TypeScript strict, contrato validado e e2e, mas a CI está vermelha no último commit, e um jurado que abra o repo vê isso. O que segura o projeto em 7: o mobile é incompatível com o backend (Agora × LiveKit); o deploy da AWS é manual; `useTrip.ts` tem 1489 linhas; a CI do web não bloqueia merge; o keycloak está solto |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está em R$ (R$ 525 por entrega, cerca de R$ 113 mil por mês numa frota de 50), como estimativa declarada. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Igual ao relatório anterior. Passa dos 20 por 3 pontos, e só se o vídeo existir. Sem ele, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | O 1º commit é de 22/11 nos repos de produto e de 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11) está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios (`+5519900000002`, `+5511900000001`, `+5511999999999` como exemplo de formato). Os e-mails são `.test`, o CPF do mockup é zerado e o alerta no SVG do keycloak é falso positivo |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Façam a correção do lint, a troca do `VITE_API_BASE_URL` e o deploy manual da AWS antes de 30/11. De 01/12 a 12/12, nada de commit, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 11 RISCOS.**
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- X1, X3, X4, X6 (credenciais), X7/X8 (main em dia) e o prazo (3d2h) estão OK nos quatro.

O script não vê a URL de API no bundle, a migração pendente nem a CI vermelha. A URL e a linha do lint eu conferi à mão. A migração precisa de humano.

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

   Gravem a Demo em 2x. Antes, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy.** Isso não exige commit. Depois, rodar `migrar.sh` e testar ao vivo o "Conectar à API", o `/mobile-web` e um OCOREN. **H1 6→7 = +1**, e o vídeo passa a mostrar o produto real.
3. **Deixar a CI do web verde e coerente com o resto.** Em um commit no web: `aria-hidden="true"` no `<svg>` e o README corrigido (linha 239, relógio em 2 s = 1 min, 632 testes). Depois, ligar a proteção da `main`. Isso devolve o web a 15/20 e protege o H2 7 do projeto. Para subir o H2 do projeto 7→8 (**+1**), também é preciso religar a voz do app ao LiveKit, ou ao menos declarar no README do mobile que o app nativo roda em Mock e linkar o `/mobile-web` como demo.

## Observações

- O push de hoje à noite foi um ajuste visual que quebrou a CI três dias antes do prazo. A partir de agora, todo push na main deve passar primeiro por `npm run lint && npm test` local. O júri avalia o último commit até 30/11.
- A dependência de uma conta AWS corporativa de terceiros não está nas regras e não afeta a nota. É risco operacional: se a demo cair, o júri avalia pelo vídeo e pelo código (item 7.3).
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem a troca para LiveKit + Gemini Live num `/adr`.
- O `PLAN.md` ainda tem o *Demo path* como template vazio. O roteiro do vídeo deveria sair dali.
- O commit `830d6a4`, como o `470b018`, tem o e-mail corporativo de um integrante como autor. É metadado do git e não entra no X6.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
