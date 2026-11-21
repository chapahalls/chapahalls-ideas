# RODAR — Contexto de produto e arquitetura

> Handoff de discussão de produto realizado em 21/11/2026. Documento de referência para Codex/OpenCode e equipe do hackathon UNMUTE by Agora.
> **Status:** concepção e hipóteses de arquitetura. Não representa implementação concluída, comprovação de viabilidade ou decisões definitivas de stack.
> **Fonte de regras:** `HACKATHON.md` no repositório é a fonte de verdade para regulamento, prazos e entregáveis; este documento é subordinado a ele.

## 1. Resumo executivo

**Nome provisório:** RODAR — “Sua voz conecta todos os caminhos” / “Você nunca está sozinho na estrada”.

RODAR é um copiloto de IA por voz para caminhoneiros que atua em **três frentes integradas**:
1. **Pessoal & Companhia:** facilita a comunicação por voz com **familiares e amigos** (já que o motorista passa muito tempo longe de casa) e atua como um **copiloto companheiro de viagem** para combater a solidão na cabine, manter o motorista ativo e engajado e **reduzir os índices de acidentes causados por sonolência** (sugerindo paradas seguras e acionando apoio quando necessário).
2. **Corporativa (CCO):** otimiza a comunicação direta com o **Centro de Controle Operacional (CCO)** da transportadora, permitindo que o caminhoneiro descreva por voz a **real situação que está passando** (se a carga vai atrasar, fila na descarga/balança, problema mecânico ou imprevisto na rota) sem precisar digitar em rastreadores enquanto dirige.
3. **Comunidade:** conecta caminhoneiros que estão passando pela **mesma via**, permitindo reportar e receber em tempo real avisos e alertas por voz sobre **acidentes, engarrafamentos, bloqueios e riscos na pista**.

O motorista conversa em linguagem natural e o copiloto identifica intenções, executa ações e escolhe o canal de comunicação adequado sem exigir troca manual de modo.

**Decisão de escopo para o Hackathon (24h):** Para garantir um protótipo funcional, fluido e 100% aderente aos critérios C1 e C2 (50% da nota), o **MVP do hackathon foca na experiência online centrada na Agora** (Conversational AI + RTC/Signaling/Chat, barge-in, orquestração de intenções nas 3 frentes — **Pessoal**, **Corporativa/CCO** e **Comunidade** —, companhia ativa contra solidão/sonolência e painel do CCO). A **operação com voz local offline (STT/LLM/TTS embarcado)** e a **rede oportunista de dispositivos (mesh/DTN, store-and-forward)** — bem como a integração com rádio PX 27 MHz — ficam documentadas como **visão de evolução e diferencial de roadmap pós-hackathon (Fase 2)**.

## 2. Problemas a resolver

1. **Solidão e sonolência ao volante:** o caminhoneiro passa dias longe de casa e horas seguidas sozinho na cabine; a monotonia e o isolamento contribuem diretamente para a fadiga e para altos índices de acidentes causados por sonolência.
2. **Distância de familiares e amigos:** dificuldade de manter contato frequente e seguro com a família e amigos durante longas jornadas sem usar o celular nas mãos.
3. **Comunicação corporativa engessada e perigosa com o CCO:** dificuldade de explicar ao CCO a real situação da viagem (motivo real de um atraso de carga, problema mecânico ou retenção), hoje limitada a macros frias digitadas no rastreador com o caminhão em movimento.
4. **Falta de alertas em tempo real na mesma via (Comunidade):** avisos sobre acidentes, engarrafamentos, interdições e perigos na pista demoram a chegar aos outros caminhoneiros que vêm logo atrás no mesmo trecho.
5. **Trechos com cobertura intermitente:** necessidade de fila/recuperação de mensagens (no MVP) e evolução futura para operação offline e rede mesh/DTN.

