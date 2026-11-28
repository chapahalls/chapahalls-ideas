# Judge: RODAR (projeto), 2026-11-27 21:34

Gatilho: push na main de rodar-web 2368b3c por HenryFacens.
Repositórios avaliados: rodar-backend 7c60ad2, rodar-web 2368b3c, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 demo) · Prazo: faltam 3d2h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2130](judge-20261127-2130.md), 23/40): só o rodar-web mudou (e6b1683 → 2368b3c, 5 commits). Os commits fazem cinco coisas:
- o link do app do motorista (linha 32 do README) aponta para `/mobile-web` e deixou de dar 404;
- o Biome passou de 53 avisos para 0;
- `payload.channel` passou a usar `painel`/`ligacao`, igual ao backend;
- a permissão de notificação só é pedida depois de um clique;
- entrou um smoke e2e com Playwright na CI (login na Demo, painel, idioma, logout).

O `repos/rodar-web/score.md` foi refeito às 21h32 para o mesmo commit e ficou em **15/20** (H2 7→8). Aceito o número. Os score.md do backend (7c60ad2, 21h25) e do mobile (9d7cc33, 15h28) são de hoje e dos commits no HEAD. Aceito os dois.

**A nota do projeto não muda.** O push fechou um dos quatro motivos que seguravam H1 em 6 (o link 404 do web). O bloqueio principal continua: **o painel no ar ainda chama a API sem banco.** Conferi às 21h34 os 21 chunks JS do deploy da Vercel. A única URL de API é `https://rodar-backend-five.vercel.app`, e `cloudfront.net` não aparece em nenhum deles. Ela não está no código (`src/` e `vercel.json` não citam nenhuma das duas), então vem da variável de ambiente da Vercel. Isso também contradiz a linha 239 do README do web, que diz "O deploy usa o modo Demo (sem `VITE_API_BASE_URL`)".

O H2 do projeto **fica em 7, no limite do 8.** O e2e derruba o "nenhum front tem e2e" do relatório anterior. O que segura o 8 é o mobile incompatível com o backend (Agora × LiveKit), o deploy manual da AWS e `useTrip.ts` com 1489 linhas.

