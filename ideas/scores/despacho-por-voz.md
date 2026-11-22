# Judge: Despacho por Voz, 2026-11-21 18:00

**Nota estimada: 3,50 / 5** · Eliminatórios: 0 FALHAS · 3 RISCOS (E2 médio, E5, E1 leve) · resto N/A ainda
**Tempo restante até o prazo (22/11/2026 12:00 BRT):** ~18h

> **E2: RISCO médio, não alto.** A Agora não é enfeite: o produto *é* uma conversa por voz em tempo real, e o Conversational AI Engine ficaria no caminho principal. O risco é outro: **toda a seção "Como a Agora entra" está marcada _(sugestão)_**, então o time ainda não se comprometeu com stack nem com mecanismo. Além disso, o passo mais forte da demo (a decisão do CCO voltando por voz) depende de um mecanismo que a ideia não descreve.

> **Calibração:** esta nota **não é comparável** com o 4,75 de `parceiro-de-estrada` / `rodar`. Aquele relatório deu 5 em C1, C2 e C4 para uma ideia sem código, o que esta rubrica não permite ("nota acima de 4 exige que o texto prove"). Recalibrada com a mesma régua, a ideia-mãe muito provavelmente fica abaixo deste recorte em C1/C2 (escopo de 3 frentes em 18h). Antes de usar o Ranking para decidir, peça um `/judge` novo das duas.

## Alertas

- **E2 RISCO médio:** Produto Agora, Fluxo e "O que a demo mostra" estão todos em _(sugestão)_. Enquanto o time não aceitar, a integração com a Agora é intenção, e intenção não pontua.
- **E2/C2 RISCO técnico não listado:** a ideia não diz **como** a decisão do operador chega como fala numa sessão do agente já aberta. Também não diz **onde** roda a chamada de ferramenta ("só confirma depois que a API aceita"). As duas coisas exigem backend próprio acessível pela nuvem da Agora (LLM customizado com tool calling e fala proativa do agente). Isso precisa ser confirmado nas docs via MCP `agora` antes de construir.
- **E5 RISCO:** o campo **Preexistente** está vazio. No mínimo entram: o hackathon kit (o README diz "feito a partir do hackathon kit"), SDKs/serviços Agora, os provedores de LLM/STT/TTS e qualquer prompt, código ou pesquisa trazido de antes de 21/11.
- **E1 RISCO leve:** o time se chama "Quarteto Chapahalls", mas a ideia lista 3 autores. Com 3 pessoas, o time está no mínimo: se alguém não estiver inscrito, aprovado ou presente nos dois dias, o time é desclassificado. Confirme quem está inscrito.

## Pontuação

| # | Critério | Peso | Nota | Justificativa |
|---|---|---|---|---|
| C1 | Voz e interação | 25 | 4 | O diálogo de 8 falas é concreto, o barge-in é específico ("não, é a 4475" → para, troca a viagem, "repete só o que mudou") e há 5 recuperações desenhadas (ambiguidade 4471/4475, pendente idempotente, recusa por permissão, informação inexistente, "só diz registrado depois que a API devolve o identificador"). Não vai a 5 porque a latência é _(sugestão)_, o "português e latência no Conversational AI Engine" está listado como maior risco e nada disso foi provado. |
| C2 | Execução + Agora | 25 | 3 | O fluxo desenhado coloca a Agora no caminho principal (ConvoAI → backend → painel → volta por voz) e a integração não é trivial. Mesmo assim, todos os campos estão _(sugestão)_, e faltam os dois mecanismos que tornam a demo possível (tool calling e fala proativa). O Signaling para a "decisão do despacho" parece supérfluo: a decisão pode ir backend → agente. Produto extra sem função conta como enfeite. |
| C3 | Problema | 20 | 4 | Público em 4 papéis nítidos (motorista, despachante, gestor, TI). Dor concreta com o roteiro "liga, espera, repete, 'vou ver e te retorno'". Há evidência de que o processo atual existe no Brasil (macros TOTVS/Open Tech) e números de mercado (U.S. Xpress 70-75%, MIT 28:1). É um 4 frágil: os números são dos EUA e de fornecedor, e o próprio texto admite "Falta medir no Brasil". O benefício ainda não é mensurável. |
| C4 | Inovação | 15 | 3 | O "Por que voz" é honesto e melhor que a média: admite que áudio no WhatsApp já existe e aposta em perguntar o dado que faltou, estruturar a fala e devolver a decisão. Mas o próprio texto se apresenta como "o modelo da HappyRobot", então não é uma experiência nova. E um bot de WhatsApp que aceita áudio cobre boa parte do valor de forma assíncrona. A voz melhora algo concreto (nota 3), mas ainda não mostra algo que só a voz faz. |
| C5 | Validação | 10 | 3 | As limitações são ótimas e honestas (sandbox, sem rota/ETA, sem fadiga, "voz não elimina distração"). O plano de teste é específico (3 motoristas + 1 despachante, voz vs. formulário, contar correções e duração), mas está _(sugestão)_ e não foi executado. Nota 3 = potencial se o teste com gente de fora acontecer. |
| C6 | Clareza | 5 | 4 | O pitch de uma linha é claro, o demo path de 4 passos cabe em 2 min e a tela dupla motorista/CCO é fácil de seguir. O passo 6 (cronômetro "medido nas entrevistas") depende de entrevistas que ainda não existem. |
| | **Total** | 100 | **3,50** | Σ(nota×peso)/100 = (4×25 + 3×25 + 4×20 + 3×15 + 3×10 + 4×5) / 100 = (100 + 75 + 80 + 45 + 30 + 20) / 100 = 350 / 100 |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| E1 | Equipe 3-5 presentes | RISCO leve | 3 autores num time chamado "Quarteto". Confirmar a lista de inscritos e aprovados e a presença nos dois dias. |
| E2 | Agora funcional e demonstrada | RISCO médio | A Agora está no núcleo do desenho, mas nada foi aceito. O vídeo e a demo precisam mostrar a Agora funcionando: sessão ConvoAI ativa, canal RTC, evento chegando ao painel e a fala voltando. |
| E3 | Entregas no prazo | N/A ainda | Faltam ~18h. |
| E4 | Repo público | N/A ainda | Conferir a visibilidade do repo da org antes de 12:00. |
| E5 | Preexistentes identificados | RISCO | Campo vazio. Ver Alertas. |
| E6 | Licenças/autorizações | N/A ainda | Pode citar HappyRobot, TOTVS, Samsara e Motive, mas sem logos, telas ou assets deles nos slides. "Cliente X/Y" fictício está certo. |
| E7 | Sem credenciais/dados pessoais | N/A ainda | Se as entrevistas acontecerem, anonimizar: sem nome, telefone, placa ou transportadora identificável no repo. |
| E8 | Simulações identificadas | OK (fase ideia) | A lista de simulados é boa: viagem fictícia, API sandbox "não é o TMS de nenhuma transportadora", operador feito pelo time, GPS e ID simulados, cenário estacionário. No README também precisam entrar: as orientações do painel são pré-definidas, a falha de rede/API é provocada de propósito e a linha de base do cronômetro tem uma origem (entrevista ou estimativa). |

