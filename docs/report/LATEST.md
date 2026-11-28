# Judge: RODAR (projeto), 2026-11-27 21:30

Gatilho: push na main de rodar-backend 7c60ad2 por HenryFacens.
Repositórios avaliados: rodar-backend 7c60ad2, rodar-web e6b1683, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 links e demo) · Prazo: faltam 3d2h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2048](judge-20261127-2048.md), 23/40): só o rodar-backend mudou (e3a8879 → 7c60ad2, 3 commits). Os commits fazem quatro coisas:
- o 500 de `deps.py` deixou de vazar o erro e agora vai para o log;
- a sequência do OCOREN passou a ser persistida com `FOR UPDATE`;
- entraram 10 testes do `voice_agent.py`;
- a migração saiu do `command` da API e foi para uma task separada, e o topo do README aponta para o CloudFront.

O `repos/rodar-backend/score.md` foi refeito às 21h25 para o mesmo commit e ficou em **16/20** (H2 8→9). Aceito o número. Os score.md do web (e6b1683, 16h58) e do mobile (9d7cc33, 15h28) são de hoje e dos commits no HEAD. Aceito os dois.

**A nota do projeto não muda.** O que o push corrigiu é qualidade interna do backend. Nada disso aparece para quem abre a demo ou o vídeo. Os dois bloqueios de H1 da rodada anterior continuam:
1. o painel no ar chama a API sem banco;
2. a voz do app nativo não fala com o backend.

O H2 do projeto **fica em 7**. Duas das sete dívidas foram fechadas (o 500 genérico e o teste do `voice_agent`). As que mais pesam continuam: o mobile é incompatível com o backend (Agora × LiveKit), o deploy da AWS é manual, `useTrip.ts` tem 1489 linhas e o Keycloak está solto.

Conferi às 21h30:
- `d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com `banco_ok: true`, `llm_upstream: true`, `twilio_configurado: false`, `recebedor_modo: rtc` e `auth_obrigatoria: true`. `/docs`, `/openapi.json` e `GET /rotas` respondem 200.
- `GET /rotas/1/ocoren` responde 401 sem login. Isso está certo, mas **não prova que a migração nova rodou** no banco do ar. Não gerei OCOREN, porque isso grava na sequência da demo. Fica como *precisa de humano*.
- `rodar-web-beta.vercel.app/home` e `/mobile-web` respondem 200.
- **O bundle publicado do painel (`/assets/operations-*.js`) ainda tem `https://rodar-backend-five.vercel.app` como base da API.** Ninguém trocou o `VITE_API_BASE_URL` na Vercel.
- `rodar-backend-five.vercel.app/health` responde 200 com `banco_ok: false`.
- `rodarglobal.github.io/rodar-mobile/` continua em 404, e a linha 32 do README do web ainda aponta para lá.

**Nenhum README tem link de vídeo. Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** O link ainda é um comentário no backend (linha 44), no web (linha 39) e no mobile (linha 36). Os tours mudos de 1 min não são o entregável. Faltam 3 dias e 2 horas.
- **RISCO S4/H1: o painel publicado continua apontando para a API sem banco.** Conferi de novo no bundle às 21h30. No ar, o "Conectar à API" e o "Testar ao vivo (LiveKit)" vão para `rodar-backend-five.vercel.app`. O CORS do CloudFront já aceita a Vercel. Falta trocar a variável na Vercel e fazer o redeploy, e depois corrigir a linha 237 do README do web, que diz "modo Demo".
- **Risco operacional novo: a migração ficou manual.** Desde `301f702`, a API não migra sozinha. Se a imagem no ar for de `16d9884` ou posterior e ninguém tiver rodado `infra/envs/dev/migrar.sh`, falta a coluna `ultima_sequencia_ocoren`, e o OCOREN quebra na frente do júri. *Precisa de humano:* com login de CCO, gerar um OCOREN no CloudFront e confirmar que responde 200.
- **A main e a demo podem se descolar.** A CI publica sozinha só na Vercel sem banco, e a AWS é publicada à mão. Até 30/11, todo push no backend exige deploy manual.
- **RISCO S4 (demo durante a avaliação): a API roda na conta AWS dev de uma empresa** (o README cita a Rumo). Ela precisa ficar no ar até 12/12, de preferência até 15/12. *Precisa de humano:* combinar por escrito.
- **Os links de demo continuam ruins ou contraditórios:**
  - web, linha 32: o "app do motorista no navegador" leva ao Pages, que dá 404;
  - backend, linha 36: diz "sem demo web própria" para o motorista e esconde o `/mobile-web`, que funciona;
  - mobile e keycloak: sem link de demo.
- **H1: a voz do app nativo não conecta ao backend.** O app espera Agora e o backend devolve LiveKit. A voz real só passa pelo `/mobile-web`, e ele hoje aponta para a API sem banco.
- **A voz atual (LiveKit com Gemini Live) não tem prova ponta a ponta.** O `evidence/validacao.md` (33/33) é da era Agora, com o LLM em contingência. *Precisa de humano.*
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **Agora são quatro contagens de testes diferentes:**
  - backend: 625 (389 + 127 + 109);
  - web: 554 (318 + 127 + 109);
  - mobile: 524 (299 + 127 + 98);
  - conferido: **631** (389 + 144 + 98).

  O júri lê os três READMEs lado a lado.
