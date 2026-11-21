# Parceiro de Estrada

- **Autor(es):** _(preencher)_
- **Status:** rascunho
- **Nota do judge:** _(preenchida por `/judge`)_

> Copiloto de voz para caminhoneiros: cada fala do motorista vira um evento e vai para um de três destinos — **Pessoal**, **Corporativo** (CCO da transportadora) ou **Comunidade** (outros caminhoneiros na mesma rodovia).

Arquivos desta pasta:

| Arquivo | Conteúdo |
|---|---|
| `README.md` | A ideia no formato do `TEMPLATE.md` (para o `/judge`) |
| [`planejamento.md`](planejamento.md) | Plano completo: frentes, arquitetura, CCO, stack Agora, escopo, cronograma, demo, riscos |
| [`mercado-e-evidencias.md`](mercado-e-evidencias.md) | Mercado (TAM/SAM/SOM), custo do problema, concorrentes, ciência, riscos, números para slide e Q&A da banca |
| [`embasamento.md`](embasamento.md) | Dados sobre solidão, sono, jornada, comunicação e acidentes, com fontes, para o pitch e a banca |
| [`historico-decisoes.md`](historico-decisoes.md) | Como a ideia evoluiu, o que foi descartado e por quê, pesquisa dos produtos Agora |

## Problema e público (C3 · 20%)

- **Quem:** caminhoneiros do transporte rodoviário de cargas (TRC) e os Centros de Controle Operacional (CCO) das transportadoras.
- **Problema concreto:** cansaço ao volante e acidentes/tombamentos; motorista avisando o CCO digitando mensagens pré-programadas no rastreador enquanto dirige; informação da pista (acidente, desvio, blitz) que não chega a quem vem atrás.
- **Benefício:** pausa sugerida antes do risco, aviso por voz do que vem pela frente, registro do trecho (RDO) sem digitar, contato direto com o CCO só quando há risco real.

## Por que voz (C4 · 15%)

O motorista está com as mãos no volante e os olhos na estrada: texto não é opção. A própria fala é o sensor de cansaço (tempo de resposta, ritmo). E a voz faz companhia em viagens longas, que é o motivo para o motorista querer usar.

## A conversa (C1 · 25%)

```
Motorista: Tem acidente aqui no km 230, sentido norte, pista da direita fechada.
Agente:    Entendi: acidente na BR-116, km 230, sentido norte, faixa da direita. Aviso a comunidade?
Motorista: Pode avisar.
Agente:    Avisado. Você está há 4h40 dirigindo. Tem posto com área de descanso no km 262. Que tal parar lá?
Motorista: Tá, paro lá.
[na parada]
Agente:    Como foi o trecho?
Motorista: Esperei duas horas pra descarregar em Registro, fora isso tranquilo.
Agente:    Anotei no relatório do trecho: 2h de espera na descarga em Registro. Mando pra transportadora?
```

- **Interrupção (barge-in):** o motorista corta o agente a qualquer momento (ex.: no meio da sugestão de parada) e o agente para de falar.
- **Falha e recuperação:** sem entender → pede para repetir só o dado que faltou (km, sentido); sem sinal → evento fica guardado e é entregue quando a conexão volta (Agora Chat).
- **Latência alvo:** resposta < 2 s.

## Como a Agora entra (C2 · 25%)

- **Produto Agora:** Conversational AI Engine (copiloto, interrupção, LLM próprio), Signaling (alertas da Comunidade em tempo real, presença), Chat (entrega quando o sinal volta; Pessoal e RDO), RTC (operador CCO ↔ motorista), AI Noise Suppression (ruído da cabine).
- **Fluxo:** microfone → Agora Conversational AI (STT → LLM → TTS) → extrator de eventos → roteador → Pessoal (Chat) / Corporativo (Chat → painel CCO) / Comunidade (Signaling + Chat).
- **O que a demo mostra da integração:** conversa por voz com interrupção; alerta chegando por voz num segundo cliente; operador do CCO entrando por voz no canal do motorista.

## Escopo para ~24h

- **Demo path (2 min):**
  1. Motorista A avisa acidente; confirma; publica na Comunidade.
  2. Motorista B, atrás, recebe o aviso por voz; evento aparece no mapa do CCO.
  3. A responde cada vez mais devagar → agente puxa conversa (nível 1) → sugere parada (nível 2).
  4. A para de responder → nível 3 abre canal de voz com o operador do CCO.
  5. Na parada, A conta o trecho → RDO no painel; grava recado para a filha (Pessoal).
- **Simulado / mockado:** posição GPS e rodovia; integração com rastreadores; dois "caminhões" são dois notebooks; sessões de cansaço induzidas.
- **Preexistente:** _(preencher)_
- **Maior risco técnico:** português e latência < 2 s no Conversational AI Engine (português não confirmado na página do produto).

## Validação e evolução (C5 · 10%)

- **Como testamos durante o hackathon:** 6+ testadores externos que não sabem o que dispara o alerta; cansaço induzido por tarefa paralela (conta de cabeça) vs. sessão sem tarefa; medir latência, acerto do roteamento (zero vazamento do Pessoal), eventos sem invenção, falsos positivos.
- **Limitações conhecidas:** depende de sinal de celular (nenhum produto Agora funciona offline); cansaço pela voz não detecta motorista calado sem o agente puxar conversa; não substitui o controle oficial de jornada.
- **Próximos passos:** LoRa para trechos sem cobertura; ConvoAI Device Kit na cabine (4G/eSIM); integração com rastreadores; rádio PX como fonte de eventos.
