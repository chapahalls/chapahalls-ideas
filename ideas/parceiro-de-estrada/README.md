# RODAR / Parceiro de Estrada

- **Autor(es):** Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`), Lucas (`@LucasLCO`)
- **Status:** pesquisa de apoio

> **Exploração anterior ao foco atual.** O propósito vigente do RODAR (agente de voz para a espera na doca, com acessibilidade como diferencial) está em [`../rodar.md`](../rodar.md) e [`../demora-em-docas/descoberta.md`](../demora-em-docas/descoberta.md). Esta pasta guarda a pesquisa de mercado, custos, concorrentes e riscos que continua útil.

> **Foco central:** **Soluciona os gargalos de comunicação manual no setor de transporte rodoviário e logística de cargas.** Copiloto de voz para caminhoneiros e operações logísticas onde cada fala do motorista elimina uma interação manual (teclado de macros, WhatsApp ao volante, anotação de doca) e vira um evento estruturado para um de três destinos — **1. Pessoal** (família, amigos e companhia ativa / Modo Atenção contra solidão e sonolência), **2. Corporativo** (relato real de atrasos/ocorrências ao CCO + diário de espera não editável) ou **3. Comunidade** (alertas de fim de fila e acidentes para caminhoneiros na mesma rodovia).

Arquivos desta pasta e contexto unificado do time:

| Arquivo | Conteúdo |
|---|---|
| `README.md` e [`../rodar.md`](../rodar.md) | A ideia unificada no formato do `TEMPLATE.md` (para o `/judge`) |
| [`../../RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md) | Contexto de produto, arquitetura das 3 frentes, corte MVP (Agora online) vs. Evolução (Voz Offline + Mesh/DTN + PX) |
| [`planejamento.md`](planejamento.md) | Plano completo: frentes, arquitetura, CCO, stack Agora, escopo, cronograma, demo, riscos |
| [`metricas.md`](metricas.md) | Resumo de todas as métricas pesquisadas, numa página |
| [`mercado-e-evidencias.md`](mercado-e-evidencias.md) | Mercado (TAM/SAM/SOM), custo do problema, concorrentes, ciência, riscos, números para slide e Q&A do júri |
| [`expansao-e-por-que-agora.md`](expansao-e-por-que-agora.md) | Resposta aos especialistas: TAM expandido e roadmap (ônibus, ferrovia/Rumo, LatAm), crescimento histórico, por que agora (Starlink, roaming, voz barata), resiliência logística, comparáveis (Legora) |
| [`embasamento.md`](embasamento.md) | Dados sobre solidão, sono, jornada, comunicação e acidentes, com fontes, para o pitch e o júri |
| [`historico-decisoes.md`](historico-decisoes.md) | Como a ideia evoluiu, o que foi descartado e por quê, pesquisa dos produtos Agora |
| [`contexto-produto.md`](contexto-produto.md) | Contexto do produto para o repo: integração com a empresa (rota, break points, regras de reporte, documentos), fluxo do app, check-in, estadia, GPS dupla prova, modelo de dados, escopo do MVP |
| [`problemas-e-decisoes.md`](problemas-e-decisoes.md) | Os 16 problemas levantados, causa, solução proposta e a decisão do time (15 decididos, 1 descartado) + fluxograma |
| [`fluxograma.svg`](fluxograma.svg) · [`revisao-fluxo.html`](revisao-fluxo.html) | Fluxograma em raias (CCO, agente, motorista) e o quadro interativo de revisão (abrir o HTML no navegador) |
| [`impacto-e-custos.md`](impacto-e-custos.md) | Impacto do problema e de resolver: espera no recebimento, multas e retenção, perda de carga, custo da hora parada, estimativa do custo da falta de comunicação e do CCO, com fontes |

## Problema e público

