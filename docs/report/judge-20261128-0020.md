# Judge: RODAR (projeto), 2026-11-28 00:20

Gatilho: push na main de rodar-backend 8b3f0d4 por HenryFacens. Repositórios avaliados: rodar-backend 8b3f0d4, rodar-web 05d559e, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 painel sem API real) · Prazo: faltam 2d23h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2356](judge-20261127-2356.md), 23/40): a nota não muda. Só o backend mudou (eec39ea → 8b3f0d4, 1 commit, 7 arquivos, +190/−4). O commit ataca o item 2 do *Maior retorno* passado, a parte do backend:
- **4c:** `normalizar_doca` (`"doca 4"` → `"4"`), e a doca e a previsão passam a ser extraídas da transcrição quando o LLM manda `null`.
- **5e2:** quando o LLM responde só em texto e há uma ocorrência aberta com faltantes, a fala do motorista é anexada como detalhe.
- O prompt não mudou. A correção fica na borda das ferramentas, que é a escolha certa.

O `repos/rodar-backend/score.md` foi refeito às 00h17 sobre `8b3f0d4`: **17/20** (H1 8, H2 9), com 413 testes passando e `ruff` limpo. Aceito o número. Os scores do web (`bac015f`, diff de UI já conferido na rodada passada) e do mobile (`9d7cc33`, mesmo commit do HEAD) seguem válidos. O keycloak não mudou.

**Conferido às 00h20 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, **`sha: "eec39ea"`**, `ligar_recebedor_na_aproximacao: true`, `twilio_configurado: false`, `recebedor_modo: rtc`. **A correção ainda não está no ar.** O deploy da CI não tinha terminado.
- `https://rodar-web-beta.vercel.app/home`: o bundle continua `index-B9aLfjQ1.js`, o mesmo das 23h06. **O painel publicado continua chamando a API sem banco** (`rodar-backend-five.vercel.app`).
- Li o diff de `contingencia.py` e de `conversa.py` e confirmo o falso positivo apontado no score do repo. `resposta_livre_ocorrencia` só descarta perguntas e menções a outro tipo de ocorrência. Um "beleza, obrigado" vira o valor do primeiro campo faltante.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum README tem o link. No backend, a linha 44 ainda é o comentário-lembrete. Sem o vídeo, o projeto é desclassificado. Faltam 2d23h.
- **RISCO S4/H1: o painel publicado chama a API sem banco.** É o mesmo bundle há mais de uma hora. Troquem o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e façam o redeploy (sem commit). Depois, corrijam a linha 239 do README do web.
- **RISCO H1: a correção da 4c e da 5e2 só está provada com LLM fake.** A evidência publicada (`evidence/validacao.md`) ainda mostra 4c em 1/4 e 5e2 em 0/4. Quando o `/health` mostrar `8b3f0d4`, rodem de novo `validar_fluxos.py` contra o CloudFront em 4 rodadas e publiquem o resultado.
- **RISCO H1 novo: falso positivo na 5e2.** Com uma ocorrência de fila aberta, um "ok", "beleza, obrigado" ou "tô chegando" sem ferramenta vira `quantos = "beleza, obrigado"` na Task do CCO. Nenhum teste cobre esse caso. Para o jurado que abre a Task no painel, isso é tão ruim quanto o "não sei" de antes.
- **H1: a voz do app nativo não conecta ao backend** (Agora × LiveKit). A voz real só passa pelo `/mobile-web`. Sem mudança.
- **H2, leitura do júri: o código e o README do backend citam o júri simulado.** Estão em `README.md:93`, `main.py:90/95`, `ocorrencias.py:128`, `rotas.py:28`, `settings.py:86` e `evidence/validacao.md`. Sem mudança.
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **A `main` do web não tem proteção de branch.** Sem mudança.
- **Contagem de testes inconsistente:** a linha 40 do README do backend diz 625 (389 + 127 + 109). O número conferido agora é **656** (413 + 145 + 98).
- **Texto antigo que o júri vê:**
  - a linha 36 do README do backend diz que o app "não tem demo web própria" e esconde o `/mobile-web`;
  - "GPT-Live" e "agent-server" aparecem nos locales do mobile (`pt-BR.json`, linhas 229, 263, 474 e 475).
