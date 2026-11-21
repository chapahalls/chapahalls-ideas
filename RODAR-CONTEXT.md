# RODAR — Contexto de produto e arquitetura

> Handoff de discussão de produto realizado em 21/11/2026. Documento de referência para Codex/OpenCode e equipe do hackathon UNMUTE by Agora.
> **Status:** concepção e hipóteses de arquitetura. Não representa implementação concluída, comprovação de viabilidade ou decisões definitivas de stack.
> **Fonte de regras:** `HACKATHON.md` no repositório é a fonte de verdade para regulamento, prazos e entregáveis; este documento é subordinado a ele.

## 1. Resumo executivo

**Nome provisório:** RODAR — “Sua voz conecta todos os caminhos” / “Você nunca está sozinho na estrada”.

RODAR é um copiloto de IA por voz para caminhoneiros, projetado para unir **vida profissional (Trabalho)**, **vida pessoal (Pessoal)** e **comunicação colaborativa na estrada (Estrada)**. O motorista conversa em linguagem natural e o copiloto identifica intenções, executa ações e escolhe o canal de comunicação adequado sem exigir troca manual de modo.

**Decisão de escopo para o Hackathon (24h):** Para garantir um protótipo funcional, fluido e 100% aderente aos critérios C1 e C2 (50% da nota), o **MVP do hackathon foca na experiência online centrada na Agora** (Conversational AI + RTC/Signaling/Chat, barge-in, orquestração de intenções nas 3 frentes, painel da Central/CCO e fila/recuperação de falha de rede). A **operação com voz local offline (STT/LLM/TTS embarcado)** e a **rede oportunista de dispositivos (mesh/DTN, store-and-forward)** — bem como a integração com rádio PX 27 MHz — ficam documentadas como **visão de evolução e diferencial de roadmap pós-hackathon (Fase 2)**.

## 2. Problemas a resolver

1. Trechos de rodovia com ausência/intermitência de cobertura celular.
2. Comunicação fragmentada entre motoristas, transportadoras, familiares e outros usuários da rodovia.
3. Dificuldade de registrar/encaminhar ocorrências de maneira simples quando a pessoa está dirigindo.
4. Isolamento social em jornadas longas; necessidade de companhia e apoio, sem confundir conversação com prevenção comprovada de fadiga.
5. Alertas rodoviários que deveriam chegar a pessoas potencialmente afetadas, inclusive em redes sem conexão contínua.

**Segurança:** não alegar que conversar com IA previne microssono ou acidentes por fadiga. Ao identificar relato de sonolência, orientar o motorista a fazer uma parada segura e descansar. Evitar distração e mensagens longas durante a condução. Alertas mesh não são substitutos de sistemas oficiais de emergência, nem têm entrega garantida.

## 3. Público e experiências

**Público principal (hipótese para MVP):** caminhoneiro vinculado a uma transportadora com central de operações, usando smartphone Android. **Secundário:** autônomos e comunidade rodoviária.

### 3.1 RODAR Trabalho
- Consultar dados de viagem/carga disponíveis.
- Avisar atraso, bloqueio ou defeito mecânico à central usando a voz.
- Registrar ocorrência com status (criada, enfileirada, encaminhada, recebida, confirmada).
- Receber resposta da central por voz, quando possível.
- Separar dados corporativos dos pessoais com controles de permissão.

### 3.2 RODAR Pessoal
- Conversar com o copiloto e pedir informações/lembranças.
- Enviar/ler mensagens de amigos e familiares **somente mediante autorização** e por integração suportada.
- Caso sem internet, enfileirar a ação e informar explicitamente que a mensagem **não foi entregue**.
- Não prometer integração com WhatsApp ou chamadas telefônicas sem integração real e permissões.

### 3.3 RODAR Estrada
- Registrar por voz alertas: acidentes, bloqueios, riscos e pedidos de ajuda.
- Distribuir para motoristas relevantes conforme localização, rodovia, sentido de tráfego, distância e validade.
- Usar internet quando houver; sem internet, contatos entre dispositivos para replicação oportunista.
- Classificar prioridade e evitar propagação indiscriminada de informações falsas ou desatualizadas.

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

## 7. Demonstração ideal de ponta a ponta (MVP Hackathon · 2 min)

**Objetivo:** provar conversa fluida por voz + Agora funcional (C1/C2) + interrupção (barge-in) + roteamento inteligente entre Trabalho, Pessoal e Estrada + recuperação de falha + entrega em tempo real a outro motorista e à Central (CCO).

1. **Motorista A conectado via Agora:** conversa com o copiloto em português com baixa latência e interrompe a resposta do agente no meio da fala (**barge-in**).
2. **RODAR Estrada (Comunidade):** A relata um risco na pista (*"RODAR, tem acidente na BR-116, km 230, sentido norte, faixa da direita bloqueada"*); o copiloto extrai o evento estruturado, pede confirmação por voz e publica o alerta.
3. **Notificação ao vivo:** Motorista B (na mesma rodovia/sentido) recebe o aviso por voz e o evento aparece instantaneamente no painel da Central (CCO).
4. **RODAR Trabalho + Recuperação de falha:** A reporta atraso ou ocorrência para a transportadora; se houver falha/instabilidade momentânea ou fala incompleta, o agente recupera o contexto (ou enfileira até reconectar) sem perder a ocorrência e confirma quando a Central recebe.
5. **RODAR Pessoal + Segurança:** A grava uma nota/lembrete pessoal (mantido isolado da transportadora por padrão); ao relatar cansaço/sonolência, o copiloto orienta uma parada segura (e, em caso de emergência ou pedido de ajuda, abre canal de voz RTC direto com o operador da Central).

## 8. Priorização de escopo (Atualizada)

### P0 — MVP do Hackathon (Alcançável em 24h)
- Voz via **Agora** funcionando de verdade (baixa latência, barge-in/interrupção e invocação de ferramentas/orquestrador).
- Orquestrador de intenções por voz roteando para as 3 frentes (**Trabalho**, **Pessoal**, **Estrada**) com confirmação vocal antes de publicar para Central ou Comunidade e isolamento de dados pessoais.
- Fluxo “registrar alerta por voz” entregue em tempo real para outro motorista e para o painel web da Central (CCO).
- Tratamento de falha e recuperação (fala ambígua/incompleta ou reconexão/fila local com status explícito `registrada != transmitida != confirmada`).
- README reprodutível, declarações de simulação/preexistentes, vídeo demo de até 2 min e deck de até 10 slides.

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
