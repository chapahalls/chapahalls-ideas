# RODAR — Copiloto de voz híbrido (Online Agora + Mesh/DTN Offline)

- **Autor(es):** Jeferson (`@STT4jeferson`)
- **Status:** avaliada
- **Nota do judge:** 3,65 / 5 ([`ideas/scores/rodar.md`](scores/rodar.md))
- **Contexto completo de produto e arquitetura:** [`RODAR-CONTEXT.md`](../RODAR-CONTEXT.md)

> Copiloto de IA por voz para caminhoneiros que une vida profissional (Trabalho), pessoal (Pessoal) e alertas colaborativos na rodovia (Estrada), operando online via Agora e mantendo voz local + rede oportunista (mesh/DTN store-and-forward) quando o sinal de celular cai.

## Problema e público (C3 · 20%)

- **Quem:** caminhoneiros vinculados a transportadoras com central de operações (CCO), utilizando smartphone Android (público principal do MVP); caminhoneiros autônomos e comunidade rodoviária como público secundário.
- **Problema concreto:**
  1. Trechos de rodovia com ausência ou intermitência de cobertura celular, onde alertas críticos de pista (acidentes, bloqueios, riscos) ficam presos no veículo sem sinal.
  2. Comunicação fragmentada entre motorista, central da transportadora, familiares e outros motoristas na mesma via.
  3. Risco e dificuldade de registrar ocorrências ou interagir com telas enquanto dirige, somados ao isolamento em jornadas longas.
- **Benefício:** o motorista fala naturalmente sem tirar as mãos do volante nem escolher canais manualmente; com sinal, conversa com baixa latência e executa ações via Agora; sem sinal, continua registrando alertas por voz que são retransmitidos entre dispositivos próximos (`A → B → C` via store-carry-forward) até que um nó com internet entregue à central, com transparência total de status (`criada != enfileirada != encaminhada != recebida != confirmada`).

## Por que voz (C4 · 15%)

Durante a condução, o motorista não pode ler tela, navegar menus ou digitar. A voz com **Orquestrador de Intenções** elimina a escolha manual entre Trabalho, Pessoal e Estrada: o motorista apenas fala, o copiloto identifica intenção, destinatário e autorização necessária, exige confirmação vocal antes de expor localização ou enviar mensagens pessoais/públicas e informa honestamente o estado de entrega conforme a conectividade disponível.

## A conversa (C1 · 25%)

Um diálogo de exemplo de 4-8 falas, do jeito que vai aparecer na demo:

```
Motorista (Celular A, online via Agora): RODAR, como está minha rota e a previsão de chegada na descarga?
Agente (Agora): Você está na BR-116, previsão de chegada às 18h40. Quer que eu avise a central sobre o trecho ou —
Motorista (interrompe / barge-in): Corta isso — avisa a central que tive um atraso de 20 minutos na balança.
Agente (Agora): Entendido. Confirma envio de aviso de atraso de 20 minutos na balança para a central da transportadora?
Motorista: Confirmo.
Agente (Agora): Aviso enviado e recebido pela central.
[Internet do Celular A é desligada; Bluetooth/Wi-Fi local mantidos]
Motorista (Celular A, offline): RODAR, houve um acidente grave na pista, preciso avisar os outros motoristas.
Agente (Voz local): Modo sem internet ativo. Alerta crítico de acidente registrado e aguardando encaminhamento pela rede local. Quando encontrar outro veículo próximo, farei a retransmissão.
```

- **Interrupção (barge-in):** com internet ativa, o motorista interrompe a resposta do agente via Agora no meio da fala para priorizar um comando urgente; o agente cessa o playback imediatamente e processa o novo turno.
- **Falha e recuperação:**
  - *Perda de sessão/internet:* o `Voice Controller` detecta timeout da sessão Agora, garante dono único de microfone/áudio, avisa a mudança para modo offline sem perder o contexto persistido no SQLite local e continua aceitando comandos de voz essenciais localmente.
  - *Retransmissão oportunista:* o alerta criado offline em `A` é transferido via proximidade (Google Nearby Connections) para `B` (offline), que armazena e encaminha para `C` (online), que entrega ao backend/central com deduplicação por UUID, TTL e controle de saltos (`hopCount`/`maxHops`).
- **Latência alvo:** `< 1,5 s` a `< 2,0 s` no modo online via Agora _(sugestão baseada no benchmark de conversação fluida da rubrica)_.

## Como a Agora entra (C2 · 25%)

