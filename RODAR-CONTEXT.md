# RODAR — Contexto de produto e arquitetura

> Handoff de discussão de produto realizado em 21/11/2026. Documento de referência para Codex/OpenCode e equipe do hackathon UNMUTE by Agora.
> **Status:** concepção e hipóteses de arquitetura. Não representa implementação concluída, comprovação de viabilidade ou decisões definitivas de stack.
> **Fonte de regras:** `HACKATHON.md` no repositório é a fonte de verdade para regulamento, prazos e entregáveis; este documento é subordinado a ele.

## 1. Resumo executivo

**Nome provisório de trabalho:** RODAR / Parceiro de Estrada _(nome comercial definitivo do app será definido pelo time posteriormente)_.

O projeto é um copiloto de IA por voz para caminhoneiros que atua em **três frentes integradas**, estruturadas sob um **modelo de conta e negócio inspirado no GitHub**:
- **Modelo de Conta & Negócio estilo GitHub:** o caminhoneiro cria e é dono da sua **conta pessoal na plataforma** (gratuita e vitalícia: acompanha o motorista mesmo que ele troque de transportadora ou atue como autônomo, preservando seus contatos pessoais e sua reputação na Comunidade). Quando opera para uma transportadora (ETC), sua conta é vinculada à **Organização Corporativa (CCO)** daquela empresa, que paga a assinatura B2B.
- **Swap fluido por voz + Comunidade aberta nos dois modos:** o motorista alterna com fluidez entre o **Modo Pessoal** e o **Modo Corporativo** pela própria voz (`"modo pessoal"` ⇄ `"modo corporativo"`), mantendo isolamento total entre vida privada e empresa, enquanto o **Modo Comunidade / Sociedade** (alertas da rodovia) **permanece aberto e ativo em ambos os modos**:
1. **Pessoal & Companhia:** facilita a comunicação por voz com **familiares e amigos** (já que o motorista passa muito tempo longe de casa) e atua como um **copiloto companheiro de viagem** para combater a solidão na cabine, manter o motorista ativo e engajado e **reduzir os índices de acidentes causados por sonolência** (sugerindo paradas seguras e acionando apoio quando necessário).
2. **Corporativa (CCO):** otimiza a comunicação direta com o **Centro de Controle Operacional (CCO)** da transportadora, permitindo que o caminhoneiro descreva por voz a **real situação que está passando** (se a carga vai atrasar, fila na descarga/balança, problema mecânico ou imprevisto na rota) sem precisar digitar em rastreadores enquanto dirige.
3. **Comunidade / Sociedade (Transversal aos dois modos):** conecta caminhoneiros que estão passando pela **mesma via**, permitindo reportar e receber em tempo real avisos e alertas por voz sobre **fim de fila, acidentes, engarrafamentos, bloqueios e riscos na pista**, estando o motorista no modo Pessoal ou no modo Corporativo.

O motorista conversa em linguagem natural e o copiloto identifica intenções, executa ações e escolhe o canal de comunicação adequado sem exigir troca manual de modo.

**Decisão de escopo para o Hackathon (24h):** Para garantir um protótipo funcional, fluido e 100% aderente aos critérios C1 e C2 (50% da nota), o **MVP do hackathon foca na experiência online centrada na Agora** (Conversational AI + RTC/Signaling/Chat, barge-in, orquestração de intenções nas 3 frentes — **Pessoal**, **Corporativa/CCO** e **Comunidade** —, companhia ativa contra solidão/sonolência e painel do CCO). A **operação com voz local offline (STT/LLM/TTS embarcado)** e a **rede oportunista de dispositivos (mesh/DTN, store-and-forward)** — bem como a integração com rádio PX 27 MHz — ficam documentadas como **visão de evolução e diferencial de roadmap pós-hackathon (Fase 2)**.

## 2. Problemas a resolver e Métricas Verificadas (Fonte: [`ideas/parceiro-de-estrada/metricas.md`](ideas/parceiro-de-estrada/metricas.md))