## Maior retorno

1. **Aceitar e fechar a seção Agora com mecanismo concreto, provado num spike de 1h hoje:** ConvoAI com LLM customizado no backend (a ferramenta de registro roda lá, com idempotência) e um caminho documentado para o agente falar proativamente a decisão do operador. Corte o Signaling se ele não tiver função real. **C2 3→4 = +0,25**, e o E2 passa de RISCO para OK.
2. **Fazer as entrevistas (3 motoristas + 1 despachante) até amanhã 9h e rodar o comparativo voz vs. formulário com 3 pessoas de outras equipes:** registrar tempo até a orientação, ligações por ocorrência e correções. **C5 3→4 = +0,10**. Se os números brasileiros forem fortes e alimentarem o cronômetro da demo, **C3 4→5 = +0,20**. Total possível: +0,30.
3. **Aceitar os passos 5 e a meta de latência, trocando "sem rede" por "API do TMS fora":** com o agente na nuvem, um motorista sem rede também fica sem agente, então essa falha não dá para demonstrar como está escrita. "API sandbox devolve 503 → pendente → reenvio com o mesmo ID, sem duplicar" dá para demonstrar ao vivo. Mostrar barge-in e essa recuperação nos 2 min, com latência medida < 1,5 s. **C1 4→5 = +0,25**, condicionado ao build.

Extra: para C4, coloque no centro do pitch o que um bot de WhatsApp não faz. A decisão do CCO chega falada, sem o motorista olhar o celular, enquanto ele está com a nota fiscal na mão. **C4 3→4 = +0,15**.

## Observações

- **Incoerência de desenho (afeta C1/C2 na demo):** o caso "Sem rede → pendente → reenvia ao voltar" pressupõe estado no cliente, mas a conversa roda no ConvoAI na nuvem. Se o motorista perde a rede, perde também o agente. Ou a falha vira "API fora", ou a fila local fica para o roadmap (com essa limitação escrita).
- **Ponto forte que a banca vai notar:** escopo estreito, demo de uma tarefa só, cenário estacionário justificado pelo CTB art. 252 e a regra "só diz registrado depois que a API devolve o ID". É o que a mentoria pediu ("tarefa operacional repetitiva, com segurança"), e este recorte é bem mais executável em 18h que a ideia-mãe de 3 frentes.
- **Pergunta provável da banca:** "Qual a diferença para a HappyRobot?" Hoje a ideia não responde. Uma resposta curta e honesta (mercado BR, TMS/rastreador brasileiro, motorista de transportadora média sem integração EDI) protege C4 no Q&A.
- **Ranking:** esta ideia não foi incluída em `ideas/README.md` (quem atualiza é o `/judge`). Se entrar como está, 3,50 fica abaixo do 4,75 da ideia-mãe só por diferença de calibração. Ver a nota no topo.
