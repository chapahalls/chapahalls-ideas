# Parceiro de Estrada — Planejamento

> Ver [`impacto-e-custos.md`](impacto-e-custos.md): o pitch abre com horas de caminhão parado; a estadia é prova e pressão sobre o recebedor.

Versão de 21/11/2026 — Documento unificado do time (`RODAR / Parceiro de Estrada`).

## Visão

**Foco Central:** **Soluciona os gargalos de comunicação manual no setor de transporte rodoviário e logística de cargas.**

Copiloto de voz para caminhoneiros e operações logísticas: substitui a comunicação manual (teclado de macros do rastreador, mensagens manuais de WhatsApp ao volante e registros manuais de fila/espera) transformando cada fala do motorista em um evento estruturado para um de três destinos — Pessoal, Corporativo ou Comunidade.

- **Problema:** o transporte rodoviário de cargas move o Brasil, e caminhões parados, tombados ou com motorista exausto são rotina. Hoje o motorista avisa o CCO digitando mensagens pré-programadas no rastreador, dirigindo.
- **Proposta:** a voz substitui o teclado, faz companhia na viagem, sugere pausa quando o cansaço aparece e avisa outros motoristas do que vem pela frente.
- **Tese de valor (Modelo estilo GitHub):** o motorista cria sua **conta pessoal gratuita na plataforma** (que é dele para sempre, preserva seus contatos pessoais e sua reputação na Comunidade mesmo se trocar de empresa) e vincula-se à **organização da transportadora (Modo Corporativo / CCO)**, que paga a assinatura B2B; a Comunidade cria o efeito de rede.
- **Como convencemos as empresas a contratar (5 Gatilhos B2B2C):**
  1. **Integração instantânea de Agregados e Autônomos (Zero Hardware):** a transportadora vincula a conta pessoal do agregado à sua Organização (CCO) na hora do embarque, sem precisar instalar teclado de macros nem câmera no caminhão terceirizado (frota TAC tem 24,4 anos de idade média).
  2. **Payback em 1 única estadia (Lei 11.442 + STF ADI 5322):** o diário não editável (geofence + hora do servidor + hash + relato por voz) prova esperas `> 5h` (84,7% hoje não recebem estadia); recuperar um único evento de 3h (~R$ 225) paga mais de 2 meses da assinatura (R$ 100/mês) e controla o passivo trabalhista de espera como jornada.
  3. **Redução de sinistros (R$ 763,7 mil) sem o custo e a rejeição de câmeras (R$ 2,8–8 mil):** corta o risco **23× maior** de digitar macros dirigindo e aciona o CCO por voz no nível 3 sem filmar o rosto do motorista (evitar 1 sinistro grave paga o contrato anual de 1.000 caminhões = R$ 420 mil).
  4. **Retenção de motoristas (88% de escassez) + Conformidade NR-1 Psicossocial (Maio/2026):** atende à exigência de gestão de riscos psicossociais (isolamento/jornada) com blindagem LGPD (empresa não vê o Modo Pessoal).
  5. **Três compradores B2B:** Transportadoras (ETC com CCO), Seguradoras/Gerenciadoras de Risco (62% dos prejuízos de carga são acidentes) e Embarcadores/Terminais Logísticos.
- **Núcleo do produto e Swap de Modos:** **Modo Pessoal** e **Modo Corporativo** são separados (com swap fluido por voz `"modo pessoal"` ⇄ `"modo corporativo"`), enquanto a frente **Comunidade / Sociedade permanece aberta e ativa nos dois modos** (o motorista recebe e reporta alertas da via estando em qualquer um dos modos).
- **ODS:** 3 (meta 3.6, mortes no trânsito); secundários 8 e 9.

## As 3 frentes

Toda fala é Pessoal por padrão; Corporativo e Comunidade só recebem fala depois de confirmação por voz. Os carimbos automáticos do Corporativo (chegada, saída, parada) não dependem de fala nem de confirmação.

