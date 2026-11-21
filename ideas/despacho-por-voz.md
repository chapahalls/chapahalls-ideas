# Despacho por Voz

- **Autor(es):** Jeferson, Henry e Lucas (time Quarteto Chapahalls)
- **Status:** avaliada
- **Nota do judge:** 3,50 / 5 ([relatório](scores/despacho-por-voz.md))

> O motorista relata uma ocorrência por voz uma vez; o agente confirma, registra na operação, o CCO decide com um clique e a resposta volta por voz para o motorista — sem ligação, sem espera na linha, sem redigitar.

Origem: retorno da mentoria (Terron / newhack, 21/11) — "escolham uma tarefa operacional repetitiva e demonstrem com segurança" — e o modelo da HappyRobot (agente de voz que termina a tarefa dentro do sistema). É um recorte da ideia [`parceiro-de-estrada`](parceiro-de-estrada/README.md), focado só no fluxo motorista ↔ despacho.

## Problema e público (C3 · 20%)

- **Quem:** motorista de transportadora com CCO (usuário), operador/despachante do CCO (usuário do painel), gestor de operação (comprador) e TI (integração).
- **Problema concreto:** quando há impedimento (cliente não descarrega, falta agendamento, espera sem previsão), o motorista liga para o CCO, espera atender, repete viagem/cliente/problema, ouve "vou ver e te retorno" e fica parado esperando orientação; o operador redigita tudo no sistema. Hoje o motorista também usa macros digitadas no teclado do rastreador ([TOTVS/Open Tech](https://tdn.totvs.com/download/attachments/61210667/TMS_BT_Integracao%20com%20Rastreadores_Open%20Tech_TGLV65.pdf?api=v2)).
  - Referência de mercado: nos EUA, agentes de voz já tiram 70–75% das ligações de rotina sem toque humano (U.S. Xpress) e liberam ~80 h/semana de conversa ([HappyRobot](https://www.happyrobot.ai/customer-story/u-s-xpress)); proporção típica de 28 motoristas por despachante ([MIT CTL 2021](https://dspace.mit.edu/bitstream/handle/1721.1/130951/Procter_Sousa_Jr_project_Goldilocks_and_the_Three_Dispatchers.pdf)).
  - **Falta medir no Brasil:** tempo do relato até a orientação e interações por ocorrência. Números de "% do dia do despachante ao telefone" circulam sem estudo por trás ([levantamento 2026](https://ainora.lt/blog/transport-logistics-dispatch-call-statistics-2026)) — não usar.
- **Benefício:**
  - Motorista: sai do impasse mais rápido (menos tempo parado esperando orientação), uma conversa em vez de várias ligações.
  - Empresa: operador decide com um clique a partir de um registro estruturado, sem redigitar; ocorrência e espera viram dado por cliente.

## Por que voz (C4 · 15%)

O WhatsApp entrega áudio; o agente entende o áudio. A voz aqui não é "falar em vez de digitar" (o WhatsApp no Android Auto já faz isso): é um agente que **pergunta o dado que faltou**, **transforma a fala em evento estruturado** na operação, **só confirma depois que a API aceita** e **traz a decisão do despacho de volta** por voz. O motorista é o único ator que não pode parar para preencher formulário (mesmo parado no cliente, está fora da cabine, com nota fiscal na mão).

## A conversa (C1 · 25%)

```
Motorista: Cheguei no cliente, mas não descarregam hoje, falta agendamento.
Agente:    Viagem 4471, parada 2, Cliente X. Status: impedimento de entrega, falta de agendamento. Confirma?
Motorista: Confirma.
[backend verifica permissão → API sandbox responde OK, operação #A93]
Agente:    Registrado na operação A93. Peço orientação ao despacho?
Motorista: Pede.
[operador no painel clica "Ir para parada 3"]
Agente:    Despacho mandou seguir pra parada 3, Cliente Y. Confirma que recebeu?
Motorista: Recebi.
```

- **Interrupção (barge-in):** o motorista corta a confirmação ("não, é a 4475") e o agente para, troca a viagem e repete só o que mudou.
- **Falha e recuperação:**
  - Duas viagens parecidas → "Viagem 4471 ou 4475?"
  - Sem rede → registro fica "pendente"; ao voltar, reenvia com o mesmo identificador de operação (sem duplicar) e avisa o status.
  - Pedido sem permissão ("muda o destino", "encerra a ocorrência") → "Isso só o despacho autoriza. Peço pra eles?" (permissão fora do modelo).
  - Informação inexistente → "Não tenho essa informação. Pergunto ao despacho?"
  - O agente só diz "registrado" depois que a API devolve o identificador da operação.
- **Latência alvo:** _(sugestão)_ resposta < 1,5 s.

## Como a Agora entra (C2 · 25%)

- **Produto Agora:** _(sugestão)_ Conversational AI Engine (agente de voz com interrupção), RTC (canal de voz do motorista), Signaling (decisão do despacho chegando em tempo real), AI Noise Suppression (ruído do pátio).
- **Fluxo:** _(sugestão)_ microfone → Agora Conversational AI (STT → LLM com ferramentas → TTS) → backend (autorização + API de operação sandbox) → painel do CCO → clique do operador → Signaling → agente avisa por voz.
- **O que a demo mostra da integração:** _(sugestão)_ a conversa com interrupção; o evento aparecendo no painel só depois da confirmação da API; o clique do operador voltando por voz em tempo real.

## Escopo para ~24h

- **Demo path (2 min):**
  1. Motorista (parado no cliente) relata impedimento; agente confirma viagem e status.
  2. API sandbox devolve o identificador da operação; agente confirma.
  3. Operador vê o evento estruturado no painel e clica a orientação.
  4. Agente avisa o motorista por voz; motorista confirma recebimento.
  5. _(sugestão)_ Um teste de falha ao vivo: rede cai e o registro fica pendente, ou "muda o destino" é recusado.
  6. _(sugestão)_ Cronômetro na tela comparando com o processo atual medido nas entrevistas.
- **Simulado / mockado:** viagem fictícia com três paradas; API de operação em sandbox identificada como simulação (não é o TMS de nenhuma transportadora); operador do CCO feito pelo time; GPS e identificação do motorista simulados. Cenário **estacionário** (motorista parado), conforme a mentoria — não demonstrar com veículo em movimento (CTB art. 252).
- **Preexistente:**
- **Maior risco técnico:** português e latência no Conversational AI Engine; chamada de ferramenta (API) confiável a partir do agente.

## Validação e evolução (C5 · 10%)

- **Como testamos durante o hackathon:** _(sugestão)_ entrevistar separadamente 3 motoristas e 1 despachante sobre a última ocorrência (informações que faltaram, quantas interações, onde ficou o registro, quanto tempo até a orientação); em simulação estacionária, comparar o fluxo por voz com mensagem/formulário medindo identificação de viagem, status, correções e duração; verificar se o "despachante" consegue agir sem redigitar.
- **Limitações conhecidas:** integração real com TMS/telemática (Samsara, Motive, TOTVS) não existe — é sandbox; não gera rota, previsão de chegada nem orientação de jornada; não infere fadiga pela voz; voz não elimina distração (por isso o cenário é estacionário).
- **Próximos passos:** _(sugestão)_ integração com um TMS brasileiro; canal pelo telefone/número que o motorista já usa (modelo HappyRobot: sem app novo); métricas de "% de ocorrências resolvidas sem ligação humana" e "horas de conversa liberadas no CCO"; registro de espera para estadia (vem do mesmo evento).