> **Headline macro:** *"O Brasil anda de caminhão: 63% de toda a carga (>85% sem minério e combustíveis), 220 mil viagens por dia (1,4 bi de toneladas/ano, R$ 427 bi de receita). Quando eles param (greve de 2018), a produção industrial cai −11,0% em um mês."* (ILOS, CNI, ANTT 2025, IBGE/BC).

1. **Sonolência, jornada exaustiva e custo de sinistros:**
   - Veículos de carga estão em **28% dos sinistros nas rodovias federais com menos de 5% da frota** (20.552 sinistros em 2024; custo de **R$ 5,1 bi/ano**, cerca de **4× o roubo de carga** de R$ 1,2 bi — ONTL/Infra S.A. 2026 e CNT).
   - O custo médio de um sinistro fatal com veículo de carga é de **R$ 763,7 mil** (ONTL 2026) e acidentes representam **62% dos prejuízos de carga** (Pamcary 2024).
   - Caminhoneiros dormem em média **6h48 por noite** (**42,5% dormem até 6h**, apesar de terem 8h36 disponíveis — CNT 2025, 800 entrevistas); **34,5% já cochilaram ao volante** (J. Bras. Pneumologia); **~28% usam estimulantes** (76% deles rebite — CNTA 2025 / MPT 2023); jornada média de **10h30/dia** (44,4% trabalham >10h e 19,5% >12h — CNT 2025).
2. **Solidão e distância de familiares e amigos:**
   - Apenas **22% costumam dormir em casa**; **72,8% dormem em postos de combustível** (CNT 2025).
   - Entre autônomos, **56,5% ficam no máximo 4 dias seguidos em casa por mês** e chegam a passar **até 16 dias seguidos longe de casa** (CNT 2025 / CNTA 2025). Estudos internacionais (Monash 2023) mostram que a solidão dobra o risco de direção com fadiga severa, e motoristas já usam chamadas de voz longas para suportar o isolamento.
3. **Espera não remunerada e comunicação corporativa perigosa com o CCO:**
   - **41,3% passam a maior parte da jornada esperando carga ou descarga** (CNT 2025); **46,1% dos autônomos "sempre" esperam 5h ou mais**, e **84,7% deles não recebem a estadia** prevista na Lei 11.442/2007 (CNTA 2025). Desde a **ADI 5322 (STF, 2023)**, o tempo de espera conta como jornada.
   - Hoje o motorista se comunica com o CCO digitando no **teclado de macros do rastreador**: estudos naturalísticos em caminhões provam que **digitar dirigindo aumenta em 23× o risco de evento crítico**, enquanto **falar em viva-voz não aumenta o risco (OR 0,65)** (VTTI/FMCSA).
4. **Falta de alertas estruturados por voz na mesma via (Comunidade):**
   - Avisos de acidentes, engarrafamentos e bloqueios hoje se perdem em grupos de WhatsApp (que exigem leitura/digitação ao volante) ou no rádio PX analógico.
5. **Mercado, Escassez e "Por Que Agora" (2023–2027):**
   - **Frota e Comprador:** ~4,1 milhões de caminhões (IBGE/Senatran); 769 mil autônomos (TAC) e 280 mil empresas (ETC, que detêm **66% dos veículos** — ANTT 2025); ~713 mil motoristas CLT (RAIS 2024). **88% das transportadoras têm dificuldade de contratar motoristas** (NTC) e o país perdeu ~1,2 milhão de habilitados C/E entre 2015 e 2025.
   - **TAM / SAM / SOM:** **TAM Caminhão Brasil:** **R$ 0,5–2,0 bi/ano**; **SAM (frotas ETC com CCO):** **R$ 170–250 mi/ano** (a R$ 30–40/veículo/mês; 1.000 caminhões ≈ **R$ 420 mil/ano**, menos que o custo social de 1 sinistro fatal de R$ 763,7 mil); **SOM (5 anos):** **R$ 2,5–10 mi ARR**; **TAM Expandido** (somando ônibus rodoviário com 93 mil motoristas ANTT, frotas corporativas, ferrovia/Rumo e LatAm com ~2 mi veículos): **R$ 1,3–3,2 bi/ano** (até ~R$ 6 bi).
   - **Gatilhos do "Por Que Agora":** (1) STF ADI 5322 (2023, espera é jornada) + NR-1 psicossocial (maio/2026); (2) custo de voz com IA caiu ~90% (`US$ 0,30/min` em 2024 → `US$ 0,007–0,091/min` em 2026); (3) cobertura 4G nas rodovias federais subindo de **36,6% para 58,9%** com o roaming obrigatório de 2027 (Anatel) + Starlink crescendo 80× no Brasil (**11,6 mil → 936,8 mil acessos**); (4) uso de smartphone entre caminhoneiros subiu de **32% para 82%**.