- **Texto antigo na tela do app:** `rodar-mobile/src/assets/locales/pt-BR.json`, linhas 229, 263, 474 e 475, ainda mostra "GPT-Live" e "agent-server".
- **STATUS desatualizado:**
  - backend (`7fe3475`): diz "branch sem PR, só HTTP", fala em 377 testes e lista demos no Pages;
  - mobile (`28e1569`): marca como Ok o Whisper local, que foi removido, e fala em 86 testes;
  - web: não registra o seletor de velocidade nem o `VITE_API_BASE_URL`.

  Rodem `/registrar` nos três.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 7c60ad2 | 7 | 9 | **16** | `repos/rodar-backend/score.md` (21h25, mesmo commit). 389 testes e ruff limpo, conferidos lá |
| rodar-web | e6b1683 | 7 | 7 | **14** | `repos/rodar-web/score.md` (16h58, mesmo commit). *Ressalva do projeto:* o deploy aponta o modo API para a Vercel sem banco. Enquanto isso não mudar, H1 6 (13/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual. H1 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto: não há score.md e o repo não mudou. Nenhum repo o usa (o login segue MOCK), e o README não tem dependências, terceiros, demo nem vídeo |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sem mudança. Há duas coisas no ar em HTTPS. O painel (`rodar-web-beta.vercel.app`) mostra o caminho feliz completo no modo Demo: aproximação, aviso, estadia e escalonamento. A API (`d3fy4m7zwukr3x.cloudfront.net`) responde com banco e implementa o fluxo inteiro, com OCOREN 5.0/3.1. A nota não chega a 7 por quatro motivos: (1) o painel publicado chama a API sem banco (conferido no bundle às 21h30); (2) dois READMEs levam a 404 ou escondem o `/mobile-web`; (3) a voz do app nativo não conecta ao backend; (4) não há prova ponta a ponta da voz atual, e o OCOREN no ar depende de uma migração manual que não consegui confirmar. *Precisa de humano:* com o `VITE_API_BASE_URL` no CloudFront e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend subiu para referência (H2 9 no repo): portas e adaptadores, motor EDI que trata o layout como dado, outbox idempotente, sequência do OCOREN com lock de linha, 500 sem vazamento, migração em task própria, OpenTofu e CI com Postgres real. O web tem TypeScript strict e contrato validado, e o mobile tem camadas claras e outbox SQLite. O que segura o projeto em 7: o mobile ficou incompatível com o backend (Agora × LiveKit); o deploy do painel diverge do README; o deploy da AWS é manual e não roda a migração; não há teste de UI nem e2e em nenhum front; `useTrip.ts` tem 1489 linhas; o Keycloak está solto |
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
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). Um link de demo dá 404, e o painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | A Vercel publica a cada push no web e no backend. Façam a troca do `VITE_API_BASE_URL` e o deploy manual da AWS antes de 30/11. De 01/12 a 12/12, nada de merge nem de redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça a trilha |

Resumo do `sh scripts/check-rules.sh`: 0 FALHAS e 11 RISCOS.
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- X1, X3, X4, X6 (credenciais), X7/X8 (main em dia) e o prazo (3d2h) estão OK nos quatro.

O script não pega links que existem mas dão 404, nem a URL de API embutida no bundle, nem migração pendente. Conferi os dois primeiros à mão. O terceiro precisa de humano.

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
3. **Acabar com os 404 e as contradições, num commit por repo:**
   - web, linha 32: `/mobile-web` no lugar do Pages;
   - backend, linha 36: apontar para o `/mobile-web` em vez de "sem demo web própria";
   - mobile: link da demo e a declaração de que o app nativo roda no modo Mock, ou religar a voz ao LiveKit;
   - nos três READMEs, 631 testes (389 + 144 + 98).

   **H1 protegido. H2 7→8 = +1 se a voz do app for religada.**

## Observações

- O push novo é bom trabalho de engenharia (o backend chegou a H2 9 no repo), mas tem retorno quase zero na nota do projeto: o júri não lê `deps.py` antes de ver a demo. Com 3 dias restantes, o tempo do time rende mais nos itens 1 e 2 acima.
- A dependência de uma conta AWS corporativa de terceiros não está nas regras e não afeta a nota. É risco operacional: se a demo cair, o júri avalia pelo vídeo e pelo código (item 7.3).
- O ID da conta AWS aparece no `repos/rodar-backend/STATUS.md` e em `infra/README.md`. Não é segredo, mas não precisava estar lá.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem num `/adr` a troca para LiveKit + Gemini Live.
- O `PLAN.md` ainda tem o *Demo path* como template vazio. O roteiro do vídeo deveria sair dali.
- Concedam a permissão de notificação do painel antes de gravar.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- Apresentem o Keycloak como "identidade pronta para o setup", não como o login do produto.
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