Conferi às 21h34:
- `d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com `banco_ok: true`, `llm_upstream: true`, `livekit_configurada: true`, `twilio_configurado: false`, `recebedor_modo: rtc` e `auth_obrigatoria: true`.
- `rodar-backend-five.vercel.app/health` responde 200, mas continua sem banco.
- `rodar-web-beta.vercel.app/home` e `/mobile-web` respondem 200.
- `rodarglobal.github.io/rodar-mobile/` continua em 404. Nenhum README de produto aponta mais para lá.

**Nenhum README tem link de vídeo. Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Ele ainda é um comentário no backend (linha 44), no web (linha 39) e no mobile (linha 36). Os tours mudos de 1 min não são o entregável. Faltam 3 dias e 2 horas.
- **RISCO S4/H1: o painel publicado continua apontando para a API sem banco.** No ar, o "Conectar à API" e o "Testar ao vivo (LiveKit)" vão para `rodar-backend-five.vercel.app`. Troquem o `VITE_API_BASE_URL` na Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy (não exige commit). Depois, corrijam a linha 239 do README do web, que nega que a variável exista.
- **Risco operacional: a migração da AWS é manual.** Desde `301f702`, a API não migra sozinha. Se ninguém rodou `infra/envs/dev/migrar.sh`, falta a coluna `ultima_sequencia_ocoren`, e o OCOREN quebra na frente do júri. *Precisa de humano:* gerar um OCOREN no CloudFront com login de CCO e confirmar o 200.
- **A main e a demo podem se descolar.** A CI publica sozinha só na Vercel sem banco, e a AWS é publicada à mão.
- **RISCO S4 (demo durante a avaliação): a API roda na conta AWS dev de uma empresa.** Ela precisa ficar no ar até 12/12, de preferência até 15/12. *Precisa de humano:* combinar por escrito.
- **Link ainda contraditório no backend:** a linha 36 diz "sem demo web própria" para o motorista e esconde o `/mobile-web`, que funciona. O mobile e o keycloak continuam sem link de demo.
- **H1: a voz do app nativo não conecta ao backend.** O app espera Agora e o backend devolve LiveKit. A voz real só passa pelo `/mobile-web`, e ele hoje aponta para a API sem banco.
- **A voz atual (LiveKit com Gemini Live) não tem prova ponta a ponta.** O `evidence/validacao.md` (33/33) é da era Agora, com o LLM em contingência. *Precisa de humano.*
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **As contagens de testes continuam diferentes nos três READMEs:**
  - backend: 625 (389 + 127 + 109);
  - web, corrigido hoje e ainda errado: 572 (318 + 145 + 109);
  - mobile: 524 (299 + 127 + 98);
  - conferido: **632** (389 + 145 + 98).

  O júri lê os três lado a lado. Ponham o mesmo número nos três.
- **Texto antigo na tela do app:** `rodar-mobile/src/assets/locales/pt-BR.json`, linhas 229, 263, 474 e 475, ainda mostra "GPT-Live" e "agent-server".
- **README do web contradiz o código no relógio:** ele diz "cada segundo real avança um minuto", mas `SIM_MINUTES_PER_SECOND = 0.5` (2 s = 1 min em 1x).
- **STATUS desatualizado:**
  - backend (`7fe3475`): diz "branch sem PR, só HTTP", fala em 377 testes e lista demos no Pages;
  - web (`e6b1683`): fala em 144 testes e 53 avisos e não registra o e2e;
  - mobile (`28e1569`): marca como Ok o Whisper local, que foi removido, e fala em 86 testes.

  Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 7c60ad2 | 7 | 9 | **16** | `repos/rodar-backend/score.md` (21h25, mesmo commit). 389 testes e ruff limpo, conferidos lá |
| rodar-web | 2368b3c | 7 | 8 | **15** | `repos/rodar-web/score.md` (21h32, mesmo commit). 145 testes, lint com 0 avisos e e2e, conferidos lá. *Ressalva do projeto:* o deploy aponta o modo API para a Vercel sem banco. Enquanto isso não mudar, H1 6 (14/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual. H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto: não há score.md e o repo não mudou. Nenhum repo o usa (o login segue MOCK), e o README não tem dependências, terceiros, demo nem vídeo |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sem mudança na nota. Há duas coisas no ar em HTTPS. O painel (`rodar-web-beta.vercel.app`) mostra o caminho feliz completo no modo Demo: aproximação, aviso, estadia e escalonamento. Os links do web agora respondem 200, e o login passa por um e2e na CI. A API (`d3fy4m7zwukr3x.cloudfront.net`) responde com banco e implementa o fluxo inteiro, com OCOREN 5.0/3.1. A nota não chega a 7 por três motivos: (1) o painel publicado chama a API sem banco, conferido nos chunks às 21h34; (2) a voz do app nativo não conecta ao backend; (3) não há prova ponta a ponta da voz atual, e o OCOREN no ar depende de uma migração manual que não consegui confirmar. *Precisa de humano:* com o `VITE_API_BASE_URL` no CloudFront e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | No limite do 8. O backend é referência (H2 9 no repo): portas e adaptadores, motor EDI que trata o layout como dado, outbox idempotente, sequência do OCOREN com lock de linha, OpenTofu e CI com Postgres real. O web subiu para 8 no repo: TypeScript strict, contrato validado, lint com 0 avisos, vocabulário de canal igual ao do backend e e2e Playwright na CI. O mobile tem camadas claras e outbox SQLite. O que segura o projeto em 7: o mobile ficou incompatível com o backend (Agora × LiveKit); o deploy do painel diverge do próprio README; o deploy da AWS é manual e não roda a migração; `useTrip.ts` tem 1489 linhas; o Keycloak está solto |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está em R$ (R$ 525 por entrega, cerca de R$ 113 mil por mês numa frota de 50), como estimativa declarada. O OCOREN dá base à tese da integração (ADR-0001). Não sobe para 8 sem piloto, usuário real ou parceiro |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe, só tours mudos de 1 min. Com um vídeo que explique a doca do zero para um júri sem ninguém de logística, mostre a voz real e feche com o R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Igual ao relatório anterior. Passa dos 20 por 3 pontos, e só se o vídeo existir. Sem ele, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | O 1º commit é de 22/11 nos repos de produto e de 26/11 no keycloak. Nenhum é fork |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11) é posterior à abertura e está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones são fictícios: `+5519900000002` e `+5511900000001` são sequenciais, e `+5511999999999` é exemplo de formato. Os e-mails são `.test`, o CPF do mockup é zerado, e o alerta no SVG do keycloak é falso positivo (coordenadas). Nenhum `.env`, `tfstate` ou `tfvars` versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | A Vercel publica a cada push no web e no backend. Façam a troca do `VITE_API_BASE_URL` e o deploy manual da AWS antes de 30/11. De 01/12 a 12/12, nada de merge nem de redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS e 11 RISCOS.
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- X1, X3, X4, X6 (credenciais), X7/X8 (main em dia) e o prazo (3d2h) estão OK nos quatro.

O script não pega a URL de API embutida no bundle nem a migração pendente. Conferi a primeira à mão. A segunda precisa de humano.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: **não** submeter o rodar-keycloak. Nenhum outro repo o usa, e o README dele está incompleto. Se ele entrar, precisa de seções de dependências e de terceiros |
| S4 | Demo HTTPS no ar | **RISCO**. No painel, ponham `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` da Vercel para o CloudFront e confirmem que o OCOREN responde no ar. Garantam a conta AWS até 12/12 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, e o recebedor avisado;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Gravem a Demo em 2x. Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy.** Isso não exige commit. Depois, rodar `migrar.sh` e testar ao vivo o "Conectar à API", o "Testar ao vivo" e um OCOREN. Refazer o `evidence/validacao.md` com a voz atual. **H1 6→7 = +1**, e o vídeo passa a mostrar o produto real.
3. **Religar a voz do app ao LiveKit, ou declarar no README do mobile que o app nativo roda no modo Mock e linkar o `/mobile-web` como demo.** No mesmo commit por repo:
   - a linha 36 do backend aponta para o `/mobile-web`;
   - a linha 239 do web diz a verdade sobre o `VITE_API_BASE_URL`;
   - os três READMEs dão 632 testes (389 + 145 + 98).

   **H2 7→8 = +1 se a voz do app for religada.** Só a declaração protege o H1, mas não sobe nota.

## Observações

- O push de hoje no web foi bem mirado: fechou o 404 que o júri veria e pôs o primeiro e2e num front. Ainda assim, a mudança de maior retorno no H1 é uma variável de ambiente na Vercel, e ela custa 5 minutos.
- A dependência de uma conta AWS corporativa de terceiros não está nas regras e não afeta a nota. É risco operacional: se a demo cair, o júri avalia pelo vídeo e pelo código (item 7.3).
- O ID da conta AWS aparece no `repos/rodar-backend/STATUS.md` e em `infra/README.md`. Não é segredo, mas não precisava estar lá.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live.
- O `PLAN.md` ainda tem o *Demo path* como template vazio. O roteiro do vídeo deveria sair dali.
- Concedam a permissão de notificação do painel antes de gravar. Agora ela só aparece depois do clique em "Ativar".
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- O commit `470b018` do web tem o e-mail corporativo de um integrante como autor. É metadado do git e não entra no X6.
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