**Ciência e responsabilidade (Modo Atenção):** em simulador (*Leeds, Applied Ergonomics 2025*), **responder perguntas em conversa ativa reduziu a sonolência (escala KSS) de 7,98 para 5,28**; alertas em cabine reduzem eventos de fadiga em **−66%**, e com aviso ao gestor/CCO chegam a **−94%** (Seeing Machines). Como >75% dos motoristas sonolentos ignoram ordens secas de parar (AAA 2023) e o benchmark de detecção de fadiga só pelo timbre da voz é de ~70% em laboratório (Interspeech 2011), o RODAR aciona o **Modo Atenção** por **tempo contínuo ao volante, janela de madrugada e quebra/lentidão de resposta na conversa**, acolhendo o motorista e sugerindo postos com o que ele realmente valoriza (**79% chuveiro, 67,8% restaurante, 55,8% estacionamento vigiado** — CNT 2025), escalando para voz direta (**Agora RTC**) com o CCO no nível 3.

## 3. Público e as 3 Frentes de Atuação

**Público principal (hipótese para MVP):** caminhoneiro vinculado a uma transportadora com Centro de Controle Operacional (CCO), usando smartphone Android. **Secundário:** caminhoneiros autônomos e comunidade rodoviária.

### 3.1 Frente 1 — Pessoal & Companhia (Modo Separado, Lembretes na Parada e Modo Atenção)
- **Separação estilo Perfil de Trabalho do Android (Swap por voz):** os modos **Pessoal** e **Corporativo** são estritamente separados; no modo Corporativo, o envio de mensagens pessoais é bloqueado para evitar distração e vira automaticamente um **lembrete** (*"Te lembro de mandar mensagem pra sua esposa na próxima parada, beleza?"*), que só dispara em **parada real** (> 5 min fora da pista ou motor desligado; fila na pista não conta).
- **Recados recebidos da família:** recados comuns aguardam a próxima parada real; recados marcados como urgentes avisam o motorista **sem dizer a palavra "urgente"** e sem ler o conteúdo dirigindo, sugerindo o próximo posto seguro (após 2 recusas no trecho, aguarda a parada). Na demo, a família ouve/interage por link navegador via **Agora RTC/Chat**.
- **Tom de companheiro de estrada (não amigo nem terapeuta):** fala coloquial, curta e respeitosa (*"Fechou"*, *"Beleza"*, *"Parou, hein"*), sem persona afetiva artificial; em sinal de crise emocional, sugere parar e indica o CVV (188). Conversa livre não é gravada por padrão e jamais é usada pela empresa para avaliação psicossocial (NR-1 / LGPD art. 11).
- **Modo Atenção e prevenção de sonolência:** disparado por tempo contínuo ao volante (>4h30), janela de madrugada e lentidão/quebra de resposta na conversa, puxando interação ativa (que reduz o KSS de 7,98 para 5,28 — *Leeds 2025*), sugerindo postos com chuveiro (79%), restaurante (67,8%) e pátio vigiado (55,8%) (nível 2) e escalando para voz direta (**Agora RTC**) com o CCO no nível 3 (única exceção de segurança que atravessa os dois modos).