- **Quem:** caminhoneiros do transporte rodoviário de cargas (TRC — 4,1 mi caminhões; 713 mil motoristas CLT + 769 mil autônomos TAC) e os Centros de Controle Operacional (CCO) das 280 mil transportadoras (ETC, que detêm 66% dos veículos — ANTT 2025).
- **Problema concreto:**
  1. **Sono, solidão e acidentes (R$ 5,1 bi/ano):** veículos de carga estão em **28% dos sinistros nas federais com <5% da frota** (custo médio de **R$ 763,7 mil por sinistro fatal** — ONTL 2026); motoristas dormem **6h48/noite** (42,5% ≤ 6h), **34,5% já cochilaram ao volante**, **~28% usam estimulantes** e só **22% dormem em casa** (72,8% em postos; autônomos ficam até **16 dias seguidos longe da família** — CNT/CNTA 2025).
  2. **Comunicação perigosa com o CCO e espera não paga:** digitar macros no rastreador enquanto dirige aumenta em **23× o risco de evento crítico** (vs. **OR 0,65** falando em viva-voz — VTTI/FMCSA); além disso, **41,3% passam a maior parte da jornada esperando carga ou descarga** e **84,7% dos autônomos com espera >5h não recebem a estadia** da Lei 11.442/2007 (CNT/CNTA 2025), embora o **STF (ADI 5322, 2023)** conte a espera como jornada.
  3. **Falta de alertas por voz na mesma via (Comunidade):** informação crítica da pista (**fim de fila / pista parada**, acidente, interdição) que não chega a tempo a quem vem atrás sem pegar o celular — hoje circula em grupos de WhatsApp.
- **Benefício:** companhia ativa por voz no **Modo Atenção** (responder perguntas reduz a sonolência na escala KSS de **7,98 para 5,28** — *Leeds 2025*) e contato seguro com família/amigos na parada (via lembrete automático e link Agora); pausa sugerida com o que o motorista valoriza (**79% chuveiro, 67,8% restaurante, 55,8% pátio vigiado** — CNT 2025); aviso por voz do que vem pela frente na via (com ciclo de vida e confirmação dupla do "não"); relato real de atrasos ao CCO + registro do trecho não editável (chegada, espera, ocorrências) que prova estadia acima de 5h; e contato direto por voz (**Agora RTC**) com o CCO quando há risco real.

## Por que voz

O motorista está com as mãos no volante e os olhos na estrada: digitar multiplica o risco em 23×, enquanto falar em viva-voz não aumenta o risco (VTTI/FMCSA). A conversa falada faz companhia ativa contra a solidão e a sonolência em viagens longas (o motivo para o motorista querer usar e manter proximidade com familiares e amigos), permite descrever com contexto real um problema ao CCO e entrega alertas imediatos para a comunidade na mesma via.

## A conversa

```
Motorista: Tem acidente aqui no km 230, sentido norte, pista da direita fechada.
Agente:    Entendi: acidente na BR-116, km 230, sentido norte, faixa da direita. Aviso a comunidade?
Motorista: Pode avisar.
Agente:    Avisado. Você está há 4h40 dirigindo. Tem posto com área de descanso no km 262. Que tal parar lá?
Motorista: Tá, paro lá.
[chega ao cliente em Registro — chegada carimbada sozinha, 14:02]
Motorista: Fila de doze caminhões aqui, ninguém dá previsão.
Agente:    Registro pra transportadora: fila de 12 caminhões, sem previsão. Confirma?
Motorista: Confirma.
Agente:    Registrado. Você chegou às 14:02; se passar das 19:02, conta estadia.
```

- **Dois modos (swap por voz):** Pessoal e Corporativo separados como o perfil pessoal e o de trabalho do Android; no Corporativo, envio pessoal é bloqueado e vira lembrete para a próxima parada real.
- **Tom:** companheiro de estrada, coloquial e curto; não é amigo nem terapeuta.
- **Interrupção (barge-in):** o motorista corta o agente a qualquer momento (ex.: no meio da sugestão de parada) e o agente para de falar.
- **Confirmação:** todo alerta relatado é repetido (tipo, km, sentido) antes de publicar; um "não, já saiu" pede confirmação dupla, e silêncio mantém o alerta.
- **Falha e recuperação:** sem entender → pede para repetir só o dado que faltou (km, sentido); sem sinal → evento fica guardado e é entregue quando a conexão volta (Agora Chat).
- **Latência alvo:** resposta < 2 s.

