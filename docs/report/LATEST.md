# Judge: RODAR (projeto), 2026-11-27 23:05

Gatilho: push na main de rodar-backend f630043 por HenryFacens. Repositórios avaliados: rodar-backend f630043, rodar-web 05d559e, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 demo) · Prazo: faltam 3d0h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2234](judge-20261127-2234.md), 23/40): a nota não muda. Só o backend mudou (bdc14e5 → f630043, 3 commits).
- `332205b`: `GET /rotas` agora usa `order_by(Rota.id)` e tem teste. O smoke do deploy deixa de poder dar 409 falso. **Alerta fechado.**
- `bf6ea0f`: primeira validação ponta a ponta da voz atual (LiveKit com LLM real): **32/34** em `evidence/validacao.md`, sobre bdc14e5. **O alerta "a voz atual não tem prova" fica fechado em parte**: a validação foi local (`localhost:8000`) e pelo gateway de texto, sem áudio, e não contra o CloudFront.
- `f630043`: compromisso por escrito de manter o cluster e a access key da AWS até 15/12 (`infra/README.md`). **Fecha o alerta da conta AWS**, com uma ressalva: quem responde pela conta é uma empresa de fora do time.
- O `repos/rodar-backend/score.md` foi refeito às 23h02 sobre f630043 e mantém **16/20** (H1 7, H2 9). Aceito o número.
- O `repos/rodar-web/score.md` é de `bac015f`, um commit antes do HEAD. O diff de `05d559e` já foi conferido na rodada anterior (UI do tour, 25 linhas), e aceito os 15/20. O mobile e o keycloak não mudaram.

**Conferido às 23h06 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com `ok: true`, `banco_ok: true` e **`sha: "bdc14e5"`**. É a primeira prova de que um deploy pela CI chegou ao ar, e fecha esse alerta. A imagem de f630043 ainda não estava no ar, mas esse commit só mexe em documentação.
- `twilio_configurado: false` e `recebedor_modo: rtc`, sem mudança.
- `https://rodar-web-beta.vercel.app/home` e `/mobile-web` respondem 200. **O bundle (`index-B9aLfjQ1.js` e os chunks) ainda tem uma só URL de API: `https://rodar-backend-five.vercel.app`.** O `/health` dessa API devolve `ok: false`, `banco_ok: false` e `sha: "dev"`. O painel publicado continua apontando para a API sem banco. **Esse é o maior bloqueio do H1, e não exige commit.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Os quatro READMEs seguem sem link (no backend, a linha 44 ainda é o comentário-lembrete). Os tours mudos de 1 min não são o entregável. Sem o vídeo, o projeto é desclassificado. Faltam 3 dias.
- **RISCO S4/H1: o painel publicado chama a API sem banco** (bundle conferido às 23h06; a API responde `banco_ok: false`). Troquem o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy. A linha 239 do README do web ("o deploy usa o modo Demo, sem `VITE_API_BASE_URL`") tem de passar a contar a verdade.
- **RISCO H1 (novo nesta rodada): a demo pública não liga para o recebedor na aproximação.** `infra/envs/dev/ecs.tf:28` fixa `LIGAR_RECEBEDOR_NA_APROXIMACAO = "false"`. O padrão do código é `true`, e o README promete essa ligação. É a primeira frase do produto ("avisa o recebedor antes da chegada"). Se o júri, ou o vídeo gravado contra o CloudFront, seguir o caminho feliz, o aviso não acontece. **Precisa de humano:** ou mudem para `"true"` e façam o deploy antes de 30/11, ou declarem a escolha na seção "Simulado" do README.
- **RISCO H1: o aviso de atraso falha cerca de 1 vez em 3 com o LLM real.** É o que a própria validação mostra: "trânsito parado, vou atrasar 40 min" foi classificado como `fila`. Uma regra determinística (`em_transito` fora da geocerca = `atraso`), com teste, resolve.
- **H1: a voz do app nativo não conecta ao backend** (o app espera Agora, e o backend devolve LiveKit). A voz real só passa pelo `/mobile-web`, que hoje usa a API sem banco. Sem mudança.
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada feita no navegador.
- **A `main` do web não tem proteção de branch.** Sem mudança. Até 30/11, um commit sem revisão pode quebrar a CI de novo, como o `830d6a4`.
- **Os READMEs dão contagens de testes diferentes.** O backend diz 625 na linha 40 ("389 no backend, 127 no web, 109 no mobile"), e o web diz 572. O número conferido agora é **635** (392 + 145 + 98).
- **Texto antigo que o júri vê:**
  - a linha 36 do README do backend diz que o app "não tem demo web própria" e esconde o `/mobile-web`;
  - "GPT-Live" e "agent-server" aparecem na tela do app (`rodar-mobile/src/assets/locales/pt-BR.json`, linhas 229, 263, 474 e 475).