| | 1. Pessoal | 2. Corporativo | 3. Comunidade |
|---|---|---|---|
| Quem lê | Só o motorista (a empresa não vê nada, nem agregado) | Transportadora (CCO) e embarcador | Caminhoneiros que vêm atrás na mesma rodovia e sentido, CCOs (sem identificar quem avisou) |
| Conteúdo | Conversa de companhia, desabafo, lembretes pessoais, recado e ligação para a família | Registro do trecho: chegada e saída no cliente, paradas, tempo de espera, avarias, ocorrências | **Fim de fila / pista parada**, acidente, interdição, óleo ou carga na pista, animal, buraco, neblina. **Sem blitz** |
| Quando | Modo Pessoal (swap por voz); no modo Corporativo só cria lembrete | Carimbos automáticos na hora (geofence + relógio do servidor); relato por voz quando o motorista quiser | Na hora; quem passa depois é perguntado se ainda está lá |
| Confirmação | Não precisa | Relato: "Vou registrar para a transportadora: avaria na lona. Confirma?" Depois de gravado, **não é editável** | "Vou avisar: acidente na BR-116, km 230, sentido norte. Confirma?" |
| Validade | Conversa livre não é gravada; só fica o que o motorista pede | Permanente e imutável, para auditoria | Expira sozinho por tipo (15 min a 24 h); renovado ou derrubado por quem passa |
| Ferramenta Agora | Conversational AI + Chat + RTC (família por link) | Conversational AI (relato) + Chat (entrega) | Signaling + Chat |
| Valor | Companhia que mantém acordado; contato com a família na hora certa (na parada) | Prova de tempo de espera (estadia > 5h, Lei 11.442) e de ocorrências | Aviso antes de chegar ao problema, sem tocar no celular |

## Pessoal: modo separado, companhia e lembretes

O Pessoal é um modo separado do Corporativo, como o perfil pessoal e o de trabalho do Android: conversa que faz companhia e mantém acordado, mais contato com a família, sem nada visível para a empresa.

**Por que existe**

- Solidão e distância da família são rotina; jornadas acima de 12h triplicam a chance de transtornos mentais comuns (Agência Brasil, 2025).
- Conversa com assistente digital reduziu sonolência e aumentou o alerta em simulador (Univ. de Nottingham, 2018; 20 participantes, 30 min, fadiga por monotonia). Indício, não prova.
- O WhatsApp no Android Auto/CarPlay já lê, responde e liga por voz: o diferencial não é "mandar WhatsApp por voz", e sim a separação dos modos, a companhia e o lembrete na parada.

**Base**

- Modelo de separação: perfil de trabalho do Android — a empresa vê e gerencia só o perfil de trabalho; apps, dados e uso pessoais não ficam visíveis; a separação é imposta pelo sistema.
- LGPD: desabafo pode conter dado de saúde (dado sensível, art. 5º II e art. 11). Por isso: conversa não gravada por padrão e transportadora nunca é controladora do Pessoal.
- NR-1: a transportadora precisa avaliar riscos psicossociais; o Pessoal **não** pode ser usado para isso.
- WhatsApp Cloud API: só número comercial (não o pessoal do motorista); fora da janela de 24h, só modelos aprovados. Telegram: bot não pode escrever primeiro. Ambos ficam como próximo passo, com aceite da família.

**Os dois modos**

| | Pessoal | Corporativo |
|---|---|---|
| Quem vê | Só o motorista | Transportadora (CCO) |
| Conversa | Livre, não gravada por padrão | Relatos confirmados, imutáveis |
| Contatos | Família e amigos | Só o CCO e contatos da operação |
| Mandar recado ou ligar para contato pessoal | Sim | **Bloqueado**: vira lembrete |
| Lembretes pessoais | Criar, ouvir, cumprir | Só criar ("me lembra de…") |
| Dados | Nunca vão para a empresa | Registro do trecho |

**Swap e Modelo de Conta (estilo GitHub)**

