# RODAR — Copiloto de voz para caminhoneiros (Pessoal, Corporativa e Comunidade)

- **Autor(es):** Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`), Lucas (`@LucasLCO`)
- **Status:** avaliada
- **Nota do judge:** 3,90 / 5 ([`ideas/scores/rodar.md`](scores/rodar.md))
- **Contexto completo de produto e arquitetura:** [`RODAR-CONTEXT.md`](../RODAR-CONTEXT.md)

> Copiloto de IA por voz para caminhoneiros que faz companhia na estrada para combater a solidão e diminuir acidentes por sonolência, enquanto orquestra a comunicação em três frentes — **1. Pessoal** (familiares e amigos), **2. Corporativa** (relato real de atrasos e ocorrências ao CCO) e **3. Comunidade** (alertas de acidentes e engarrafamentos na mesma via) — sem que o motorista tire as mãos do volante.

## Problema e público (C3 · 20%)

- **Quem:** caminhoneiros do transporte rodoviário de cargas e os Centros de Controle Operacional (CCO) das transportadoras (público principal do MVP); caminhoneiros autônomos e comunidade da rodovia como público secundário.
- **Problema concreto:**
  1. **Solidão e sonolência ao volante:** caminhoneiros passam muito tempo longe de casa e horas seguidas sozinhos na cabine; o isolamento e a monotonia favorecem a sonolência, uma das maiores causas de acidentes graves nas rodovias.
  2. **Distância de familiares e amigos:** dificuldade de manter contato próximo e seguro com a família e amigos durante a viagem sem manusear o celular dirigindo.
  3. **Comunicação corporativa fria e perigosa com o CCO:** quando há um problema mecânico ou atraso de carga, o motorista hoje depende de macros pré-programadas no rastreador (digitando em movimento) e não consegue descrever com clareza a real situação que está enfrentando.
  4. **Falta de avisos em tempo real na mesma via (Comunidade):** informações urgentes sobre acidentes, engarrafamentos e bloqueios demoram a chegar aos caminhoneiros que estão passando pelo mesmo trecho.
- **Benefício:**
  - **1. Frente Pessoal & Companhia:** o copiloto faz companhia ativa na viagem para manter o motorista alerta (ajudando a diminuir os índices de acidentes por sonolência, sugerindo paradas seguras quando identifica cansaço) e facilita trocar recados de voz com familiares e amigos com privacidade total.
  - **2. Frente Corporativa (CCO):** o motorista descreve por voz a situação real da viagem/carga (atrasos, problemas, retenções), gerando ocorrências contextualizadas para o CCO e abrindo canal de voz direto (Agora RTC) com o operador quando necessário.
  - **3. Frente Comunidade:** alertas de acidentes, engarrafamentos e riscos são reportados e recebidos por voz em tempo real pelos caminhoneiros que trafegam na mesma via e sentido.

## Por que voz (C4 · 15%)

Com as mãos no volante e os olhos na pista, digitar macros no rastreador ou usar aplicativos de mensagem é inviável e perigoso. A voz resolve ao mesmo tempo a **interação mãos-livres** e o **fator humano**: só a conversa falada faz companhia real contra a solidão e a sonolência na cabine, permite explicar com riqueza de contexto um imprevisto ao CCO e entrega avisos imediatos da pista sem desviar o olhar da estrada.

## A conversa (C1 · 25%)

Um diálogo de exemplo de 4-8 falas, do jeito que vai aparecer na demo:

```
Agente (Agora, companhia ativa): Faz 4 horas que estamos rodando na BR-116, Jeferson. Como você está se sentindo? Quer ouvir o recado que sua família mandou ou conversar um pouco?
Motorista (A, interrompe / barge-in): Espera — acabou de ter um acidente feio aqui no km 230, sentido norte, trânsito parou tudo!
Agente (Agora): Entendi: acidente e engarrafamento na BR-116, km 230, sentido norte. Confirma enviar esse alerta para a Comunidade da via e avisar o CCO que sua carga vai atrasar?
Motorista (A): Confirmo, avisa o CCO que devo atrasar uns 45 minutos por causa desse bloqueio.
Agente (Agora): Alerta publicado para os caminhoneiros do trecho e atraso de 45 minutos detalhado para o CCO.
Motorista (A): Aproveita e manda um recado pessoal para minha esposa dizendo que estou bem, só parado no trânsito, e que ligo quando parar no posto.
Agente (Agora): Recado pessoal enviado para sua esposa. Essa mensagem é privada e não vai para a transportadora.
```

- **Interrupção (barge-in):** o motorista corta o agente a qualquer momento no meio da fala (ex.: durante uma conversa de companhia quando surge um acidente ou engarrafamento à frente); o agente interrompe o áudio imediatamente e prioriza a ocorrência.
- **Falha e recuperação:**
  - *Informação incompleta ou ruído:* se faltar um dado essencial do alerta ou do reporte ao CCO (como km, sentido ou motivo do atraso), o agente pergunta apenas o dado que faltou.
  - *Oscilação de rede / falha de envio:* a ocorrência fica registrada na fila local com status explícito (`enfileirada / aguardando confirmação`), avisando o motorista honestamente e sincronizando assim que a conexão estabiliza; em caso de silêncio/sonolência crítica ou pedido de ajuda, abre canal de voz direto (Agora RTC) com o operador do CCO.
- **Latência alvo:** resposta `< 1,5 s` a `< 2,0 s` via Agora.

## Como a Agora entra (C2 · 25%)

- **Produto Agora:** **Agora Conversational AI Engine + Agora RTC** (conversação fluida para companhia ativa, barge-in, orquestração das 3 frentes e canal de voz direto Operador CCO ↔ Motorista), combinados com **Agora Signaling / Chat** (distribuição em tempo real dos alertas da Comunidade na mesma via, recados da frente Pessoal e eventos detalhados para o painel do CCO) e **Agora AI Noise Suppression** (supressão de ruído da cabine do caminhão).
- **Fluxo:** Microfone do motorista → Agora RTC / Conversational AI (STT → LLM + Orquestrador de Intenções → TTS) → Roteador das 3 Frentes:
  1. **1. Pessoal & Companhia:** conversa ativa contra solidão/sonolência + envio/leitura de recados para familiares e amigos (isolado do CCO por padrão).
  2. **2. Corporativa (CCO):** descrição rica da situação real da viagem (atraso de carga, problema mecânico, resumo do trecho) entregue ao painel do CCO + canal de voz Agora RTC entre operador e motorista.
  3. **3. Comunidade:** avisos de acidentes, engarrafamentos e riscos na pista transmitidos em tempo real por voz para caminhoneiros na mesma rodovia/sentido.
- **O que a demo mostra da integração:**
  1. Conversa por voz fluida na Agora fazendo companhia ao motorista, seguida de **barge-in** ao vivo para reportar um acidente/engarrafamento.
  2. Roteamento inteligente: alerta chegando por voz em tempo real para o **Motorista B (Comunidade)** e relato contextualizado de atraso chegando ao **painel do CCO (Corporativa)**.
  3. Envio de recado para a família na frente **Pessoal** (com isolamento comprovado em relação ao CCO), além de atuação preventiva em situação de cansaço/ajuda abrindo voz direta (Agora RTC) com o operador do CCO.

## Escopo para ~24h

- **Demo path (o que a banca vê, 2 min):**
  1. **Companhia + Barge-in + Alerta Comunidade:** O copiloto conversa com o Motorista A via Agora (combate à solidão/sonolência); A interrompe o agente (barge-in) para avisar sobre um acidente e engarrafamento no km 230 e confirma o envio.
  2. **Comunidade + Corporativa (CCO) em tempo real:** Motorista B (na mesma via) recebe o alerta por voz; simultaneamente, o Motorista A descreve a situação real do atraso da carga e o operador vê o relato detalhado no painel do CCO.
  3. **Pessoal (Família e Amigos com Privacidade):** Motorista A envia por voz um recado para a família; a demo comprova que o conteúdo pessoal não aparece no painel do CCO.
  4. **Prevenção de Sonolência / Recuperação e Voz Direta com CCO:** Diante de sinais de sonolência/falta de resposta ou pedido de apoio, o copiloto sugere parada segura e abre um canal de voz Agora RTC direto entre o operador do CCO e o motorista.
- **Simulado / mockado:** coordenadas GPS, rodovia/sentido e cadastro da viagem; dois clientes representando dois caminhões na mesma via e o painel web representando o CCO.
- **Preexistente:** SDKs e documentação oficial da Agora (`agora@agora-skills` / MCP).
- **Maior risco técnico:** latência e naturalidade do português no pipeline Agora Conversational AI (`< 2 s` com barge-in confiável) — mitigado testando o canal de voz na Fase 1 com LLM/TTS reserva configurável por variável de ambiente.

## Validação e evolução (C5 · 10%)

- **Como testamos durante o hackathon:** rodada de testes com integrantes de outras equipes (6+ interações) medindo latência de resposta por voz, funcionamento do barge-in, precisão do roteador entre **1. Pessoal**, **2. Corporativa (CCO)** e **3. Comunidade** (**zero vazamento** de conversas pessoais para o CCO) e detecção de lentidão/cansaço na conversa.
- **Limitações conhecidas:**
  - O MVP do hackathon opera online sobre a rede da Agora (com fila local para oscilações curtas, mas sem operação conversacional totalmente offline).
  - O acompanhamento conversacional contra solidão e sonolência atua como camada preventiva de engajamento e recomendação de parada segura, não substituindo o descanso regulamentar obrigatório.
  - Alertas da Comunidade não substituem canais oficiais de emergência (190/191/193/SAMU).
- **Próximos passos (Pós-Hackathon):**
  - **Modo de voz offline no dispositivo:** STT/TTS local + modelo pequeno quantizado (`llama.cpp` / `whisper.cpp`) para manter o copiloto ativo em zonas sem cobertura celular.
  - **Rede oportunista Mesh/DTN (`A → B → C` store-carry-forward):** retransmissão de alertas da Comunidade e do CCO entre caminhões próximos (via Nearby Connections / Wi-Fi Direct / BLE ou LoRa) até alcançar um veículo com internet.
  - **Integração com rádio PX (27 MHz) e hardware dedicado:** interface homologada pela Anatel / Agora ConvoAI Device Kit na cabine.