**Segurança e responsabilidade:** o copiloto atua como companhia ativa para combater a solidão e monitora sinais de cansaço/lentidão na conversa para recomendar paradas seguras e acionar o CCO em caso de falta de resposta ou pedido de ajuda (atuando como camada preventiva de apoio, sem substituir o descanso obrigatório). Evitar distração visual e mensagens longas durante a condução.

## 3. Público e as 3 Frentes de Atuação

**Público principal (hipótese para MVP):** caminhoneiro vinculado a uma transportadora com Centro de Controle Operacional (CCO), usando smartphone Android. **Secundário:** caminhoneiros autônomos e comunidade rodoviária.

### 3.1 Frente 1 — Pessoal & Companhia (Família, Amigos e Combate à Solidão/Sonolência)
- **Companhia ativa na estrada:** o copiloto conversa naturalmente com o motorista ao longo da viagem para quebrar a solidão e a monotonia da cabine, mantendo-o desperto e alerta para **diminuir os índices de acidentes causados por sonolência**.
- **Prevenção de sonolência e sugestão de parada:** ao notar respostas mais lentas, silêncio prolongado ou relato de cansaço, o copiloto puxa conversa ativa, recomenda o próximo ponto de parada segura e, se o motorista não responder ou pedir socorro, escala para contato de voz com o CCO.
- **Comunicação com familiares e amigos:** facilita enviar e ouvir recados e mensagens de voz para a família e amigos sem tirar as mãos do volante, aproximando quem está longe de casa.
- **Privacidade garantida:** tudo o que pertence à esfera Pessoal (conversas, desabafos, mensagens para família/amigos) é estritamente isolado da transportadora por padrão.

### 3.2 Frente 2 — Corporativa (Comunicação rica e contextual com o CCO)
- **Relato real da situação ao CCO:** o caminhoneiro explica por voz o que realmente está acontecendo (ex.: *"vou atrasar a entrega em 40 minutos porque a pista parou após a balança"* ou *"tive um problema no freio e precisei encostar no posto"*), substituindo macros limitadas por um evento estruturado e claro para o operador do CCO.
- **Acompanhamento de viagem e RDO por voz:** consultar dados da carga/rota, registrar ocorrências com status transparente (`criada`, `enfileirada`, `encaminhada`, `recebida`, `confirmada`) e consolidar o relato do trecho nas paradas.
- **Canal de voz direto (Agora RTC) com o CCO:** quando há problema crítico, risco ou necessidade de alinhamento imediato, o operador do CCO e o motorista conversam por voz no mesmo canal.

### 3.3 Frente 3 — Comunidade (Alertas colaborativos na mesma via)
- **Avisos de pista por voz:** reportar instantaneamente acidentes, engarrafamentos, obras, bloqueios, perigos na via e pedidos de ajuda.
- **Distribuição para quem está na mesma rodovia:** entregar o alerta por voz para os caminhoneiros que trafegam na mesma via e sentido (com confirmação vocal antes da publicação para evitar disparos acidentais).
- **Visibilidade para o CCO:** refletir os alertas da via no mapa operacional para apoiar decisões de rota e segurança.

## 4. Como deve ser a interação por voz

1. O motorista só precisa falar; não escolhe manualmente entre Trabalho/Pessoal/Estrada.
2. **Orquestrador de intenções** detecta solicitação, destinatário, contexto e autorização necessária.
3. **Gerenciador de conectividade** escolhe internet, comunicação de proximidade ou fila local.
4. O estado de uma ação deve ser honesto: registrada != transmitida != recebida != confirmada.
5. Com internet, usar **Agora** para demonstrar conversa fluida, baixa latência, interrupção/barge-in e ações reais.
6. Sem internet, a aplicação deve continuar aceitando ao menos comandos essenciais por voz e, idealmente, conversa reduzida por LLM local.
7. Preservar identidade e contexto do copiloto entre modalidades. Não prometer continuidade da mesma sessão Agora, nem troca perfeitamente invisível no meio de fala.
8. Confirmações antes de enviar mensagens pessoais ou divulgar localização/dados sensíveis; ações urgentes de segurança exigem política clara.

