# Parceiro de Estrada — histórico e decisões

Resumo da conversa de brainstorm (21/11/2026, manhã) para quem não estava. Ordem cronológica: o que foi proposto, a crítica e o que ficou.

## 1. Ponto de partida

- Ideia anterior do time: agente de voz para pedidos de resgate em enchente. **Trocada** por um tema com público mais definido: caminhoneiros.
- Proposta inicial: agente de IA conversacional que faz companhia durante a viagem e detecta sono (câmera na cabine, ligação no carro/OBD, ou pela voz), mais o brief "Parceiro de Estrada": escutar o rádio PX, transformar falas em eventos (tipo, rodovia, km, sentido), responder perguntas sobre a pista e medir cansaço pelo ritmo da fala.

**Críticas e decisões**

| Proposta | Decisão | Por quê |
|---|---|---|
| Câmera de fadiga e OBD | Cortado (vai para "próximos passos") | Já existe no mercado; não usa Agora; aumenta escopo |
| Cansaço só pelo ritmo da fala | Mantido, com ajuste | Quem está pegando no sono fica **calado**; o agente precisa puxar conversa e o tempo de resposta vira o sinal |
| Validar cansaço com o time "fingindo" lentidão | Trocado | Validação circular; usar testadores externos com tarefa paralela (conta de cabeça) |
| Plano B só para o rádio | Ampliado | Faltava plano B para latência > 2 s: LLM reserva trocável por variável de ambiente |
| Rádio PX | Opcional | Áudio AM/SSB ruidoso e cheio de gíria; captura exige hardware. Se usar, gravações limpas declaradas |

## 2. Diário de bordo → "tipo RDO de obra"

