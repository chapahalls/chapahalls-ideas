# Parceiro de Estrada — Planejamento

Versão de 21/11/2026. Fonte viva: [doc no Claude](https://claude.ai/artifact/7Gz8rWwKweRo3EWrUfP9Wa) (este arquivo é uma cópia para o time).

## Visão

Copiloto de voz para caminhoneiros: cada fala do motorista vira um evento estruturado e vai para um de três destinos — Pessoal, Corporativo ou Comunidade.

- **Problema:** o transporte rodoviário de cargas move o Brasil, e caminhões parados, tombados ou com motorista exausto são rotina. Hoje o motorista avisa o CCO digitando mensagens pré-programadas no rastreador, dirigindo.
- **Proposta:** a voz substitui o teclado, faz companhia na viagem, sugere pausa quando o cansaço aparece e avisa outros motoristas do que vem pela frente.
- **Tese de valor:** o motorista usa porque a frente Pessoal é dele; a transportadora paga pelo Corporativo e pelo CCO; a Comunidade cria o efeito de rede.
- **ODS:** 3 (meta 3.6, mortes no trânsito); secundários 8 e 9.

## As 3 frentes

Toda fala é Pessoal por padrão; Corporativo e Comunidade só recebem fala depois de confirmação por voz. Os carimbos automáticos do Corporativo (chegada, saída, parada) não dependem de fala nem de confirmação.

| | 1. Pessoal | 2. Corporativo | 3. Comunidade |
|---|---|---|---|
| Quem lê | Só o motorista | Transportadora (CCO) e embarcador | Caminhoneiros que vêm atrás na mesma rodovia e sentido, CCOs (sem identificar quem avisou) |
| Conteúdo | Histórias, família, pet, desabafo, recado para casa | Registro do trecho: chegada e saída no cliente, paradas, tempo de espera, avarias, ocorrências | **Fim de fila / pista parada**, acidente, interdição, óleo ou carga na pista, animal, buraco, neblina. **Sem blitz** |
| Quando | Conversa livre | Carimbos automáticos na hora (geofence + relógio do servidor); relato por voz quando o motorista quiser | Na hora; quem passa depois é perguntado se ainda está lá |
| Confirmação | Não precisa | Relato: "Vou registrar para a transportadora: avaria na lona. Confirma?" Depois de gravado, **não é editável** | "Vou avisar: acidente na BR-116, km 230, sentido norte. Confirma?" |
| Validade | Permanente | Permanente e imutável, para auditoria | Expira sozinho por tipo (15 min a 24 h); renovado ou derrubado por quem passa |
| Ferramenta Agora | Conversational AI + Chat | Conversational AI (relato) + Chat (entrega) | Signaling + Chat |
| Valor | Companhia, recado da família | Prova de tempo de espera (estadia > 5h, Lei 11.442) e de ocorrências | Aviso antes de chegar ao problema |

## Corporativo: registro não editável

O registro do trecho não é editável e não depende do condutor: a fala do motorista só acrescenta contexto, nunca altera hora ou local.

**Base legal**

- CTB art. 67-C: no máximo 5h30 de direção ininterrupta. Vale para todo motorista profissional, empregado (CLT) ou autônomo (TAC); jornada de 8h e horas extras (CLT art. 235-C) valem só para o empregado.
- CTB art. 67-E e Lei 13.103: jornada registrada "de maneira fidedigna"; o equipamento eletrônico deve "funcionar de forma independente de qualquer interferência do condutor, quanto aos dados registrados".
- STF, ADI 5322 (2023): tempo de espera na carga e descarga conta como jornada.
- Lei 11.442, art. 11, §5º: carga e descarga em até 5h a partir da chegada; depois disso é devida estadia por tonelada/hora. Hoje o motorista raramente consegue provar o horário de chegada (CNTA 2025: 84,7% dos que esperam mais de 5h não recebem estadia).

**Regras do registro**

| Regra | Como |
|---|---|
| Hora e local não vêm do motorista | Chegada, saída e paradas detectadas por geofence/GPS; hora do servidor, não do celular |
| Nada é apagado nem editado | Log só de inclusão (append-only); cada evento leva o hash do anterior |
| Correção = adendo | Se o motorista ou o agente errou, entra um novo evento "correção de #N"; o original continua visível |
| Fala vira anexo, não campo | Relato por voz é transcrito e anexado ao evento; não muda os carimbos |
| Sem sinal | Evento gerado no aparelho com hora do GPS, marcado "registrado offline", entregue pelo Chat quando a conexão volta |

**O que não é:** não substitui o controle oficial de jornada (rastreador/tacógrafo da transportadora). É prova complementar de espera e ocorrências.

**Quem usa:** motoristas da transportadora que contrata a ferramenta. O uso por autônomos (TAC) depende do contrato de cada empresa com eles; fora do nosso escopo.

**Exemplo**

```
14:02  CHEGADA     Cliente X, Registro/SP   (geofence, automático)
14:05  RELATO      "Fila de 12 caminhões, sem previsão"   (voz, confirmado)
19:47  LIBERAÇÃO   Início da descarga       (geofence da doca, automático)
→ Espera: 5h45  |  Excedente para estadia: 0h45
```

## Comunidade: alertas por voz entre motoristas

O motorista avisa e confirma alertas só por voz; o alerta mais valioso é o fim de fila, onde caminhões batem na traseira de quem já parou.

**Por que existe**

- Engavetamento no fim da fila: acidentes geram congestionamento e, nele, novas colisões traseiras (casos na BR-116, BR-277, BR-153). Com caminhão é pior: 1 morte a cada 6 sinistros com caminhões e ônibus nas rodovias federais, contra 1 a cada 18 com carros (PRF 2024).
- Hoje a informação da pista circula em grupos de WhatsApp (texto, vídeo, áudio) — exige pegar o celular e mistura com fake news.
- O Waze não tem perfil para caminhão e exige toque para alertar e para confirmar; a confirmação por voz é pedido aberto na caixa de sugestões do próprio Waze.

**Base legal**

- CTB art. 252: proibido dirigir segurando ou manuseando celular. O uso só por voz é zona cinzenta (há especialista que entende viva-voz como infração). Mitigação: toque zero, celular no suporte, tudo por voz. Declarado como risco.
- Blitz fica fora: o PL 5.596/2013 propõe proibir apps de alertar blitz, e o aviso vai contra o argumento de segurança do produto.

**Ciclo de vida do alerta (inspirado no Waze)**

| Regra | Como |
|---|---|
| Validade por tipo | Fim de fila 15 min · acidente 30 min · interdição 1 h · clima 1 h · buraco 24 h. Sem renovação, some sozinho |
| Quem recebe | Quem vem atrás na mesma rodovia e sentido, com antecedência para frear |
| Quem pode confirmar ou negar | Só quem passa no local, na mesma rodovia e sentido |
| Renovar | "Sim, ainda está" renova o prazo a partir daquele momento |
| Derrubar | Cada "não" confirmado soma o peso de quem respondeu; o alerta cai quando a soma iguala o peso de quem alertou. Um "não" sozinho não apaga o alerta de um motorista confiável |
| Reputação | Alertas confirmados por outros sobem o peso de quem avisou; alertas derrubados baixam |
| Anonimato | Os outros veem o evento, não quem avisou |

**Regras de confirmação por voz**

Confirmar sempre repetindo o conteúdo (tipo, km, sentido), nunca só "confirma?". Derrubar um alerta verdadeiro é o erro mais perigoso, então o "não" pede confirmação dupla; na dúvida, o alerta fica.

| Situação | O agente faz | Resultado |
|---|---|---|
| Motorista relata | "Beleza, buraco no km 230, sentido norte. É isso mesmo?" | "Sim": publica. "Não" ou silêncio: descarta |
| Responde "sim, ainda está" | "Valeu, deixei o aviso de pé." | Renova o prazo |
| Responde "não" | "Hum, então o buraco do km 230 sumiu, é isso? Me confirma aí." | Segundo "sim": conta para derrubar |
| "Não" e depois "não" ou silêncio | "Tranquilo, vou deixar o aviso lá por enquanto." | Alerta mantido |
| Resposta confusa (ruído, "sei lá") | Uma nova tentativa curta: "Tem buraco ou não tem?" | Sem resposta clara: mantém |

**Exemplo**

```
Agente:    Tinha um buraco aqui no km 230. Ainda tá na pista?
Motorista: Não.
Agente:    Hum, então o buraco do km 230 já não tá mais lá, é isso? Me confirma aí.
Motorista: Isso, tapado.
Agente:    Fechou, tirei o aviso. Valeu!
```

**Efeito de rede:** sem outro usuário no mesmo trecho e hora, não há alerta. Começar pela frota da transportadora (vários caminhões no mesmo corredor) e abrir para todos depois; isso também liga a Comunidade ao Corporativo, que é quem paga.

## Núcleo comum e roteamento

As três frentes compartilham um único pipeline: a diferença está só no destino que o roteador escolhe.

```
Motorista ⇄ Agente de voz (Convo AI) → Extrator (fala vira evento) → Roteador ─┬→ 1. Pessoal
   ▲                                                    padrão: Pessoal        ├→ 3. Comunidade
   │                                                    outros: confirma voz   └→ 2. Corporativo → Operador CCO
   └──────────────────── voz direta (RTC), só no nível 3 ──────────────────────────────────────────┘
```

## CCO e escalonamento de cansaço

O CCO só entra quando há risco real ou quando o motorista pede; cansaço comum nunca vira punição.

**O que a voz resolve que o CCO de hoje não resolve**

1. Mensagem digitada dirigindo: a voz substitui as macros do rastreador e traz contexto.
2. Excesso de alertas: o operador recebe a ocorrência já resumida e priorizada.
3. Falta de contato: operador e motorista falam no mesmo canal de voz.

| Nível | Gatilho | Ação | Quem sabe |
|---|---|---|---|
| 1 | Ritmo da fala caindo ou 4h30 ao volante | Agente puxa conversa | Só o motorista |
| 2 | Sinal persiste ou passa de 5h30 | Agente sugere a próxima parada segura | Só o motorista |
| 3 | Sem resposta ao agente, ou "preciso de ajuda" | Abre canal de voz com o operador | CCO |

- **O CCO recebe:** ocorrências estruturadas com resumo de uma linha, registro do trecho (carimbos automáticos + relatos confirmados), tempo de espera e excedente de estadia, status de jornada, escalonamentos de nível 3, eventos da Comunidade anonimizados.
- **O CCO não recebe:** nada da frente Pessoal, áudio bruto, curva de fala, sinais de nível 1 e 2.
- **Tela do operador:** fila priorizada (emergência, sinistro, atraso), mapa com veículos e eventos, botão "falar" que entra no canal do motorista, registros do dia (somente leitura, também para o operador).

## Stack Agora

Tudo roda na rede da Agora; nenhum produto dela funciona offline, então o "sem sinal" é resolvido com entrega adiada do Chat.

| Produto | Uso | Atenção |
|---|---|---|
| [Conversational AI Engine](https://www.agora.io/en/products/conversational-ai-engine/) | Copiloto de voz, interrupção, LLM próprio | Português não confirmado na página: testar ASR e TTS primeiro |
| [Signaling](https://www.agora.io/en/products/signaling/) | Alertas da Comunidade em tempo real, presença online/offline | Sem limite de tamanho de mensagem documentado na página |
| [Chat](https://www.agora.io/en/products/chat/) | Entrega quando o sinal volta; Pessoal e registro do trecho | Cifra no servidor (TLS + arquivos cifrados), não ponta a ponta |
| [RTC](https://www.agora.io/en/products/agora-rtc/) | Canal de voz operador ↔ motorista (nível 3) | — |
| [AI Noise Suppression](https://www.agora.io/en/products/ai-noise-suppression/) | Ruído da cabine | Motor e vento não citados: testar |
| [Media Services](https://www.agora.io/en/products/media-services/) | Transcrição dos relatos do registro | — |
| [Analytics](https://www.agora.io/en/products/agora-analytics/) | Opcional: qualidade de rede por trecho | — |

- [ ] Testar português no Conversational AI Engine antes de qualquer outra coisa
- [ ] Definir LLM reserva hospedado, trocável por variável de ambiente

## Escopo

O MVP é 100% online via Agora; tudo que depende de operação offline ou de hardware que não temos fica fora.

**Dentro**

- Copiloto de voz em português com interrupção
- Extrator de eventos e roteador para as 3 frentes, com confirmação por voz
- Comunidade: alerta entre dois clientes na mesma rodovia e sentido, com validade por tipo, confirmação dupla do "não" e remoção por peso
- Cansaço: tempo ao volante + ritmo da fala, escalonamento em 3 níveis
- Painel CCO: fila, mapa, botão "falar", registros
- Registro do trecho não editável: carimbos automáticos (GPS simulado), relatos por voz como anexo, correção só por adendo, cálculo de espera e excedente de 5h
- Pessoal: histórico guardado e recado para a família

**Fora (e por quê)**

| Item | Motivo |
|---|---|
| Rede mesh | Alcance de Wi-Fi/Bluetooth é de metros; caminhões ficam a km. Nenhum produto Agora suporta |
| LoRa | Sem hardware; fora do ecossistema Agora. Vai para "próximos passos" |
| Modo offline / implantação privada da Agora | Exige servidor próprio e contato com suporte |
| ConvoAI Device Kit | Só via formulário de vendas; citar como hardware do produto final |
| Câmera de fadiga e OBD | Fora da proposta de voz; já existe no mercado |
| Integração com rastreadores reais | API por fabricante; simular na demo |
| Rádio PX | Áudio ruidoso e captura exige hardware; opcional com gravações limpas, declarado no README |

## Cronograma

Cada fase só começa quando o gate da anterior passa; se a fase 1 não passar até 14h, aciona o LLM reserva.

| Prazo | Fase | Gate |
|---|---|---|
| Sáb 14h | 1. Canal de voz | Português, resposta abaixo de 2 s, interrupção, LLM reserva definido |
| Sáb 19h | 2. Comunidade | Extrator sem invenção, roteador com confirmação, alerta entre 2 clientes, "ainda está lá?" com confirmação dupla do "não" |
| Sáb 23h | 3. Cansaço e CCO | 3 níveis funcionando, sem falso positivo na sessão desperta, painel CCO |
| Dom 7h | 4. Corporativo e Pessoal | Registro imutável (tentativa de editar falha; correção vira adendo), espera calculada, Pessoal isolado dos outros destinos |
| Dom 9h | 5. Validação | 6 ou mais testadores externos, números em `docs/validacao.md` |
| Dom 11h | 6. Entrega | Repo com tag, vídeo de 2 min, 10 slides, demo ensaiada (prazo final 12h) |

A ordem segue o valor na demo: Comunidade impressiona mais e vem antes; Pessoal é só armazenamento e fica por último.

## Demo, validação e entrega

**Roteiro da demo**

1. Motorista A fala "acidente no km 230"; o agente confirma e publica na Comunidade.
2. Motorista B, atrás, é avisado por voz; o evento aparece no mapa do CCO. Ao passar pelo km 230, o agente pergunta "ainda tá lá?"; B diz "não, já liberou", o agente pede confirmação, B confirma e o alerta some do painel.
3. A responde cada vez mais devagar; o agente puxa conversa (nível 1) e sugere parada (nível 2).
4. A deixa de responder; nível 3 abre o canal e o operador do CCO entra por voz.
5. A chega ao cliente: a chegada é carimbada sozinha. Ele fala "fila de 12 caminhões"; o relato entra como anexo. Tempo acelerado até a liberação: o painel mostra 5h45 de espera e 0h45 de excedente. Ele grava um recado para a filha, que fica no Pessoal.

**Validação**

- 6 ou mais testadores externos, sem saber o que dispara o alerta.
- Cansaço induzido por tarefa paralela (conta de cabeça enquanto conversam), comparado com sessão sem tarefa.
- Medir: latência de resposta do agente, acerto do roteamento (zero vazamento do Pessoal), eventos extraídos sem invenção, falsos positivos de cansaço.
- Números em `docs/validacao.md`; dados reais fora do repositório.

**Entrega**

- [ ] Repositório público com tag e README (planos B declarados)
- [ ] Vídeo de 2 minutos
- [ ] 10 slides, incluindo "próximos passos" (LoRa, Device Kit, rastreadores)
- [ ] Demo ensaiada

## Riscos e mitigação

O maior risco técnico é a latência em português; o maior risco de produto é o motorista se sentir vigiado.

| Risco | Impacto | Mitigação |
|---|---|---|
| Português ou latência > 2 s no Conversational AI | Demo ao vivo quebra | Testar primeiro; LLM reserva trocável por variável de ambiente |
| Motorista calado (microssono é silêncio) | Cansaço não é detectado | Agente puxa conversa; tempo de resposta vira o sinal |
| Fala pessoal roteada para Corporativo ou Comunidade | Perda total de confiança | Pessoal por padrão; confirmação por voz para os outros destinos |
| Corporativo vira fiscalização | Motorista para de usar | Níveis 1 e 2 nunca saem do motorista; relato só com confirmação; o registro também protege o motorista (prova de espera) |
| Registro vendido como controle de jornada | Banca ou jurídico derruba | Dizer "prova complementar de espera e ocorrências"; jornada oficial segue no rastreador/tacógrafo |
| Carimbo depende do motorista ("cheguei") | Registro perde valor de prova | Chegada/saída por geofence e hora do servidor; voz só anexa contexto |
| Prometer "criptografado, ninguém vê" | Banca derruba | Dizer "cifrado no servidor"; o áudio passa por STT e LLM na nuvem |
| Validação circular do cansaço | Banca questiona | Testadores externos, cansaço induzido por tarefa paralela |
| Falha no nível 3 com acidente real | Responsabilidade | Posicionar como apoio, não garantia; escrito no README |
| LGPD (voz e jornada são dados do motorista) | Jurídico | Consentimento por destino; tela "o que a empresa vê" |
| Sem sinal na rodovia | Alerta não chega | Entrega adiada via Chat; LoRa como próximo passo |
| Uso do celular ao volante (CTB 252) | Multa / banca questiona | Toque zero, celular no suporte, só voz; declarado no README |
| Alerta verdadeiro derrubado por engano | Caminhão chega ao problema sem aviso | "Não" com confirmação dupla; silêncio mantém; remoção por peso |
| Alerta falso ou velho | Motorista perde confiança | Validade por tipo; "ainda está lá?" para quem passa; reputação |
| Sem usuários no trecho | Comunidade não gera alerta | Começar pela frota da transportadora |

Pendências: nome do time e integrantes.