## 5. Arquitetura conceitual

```text
Motorista (voz)
    |
Voice Controller (captura, playback, wake/VAD, turnos, falhas)
    |
Orquestrador de intenções e ações
    |-----------------------------|
    |                             |
 ONLINE (Agora RTC/              OFFLINE (no Android)
 Conversational AI)              STT local -> LLM ou
 agente e ferramentas            regras -> TTS local
    |                             |
    |------ Contexto compartilhado|
                 |
           SQLite local
       viagens / contatos /
       eventos / mensagens
                 |
      Router de mensagens
       /       |       \
 Internet    Mesh/DTN   Fila local
       \       |       /
       Backend / Central / Destinatários
```

**Importante:** a Agora é a camada online de voz/RTC/agentes; não assumir que seus SDKs executam um LLM conversacional integralmente offline no Android. Validar versões e capacidades na documentação oficial durante a implementação.

### 5.1 Possíveis tecnologias (candidatas, ainda não decididas)
- App: React Native/Expo com módulos nativos Android, ou Android nativo se integrações exigirem; confirmar compatibilidade de SDKs.
- Voz online: Agora RTC + Conversational AI (conforme APIs e SDKs efetivamente disponíveis).
- Voz offline: Android on-device speech recognition ou whisper.cpp; Android TextToSpeech ou TTS local embarcado.
- LLM offline: llama.cpp (modelo pequeno quantizado com suporte a português), ou regras/intent classifier como fallback. Benchmark no hardware real antes de prometer conversação natural offline.
- Persistência: SQLite, fila transacional, outbox, dados de viagem/contexto, retenção e privacidade.
- Mesh de smartphones: Google Nearby Connections (BLE/Bluetooth/Wi-Fi; verificar plataforma e permissões) e protocolo próprio de múltiplos saltos/store-and-forward. Nearby não fornece roteamento mesh multi-hop automaticamente.
- Backend: API + serviços de eventos, central web, cadastro de dispositivos e confirmações.

### 5.2 Operação híbrida
- O aplicativo mantém estado de conversação próprio (resumos recentes, viagem, preferências permitidas, ações pendentes), fora da sessão da Agora.
- Detectar falha de sessão, com timeouts, e fazer transição ordenada entre modos.
- Ter um único dono do microfone/áudio a cada momento; evitar respostas simultâneas.
- Se cair no meio da fala, retomar a partir de turno/contexto persistido; pode haver uma frase de aviso e repetição breve.
- Manter modelo local previamente carregado **se RAM/bateria permitirem**; avaliar custo térmico, bateria e reatividade em Android real.
- Reconectar e reconciliar mensagens sem envio duplicado.

## 6. Evolução Futura (Pós-Hackathon): Voz Offline, Rede Mesh/DTN e Rádio PX

> **Nota de escopo:** Os itens desta seção (voz local offline, rede mesh/oportunista DTN entre smartphones e integração com rádio PX) foram movidos por decisão da equipe para o **roadmap futuro (P2)**, mantendo o MVP de 24h focado em execução sólida sobre a stack da Agora.

**Visão de evolução (Rede mesh/oportunista):** em trechos sem cobertura celular, um alerta crítico originado em A poderá ser transmitido a B, retido por B e encaminhado a C, mesmo sem haver conectividade simultânea ponta a ponta. Quando C recuperar internet, entrega ao backend/central. Se não houver vizinhos, o alerta permanece pendente; não existe garantia de prazo nem entrega.

**Modelo recomendado:** DTN / store-carry-forward com descoberta e transporte de proximidade, mais eventual upload à nuvem.

