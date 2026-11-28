# Judge: RODAR (projeto), 2026-11-27 23:56

Gatilho: push na main de rodar-backend eec39ea por HenryFacens. Repositórios avaliados: rodar-backend eec39ea, rodar-web 05d559e, rodar-mobile 9d7cc33, rodar-keycloak de1817a.

**Nota estimada: 23 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 painel sem API real) · Prazo: faltam 3d0h para 30/11 23h59

**Comparação com o relatório anterior** ([judge-20261127-2336](judge-20261127-2336.md), 23/40): a nota do projeto não muda, mas um dos três bloqueios de H1 fechou no ar. Só o backend mudou (c9c040c → eec39ea), e o commit mexe apenas em documentação (`README.md`, 1 linha, e `evidence/validacao.md`, +108 linhas).
- **Primeira validação publicada contra o ambiente público** (`https://d3fy4m7zwukr3x.cloudfront.net`, sobre `c9c040c`, com LLM e LiveKit reais, 4 rodadas): 31 ou 32/34 em todas. A 3d (atraso na estrada) passou 4/4 depois da regra determinística. A 4c falhou em 3/4, a 5e2 em 4/4 e a 5e em 2/4, com a causa diagnosticada no banco.
- O `repos/rodar-backend/score.md` foi refeito às 23h55 sobre `eec39ea`: **17/20** (H1 8, H2 9). Aceito o número.
- O `repos/rodar-web/score.md` é de `bac015f`, um commit antes do HEAD. Conferi de novo o diff de `05d559e`: são 3 arquivos de UI (tour, aviso de push e `/mobile-web`, +25/−9), sem efeito na nota. Aceito os 15/20. O score do mobile (15h28) é do mesmo commit do HEAD. O keycloak não tem score.md e não mudou.

**Conferido às 23h56 (-03):**
- `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, **`sha: "c9c040c"`**, **`ligar_recebedor_na_aproximacao: true`**, `twilio_configurado: false`, `recebedor_modo: rtc`. **Fecha o alerta da rodada passada:** a demo pública liga mesmo para o recebedor na aproximação. O `sha` não é `eec39ea`, e isso é esperado, porque o commit só mexe em docs.
- `https://rodar-web-beta.vercel.app/home`, `/dashboard` e `/mobile-web` respondem 200. O bundle continua `index-B9aLfjQ1.js`, e o chunk `operations-Bi56NYIX.js` só conhece `rodar-backend-five.vercel.app`. Esse host responde `ok: false`, `banco_ok: false` e `ligar_recebedor_na_aproximacao: false`. **O painel publicado continua sem falar com a API real.**

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link (no backend, a linha 44 ainda é o comentário-lembrete). Sem o vídeo, o projeto é desclassificado. Faltam 3 dias.
- **RISCO S4/H1: o painel publicado chama a API sem banco.** É o mesmo bundle das 23h06. Agora a API certa está provada no ar, então o que falta é só trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy, sem commit. Isso também corrige o que o júri veria no `/mobile-web` e no botão "Conectar à API". Corrijam depois a linha 239 do README do web.
- **RISCO H1: duas etapas da voz quebram na maioria das execuções no próprio ambiente público.**
  - Na 4c, a resposta do recebedor não vira doca e previsão estruturadas: os campos saem `None` ou com o prefixo `"doca 4"`.
  - Na 5e2, o aprofundamento da fila não vira ocorrência detalhada.

  O júri vê o resultado no painel: uma Task sem doca ou uma ocorrência com "não sei". Normalizar `"doca 4"` → `"4"` no domínio é trivial. Façam isso, com teste, antes de gravar o vídeo.
- **H1: a voz do app nativo não conecta ao backend** (o app espera Agora, e o backend devolve LiveKit). A voz real só passa pelo `/mobile-web`. Sem mudança.
- **H2, leitura do júri: código e README citam o júri simulado.** São eles:
  - `README.md:93` ("alerta do júri, score.md 2026-11-27");
  - `backend/app/main.py:90` e `:95`, `ocorrencias.py:128`, `rotas.py:28` e `settings.py:86`;
  - `evidence/validacao.md`, que fala em "risco do júri de hoje".

  Um jurado real vai ler isso como código escrito para a banca. Troquem pela razão de domínio antes de 30/11.
