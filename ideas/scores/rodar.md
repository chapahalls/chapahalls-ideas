# Judge: rodar, 2026-11-21 13:33

**Nota estimada: 4,40 / 5** · Eliminatórios: OK (Atenção documental em E5/E8 no README final)

## Alertas
- **Validação empírica no build (C5):** Executar os testes planejados com 6+ pessoas de outras equipes antes de domingo às 9h para converter o protocolo mapeado em números reais na entrega.
- **Declaração obrigatória no README (E5 / E8):** Manter a seção de componentes preexistentes (SDKs Agora) e itens simulados (GPS/km da rodovia, 2 clientes simulando caminhões e painel CCO).

## Pontuação
| # | Critério | Peso | Nota | Justificativa |
|---|---|---|---|---|
| C1 | Voz e interação | 25 | 5 | O escopo do vídeo demo e da implementação fecha todos os requisitos da nota máxima: conversa fluida (`< 1,5 s`) de companhia ativa, **barge-in** no meio da fala para reportar acidente e **recuperação de falha** dupla (cobrança de dado faltante no relato + transição honesta de fila `enfileirada → confirmada`). |
| C2 | Execução + Agora | 25 | 5 | A Agora é o coração do produto conectando **3 pontas reais** na demo: Motorista A (Conversational AI Engine + AI Noise Suppression), Motorista B na mesma via (Signaling/Chat + TTS para alertas da Comunidade) e Operador do CCO (relato detalhado + entrada por voz direta via **Agora RTC** na cabine). |
| C3 | Relevância do problema e impacto | 20 | 4 | Dor concreta e tese comercial amarrada para o mercado logístico/financeiro/segurador: o motorista usa porque a **Frente 1 (Pessoal & Companhia)** combate a solidão e aproxima da família com privacidade; a transportadora paga pela **Frente 2 (Corporativa/CCO)** para reduzir sinistros por sonolência e ter visibilidade real; a **Frente 3 (Comunidade)** gera efeito de rede. |
| C4 | Inovação e diferenciação | 15 | 4 | Entrada única por voz com **Orquestrador de Intenções** nas 3 frentes (**1. Pessoal**, **2. Corporativa/CCO**, **3. Comunidade**), privacidade pessoal por padrão (0% de vazamento para o CCO provado lado a lado), confirmação vocal para alertas externos e atuação preventiva contra sonolência. |
| C5 | Validação e potencial de evolução | 10 | 3 | Protocolo de validação com 6+ testadores externos e métricas já mapeado para a entrega (sobe para 4 ou 5 com os números coletados na Fase 5), somado ao roadmap pós-hackathon com **Voz Offline**, **Rede Mesh/DTN (`A → B → C`)** e **Rádio PX 27 MHz**. |
| C6 | Clareza da apresentação | 5 | 4 | Estratégia fechada de apresentar o pitch apoiado no **vídeo demo narrado de até 2 minutos** da solução real (cumprindo D3 e blindando contra falhas de rede no palco), mostrando as 3 pontas e as 3 frentes em 4 atos claros. |
| | **Total** | 100 | **4,40** | Σ(nota×peso)/100 = (5×25 + 5×25 + 4×20 + 4×15 + 3×10 + 4×5) / 100 = 440 / 100 |

## Eliminatórios
| # | Regra | Status | Nota |
|---|---|---|---|
| E1 | Equipe 3-5 presentes | OK | Jeferson, Henry e Lucas alinhados. |
| E2 | Uso funcional da Agora demonstrado | OK | Agora demonstrada nas 3 pontas (Motorista A, Motorista B e Operador CCO) no vídeo e no código. |
| E3 | Entrega até 22/11 12:00 BRT | OK | Escopo fechado, alcançável em ~24h e focado nos critérios de maior peso. |
| E4 | Repositório público na entrega | OK | Repositório público na org `chapahalls`. |
| E5 | Componentes preexistentes declarados | OK (map.) | Já mapeado para declaração explícita no `README.md` final. |
| E6 | Licenças e ativos autorizados | OK | Uso de SDKs oficiais da Agora. |
| E7 | Sem credenciais ou dados pessoais | OK | Chaves apenas em `.env` e dados fictícios na demo. |
| E8 | Simulações identificadas | OK (map.) | Simulações de GPS/rodovia e clientes representando caminhões mapeadas para o `README.md`. |

## Maior retorno (durante o build)
1. **Coletar e publicar os números reais dos 6+ testadores externos em `docs/validacao.md` e nos slides (latência média, barge-in e 0% de vazamento Pessoal):** C5 3→5 = **+0,20** (levando a nota potencial para **4,60 / 5**).
2. **Ensaiar a transição entre o pitch (3 min) e o vídeo demo narrado (2 min) com prova ao vivo da tese "quem usa vs. quem paga":** C6 4→5 = **+0,05** e C3 4→5 = **+0,20**.

## Observações
- Com os 4 pontos confirmados pelo time (vídeo demo real cobrindo barge-in + recuperação de falha para C1, ciclo Agora nas 3 pontas para C2, protocolo de validação mapeado para C5 e tese comercial de redução de sinistros por sonolência para C3), a proposta atinge **nota máxima projetada em C1 e C2 (os dois primeiros critérios de desempate e 50% da nota total)**.