Regras mínimas:
- Identificador único de mensagem + idempotência/deduplicação.
- Timestamp e validade (TTL), limite de saltos, tipo e prioridade.
- Estado de envio e confirmação fim a fim (ACK de vizinho não equivale a ACK do destino).
- Persistência em armazenamento local, sobrevivendo ao fechamento/reabertura do app.
- Critérios geográficos: rodovia, sentido, distância, validade, se disponíveis. Não presumir geolocalização perfeita.
- Proteção contra spam, replay, floods, localização indevida; autenticação de dispositivos e criptografia conforme ameaça/modelo de confiança.
- Escolha de payloads pequenos: evento estruturado, sem streaming contínuo de áudio.
- Testes em deslocamento e em aparelho real; dois caminhões em alta velocidade podem se comunicar por muito pouco tempo.

**Cuidado de nomenclatura:** Nearby Connections é comunicação peer-to-peer/local; o comportamento mesh multi-hop depende do protocolo implementado. Se o MVP demonstrar somente A→B→C com persistência e encaminhamento, chamá-lo de rede oportunista/multi-hop implementada, sem afirmar conformidade com protocolos DTN formais.

### 6.1 Rádio PX: ideia futura, NÃO no MVP
- Muitos caminhoneiros usam rádio PX analógico na faixa dos 27 MHz.
- Smartphones não transmitem nessa faixa diretamente.
- Integração exigiria interface com rádio, modem, PTT e compatibilidade regulatória/homologação.
- Verificar regras Anatel antes de transmitir dados digitais; não presumir autorização por operar na mesma frequência.
- Possível expansão: adaptador para rádios existentes ou rádio digital homologado; nós fixos em postos/transportadoras.

## 7. Demonstração ideal de ponta a ponta (Vídeo Demo da Solução + Pitch · 2 min)

**Estratégia de Apresentação:** A demonstração do pitch será baseada na gravação do **vídeo demo narrado de até 2 minutos** da solução real funcionando (atendendo ao entregável obrigatório D3 e garantindo execução sem risco de oscilação de rede no palco), cobrindo todos os gatilhos de pontuação máxima de **C1 (25%)** e **C2 (25%)** entre as **3 pontas conectadas pela Agora** (**Motorista A**, **Motorista B** e **Operador do CCO**):

1. **Companhia ativa + Barge-in via Agora (Motorista A):** O copiloto conversa com o Motorista A em português com baixa latência (`< 1,5 s`), puxando assunto para combater a solidão e a sonolência na estrada; A **interrompe a fala do agente no meio (barge-in)** para relatar um acidente e engarrafamento à frente.
2. **Recuperação de falha + Frente 3 — Comunidade (Motorista A → Motorista B):** Se o relato inicial omitir um dado (ex.: sentido da via ou km), o agente cobra apenas o dado faltante (**recuperação de falha conversacional**), confirma por voz e dispara o alerta via Agora; o **Motorista B** (na mesma via) ouve o alerta narrado em tempo real e o evento surge no mapa do CCO.
3. **Frente 2 — Corporativa / CCO + Recuperação de fila (Motorista A → CCO):** A explica por voz a situação real do atraso da carga causado pelo bloqueio; o sistema demonstra o status honesto de entrega (`enfileirada` → `confirmada pelo CCO`) e exibe o relato estruturado na fila do operador.
4. **Frente 1 — Pessoal & Família (Privacidade comprovada):** A envia um recado de voz para a família avisando que está bem; o vídeo mostra lado a lado que a mensagem **Pessoal** fica estritamente bloqueada/invisível no painel do CCO.
5. **Prevenção de Sonolência + Canal de Voz Direto Agora RTC (CCO ↔ Motorista A):** Diante de sinais de cansaço/lentidão na resposta ou pedido de apoio, o copiloto recomenda parada segura e o operador do CCO clica para abrir **voz direta via Agora RTC** na cabine do Motorista A.

## 8. Priorização de escopo e Compromissos de Entrega (Atualizada)

### P0 — Compromissos Fechados para o Protótipo do Hackathon (24h)
- **Ciclo Agora nas 3 pontas (C1 + C2):**
  - **Ponta 1 (Motorista A):** Agora Conversational AI Engine (baixa latência, barge-in e companhia ativa contra solidão/sonolência) + AI Noise Suppression.
  - **Ponta 2 (Motorista B — Comunidade):** Recebimento por voz em tempo real dos alertas da mesma via (Agora Signaling / Chat + TTS).
  - **Ponta 3 (Operador do CCO — Corporativa):** Painel web recebendo relatos reais de atraso/ocorrências + botão de entrada por voz direta (**Agora RTC**) no canal do motorista + bloqueio total de dados da frente **Pessoal**.
