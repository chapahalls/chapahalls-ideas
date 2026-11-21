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
| [`metricas.md`](metricas.md) | Resumo de todas as métricas pesquisadas, numa página |
| [`mercado-e-evidencias.md`](mercado-e-evidencias.md) | Mercado (TAM/SAM/SOM), custo do problema, concorrentes, ciência, riscos, números para slide e Q&A da banca |
| [`expansao-e-por-que-agora.md`](expansao-e-por-que-agora.md) | Resposta aos especialistas: TAM expandido e roadmap (ônibus, ferrovia/Rumo, LatAm), crescimento histórico, por que agora (Starlink, roaming, voz barata), resiliência logística, comparáveis (Legora) |
| [`embasamento.md`](embasamento.md) | Dados sobre solidão, sono, jornada, comunicação e acidentes, com fontes, para o pitch e a banca |
| [`historico-decisoes.md`](historico-decisoes.md) | Como a ideia evoluiu, o que foi descartado e por quê, pesquisa dos produtos Agora |

## Problema e público (C3 · 20%)

- **Quem:** caminhoneiros do transporte rodoviário de cargas (TRC) e os Centros de Controle Operacional (CCO) das transportadoras.
- **Problema concreto:** cansaço ao volante e acidentes/tombamentos; motorista avisando o CCO digitando mensagens pré-programadas no rastreador enquanto dirige; informação da pista (fim de fila, acidente, interdição) que não chega a quem vem atrás sem pegar o celular — hoje circula em grupos de WhatsApp.
- **Benefício:** pausa sugerida antes do risco, aviso por voz do que vem pela frente, registro do trecho não editável (chegada, espera, ocorrências) que prova estadia acima de 5h, contato direto com o CCO só quando há risco real.

## Por que voz (C4 · 15%)

O motorista está com as mãos no volante e os olhos na estrada: texto não é opção. A própria fala é o sensor de cansaço (tempo de resposta, ritmo). E a voz faz companhia em viagens longas, que é o motivo para o motorista querer usar.

## A conversa (C1 · 25%)

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

## Como a Agora entra (C2 · 25%)

- **Produto Agora:** Conversational AI Engine (copiloto, interrupção, LLM próprio), Signaling (alertas da Comunidade em tempo real, presença), Chat (entrega quando o sinal volta; Pessoal e registro do trecho), RTC (operador CCO ↔ motorista), AI Noise Suppression (ruído da cabine).
- **Fluxo:** microfone → Agora Conversational AI (STT → LLM → TTS) → extrator de eventos → roteador → Pessoal (Chat) / Corporativo (Chat → painel CCO) / Comunidade (Signaling + Chat).
- **O que a demo mostra da integração:** conversa por voz com interrupção; alerta chegando por voz num segundo cliente; operador do CCO entrando por voz no canal do motorista.

## Escopo para ~24h

- **Demo path (2 min):**
  1. Motorista A avisa acidente; confirma; publica na Comunidade.
  2. Motorista B, atrás, recebe o aviso por voz; evento aparece no mapa do CCO. Ao passar no local: "ainda tá lá?" → "não" → agente pede confirmação → alerta some.
  3. A responde cada vez mais devagar → agente puxa conversa (nível 1) → sugere parada (nível 2).
  4. A para de responder → nível 3 abre canal de voz com o operador do CCO.
  5. A chega ao cliente → chegada carimbada sozinha; relato por voz entra como anexo; tempo acelerado → painel mostra espera e excedente de 5h; pedido "manda mensagem pra esposa" no modo trabalho vira lembrete; na parada o agente lembra, ele grava, a esposa ouve por link (Pessoal; empresa não vê).
- **Simulado / mockado:** posição GPS, geofence do cliente e rodovia; tempo acelerado na espera; integração com rastreadores; dois "caminhões" são dois notebooks; sessões de cansaço induzidas.
- **Preexistente:** _(preencher)_
- **Maior risco técnico:** português e latência < 2 s no Conversational AI Engine (português não confirmado na página do produto).

## Validação e evolução (C5 · 10%)

- **Como testamos durante o hackathon:** 6+ testadores externos que não sabem o que dispara o alerta; cansaço induzido por tarefa paralela (conta de cabeça) vs. sessão sem tarefa; medir latência, acerto do roteamento (zero vazamento do Pessoal), eventos sem invenção, falsos positivos.
- **Limitações conhecidas:** depende de sinal de celular (nenhum produto Agora funciona offline); cansaço pela voz não detecta motorista calado sem o agente puxar conversa; não substitui o controle oficial de jornada (o registro do trecho é prova complementar de espera e ocorrências, não ponto).
- **Próximos passos:** LoRa para trechos sem cobertura; ConvoAI Device Kit na cabine (4G/eSIM); integração com rastreadores; rádio PX como fonte de eventos.