- **A ligação telefônica real está desligada** (`twilio_configurado: false`). No vídeo, não chamem de "ligação" uma chamada no navegador.
- **A `main` do web não tem proteção de branch.** Sem mudança.
- **Os READMEs dão contagens de testes diferentes.** A linha 40 do backend diz 625 ("389 no backend, 127 no web, 109 no mobile"). O número conferido é **640** (397 + 145 + 98).
- **Texto antigo que o júri vê:**
  - a linha 36 do README do backend diz que o app "não tem demo web própria" e esconde o `/mobile-web`;
  - "GPT-Live" e "agent-server" aparecem na tela do app (`rodar-mobile/src/assets/locales/pt-BR.json`, linhas 229, 263, 474 e 475).
- **STATUS desatualizado:** o do backend está sobre `7fe3475`, 15 commits atrás (diz que a infra está numa "branch sem PR" e que não há validação publicada). O do mobile está sobre `28e1569` (dá o Whisper local como entregue). Rodem `/registrar rodar-backend` e `/registrar rodar-mobile`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | eec39ea | 8 | 9 | **17** | `repos/rodar-backend/score.md` (23h55, mesmo commit). 397 testes. O `/health` no ar roda `c9c040c` com a flag ligada, o que confirmei |
| rodar-web | 05d559e | 8 | 7 | **15** | `repos/rodar-web/score.md` (21h52, sobre `bac015f`; o diff de UI foi conferido). *Ressalva do projeto:* enquanto o deploy chamar a API sem banco, o H1 é 7 (14/20) |
| rodar-mobile | 9d7cc33 | 6 | 7 | **13** | `repos/rodar-mobile/score.md` (15h28, mesmo commit). *Ressalva do projeto:* a voz real não conecta ao backend atual, então o H1 é 5 (12/20) |
| rodar-keycloak | de1817a | 4 | 6 | **10** | Estimativa do judge projeto, sem score.md e sem mudança. Nenhum repo o usa (o login segue MOCK) |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | Está no limite do 7, mas ainda não chega. **Fechado no ar:** o `/health` público mostra `c9c040c` com `ligar_recebedor_na_aproximacao: true`, e há uma validação de 34 etapas contra o CloudFront em 4 rodadas (31 ou 32/34). **Ainda aberto:** (1) o painel que o júri abre chama `rodar-backend-five.vercel.app`, que está com `banco_ok: false`, então fora do modo Demo nada funciona; (2) a 4c e a 5e2 quebram na maior parte das execuções; (3) a voz do app nativo não conecta. *Precisa de humano:* com o `VITE_API_BASE_URL` no CloudFront e um vídeo da voz real com a estadia fechando, a nota provável é 7 |
| H2 | Implementação técnica | 7 | O backend é referência: 9 no repo, com medição em várias rodadas e causa confirmada no banco, o rigor que um júri de dados e ML valoriza. O que segura o projeto: o mobile é incompatível com o backend (Agora × LiveKit), a `main` do web não tem proteção, `useTrip.ts` tem 1489 linhas, o keycloak está solto e a extração de argumentos das ferramentas não tem validação determinística |
| H3 | Impacto | 7 | Sem mudança. A doca parada cabe em uma frase e tem fonte brasileira: IER 2025 (5h09 de média, 11h40 em CD na Grande SP) e CNTA 2025 (91% não recebem estadia). O benefício está estimado em R$ (R$ 525 por entrega, cerca de R$ 113 mil por mês numa frota de 50) e declarado como estimativa. Não sobe para 8 sem piloto ou usuário real |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo não existe. Com um vídeo que explique a doca do zero, mostre a voz real e feche com o valor em R$, a nota provável é 6-7 |
| | **Total** | **23/40** | Igual ao relatório anterior. Passa dos 20 por 3 pontos, mas **só se o vídeo existir**. Sem ele, o projeto é desclassificado (X7). Com o vídeo e o painel na API real, a nota provável é 27/40 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11 nos repos de produto e em 26/11 no keycloak |
| X2 | Sem código privado anterior | OK, precisa de humano | A origem no UNMUTE by Agora (21 e 22/11) está declarada. Um humano deve confirmar que nada da stack antiga citada em `infra/README.md` entrou |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK, precisa de humano | Públicos e sem fork hoje. Não arquivem antes de 15/12 |
| X5 | Temas proibidos | OK | Nenhum |
| X6 | Sem dado pessoal real | OK | Os telefones seguem o padrão sequencial fictício (`+5519900000002`, `+5511900000001`) ou são exemplo de formato (`+5511999999999`). Os e-mails são `.test`, o CPF do mockup é zerado e o alerta no SVG do keycloak é falso positivo. A validação nova traz só IDs e o CNPJ da NF-e de demo |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5). O painel aponta para a API sem banco (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Todo push na main do backend faz deploy na AWS. De 01/12 a 12/12: nada de push, merge nem redeploy em nenhum repo |
| X9 | Time de 1 a 4, todos na final | precisa de humano | São 4. Confirmar no painel e a presença de todos em 12/12 |
| X10 | Enquadramento | OK | O problema é a doca, a estadia e o fluxo de informação entre motorista, recebedor e CCO. O OCOREN reforça o enquadramento |

Resumo do `sh scripts/check-rules.sh`: **0 FALHAS e 11 RISCOS.**
- Nenhum README tem link do vídeo (4 RISCOS).
- O mobile e o keycloak não têm link de demo (2).
- O README do keycloak não tem seção de dependências nem separa o que é de terceiros (2).
- Os telefones do backend e do web e o SVG do keycloak são fictícios ou falsos positivos (3).
- Estão OK nos quatro: X1, X3 (LICENSE), X4 (público, não fork), X6 (sem `.env` e sem credenciais), X7/X8 (main em dia) e o prazo (3d0h).

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

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado) e pôr o link nos três READMEs e no painel. Isso tira o risco de X7. **H4 3→6 = +3.** Roteiro:
   - a doca em uma frase, com o dado de 11h40 na Grande SP;
   - a voz real pelo `/mobile-web` contra o CloudFront, com o recebedor avisado na aproximação, que agora está provado no ar;
   - o escalonamento push → painel → chamada, com a Task assumida no CCO;
   - a estadia fechando em R$ e o OCOREN gerado em um clique.

   Antes de gravar, troquem "GPT-Live" e "agent-server" nos locales do mobile.