- **STATUS desatualizado:** o do backend está sobre `7fe3475` (fala em "branch sem PR", 377 testes e voz sem validação). O do mobile está sobre `28e1569` e dá o Whisper local como entregue. Rodem `/registrar rodar-backend` e `/registrar rodar-mobile`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | f630043 | 7 | 9 | **16** | `repos/rodar-backend/score.md` (23h02, mesmo commit). 392 testes, sha bdc14e5 no ar, validação 32/34 |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (21h52, sobre `bac015f`, um commit antes; o diff já foi conferido). *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, o H1 é 7 (14/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual, então o H1 é 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto, sem score.md e sem mudança. Nenhum repo o usa (o login segue MOCK) |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Mais perto de 7, mas ainda não chega. A favor: o painel em HTTPS mostra o caminho feliz completo no modo Demo; a API no CloudFront tem banco e roda o commit certo (`sha: bdc14e5`); e a voz real já tem validação de 32/34. Três pontos seguram a nota: (1) o painel publicado chama a API sem banco; (2) a demo pública desliga justamente o aviso ao recebedor na aproximação, que o pitch promete; (3) a voz do app nativo não conecta ao backend, e a validação foi local, por texto. *Precisa de humano:* com o `VITE_API_BASE_URL` no CloudFront, a flag do recebedor ligada e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend é referência (9 no repo): portas e adaptadores, motor EDI dirigido por layout, outbox idempotente, 392 testes com Postgres real, OpenTofu, deploy pela CI provado pelo sha no ar e smoke agora determinístico. O que segura o projeto: o mobile é incompatível com o backend (Agora × LiveKit), a `main` do web não tem proteção, `useTrip.ts` tem 1489 linhas, a configuração de produção contradiz o padrão documentado (`ecs.tf:28`) e o keycloak está solto |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está estimado em R$ (R$ 525 por entrega, cerca de R$ 113 mil por mês numa frota de 50) e declarado como estimativa. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Igual ao relatório anterior. Passa dos 20 por 3 pontos, mas **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11) está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Públicos e sem fork hoje. Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones seguem o padrão sequencial fictício (`+5519900000002`, `+5511900000001`) ou são exemplo de formato (`+5511999999999`). Os e-mails são `.test`, o CPF do mockup é zerado e o alerta no SVG do keycloak é falso positivo |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Todo push na main do backend faz deploy na AWS. De 01/12 a 12/12: nada de push, merge nem redeploy em nenhum repo |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça o enquadramento |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 11 RISCOS.**
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- Estão OK nos quatro: X1, X3 (LICENSE), X4 (público), X6 (credenciais), X7/X8 (main em dia) e o prazo (3d0h).

O script não vê a URL de API no bundle nem a configuração da infra. Conferi as duas à mão.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: **não** submeter o rodar-keycloak |
| S4 | Demo HTTPS no ar | **RISCO**. No painel: `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` para o CloudFront e liguem a flag do recebedor. A AWS está garantida por escrito até 15/12 |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado na aproximação;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Pôr a demo pública no caminho que o pitch promete.** Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy, sem commit. Mudar `LIGAR_RECEBEDOR_NA_APROXIMACAO` para `"true"` em `ecs.tf:28`, ou declará-la como simulada. Depois, testar ao vivo o "Conectar à API", o `/mobile-web` com o aviso ao recebedor e um OCOREN. **H1 6→7 = +1**, e o vídeo passa a mostrar o produto real.
3. **Voz do app resolvida e `main` do web protegida.** No mobile, religar a voz ao LiveKit ou declarar no README que o app nativo roda em Mock e linkar o `/mobile-web` como demo do motorista (isso também tira o RISCO de link de demo do mobile). No web, ligar a proteção da `main` com o job de CI obrigatório. **H2 7→8 = +1.** A regra determinística de `atraso` × `fila`, com teste, também protege o H1.

## Observações

- O backend respondeu a três alertas em uma hora, com teste e com evidência honesta. O H1 do projeto, porém, depende agora de duas configurações (a variável da Vercel e a flag em `ecs.tf`), não de código novo.
- O `evidence/validacao.md` diz que "a ligação ao recebedor foi estável", e isso vale para o ambiente local. No CloudFront, a ligação está desligada. No pitch, não misturem as duas coisas.
- O smoke do deploy ainda faz um GET que muda estado (incrementa a sequência do OCOREN). Se o júri abrir dois OCOREN seguidos e vir a sequência pular, o time precisa saber explicar.
- A access key fixa não expira. Depois de 15/12, revoguem a chave e apaguem o usuário IAM de deploy.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem a troca para LiveKit + Gemini Live num `/adr`.
- O `PLAN.md` ainda tem o *Demo path* e as fases como template vazio. O roteiro do vídeo deveria sair dali.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