- **STATUS desatualizado:** o do backend ainda está sobre `7fe3475` e o do mobile sobre `28e1569`. Rodem `/registrar rodar-backend` e `/registrar rodar-mobile`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | 8b3f0d4 | 8 | 9 | **17** | `repos/rodar-backend/score.md` (00h17, mesmo commit). 413 testes. O ar ainda roda `eec39ea` |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (sobre `bac015f`, diff de UI conferido). *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, H1 é 7 (14/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (mesmo commit). *Ressalva do projeto:* a voz real não conecta, então H1 é 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto, sem mudança. Nenhum repo o usa (o login segue MOCK) |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Sem mudança. O backend público está no ar com banco e com a chamada ao recebedor ligada, e a validação de 34 etapas contra o CloudFront deu 31 ou 32/34. Ainda falta: (1) o painel que o júri abre chama a API sem banco; (2) a correção da 4c e da 5e2 está no código mas não no ar, nem medida; (3) a voz do app nativo não conecta. *Precisa de humano:* com a Vercel no CloudFront, a nova validação publicada e o vídeo, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend sobe em qualidade: a guarda determinística fica na borda da ferramenta, reaproveita a regra da contingência e tem testes que reproduzem o erro de produção. O que segura o projeto continua igual: o mobile é incompatível com o backend, a `main` do web não tem proteção, `useTrip.ts` tem 1489 linhas, o keycloak está solto e há comentários escritos para a banca |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está estimado em R$ (R$ 525 por entrega, cerca de R$ 113 mil por mês numa frota de 50). Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Passa dos 20 por 3 pontos, **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo e o painel na API real, a nota provável é 27/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Públicos e sem fork. Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones seguem o padrão fictício `9000000xx` ou são exemplo de formato (`+5511999999999`). Os e-mails são `.test`. O alerta no SVG do keycloak é falso positivo. O commit novo não adiciona dados pessoais |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Todo push na main do backend faz deploy na AWS. De 01/12 a 12/12: nada de push, merge nem redeploy |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça o enquadramento |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 11 RISCOS.**
- Nenhum README tem o link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- Estão OK nos quatro: X1, X3, X4, X6 (sem `.env` e sem credenciais), X7/X8 (main em dia) e o prazo.

O script não vê a URL de API no bundle nem o `/health` no ar. Conferi os dois à mão.

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição | precisa de humano |
| S2 | Trilha Logística & automação | OK nos READMEs. Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Recomendação: **não** submeter o rodar-keycloak |
| S4 | Demo HTTPS no ar | **RISCO**. No painel: `https://rodar-web-beta.vercel.app/home` e, como segundo link, `https://d3fy4m7zwukr3x.cloudfront.net/docs`. Antes, apontem o `VITE_API_BASE_URL` para o CloudFront |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado na aproximação;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Gravem depois do item 2, para que a Task mostre a doca preenchida.
2. **Painel na API real e voz medida no ar.**
   - Troquem o `VITE_API_BASE_URL` da Vercel para o CloudFront e façam o redeploy (sem commit).
   - Fechem o falso positivo da 5e2: descartem confirmações curtas ("ok", "beleza", "obrigado", "tô chegando") e só anexem a fala se ela responder ao campo. Façam um teste para cada caso.
   - Na 4c, usem a **última** `doca N` da transcrição.
   - Com o `/health` no commit novo, rodem `validar_fluxos.py` contra o CloudFront em 4 rodadas e publiquem o resultado.
   - **H1 6→7 = +1.**
3. **Voz do app, proteção da `main` do web e menções ao "júri" fora do código.**
   - No mobile, religuem a voz ao LiveKit, ou declarem que o app nativo roda em Mock e linkem o `/mobile-web` como demo do motorista. Isso também tira o RISCO de link de demo.
   - No web, liguem a proteção da `main`.
   - No backend, troquem os comentários sobre o júri pela razão de domínio e corrijam as linhas 36 e 40 do README.
   - **H2 7→8 = +1.**

## Observações

- O commit novo é uma boa história técnica para um júri de dados e ML: "o modelo decide, o sistema garante". Ele separa a extração do LLM de uma guarda determinística testada. Vale citar no pitch junto com a tabela de rodadas, **depois** que a nova rodada no ar confirmar o ganho.
- Este é o primeiro commit no caminho da voz depois da validação publicada. Até a nova medição, não dá para garantir que ele não piorou etapas que passavam 4/4.
- Ordem sugerida: dia 28, item 2; dia 29, item 3 e a gravação do vídeo; dia 30, só o link do vídeo e a conferência do `/health` e do bundle. Uma regressão de última hora na voz custa mais H1 do que qualquer ganho de H2.
- O smoke do deploy ainda faz um GET que incrementa a sequência do OCOREN em produção.
- A `evidence/validacao.md` diz que o LLM e o LiveKit são de uma conta corporativa. Confirmem que ela segue ativa e autorizada até 15/12.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem a troca para LiveKit num `/adr`.
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