- "Jarvis para o caminhoneiro" foi **descartado**: assistente genérico vira "ChatGPT com voz" e não dá para provar nada em 24h.
- **Diário de bordo** foi aceito por dar base legal ao alerta: Lei 13.103/2015 — 30 min de pausa a cada 5h30 de direção (cargas) e 11h de descanso ininterrupto, que após a ADI 5322 (STF, 2023) não pode ser fracionado. O STF também passou a contar o tempo de espera na carga/descarga como jornada. Fontes: [STF](https://noticias.stf.jus.br/?p=58525), [Diário do Transporte](https://diariodotransporte.com.br/2025/08/30/lei-do-motorista-advogado-ilo-lobel-da-luz-analisa-decisao-do-stf-sobre-jornada-e-descanso/).
- Evoluiu para um **"RDO do trecho"** (como o Relatório Diário de Obra): o agente pergunta na parada "Como foi o trecho?" e gera paradas, tempo de espera, avarias e ocorrências.
- Cuidados: não chamar de registro oficial (não vale como controle de jornada); o reporte **não** pode ser obrigatório; motivação tem que ser concreta (km rodados, tempo até chegar, recado da família), não frase de coach.

## 3. Público vs. pessoal → 3 frentes

- Ideia do time: no fim da fala, o motorista escolhe para onde vai — `work` (acidente, desvio) ou `pessoal` (família, pet), com a parte pessoal cifrada.
- Ajustes: **pessoal por padrão** e **confirmação por voz** para o resto (o pior erro é vazar algo pessoal); "cifrado" tem que ser honesto — o áudio passa por STT/LLM na nuvem e o Agora Chat cifra no servidor, não ponta a ponta.
- Virou as **3 frentes**: Pessoal, Corporativo, Comunidade (ver [`planejamento.md`](planejamento.md)).

## 4. Rede mesh / LoRa

- Proposta: rede mesh (LoRa) entre caminhões para avisar quem usa o sistema, inclusive sem sinal.
- Pesquisa nos produtos Agora (15 páginas, abaixo): **nenhum funciona offline, em LAN ou mesh**. A implantação privada do Signaling existe, mas exige servidor próprio e contato com o suporte.
- Mesh por Wi-Fi/Bluetooth alcança metros; caminhões ficam a km. LoRa precisa de hardware (ex.: ESP32 + SX1276) e fica fora da Agora (critério E2).
- **Decisão:** sem mesh/LoRa no MVP. "Sem sinal" é tratado com **entrega adiada do Agora Chat** + **Signaling** em tempo real. LoRa vai para o slide de próximos passos (um evento "work" compacto cabe num pacote LoRa — bom argumento de arquitetura).

### Produtos Agora pesquisados

| Produto | Serve? | Nota |
|---|---|---|
| Conversational AI Engine | Sim, núcleo | Custom LLM suportado; interrupção; português **não** confirmado na página |
| Agent Studio | Talvez | No-code sobre o Convo AI; SIP/telefone |
| Signaling | Sim | Tempo real, presença online/offline |
| Chat | Sim | Mensagem para destinatário offline + push; TLS e arquivos cifrados |
| RTC | Sim | Voz operador ↔ motorista |
| AI Noise Suppression | Sim | 100+ tipos de ruído, inclui trânsito |
| Media Services | Sim | Transcrição/gravação |
| Analytics | Opcional | Qualidade de rede |
| ConvoAI Device Kit | Futuro | Hardware com 4G/eSIM, wake word no aparelho; só via vendas |
| IoT SDK | Não agora | Embarcado, sem LoRa nem veículo |
| 3D Spatial Audio, Whiteboard, Marketplace | Não | Sem aplicação |
| SD-RTN | — | Rede global da Agora; sem mesh nem offline |

## 5. CCO (Centro de Controle Operacional)

- O CCO de transportadora já recebe rastreador, telemetria, cerca eletrônica. A voz só agrega se resolver: (1) motorista digitando macros dirigindo, (2) excesso de alertas para o operador, (3) falta de contato direto.
- **Escalonamento em 3 níveis**: níveis 1 e 2 ficam só com o motorista; o CCO entra no nível 3 (sem resposta ao agente, ou pedido de ajuda). Assim o cansaço não vira punição.
- Quem paga é a transportadora; quem usa é o motorista — por isso a frente Pessoal existe.

## 6. RDO aprovado pelo motorista → registro não editável

- **Problema do desenho anterior:** um RDO que o motorista aprova e edita não tem valor de prova. A Lei 13.103 / CTB art. 67-E exige que o equipamento eletrônico funcione "de forma independente de qualquer interferência do condutor, quanto aos dados registrados".
- **Onde está a dor real:** estadia. Lei 11.442 fixa 5h para carga/descarga, depois disso é devido valor por tonelada/hora; CNTA 2025: 46,1% sempre esperam 5h ou mais, 84,7% desses não recebem estadia. O gargalo é provar o horário de chegada (há caso no TJMT em que prints de WhatsApp foram contestados como prova).
- **Decisão:** o Corporativo vira registro do trecho **não editável**: chegada, saída e paradas por geofence e hora do servidor; log só de inclusão com hash encadeado; correção só por adendo; a voz só anexa relato confirmado.
- **Posicionamento:** prova complementar de espera e ocorrências, não controle de jornada (que segue no rastreador/tacógrafo).
- **Descartado:** "Como foi o trecho?" no fim da viagem como fonte principal: era relato de memória, editável, sem carimbo.
- **TAC:** o limite de 5h30 (CTB 67-C) vale para empregado e autônomo; o uso da ferramenta pelo TAC depende do contrato de cada transportadora, então fica fora do escopo.
- Fontes: [Lei 13.103](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2015/lei/l13103.htm), [CTB art. 67 comentado](https://ctbdigital.com.br/artigo/art67/), [ANTT nota técnica estadia](https://www.gov.br/antt/pt-br/assuntos/cargas/arquivos/arquivos-pagamento-do-tempo-adicional-de-carga-e-descarga/sei_31291793_nota_tecnica___antt_3335.pdf/@@download/file), [pesquisa CNTA 2025](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-trabalham-25-dias-por-mes), [TJMT](https://www.legjur.com/jurisprudencia/eme/908.2495.7726.5333).

## Pendências

- Nome do time e integrantes
- Testar português no Conversational AI Engine
- Escolher o LLM reserva