- **Conta do motorista + Organização da transportadora:** como no GitHub, o motorista tem sua conta pessoal própria na plataforma e atua dentro da organização da transportadora quando está no modo Corporativo.
- **Troca fluida por voz** ("modo pessoal" / "modo trabalho"): o agente confirma em que modo está.
- **Comunidade / Sociedade aberta nos dois modos:** alertas da via (fim de fila, acidente, interdição e confirmação *"ainda tá lá?"*) funcionam tanto no modo Pessoal quanto no modo Corporativo.
- Viagem em andamento abre no Corporativo; ao parar fora da pista, o agente oferece o Pessoal.
- Segurança atravessa os dois modos: cansaço nível 3 e "preciso de ajuda" chamam o CCO mesmo no Pessoal. É a única exceção, escrita no consentimento.
- Nada passa do Pessoal para o Corporativo sem o motorista pedir e confirmar.

**Ciclo de vida do lembrete**

| Etapa | Regra |
|---|---|
| Criar | No Corporativo, pedido pessoal ("manda mensagem pra minha esposa") é bloqueado e o agente oferece lembrete |
| Confirmar | Repete o conteúdo: "Te lembro de mandar mensagem pra sua esposa na próxima parada, beleza?" |
| Guardar | No Pessoal; não aparece no painel do CCO, nem que existe |
| Disparar | Na próxima parada real — parado há mais de 5 min fora da pista (posto, ponto de parada, cliente) ou motor desligado — ou ao trocar para o Pessoal. Fila parada na pista não conta |
| Cumprir | "Você pediu pra lembrar: mandar mensagem pra sua esposa. Quer gravar agora?" |
| Adiar ou descartar | "Depois" volta para a próxima parada; "esquece" apaga |
| Vários | Lidos em ordem na parada, um de cada vez |

A pausa obrigatória de 30 min a cada 5h30 (CTB 67-C) vira o momento de falar com a família: um motivo a mais para parar.

**Recado recebido da família no modo Corporativo**

| Tipo | O agente faz | Não faz |
|---|---|---|
| Comum | Segura até a próxima parada real: "Chegou um recado da sua esposa. Quer ouvir?" | Avisar ou ler dirigindo |
| Urgente (marcado pela família) | Avisa já, **sem dizer que é urgente**, e sugere parar: "Chegou um recado da sua esposa. Tem posto no km 270, uns 8 minutos daqui. Quer parar lá pra ouvir?" | Dizer "urgente", ler o conteúdo, mandar parar no acostamento |
| "Agora não" | "Beleza, te lembro na próxima parada." | Insistir |
| Urgência em excesso | Depois de 2 urgências recusadas no mesmo trecho, passa a segurar até a próxima parada | — |

Do lado da família, o link avisa que "urgente" só adianta a sugestão de parada e que, em emergência de verdade, é para ligar. O produto não é canal de emergência.

**Recado e ligação (demo):** no Pessoal, o recado é gravado e a família ouve ou atende por link no navegador (Agora RTC/Chat), para manter a Agora no caminho.

**Tom do agente: companheiro, não amigo**

Um colega de estrada experiente: fala como caminhoneiro, respeita o espaço do motorista e ajuda no trecho, sem se colocar como alguém da vida pessoal dele.

| Faz | Não faz |
|---|---|
| Fala coloquial e curta: "Fechou", "Beleza", "Tranquilo", "Parou, hein" | Declarar afeto ou saudade ("senti sua falta", "você é especial pra mim") |
| Responde ao que o motorista traz | Puxar assunto íntimo ou fazer pergunta pessoal sem motivo |
| Ouve o desabafo e devolve curto: "Pesado isso, hein." | Dar conselho de vida não pedido ou bancar terapeuta |
| Lembra da família como algo dele: "Quer mandar um áudio pra sua filha?" | Se colocar no lugar da família ou dos amigos ("pode contar comigo pra tudo") |
| Respeita o "agora não": "Beleza, fico quieto." | Insistir, cobrar atenção, chantagem emocional |
| Fala da estrada, do trecho, do tempo ao volante | Julgar, fiscalizar ou dar bronca |

- Frases curtas; o motorista manda no ritmo e pode cortar o agente a qualquer momento.
- Humor leve, sem ironia com o motorista.
- Sinal de crise: muda o tom, sugere parar e oferece o CVV (188), sem drama.

```
Motorista: Tô cansado dessa vida, cara, quase não vejo meus filhos.
Agente:    Pesado, hein. Ficar longe é o mais difícil do trecho. Quer mandar um áudio pra eles na próxima parada?
Motorista: Quero.
Agente:    Beleza, te lembro quando parar.
```

