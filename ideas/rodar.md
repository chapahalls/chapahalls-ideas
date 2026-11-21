# RODAR — Copiloto de voz para caminhoneiros (Pessoal, Corporativa e Comunidade)

- **Autor(es):** Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`), Lucas (`@LucasLCO`)
- **Status:** avaliada
- **Nota do judge:** 4,75 / 5 ([`ideas/scores/rodar.md`](scores/rodar.md))
- **Contexto e métricas completas:** [`RODAR-CONTEXT.md`](../RODAR-CONTEXT.md) · [`ideas/parceiro-de-estrada/metricas.md`](parceiro-de-estrada/metricas.md) · [`ideas/parceiro-de-estrada/mercado-e-evidencias.md`](parceiro-de-estrada/mercado-e-evidencias.md) · [`ideas/parceiro-de-estrada/expansao-e-por-que-agora.md`](parceiro-de-estrada/expansao-e-por-que-agora.md)

> Copiloto de IA por voz para caminhoneiros que faz companhia ativa na estrada para combater a solidão e diminuir acidentes por sonolência, enquanto orquestra a comunicação em três frentes — **1. Pessoal** (familiares, amigos e Modo Atenção), **2. Corporativa** (relato real de atrasos/ocorrências ao CCO e diário de bordo não editável de espera) e **3. Comunidade** (alertas de acidentes e engarrafamentos na mesma via) — sem que o motorista tire as mãos do volante.

## Problema e público (C3 · 20%)

- **Quem:** caminhoneiros do transporte rodoviário de cargas (4,1 mi caminhões; 713 mil motoristas CLT + 769 mil autônomos TAC) e os Centros de Controle Operacional (CCO) das 280 mil transportadoras (ETC, que operam **66% da frota** — ANTT 2025).
- **Problema concreto (com métricas oficiais verificadas em [`metricas.md`](parceiro-de-estrada/metricas.md)):**
  1. **Peso econômico crítico:** a rodovia carrega **~63% do TKU do Brasil** (**>85%** sem minério e combustíveis — ILOS/CNI), somando **1,4 bilhão de toneladas, 80,4 milhões de viagens/ano (~220 mil viagens/dia)** e **R$ 427 bi** de faturamento (ANTT 2025 / IBGE). Quando os caminhões param (greve de 2018, 11 dias), a produção industrial cai **−11,0% em um mês** (IBGE/BC).
  2. **Sono, jornada exaustiva e custo bilionário de acidentes:** veículos de carga estão em **28% dos sinistros nas rodovias federais com menos de 5% da frota** (20.552 sinistros em 2024; custo de **R$ 5,1 bi/ano**, **4× o roubo de carga** de R$ 1,2 bi; custo médio de **R$ 763,7 mil por sinistro fatal** — ONTL/Infra S.A. 2026 e CNT). Caminhoneiros dormem em média **6h48/noite** (**42,5% dormem até 6h**), **34,5% já cochilaram ao volante** (J. Bras. Pneumologia), **~28% usam estimulantes** (76% rebite — CNTA 2025 / MPT 2023) e cumprem jornada média de **10h30/dia** (CNT 2025).
  3. **Solidão e distância de familiares e amigos:** apenas **22% dormem em casa** e **72,8% dormem em postos** (CNT 2025); **56,5% dos autônomos ficam no máximo 4 dias seguidos em casa por mês** e passam **até 16 dias seguidos longe da família** (CNT/CNTA 2025).
  4. **Espera não paga e risco 23× maior ao digitar para o CCO:** **41,3% passam a maior parte da jornada esperando carga ou descarga** (CNT 2025) e **84,7% dos autônomos com espera >5h não recebem a estadia** da Lei 11.442/2007 (CNTA 2025), embora o **STF (ADI 5322, 2023)** conte a espera como jornada. Além disso, avisar o CCO digitando macros no rastreador em movimento aumenta em **23× o risco de evento crítico**, enquanto **falar em viva-voz não aumenta o risco (OR 0,65)** (VTTI/FMCSA).
  5. **Falta de alertas estruturados por voz na mesma via (Comunidade):** avisos sobre acidentes e engarrafamentos hoje dependem de WhatsApp (leitura/digitação perigosa ao volante) ou rádio PX analógico ruidoso.
- **Benefício mensurável e Tese Comercial ("Quem usa vs. Quem paga"):**
  - **1. Frente Pessoal & Companhia (Modo Atenção):** responder perguntas em conversa ativa reduz a sonolência na escala KSS de **7,98 para 5,28** (*Leeds, Applied Ergonomics 2025*), e alertas em cabine combinados com aviso ao gestor/CCO reduzem eventos de fadiga em **−66% a −94%** (Seeing Machines). O copiloto puxa conversa nos vales de atenção (tempo contínuo ao volante e madrugada), sugere postos com o que o motorista valoriza (**79% chuveiro, 67,8% restaurante, 55,8% pátio vigiado** — CNT 2025) e facilita recados de voz com familiares e amigos com **0% de vazamento para o CCO**.
  - **2. Frente Corporativa (CCO + Diário de Bordo Não Editável):** substitui a digitação (risco **23× menor**) por relatos de voz detalhados sobre a situação real da carga/atraso, anexados a um registro de espera não editável (cerca eletrônica + hora do servidor + hash append-only) que comprova estadias acima de 5h (~R$ 217 por evento de 3h em 30 t) e reduz passivo trabalhista pós-ADI 5322 e NR-1 psicossocial (maio/2026), além de abrir canal de voz direto (**Agora RTC**) entre CCO e motorista no nível 3.
  - **3. Frente Comunidade:** alertas de acidentes, engarrafamentos e bloqueios reportados e recebidos por voz em tempo real pelos caminhoneiros na mesma rodovia e sentido (sem alertas de blitz/polícia).
  - **Mercado (TAM / SAM / SOM):** **TAM Caminhão Brasil:** **R$ 0,5–2,0 bi/ano**; **SAM (frotas ETC com CCO):** **R$ 170–250 mi/ano** (a R$ 30–40/mês; uma frota de 1.000 caminhões = **R$ 420 mil/ano**, menos que **1 sinistro fatal** de R$ 763,7 mil); **SOM (5 anos):** **R$ 2,5–10 mi ARR**; **TAM Expandido** (ônibus ANTT com 93 mil motoristas, frotas corporativas, ferrovia/Rumo e LatAm com ~2 mi veículos): **R$ 1,3–3,2 bi/ano** (até R$ 6 bi). Comparáveis: **HappyRobot** (US$ 1,2 bi em voz para frete), **Samsara** (US$ 1,89 bi ARR), **Motive** (US$ 501 mi ARR), **Sascar** (R$ 1,6 bi EV) e **Legora** (US$ 675 mi → US$ 8,8 bi em 17 meses).

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

- **Interrupção (barge-in):** o motorista corta o agente a qualquer momento no meio da fala (ex.: durante uma conversa de companhia quando surge um acidente ou fim de fila à frente); o agente interrompe o áudio imediatamente e prioriza a ocorrência.
- **Modelo de Conta estilo GitHub + Swap por voz (`Pessoal` ⇄ `Corporativo`) com `Comunidade` aberta nos dois modos:**
  - O motorista cria sua **conta pessoal na plataforma** (gratuita e dele, mesmo se mudar de empresa) e pode vincular-se à **Organização Corporativa (CCO)** da transportadora para a qual trabalha.
  - Alterna de forma fluida por voz entre **Modo Pessoal** e **Modo Corporativo** (como o perfil pessoal e o de trabalho do Android): no modo Corporativo, envio pessoal é bloqueado e vira lembrete automático para a próxima parada real (> 5 min fora da pista ou motor desligado).
  - Já a frente **Comunidade / Sociedade** fica **aberta e ativa nos dois modos**: tanto no modo Pessoal quanto no Corporativo, o motorista pode emitir, confirmar e receber alertas de pista por voz.
- **Ciclo de vida do alerta na Comunidade (estilo Waze por voz):** foco em **fim de fila / pista parada** e acidentes (sem blitz); validade por tipo; quem passa depois no mesmo trecho/sentido confirma (`"sim"` renova) ou nega com **confirmação dupla do `"não"`** e remoção por peso/reputação (silêncio mantém o alerta).
- **Falha e recuperação:**
  - *Informação incompleta ou ruído:* se faltar um dado essencial do alerta ou do reporte ao CCO (como km, sentido ou motivo do atraso), o agente pergunta apenas o dado que faltou.
  - *Oscilação de rede / falha de envio:* a ocorrência fica registrada na fila local do app com status explícito (`enfileirada / aguardando confirmação`) e é entregue via Agora Chat assim que a conexão estabiliza; em caso de quebra de conversa/sonolência crítica (nível 3) ou pedido de ajuda, abre canal de voz direto (**Agora RTC**) com o operador do CCO.
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

- **Demo path (Vídeo demo da solução real gravado para o pitch · 2 min):**
  1. **Companhia Ativa + Barge-in + Recuperação de Dado Faltante (Motorista A):** O copiloto conversa com o Motorista A via Agora (combate à solidão/sonolência com latência `< 1,5 s`); A interrompe o agente (**barge-in**) para avisar sobre um acidente e engarrafamento, o agente cobra eventual dado faltante (km/sentido) e confirma o envio por voz.
  2. **Ponta 2 (Comunidade) + Ponta 3 (CCO) em tempo real:** Motorista B (na mesma via) ouve o alerta narrado por voz via Agora; simultaneamente, o Motorista A descreve a situação real do atraso da carga e o operador vê o relato detalhado no painel do CCO (com transição de fila `enfileirada` → `confirmada`).
  3. **Frente Pessoal (Família e Amigos com Privacidade Lado a Lado):** Motorista A envia por voz um recado para a família; o vídeo comprova lado a lado que o conteúdo pessoal não aparece no painel do CCO (**0% de vazamento**).
  4. **Prevenção de Sonolência + Entrada de Voz Direta do CCO (Agora RTC):** Diante de sinais de sonolência/lentidão na conversa ou pedido de apoio, o copiloto sugere parada segura e o operador do CCO clica para entrar por voz (**Agora RTC**) direto na cabine do Motorista A.
- **Simulado / mockado:** coordenadas GPS, rodovia/sentido e cadastro da viagem; dois clientes representando dois caminhões na mesma via e o painel web representando o CCO.
- **Preexistente:** SDKs e documentação oficial da Agora (`agora@agora-skills` / MCP).
- **Maior risco técnico:** latência e naturalidade do português no pipeline Agora Conversational AI (`< 2 s` com barge-in confiável) — mitigado testando o canal de voz na Fase 1 com LLM/TTS reserva configurável por variável de ambiente.

## Validação e evolução (C5 · 10%)

- **Como testamos durante o hackathon:** bateria estruturada com **3 testadores × 5 cenários padronizados (15 interações medidas no total)** — (1) recado Pessoal, (2) atraso/espera para o CCO, (3) alerta de acidente na Comunidade, (4) interrupção/barge-in e (5) relato com dado faltante + Modo Atenção —, registrando em `docs/validacao.md` a latência média (`ms`), taxa de sucesso do barge-in, precisão do roteador (**0% de vazamento de conversas pessoais para o CCO**), limitação honesta da amostra (`n = 3`) e **aprendizados concretos** que geraram ajustes no protótipo antes da gravação do vídeo final.
- **Limitações conhecidas:**
  - O MVP do hackathon opera online sobre a rede da Agora (com fila local para oscilações curtas, mas sem operação conversacional totalmente offline).
  - O acompanhamento conversacional contra solidão e sonolência atua como camada preventiva de engajamento e recomendação de parada segura, não substituindo o descanso regulamentar obrigatório.
  - Alertas da Comunidade não substituem canais oficiais de emergência (190/191/193/SAMU).
- **Próximos passos (Pós-Hackathon):**
  - **Modo de voz offline no dispositivo:** STT/TTS local + modelo pequeno quantizado (`llama.cpp` / `whisper.cpp`) para manter o copiloto ativo em zonas sem cobertura celular.
  - **Rede oportunista Mesh/DTN (`A → B → C` store-carry-forward):** retransmissão de alertas da Comunidade e do CCO entre caminhões próximos (via Nearby Connections / Wi-Fi Direct / BLE ou LoRa) até alcançar um veículo com internet.
  - **Integração com rádio PX (27 MHz) e hardware dedicado:** interface homologada pela Anatel / Agora ConvoAI Device Kit na cabine.