### 3.2 Frente 2 — Corporativa (CCO + Diário de Bordo Não Editável)
- **Relato real da situação ao CCO:** o caminhoneiro explica por voz o que realmente está acontecendo (ex.: *"fila de 12 caminhões aqui, ninguém dá previsão"* ou atraso por bloqueio na via), substituindo macros limitadas (cujo uso digitando tem **risco 23× maior**) por um anexo confirmado e estruturado para o CCO.
- **Registro do trecho não editável (prova complementar de espera e ocorrências):** chegada, saída e paradas são carimbadas automaticamente por **geofence + relógio do servidor** em um log **append-only com hash encadeado** (correções entram apenas como novo evento de adendo). Prova o tempo de espera e o excedente acima de 5h para cobrança de estadia (Lei 11.442/2007 e STF ADI 5322). Se o motorista estiver sem sinal, o evento é enfileirado localmente com hora do GPS (`registrado offline`) e entregue via Agora Chat quando a conexão retorna.
- **Canal de voz direto (Agora RTC) com o CCO:** quando há risco real (nível 3, sem resposta ao agente ou pedido *"preciso de ajuda"*), o operador do CCO entra por voz no canal do motorista.

### 3.3 Frente 3 — Comunidade (Alertas colaborativos na mesma via · Ciclo de vida estilo Waze por voz)
- **Foco em Fim de Fila / Pista Parada e riscos reais (sem blitz):** reportar por voz fim de fila, acidentes, interdições, óleo/carga na pista, animais, buracos e neblina (1 morte a cada 6 sinistros com caminhões/ônibus nas federais — PRF 2024). Alertas de blitz ficam fora (PL 5.596/2013 e coerência com segurança).
- **Ciclo de vida e confirmação dupla do "não":** cada alerta tem validade por tipo (fim de fila 15 min, acidente 30 min, interdição/clima 1 h, buraco 24 h) e é entregue a quem vem atrás na mesma rodovia e sentido. Ao passar pelo local, o agente pergunta *"ainda tá lá?"*: `"sim"` renova o prazo; `"não"` exige **confirmação dupla** repetindo o conteúdo (*"Hum, então o acidente do km 230 já liberou, é isso? Me confirma aí."*) e soma o peso/reputação de quem respondeu antes de derrubar o alerta (na dúvida ou silêncio, o alerta é mantido).

### 3.4 Estratégia Comercial B2B2C (Estilo GitHub): Como convencemos as empresas a contratar

> **Síntese para o Pitch:** *"Ferramenta corporativa que o caminhoneiro odeia vira sucata no painel; app pessoal que a empresa não vê não tem quem pague. Nós resolvemos os dois lados com o modelo GitHub: o caminhoneiro entra de graça pela Conta Pessoal e pela Comunidade porque o copiloto faz companhia e protege a privacidade dele; e a transportadora paga R$ 30–40/mês pelo Modo Corporativo porque uma única estadia comprovada ou um único acidente de R$ 763 mil evitado paga a frota inteira."*

1. **Cobertura imediata de Agregados e Autônomos (Zero Hardware):**
   - Quase toda transportadora (ETC) depende de caminhoneiros agregados e autônomos (TAC) cuja frota tem **24,4 anos de idade média** (ANTT 2025) e não possui o teclado de macros nem a câmera da transportadora.
   - Com o modelo GitHub, o motorista já tem sua conta pessoal no celular; ao ser contratado para uma viagem, a transportadora apenas vincula a conta dele à sua **Organização (CCO)**, ganhando visibilidade operacional, diário de doca e alerta de risco (nível 3) em 100% da frota própria e terceirizada sem instalar hardware.