2. **Ligar o painel publicado à API real e consertar a 4c.** Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy, sem commit. Testar ao vivo o "Conectar à API", o `/mobile-web` e um OCOREN. No backend, normalizar doca e previsão em `registrar_resposta_recebedor` (`"doca 4"` → `"4"`, `None` → nova pergunta), com teste, e rodar de novo a validação contra o CloudFront. **H1 6→7 = +1**, e o vídeo passa a mostrar o produto real sem uma Task vazia.
3. **Voz do app resolvida, `main` do web protegida e menções ao "júri" fora do código.** No mobile, religar a voz ao LiveKit, ou declarar no README que o app nativo roda em Mock e linkar o `/mobile-web` como demo do motorista (isso também tira o RISCO de link de demo do mobile). No web, ligar a proteção da `main` com o job de CI obrigatório. No backend, trocar os comentários "risco do júri" pela razão de domínio. **H2 7→8 = +1.**

## Observações

- O backend fechou, em 25 minutos, o alerta de H1 da rodada passada (a flag no ar) e trouxe a primeira medição real no ambiente público. O que falta agora é a Vercel e duas extrações do LLM, não arquitetura.
- A `evidence/validacao.md` diz que o LLM e o LiveKit são de uma conta corporativa. Não é regra do hackathon, mas confirmem que essa conta segue paga e ativa até 15/12 e que o uso está autorizado. Se a conta cair, a demo de voz cai junto.
- O smoke do deploy ainda faz um GET que muda estado (incrementa a sequência do OCOREN). Se o júri abrir dois OCOREN seguidos e vir a sequência pular, o time precisa saber explicar.
- A access key fixa não expira. Depois de 15/12, revoguem a chave e apaguem o usuário IAM de deploy.
- O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Registrem a troca para LiveKit num `/adr`.
- O `PLAN.md` ainda tem o *Demo path* e as fases como template vazio. O roteiro do vídeo deveria sair dali.
- No pitch, cabe dizer "geramos OCOREN no padrão de mercado". Não cabe dizer "integramos com TOTVS ou Intelipost".
- De 01/12 a 12/12, nenhum commit nem redeploy: só slides, roteiro, ensaio e manter a demo (Vercel e AWS) no ar.