- **Orquestrador das 3 Frentes:** Roteamento por voz entre **1. Pessoal** (padrão privado), **2. Corporativa (CCO)** e **3. Comunidade**, com confirmação por voz para destinos externos.
- **Recuperação de falhas implementada:** Tratamento de dado faltante no diálogo + fila de reconexão com status explícito (`registrada != transmitida != confirmada`).
- **Validação empírica mapeada (C5):** Bateria de testes com 6+ interações externas medindo latência, barge-in, acerto do roteador (**0% de vazamento Pessoal para o CCO**) e resposta a sinais de sonolência.
- **Tese Comercial no Pitch e Vídeo Demo (C3 + C6):** Vídeo de até 2 min da solução real + pitch de 3 min destacando o modelo onde **o motorista adota pela companhia e conexão com a família (Frente Pessoal)**, **a transportadora/seguradora paga pela redução de sinistros por sonolência e visibilidade operacional (Frente Corporativa/CCO)** e **a estrada ganha efeito de rede (Frente Comunidade)**.

### P1 — Diferenciação adicional no Hackathon (se o P0 estiver fechado)
- Canal de voz direto (Agora RTC) entre operador da Central (CCO) e motorista em situações críticas / pedido de ajuda.
- Resumo do trecho (RDO por voz) gerado na parada e aprovado pelo motorista antes do envio à transportadora.
- Filtro de alertas por rodovia/sentido e supressão de ruído de cabine (Agora AI Noise Suppression).

### P2 — Evolução Pós-Hackathon (Futuro)
- **Operação offline por voz no Android** (`whisper.cpp` / STT nativo + LLM local quantizado `llama.cpp` + TTS local).
- **Rede oportunista Mesh/DTN (`A → B → C` store-carry-forward)** via Google Nearby Connections / Wi-Fi Direct / BLE para trechos sem cobertura celular.
- **Integração com rádio PX (27 MHz)** ou LoRa / rádio digital homologado pela Anatel e nós fixos em postos/transportadoras.
- Integrações reais com mensageiros pessoais (mediante permissões) e telemetria/clima/trânsito.
- Estudos de fadiga com métodos validados e salvaguardas.

## 9. Segurança, privacidade e experiência responsável

- Não afirmar que a IA mantém o caminhoneiro acordado ou previne acidentes. Fadiga pede descanso seguro.
- Não substituir 190/191/193/SAMU e outros canais oficiais de emergência; explicar que a mesh é oportunista e não garante entrega.
- Segurança viária: não induzir leitura de tela, navegação visual ou diálogos complexos em movimento.
- Conversas pessoais isoladas da transportadora; nunca disponibilizar dados privados à central por padrão.
- Consentimento e controles de localização, contatos, gravações, retenção e compartilhamento entre nós.
- Para mensagens encaminhadas por terceiros, cifrar conteúdo; intermediários precisam somente do mínimo necessário para roteamento.
- Combater alertas falsos e invalidados e respeitar LGPD.
- Documentar uso de serviços de terceiros e licenças.

## 10. Hackathon UNMUTE by Agora

**Fonte de verdade:** `HACKATHON.md` no repositório.

Pesos informados:
- Experiência de voz e interação — 25%.
- Execução técnica e integração Agora — 25%.
- Relevância do problema e impacto — 20%.
- Inovação e diferenciação — 15%.
- Validação e potencial de evolução — 10%.
- Clareza da apresentação — 5%.

Segundo o arquivo do repositório, a entrega é em **22/11/2026 às 12h (Brasília)**; materiais incluem descrição, até 10 slides, vídeo demo de até 2 min e repositório público. Pitch 5 min (até 3 min explicação + até 2 min demo). Consultar `HACKATHON.md` para detalhes completos, eliminatórios e eventuais atualizações.

