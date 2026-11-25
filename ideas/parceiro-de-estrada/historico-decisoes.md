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

- "Jarvis para o caminhoneiro" foi **descartado**: assistente genérico vira "ChatGPT com voz" e não dá para provar nada no MVP.
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
- Mesh por Wi-Fi/Bluetooth alcança metros; caminhões ficam a km. LoRa precisa de hardware (ex.: ESP32 + SX1276) e fica fora da Agora.
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

## 7. Comunidade: fim de fila, sem blitz, ciclo de vida do Waze por voz

- **Foco:** o alerta mais valioso é o fim de fila / pista parada (colisões traseiras e engavetamentos em congestionamento causado por acidente). PRF 2024: 1 morte a cada 6 sinistros com caminhões e ônibus, contra 1 a cada 18 com carros.
- **Concorrência:** grupos de WhatsApp (exigem pegar o celular, fake news) e Waze (sem perfil de caminhão, alerta e confirmação por toque; voz é pedido aberto dos usuários).
- **Descartado:** alerta de blitz — PL 5.596/2013 propõe proibir, e contradiz o argumento de segurança.
- **Notícia falsa → ciclo de vida do alerta** (modelo do Waze, por voz): validade por tipo; só quem passa no mesmo trecho e sentido confirma ou nega; "sim" renova; cada "não" soma o peso de quem respondeu e o alerta cai quando iguala o peso de quem alertou; reputação por histórico.
- **Decisão do time:** o agente sempre confirma repetindo o conteúdo, inclusive na negação ("Hum, então o buraco do km 230 sumiu, é isso? Me confirma aí."). Derrubar alerta verdadeiro é o erro mais perigoso: silêncio ou resposta confusa mantém o alerta.
- **Riscos:** CTB art. 252 (uso do celular; mitigação: toque zero) e efeito de rede (começar pela frota da transportadora).
- Fontes: [PRF via Portal do Trânsito](https://www.portaldotransito.com.br/noticias/mobilidade-e-tecnologia/transporte-de-carga/acidentes-com-caminhoes-e-onibus-causaram-tres-vezes-mais-mortes-que-veiculos-pequenos-em-2024-nas-rodovias-federais/), [Waze: duração dos alertas no Brasil](https://www.waze.com/discuss/t/duracao-dos-alertas/375087), [Waze: sugestão de confirmação por voz](https://waze.uservoice.com/forums/59223-waze-suggestion-box/suggestions/51348319-voice-confirm-or-expiry-of-reports), [PL 5.596/2013](https://tecnoblog.net/arquivo/projeto-lei-proibir-waze-cctci/), [CTB art. 252 e viva-voz](https://www.portaldotransito.com.br/?p=18067).

## 8. Pessoal: modo separado (swap), lembretes e tom de companheiro

- **Núcleo:** Pessoal + Corporativo; Comunidade vira complemento no produto, mas fica na demo (é onde a Agora mais aparece).
- **Separação:** modelo do perfil de trabalho do Android — a empresa só vê o perfil de trabalho; o pessoal não fica visível nem acessível. Troca de modo por voz; segurança (nível 3, "preciso de ajuda") atravessa os dois modos.
- **Decisão do time:** no modo Corporativo, envio pessoal é bloqueado e vira lembrete ("mandar mensagem para esposa"), disparado na próxima parada real (> 5 min fora da pista ou motor desligado).
- **Recado recebido:** comum espera a parada; urgente avisa já e sugere parada, **sem mencionar que é urgente** (decisão do time) e sem ler o conteúdo dirigindo; após 2 recusas, segura.
- **Tom (decisão do time):** coloquial, companheiro e não amigo, receptivo o bastante para adoção; sem persona afetiva; CVV (188) em sinal de crise.
- **WhatsApp/Telegram:** a Cloud API exige número comercial e, fora da janela de 24h, só modelos aprovados; bot do Telegram não pode escrever primeiro; o WhatsApp no Android Auto já faz voz. Ficam como próximo passo; na demo, família por link Agora.
- **Privacidade:** conversa livre não é gravada por padrão; desabafo pode ser dado de saúde (LGPD art. 11); Pessoal não pode servir à avaliação de riscos psicossociais da NR-1.
- Fontes: [Android work profile](https://support.google.com/work/android/answer/7502354), [WhatsApp Business Policy](https://whatsappbusiness.com/es/policy/), [Telegram bot não inicia conversa](https://www.unipile.com/telegram-api-send-message-a-comprehensive-guide/), [WhatsApp no Android Auto](https://9to5google.com/?p=723266), [Nottingham 2018](https://eprints.nottingham.ac.uk/50351), [Agência Brasil 2025](https://agenciabrasil.ebc.com.br/saude/noticia/2025-09/jornada-exaustiva-e-solidao-afetam-saude-mental-de-caminhoneiros), [LGPD art. 11](https://www.aurum.com.br/blog/lgpd-comentada/art-11-a-13-lgpd/).

## 9. Unificação de contextos (Jeferson, Henry e Lucas — RODAR / Parceiro de Estrada)

- **Convergência:** os levantamentos de arquitetura do `RODAR-CONTEXT.md` (Jeferson) e o planejamento/pesquisa de mercado de `ideas/parceiro-de-estrada/` (Henry e Lucas) foram unificados sob o nome **RODAR / Parceiro de Estrada** nas **3 frentes**: **1. Pessoal & Companhia (Modo Atenção + Família/Amigos via swap e lembrete na parada)**, **2. Corporativa (CCO + Diário de espera não editável)** e **3. Comunidade (Alertas de fim de fila/acidente na mesma via com confirmação dupla)**.
- **Offline e Mesh/DTN no Roadmap Futuro:** decisão conjunta de manter o MVP 100% focado na stack online da **Agora** (Conversational AI + RTC + Signaling/Chat + AI Noise Suppression, com fila local no remetente para oscilações curtas), movendo a operação de voz offline no Android (`whisper.cpp`/`llama.cpp`) e a rede oportunista **Mesh/DTN (`A → B → C` store-carry-forward)** para *Próximos passos (P2)* junto com LoRa e Rádio PX 27 MHz.
- **Validação e Vídeo Demo:** protocolo ajustado para a realidade do time (**3 testadores × 5 cenários = 15 interações medidas** + registro de aprendizados concretos em `docs/validacao.md`), com gravação do **vídeo demo de 2 minutos** assim que o produto estiver solidificado.

## Pendências

- **Time definido:** Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`) e Lucas (`@LucasLCO`)
- Testar português no Conversational AI Engine (Fase 1)
- Escolher o LLM reserva (Fase 1)