```
[modo trabalho, dirigindo]
Motorista: Manda uma mensagem pra minha esposa falando que vou atrasar.
Agente:    No modo trabalho eu não mando recado pessoal. Quer que eu te lembre na próxima parada?
Motorista: Pode ser.
Agente:    Fechou: na próxima parada te lembro de avisar sua esposa que vai atrasar.
[para no posto do km 262, motor desligado]
Agente:    Parou, hein. Você pediu pra lembrar: avisar sua esposa que vai atrasar. Quer gravar agora?
Motorista: Quero. "Amor, vou chegar umas duas horas depois, tá tudo bem."
Agente:    Mandei. Quer descansar um pouco antes de seguir?
```

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
| 1 | Tempo contínuo ao volante (ex.: >4h30), janela de madrugada ou lentidão de resposta na conversa (**Modo Atenção**) | Agente puxa conversa engajadora (reduz KSS de 7,98 para 5,28 — *Leeds 2025*) | Só o motorista |
| 2 | Sinal persiste ou aproxima-se do limite de 5h30 (CTB art. 67-C) | Agente acolhe e sugere a próxima parada segura destacando chuveiro (79%), restaurante (67,8%) e pátio vigiado (55,8%) | Só o motorista |
| 3 | Quebra de conversa / sem resposta ao agente, ou "preciso de ajuda" | Abre canal de voz direto (**Agora RTC**) com o operador | CCO |

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
- Modo Atenção (cansaço): tempo contínuo ao volante, janela de madrugada e tempo de resposta/quebra de conversa, com escalonamento em 3 níveis
- Painel CCO: fila, mapa, botão "falar", registros
- Registro do trecho não editável: carimbos automáticos (GPS simulado), relatos por voz como anexo, correção só por adendo, cálculo de espera e excedente de 5h
- Pessoal: swap por voz entre modos, envio pessoal bloqueado no Corporativo, lembrete disparado na parada real, recado/ligação para a família por link (Agora), recado recebido segurado até a parada

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
| Dom 7h | 4. Corporativo e Pessoal | Registro imutável (tentativa de editar falha; correção vira adendo), espera calculada, Pessoal isolado dos outros destinos, envio pessoal bloqueado no Corporativo, lembrete dispara só em parada real |
| Dom 9h | 5. Validação | 3 testadores × 5 cenários (15 interações medidas) + aprendizados concretos em `docs/validacao.md` |
| Dom 11h | 6. Entrega | Produto solidificado, repo com tag, gravação do vídeo demo de 2 min, 10 slides, demo ensaiada (prazo final 12h) |

A ordem segue o valor na demo: Comunidade impressiona mais e vem antes; o Pessoal reaproveita o canal de voz e o detector de parada, por isso fica por último.

## Demo, validação e entrega

**Roteiro da demo**

1. Motorista A fala "acidente no km 230"; o agente confirma e publica na Comunidade.
2. Motorista B, atrás, é avisado por voz; o evento aparece no mapa do CCO. Ao passar pelo km 230, o agente pergunta "ainda tá lá?"; B diz "não, já liberou", o agente pede confirmação, B confirma e o alerta some do painel.
3. A responde cada vez mais devagar; o agente puxa conversa (nível 1) e sugere parada (nível 2).
4. A deixa de responder; nível 3 abre o canal e o operador do CCO entra por voz.
5. A chega ao cliente: a chegada é carimbada sozinha. Ele fala "fila de 12 caminhões"; o relato entra como anexo. Tempo acelerado até a liberação: o painel mostra 5h45 de espera e 0h45 de excedente. No caminho ele tinha pedido "manda mensagem pra minha esposa" (bloqueado no modo trabalho, virou lembrete); ao parar com o motor desligado, o agente lembra, ele grava o recado e a esposa ouve pelo link. O painel "o que a empresa vê" segue vazio para o Pessoal.

**Validação**