**Estratégia de banca:** primeira metade da nota depende de uma experiência vocal convincente e integração real Agora. Não sacrificar isso para implementar funcionalidades numerosas.

## 11. Hipóteses que precisam de validação — NÃO afirmar como prontas

- Android usado na demo (modelo, SoC, RAM, suporte on-device STT) e desempenho do LLM quantizado.
- Disponibilidade/integração dos SDKs Agora e custo operacional.
- Compatibilidade e restrições Nearby Connections sob modo avião, Bluetooth, Wi-Fi e versões Android.
- Viabilidade de três nós reais, permissões runtime e comportamento em segundo plano.
- Entrega de ACK da central para A quando A permanecer sem internet.
- Políticas de alcance, TTL, geofencing e direcionamento a caminhoneiros daquela rodovia.
- Direito de acessar mensageiros/contatos e limites de APIs de terceiros.
- Testes/entrevistas com caminhoneiros ou profissionais de transporte; resultados reais devem ser registrados como evidência, nunca inventados.

## 12. Contrato de dados sugerido para alertas (exemplo, NÃO definitivo)

```json
{
  "id": "uuid",
  "schemaVersion": 1,
  "kind": "ROAD_HAZARD",
  "priority": "CRITICAL",
  "createdAt": "2026-11-21T15:00:00Z",
  "expiresAt": "2026-11-21T16:00:00Z",
  "originDeviceId": "device-pseudonym",
  "location": { "lat": -23.0, "lon": -47.0, "accuracyM": 80 },
  "road": { "id": null, "direction": null, "km": null },
  "hazard": { "type": "ACCIDENT", "description": "Acidente relatado" },
  "routing": { "hopCount": 0, "maxHops": 5 },
  "auth": { "signature": "placeholder" }
}
```

Dados acima são **fictícios**, para discussão. Evitar expor latitude/longitude em claro a toda a comunidade se não forem estritamente necessários; separar payload cifrado e metadados mínimos de roteamento.

## 13. Orientações para o agente Codex/OpenCode

1. Ler nesta ordem: `HACKATHON.md`, `README.md`, `PLAN.md`, este documento e `CLAUDE.md`, além dos ADRs relevantes.
2. Respeitar fluxo de commits, fases, trilha de evidências e decisões que o repositório já define. Não sobrescrever `PLAN.md` sem revisão ou instrução da equipe; **não editar `ROADMAP.md` diretamente**.
3. Fazer inventário do código existente antes de propor implementação. Este repo pode ser inicialmente um kit de brainstorming, não um app.
4. Separar: (a) produto desejado, (b) MVP acordado, (c) hipótese técnica, (d) implementação verificada.
5. Priorizar um vertical slice funcional: Agora voice -> evento -> armazenamento -> transporte local -> entrega central -> prova visível.
6. Criar testes reprodutíveis, identificar mocks e registrar evidências reais de latência, perda de conexão e retransmissão.
7. Se necessário, produzir ADR para selecionar plataforma, stack offline e protocolo local, apresentando trade-offs e riscos.
8. Segurança e honestidade são critérios de aceite, não apenas itens futuros.

## 14. Referências para checagem técnica

- Hackathon: https://newhack.vc/hackathon/agora
- Repositório: https://github.com/LucasLCO/chapahalls-ideas
- Agora docs: https://docs.agora.io/en/
- Agora: https://www.agora.io/en/products/conversational-ai/
- Nearby Connections: https://developers.google.com/nearby/connections/overview
- llama.cpp: https://github.com/ggml-org/llama.cpp
- whisper.cpp: https://github.com/ggml-org/whisper.cpp
- Meshtastic (pesquisa futura): https://meshtastic.org/

> Este handoff sintetiza decisões e sugestões discutidas em chat. Corrigir/atualizar as partes técnicas conforme documentação vigente e experimentos reais.