- **Produto Agora:** **Agora RTC + Agora Conversational AI** (camada principal de voz conversacional online, VAD/turnos, barge-in e invocação de ferramentas/ações do orquestrador).
- **Fluxo:**
  - *Online:* Microfone → `Voice Controller` → Agora RTC / Conversational AI → Orquestrador de intenções e ações → Contexto compartilhado (SQLite local) → Router de mensagens → Backend / Central / Destinatários → Resposta em voz via Agora.
  - *Transição Offline:* Queda da sessão Agora detectada → Fallback ordenado para pipeline local no Android (`STT local → LLM quantizado ou regras/intent classifier → TTS local`) lendo o mesmo contexto compartilhado em SQLite → Router de mensagens envia pacote estruturado por Mesh/DTN (`A → B → C`) até nó com internet sincronizar com a central.
- **O que a demo mostra da integração:**
  1. Conversa real em voz pelo celular `A` conectado à Agora com **barge-in** ao vivo e execução de ação profissional/pessoal refletida na interface/central.
  2. Corte controlado da internet de `A`, transição limpa da sessão Agora para o modo de voz local sem perda de contexto da viagem e criação por voz de um pacote JSON de alerta (`aguardando encaminhamento`) que salta `A → B → C` até chegar à central web.

## Escopo para ~24h

- **Demo path (o que a banca vê, 2 min):**
  1. **Online via Agora + Barge-in:** Celular `A` conectado conversa com o copiloto via Agora, interrompe a fala do agente (barge-in) e solicita uma ação profissional/pessoal; o agente executa e exibe o resultado.
  2. **Perda de conexão e continuidade local:** Internet do Celular `A` é desligada de forma controlada (mantendo Bluetooth/Wi-Fi para transporte local); `A` informa mudança de modo por voz sem perder fatos-chave da viagem.
  3. **Alerta por voz offline:** Motorista em `A` diz: *"RODAR, houve um acidente na rodovia, preciso avisar os outros motoristas"*; o app gera o pacote estruturado com status `aguardando encaminhamento`.
  4. **Mesh / Store-and-forward (`A → B → C`):** `A` transfere o pacote para `B` (offline) por proximidade; `B` persiste e retransmite para `C`.
  5. **Gateway online e entrega à Central:** `C` (com internet) entrega o alerta ao backend; o painel da central exibe a ocorrência recebida e propaga o ACK quando houver conectividade oportunista.
- **Simulado / mockado:** coordenadas/trecho de rodovia no payload de exemplo; caso 3 aparelhos Android físicos não estejam simultaneamente disponíveis para algum salto, qualquer nó simulado será explicitamente declarado (prioridade P0 é demonstrar com dados reais entre celulares); integrações externas como WhatsApp, telefonia e rádio PX 27 MHz **não** fazem parte do MVP.
- **Preexistente:** modelos abertos candidatos (`whisper.cpp` / Android SpeechRecognizer, `llama.cpp` quantizado, Android TTS), SDKs da Agora e API Google Nearby Connections _(preencher bibliotecas/templates adicionais do time se houver)_.
- **Maior risco técnico:** coordenar no mesmo app Android o domínio de áudio/microfone entre a sessão Agora RTC/Conversational AI e o fallback STT/TTS local, além da estabilidade de descoberta/transferência do Google Nearby Connections em modo offline entre `A → B → C` dentro dos 2 minutos de demo.

## Validação e evolução (C5 · 10%)

- **Como testamos durante o hackathon:** benchmark em aparelho Android real (latência da conversa Agora, tempo de detecção de queda de conexão, consumo de RAM/bateria do pipeline local e tempo de transferência do pacote estruturado `A → B → C` com teste de deduplicação/idempotência). _(sugestão: incluir rodada de testes de voz com participantes de outras equipes para medir taxa de acerto de intenção e barge-in)_.
- **Limitações conhecidas:**
  - Conversar com a IA **não** previne microssono nem substitui descanso (ao relato de sonolência, o sistema orienta parada segura).
  - A rede mesh/oportunista não tem entrega em tempo garantido e **não** substitui canais oficiais de emergência (190/191/193/SAMU).
  - A transição online → offline não mantém a mesma sessão Agora aberta no meio de uma frase; faz retomada ordenada a partir do último turno persistido com aviso breve.
- **Próximos passos:**
  - Integração com rádio PX (27 MHz) via interface de hardware/modem homologada pela Anatel e nós fixos em postos/transportadoras.
  - Criptografia ponta a ponta do payload roteado por terceiros (deixando apenas metadados mínimos para roteamento) e filtros avançados de geofencing/sentido da via.
  - Integrações reais com mensageiros pessoais (mediante permissão) e dados operacionais de rotas/clima/trânsito.