- **3 testadores × 5 cenários padronizados (15 interações medidas no total)**, cobrindo Pessoal, Corporativo/CCO, Comunidade, barge-in e dado faltante/Modo Atenção.
- Cansaço induzido por tarefa paralela (conta de cabeça enquanto conversam), comparado com sessão sem tarefa.
- Medir: latência de resposta do agente, acerto do roteamento (zero vazamento do Pessoal), eventos extraídos sem invenção, falsos positivos de cansaço e registrar pelo menos **2 aprendizados concretos** aplicados ao produto.
- Números em `docs/validacao.md` (declarando honestamente a amostra `n = 3`); dados reais fora do repositório.

**Entrega**

- [ ] Repositório público com tag e README (planos B declarados)
- [ ] Vídeo de 2 minutos (gravado assim que o produto estiver solidificado)
- [ ] 10 slides, incluindo "próximos passos" (Voz Offline, Rede Mesh/DTN `A → B → C`, LoRa, Device Kit, rastreadores, Rádio PX)
- [ ] Demo ensaiada

## Riscos e mitigação

O maior risco técnico é a latência em português; o maior risco de produto é o motorista se sentir vigiado.

| Risco | Impacto | Mitigação |
|---|---|---|
| Português ou latência > 2 s no Conversational AI | Demo ao vivo quebra | Testar primeiro; LLM reserva trocável por variável de ambiente |
| Motorista calado (microssono é silêncio) | Cansaço não é detectado | Agente puxa conversa; tempo de resposta vira o sinal |
| Fala pessoal roteada para Corporativo ou Comunidade | Perda total de confiança | Pessoal por padrão; confirmação por voz para os outros destinos |
| Corporativo vira fiscalização | Motorista para de usar | Níveis 1 e 2 nunca saem do motorista; relato só com confirmação; o registro também protege o motorista (prova de espera) |
| Registro vendido como controle de jornada | Júri ou jurídico derruba | Dizer "prova complementar de espera e ocorrências"; jornada oficial segue no rastreador/tacógrafo |
| Carimbo depende do motorista ("cheguei") | Registro perde valor de prova | Chegada/saída por geofence e hora do servidor; voz só anexa contexto |
| Prometer "criptografado, ninguém vê" | Júri derruba | Dizer "cifrado no servidor"; o áudio passa por STT e LLM na nuvem |
| Validação circular do cansaço | Júri questiona | Testadores externos, cansaço induzido por tarefa paralela |
| Falha no nível 3 com acidente real | Responsabilidade | Posicionar como apoio, não garantia; escrito no README |
| LGPD (voz e jornada são dados do motorista) | Jurídico | Consentimento por destino; tela "o que a empresa vê" |
| Sem sinal na rodovia | Alerta não chega | Entrega adiada via Chat; LoRa como próximo passo |
| Uso do celular ao volante (CTB 252) | Multa / júri questiona | Toque zero, celular no suporte, só voz; declarado no README |
| Alerta verdadeiro derrubado por engano | Caminhão chega ao problema sem aviso | "Não" com confirmação dupla; silêncio mantém; remoção por peso |
| Alerta falso ou velho | Motorista perde confiança | Validade por tipo; "ainda está lá?" para quem passa; reputação |
| Sem usuários no trecho | Comunidade não gera alerta | Começar pela frota da transportadora |
| Empresa usa o Pessoal (NR-1, desempenho) | Produto vira vigilância; LGPD art. 11 | Conversa não gravada por padrão; transportadora nunca é controladora do Pessoal; tela "o que a empresa vê" |
| Lembrete dispara em fila parada | Motorista se distrai na pista | Só parada real: > 5 min fora da pista ou motor desligado |
| Família marca tudo como urgente | Motorista passa a ignorar sugestões de parada | Agente não diz "urgente"; após 2 recusas no trecho, segura até a parada |
| Agente vira "amigo" e cria dependência | Risco emocional; júri questiona | Tom de companheiro, sem persona afetiva; puxa o contato real com a família; CVV em sinal de crise |
| Recado pela API do WhatsApp/Telegram | Fora da Agora; limites das APIs | Demo por link Agora; WhatsApp/Telegram como próximo passo |

**Time:** Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`) e Lucas (`@LucasLCO`). Contexto unificado com [`../../RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md) e [`../rodar.md`](../rodar.md).