## Como a Agora entra

- **Produto Agora:** Conversational AI Engine (copiloto, interrupção, LLM próprio), Signaling (alertas da Comunidade em tempo real, presença), Chat (entrega quando o sinal volta; Pessoal e registro do trecho), RTC (operador CCO ↔ motorista), AI Noise Suppression (ruído da cabine).
- **Fluxo:** microfone → Agora Conversational AI (STT → LLM → TTS) → extrator de eventos → roteador → Pessoal (Chat) / Corporativo (Chat → painel CCO) / Comunidade (Signaling + Chat).
- **O que a demo mostra da integração:** conversa por voz com interrupção; alerta chegando por voz num segundo cliente; operador do CCO entrando por voz no canal do motorista.

## Escopo do MVP

- **Demo path (2 min):**
  1. Motorista A avisa acidente; confirma; publica na Comunidade.
  2. Motorista B, atrás, recebe o aviso por voz; evento aparece no mapa do CCO. Ao passar no local: "ainda tá lá?" → "não" → agente pede confirmação → alerta some.
  3. A responde cada vez mais devagar → agente puxa conversa (nível 1) → sugere parada (nível 2).
  4. A para de responder → nível 3 abre canal de voz com o operador do CCO.
  5. A chega ao cliente → chegada carimbada sozinha; relato por voz entra como anexo; tempo acelerado → painel mostra espera e excedente de 5h; pedido "manda mensagem pra esposa" no modo trabalho vira lembrete; na parada o agente lembra, ele grava, a esposa ouve por link (Pessoal; empresa não vê).
- **Simulado / mockado:** posição GPS, geofence do cliente e rodovia; tempo acelerado na espera; integração com rastreadores; dois "caminhões" são dois notebooks; sessões de cansaço induzidas.
- **Preexistente:** SDKs e documentação oficial da Agora (`agora@agora-skills` / MCP).
- **Maior risco técnico:** português e latência < 2 s no Conversational AI Engine (português não confirmado na página do produto).

## Validação e evolução

- **Como testamos no MVP:** bateria estruturada com **3 testadores × 5 cenários padronizados (15 interações medidas no total)** — (1) recado Pessoal para família/amigos, (2) relato de atraso/espera para o CCO, (3) alerta de acidente na Comunidade, (4) interrupção/barge-in e (5) relato com dado faltante + Modo Atenção (cansaço induzido por tarefa paralela) —, medindo latência (`ms`), acerto do roteamento (**0% de vazamento do Pessoal para o CCO**), eventos sem invenção, limitação honesta da amostra (`n = 3`) e **aprendizados concretos** aplicados antes de gravar o vídeo demo final da solução solidificada.
- **Limitações conhecidas:** depende de sinal de celular no MVP (nenhum produto Agora funciona offline); o Modo Atenção atua por tempo ao volante, janela circadiana e tempo de resposta na conversa (não promete biomarcador de voz isolado) e não substitui o descanso obrigatório; não substitui o controle oficial de jornada (o registro do trecho é prova complementar de espera e ocorrências, não ponto).
- **Próximos passos:** modo de voz offline no dispositivo (`whisper.cpp`/`llama.cpp`), rede oportunista **Mesh/DTN (`A → B → C` store-carry-forward)** e LoRa para trechos sem cobertura; ConvoAI Device Kit na cabine (4G/eSIM); integração com rastreadores e rádio PX 27 MHz; expansão para ônibus rodoviário, terminais ferroviários (Rumo) e América Latina.