2. **ROI Direto no Caixa: Cobrança de Estadia (Lei 11.442) e Controle de Espera (STF ADI 5322):**
   - **41,3%** dos motoristas passam a maior parte da jornada esperando carga/descarga (CNT 2025) e **84,7%** das esperas acima de 5h não são pagas por falta de prova robusta (CNTA 2025). Desde a **ADI 5322 do STF (2023)**, o tempo de espera também conta como jornada para o motorista CLT.
   - O **Diário de Trecho Não Editável** (geofence + hora do servidor + hash append-only + relato por voz confirmado) comprova o tempo de doca: recuperar **uma única estadia de 3h excedentes num caminhão de 30 t (~R$ 217)** já paga mais de 5 meses da assinatura daquele veículo (**R$ 30–40/mês**).
3. **Redução de Sinistros (R$ 763,7 mil) por ~1% do custo de Câmeras de Fadiga (e sem rejeição sindical):**
   - Caminhões estão em **28% dos sinistros nas federais** (<5% da frota, **R$ 5,1 bi/ano**, **R$ 763,7 mil por sinistro fatal** — ONTL 2026), e digitar macros dirigindo aumenta em **23× o risco de evento crítico** vs. viva-voz (**OR 0,65** — VTTI/FMCSA).
   - Câmeras de fadiga (DMS) custam **R$ 2,8 mil a R$ 8 mil de hardware por caminhão** e sofrem resistência dos motoristas por filmarem a cabine. Nossa solução custa **R$ 35/mês sem hardware**: numa frota de **1.000 caminhões (R$ 420 mil/ano)**, evitar **1 único sinistro grave no ano** paga o contrato da frota inteira, e o motorista adota porque os níveis 1 e 2 ficam só com ele.
4. **Retenção na Crise de Mão de Obra (88% de escassez) + Conformidade NR-1 Psicossocial (Maio/2026):**
   - **88% das transportadoras não conseguem contratar motoristas** (NTC) e desde **26/05/2026 a nova NR-1** exige gestão de riscos psicossociais (isolamento e jornada exaustiva) no PGR.
   - A empresa comprova ação preventiva de saúde e segurança (Modo Atenção + incentivo a falar com a família nas paradas obrigatórias) mantendo 100% de conformidade com a **LGPD (art. 11)**, já que nunca acessa o Modo Pessoal.
5. **Três Bolsos Compradores B2B:**
   - **Transportadoras (ETC com CCO — SAM de R$ 170–250 mi/ano):** pagam por assento/veículo ativo na organização para operação de CCO, prova de estadia e segurança.
   - **Seguradoras e Gerenciadoras de Risco:** como **62% dos prejuízos de carga vêm de acidentes** (Pamcary), subsidiam ou exigem o uso na apólice para reduzir engavetamentos de fim de fila e tombamentos.
   - **Embarcadores e Terminais Logísticos (ex.: terminais de transbordo):** utilizam os dados auditáveis de chegada e fila para gestão de pátio e redução de disputas de estadia.

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
- **Validação empírica mapeada (C5):** Bateria estruturada com **3 testadores** executando **5 cenários cada (15 interações cronometradas e auditadas)** — cobrindo (1) Pessoal/família, (2) Corporativa/CCO + diário de espera, (3) Comunidade/alerta na via, (4) interrupção/barge-in e (5) recuperação de dado faltante + Modo Atenção —, medindo latência (`ms`), acerto do roteador (**0% de vazamento Pessoal para o CCO**), declarando honestamente a limitação amostral (`n = 3`) e registrando os **aprendizados concretos** aplicados no produto após os testes.
- **Tese Comercial no Pitch e Vídeo Demo (C3 + C6):** Assim que o produto estiver solidificado, gravação do vídeo demo narrado de até 2 min da solução real + pitch de 3 min destacando o modelo onde **o motorista adota pela companhia e conexão com a família (Frente Pessoal)**, **a transportadora/seguradora paga pela redução de sinistros por sonolência e visibilidade operacional (Frente Corporativa/CCO)** e **a estrada ganha efeito de rede (Frente Comunidade)**.

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
