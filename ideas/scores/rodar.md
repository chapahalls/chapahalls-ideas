# Judge: rodar, 2026-11-21 13:26

**Nota estimada: 3,90 / 5** · Eliminatórios: OK (1 RISCO de atenção em E5/E8 no README final)

## Alertas
- **Atenção técnica (Fase 1):** Validar imediatamente a latência (`< 2 s`) e a qualidade do português no **Agora Conversational AI Engine** com barge-in; manter LLM/TTS reserva trocável por variável de ambiente.
- **RISCO E5 / E8 (Declaração no README):** Lembrar de declarar explicitamente no `README.md` de entrega os dados simulados (coordenadas GPS, rodovia/km, dois clientes simulando caminhões) e os SDKs/componentes preexistentes.

## Pontuação
| # | Critério | Peso | Nota | Justificativa |
|---|---|---|---|---|
| C1 | Voz e interação | 25 | 4 | O diálogo e o roteiro de demo mostram conversa natural, interrupção ao vivo (*"Espera — acabou de ter um acidente..."*), confirmação auditiva antes de publicar e recuperação de falha (dado faltante + fila com status honesto). |
| C2 | Execução + Agora | 25 | 4 | Com a decisão de mover voz offline e rede mesh para *Próximos passos*, 100% do fluxo crítico do MVP roda sobre a Agora (Conversational AI Engine + RTC para contato CCO ↔ Motorista + Signaling/Chat para alertas em tempo real e fila + AI Noise Suppression). |
| C3 | Relevância do problema e impacto | 20 | 4 | Público e dor muito claros: ataca a solidão e a sonolência ao volante (companhia ativa na cabine + conexão com familiares e amigos), a comunicação precária com o CCO sobre a situação real da carga/atrasos e a falta de alertas em tempo real para a comunidade na mesma via. |
| C4 | Inovação e diferenciação | 15 | 4 | Unifica em uma única conversa por voz as 3 frentes (**1. Pessoal & Companhia contra sonolência**, **2. Corporativa/CCO**, **3. Comunidade na via**) com privacidade pessoal por padrão, confirmação por voz para destinos externos e ponte de voz RTC com o CCO. |
| C5 | Validação e potencial de evolução | 10 | 3 | Plano de teste com 6+ interações de outras equipes medindo latência, barge-in e zero vazamento de dados pessoais, somado a um roadmap pós-hackathon muito bem fundamentado (voz offline, Mesh/DTN `A → B → C` e rádio PX 27 MHz). |
| C6 | Clareza da apresentação | 5 | 4 | Demo path de 4 passos cabe com folga e impacto nos 2 minutos de vídeo, mostrando 2 motoristas + painel do CCO interagindo em tempo real por voz. |
| | **Total** | 100 | **3,90** | Σ(nota×peso)/100 = (4×25 + 4×25 + 4×20 + 4×15 + 3×10 + 4×5) / 100 = 390 / 100 |

## Eliminatórios
| # | Regra | Status | Nota |
|---|---|---|---|
| E1 | Equipe 3-5 presentes | OK | Jeferson, Henry e Lucas alinhados no escopo. |
| E2 | Uso funcional da Agora demonstrado | OK | Agora é o núcleo de ponta a ponta da demo (voz com IA, barge-in, alertas entre motoristas e canal RTC com o CCO). |
| E3 | Entrega até 22/11 12:00 BRT | OK | Escopo enxuto e totalmente alcançável em ~24h após o corte de LLM offline e mesh/DTN do MVP. |
| E4 | Repositório público na entrega | OK | Repositório público na org `chapahalls`. |
| E5 | Componentes preexistentes declarados | RISCO | Garantir seção explícita no `README.md` final listando SDKs e assets preexistentes. |
| E6 | Licenças e ativos autorizados | OK | Uso de SDKs oficiais da Agora. |
| E7 | Sem credenciais ou dados pessoais | OK | Chaves apenas em `.env` e dados de viagem/localização fictícios. |
| E8 | Simulações identificadas | OK | Simulações de GPS/rodovia e clientes representando caminhões já mapeadas para declaração no `README.md`. |

## Maior retorno
1. **Provar na demo ao vivo latência `< 1,5 s`, barge-in instantâneo e recuperação de falha real (ex.: fala incompleta + reconexão de evento enfileirado com atualização ao vivo no CCO):** C1 4→5 = **+0,25**.
2. **Demonstrar integração multi-produto Agora consistente (Conversational AI + Signaling/Chat + operador do CCO entrando por voz via Agora RTC no mesmo canal do motorista):** C2 4→5 = **+0,25**.
3. **Executar e documentar os resultados reais com 6+ testadores externos (latência média, taxa de acerto do roteador e zero vazamento de falas pessoais):** C5 3→4 = **+0,10**.

## Observações
- O corte de **operação offline** e **rede mesh/DTN** para a seção de *Próximos passos (P2)* subiu a nota estimada de **3,65 para 3,90**, eliminou o risco de E2/E3 e alinhou a visão arquitetural do `RODAR` com a proposta `parceiro-de-estrada` (PR #1), permitindo ao time unificar as duas frentes e partir para o `/kickoff`.
