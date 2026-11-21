# RODAR — Copiloto de voz para caminhoneiros (Trabalho, Pessoal e Estrada)

- **Autor(es):** Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`), Lucas (`@LucasLCO`)
- **Status:** avaliada
- **Nota do judge:** 3,90 / 5 ([`ideas/scores/rodar.md`](scores/rodar.md))
- **Contexto completo de produto e arquitetura:** [`RODAR-CONTEXT.md`](../RODAR-CONTEXT.md)

> Copiloto de IA por voz para caminhoneiros que une vida profissional (**Trabalho/CCO**), vida pessoal (**Pessoal**) e alertas colaborativos na rodovia (**Estrada/Comunidade**) em uma única conversa natural via Agora, sem exigir que o motorista tire as mãos do volante ou escolha canais manualmente.

## Problema e público (C3 · 20%)

- **Quem:** caminhoneiros vinculados a transportadoras com Centro de Controle Operacional (CCO) como público principal do MVP; caminhoneiros autônomos e comunidade rodoviária como público secundário.
- **Problema concreto:**
  1. Comunicação fragmentada e perigosa durante a condução: motoristas precisam interagir com rastreadores/macros para avisar a transportadora, não conseguem alertar facilmente quem vem atrás sobre acidentes/bloqueios e enfrentam isolamento em jornadas longas.
  2. Risco de vazamento de privacidade quando ferramentas corporativas misturam rotina pessoal e fiscalização da empresa.
  3. Instabilidade de conexão na estrada que faz ocorrências importantes se perderem ou ficarem sem confirmação clara de entrega.
- **Benefício:** o motorista apenas fala; o **Orquestrador de Intenções** classifica a fala entre **Trabalho**, **Pessoal** (padrão seguro e isolado da empresa) e **Estrada**, exige confirmação por voz antes de publicar para a Central ou para outros motoristas e garante transparência de estado (`registrada != transmitida != recebida != confirmada`).

## Por que voz (C4 · 15%)

Com as mãos no volante e os olhos na pista, digitar ou navegar em menus visuais é inviável e perigoso. A voz permite entrada única sem troca manual de modo, confirmação auditiva imediata antes de compartilhar informações externas, recepção de alertas da via narrados em tempo real e abertura de canal de voz direto (RTC) com o operador da Central quando o motorista pede ajuda.

## A conversa (C1 · 25%)

Um diálogo de exemplo de 4-8 falas, do jeito que vai aparecer na demo:

```
Motorista (A): RODAR, como está minha previsão de chegada na descarga?
Agente (Agora): Você está na BR-116, previsão de chegada às 18h40. Quer que eu leia os detalhes da carga ou —
Motorista (A, interrompe / barge-in): Espera — acabou de ter um acidente aqui no km 230, sentido norte, faixa da direita bloqueada.
Agente (Agora): Entendi: acidente na BR-116, km 230, sentido norte, faixa da direita bloqueada. Confirma avisar os motoristas do trecho e a central?
Motorista (A): Confirmo.
Agente (Agora): Alerta publicado para a estrada e confirmado pela central.
Motorista (A): Anota também um lembrete pessoal para eu ligar para casa quando parar no posto.
Agente (Agora): Guardado nos seus registros pessoais. Isso não é compartilhado com a transportadora.
```

- **Interrupção (barge-in):** o motorista corta o agente a qualquer momento no meio da fala (ex.: para reportar um perigo repentino na pista); o agente interrompe o TTS imediatamente e processa o alerta prioritário.
- **Falha e recuperação:**
  - *Informação incompleta ou ruído:* se faltar um dado essencial do alerta (como km ou sentido), o agente pede para repetir apenas o campo faltante em vez de reiniciar o fluxo.
  - *Oscilação de rede / falha de envio:* a ação é persistida localmente com status explícito (`enfileirada / aguardando confirmação`), o motorista é avisado honestamente que ainda não foi entregue e o evento é sincronizado sem duplicação assim que a conexão retorna.
- **Latência alvo:** resposta `< 1,5 s` a `< 2,0 s` via Agora.

## Como a Agora entra (C2 · 25%)

- **Produto Agora:** **Agora Conversational AI Engine + Agora RTC** (conversação por voz com baixa latência, barge-in, invocação do orquestrador de ferramentas e canal de voz direto Operador CCO ↔ Motorista), combinados com **Agora Signaling / Chat** (ou entrega em tempo real dos eventos estruturados para outros motoristas e painel da Central) e **Agora AI Noise Suppression** (ruído de cabine).
- **Fluxo:** Microfone do motorista → Agora RTC / Conversational AI (STT → LLM + Orquestrador de Intenções → TTS) → Persistência de contexto e fila idempotente → Roteador de destinos:
  1. **Pessoal:** armazenado com isolamento de privacidade (padrão sem vazamento para o CCO).
  2. **Trabalho (CCO):** ocorrência/atraso/resumo do trecho enviado ao painel da Central + canal de voz Agora RTC caso o operador ou motorista acione contato direto.
  3. **Estrada (Comunidade):** alerta geolocalizado por rodovia/sentido transmitido em tempo real para motoristas próximos (narrado por voz no cliente B) e exibido no mapa do CCO.
- **O que a demo mostra da integração:**
  1. Conversa por voz fluida na Agora com **barge-in** ao vivo.
  2. Extração de alerta de acidente com confirmação por voz e **chegada em tempo real por voz no Motorista B** + atualização instantânea no **painel da Central (CCO)**.
  3. Isolamento comprovado de uma nota **Pessoal** vs. ocorrência de **Trabalho**, mais um cenário de **recuperação de falha** (dado faltante ou reconexão de fila) e entrada de voz do operador CCO via Agora RTC.

## Escopo para ~24h

- **Demo path (o que a banca vê, 2 min):**
  1. **Conversa Agora + Barge-in + Alerta Estrada:** Motorista A conversa com o copiloto via Agora, interrompe a resposta (barge-in) para relatar um acidente no km 230 e confirma por voz o envio.
  2. **Comunidade + CCO em tempo real:** Motorista B (segundo cliente na mesma rodovia/sentido) recebe o alerta narrado por voz; o evento aparece simultaneamente na fila/mapa do painel do CCO.
  3. **Trabalho vs. Pessoal (Privacidade):** Motorista A registra um atraso operacional (visível no CCO com status confirmado) e uma nota pessoal para a família (que permanece estritamente privada no app do motorista).
  4. **Falha, Recuperação e Contato CCO:** Demonstração de recuperação quando um comando falha/oscila (status honesto de fila → entrega confirmada) e abertura de canal de voz Agora RTC entre o operador do CCO e o motorista.
- **Simulado / mockado:** coordenadas GPS, rodovia/sentido e dados cadastrais da viagem/transportadora; dois clientes (notebooks/celulares) representando dois caminhões e o painel web representando o CCO.
- **Preexistente:** SDKs e documentação oficial da Agora (`agora@agora-skills` / MCP).
- **Maior risco técnico:** latência e naturalidade do português no pipeline Agora Conversational AI (`< 2 s` com barge-in confiável) — mitigado testando o canal de voz na Fase 1 com LLM/TTS reserva configurável por variável de ambiente.

## Validação e evolução (C5 · 10%)

- **Como testamos durante o hackathon:** rodada de testes com integrantes de outras equipes (6+ interações) medindo latência de resposta por voz, funcionamento do barge-in, precisão do roteador entre Trabalho/Pessoal/Estrada (**zero vazamento** de falas pessoais para o CCO) e recuperação limpa após falha simulada.
- **Limitações conhecidas:**
  - O MVP do hackathon opera online sobre a rede da Agora (com fila local para oscilações curtas, mas sem operação conversacional totalmente offline).
  - Conversar com a IA **não** previne microssono nem substitui descanso regulamentar (ao relato de sonolência, o copiloto orienta parada segura).
  - Alertas colaborativos **não** substituem canais oficiais de emergência (190/191/193/SAMU).
- **Próximos passos (Pós-Hackathon):**
  - **Modo de voz offline no dispositivo:** STT/TTS local + modelo pequeno quantizado (`llama.cpp` / `whisper.cpp`) para manter comandos essenciais de voz em zonas sem cobertura celular.
  - **Rede oportunista Mesh/DTN (`A → B → C` store-carry-forward):** retransmissão de pacotes compactos de alerta entre veículos próximos (via Nearby Connections / Wi-Fi Direct / BLE ou LoRa) até alcançar um nó com internet.
  - **Integração com rádio PX (27 MHz) e hardware dedicado:** interface homologada pela Anatel / Agora ConvoAI Device Kit na cabine e nós fixos em postos e bases de transportadoras.
