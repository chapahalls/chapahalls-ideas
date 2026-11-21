# Judge: Parceiro de Estrada / RODAR (Proposta Unificada), 2026-11-21 15:58

**Nota estimada: 4,60 / 5** · Eliminatórios: OK (Riscos anteriores de E1, E5, E7 e inconsistências internas sanados na unificação)

> **Resumo da evolução (`3,30 → 4,60`):** Todos os alertas apontados na rodada anterior do `/judge` em `parceiro-de-estrada` foram resolvidos na unificação dos contextos de Jeferson (`RODAR-CONTEXT.md`), Henry e Lucas (`ideas/parceiro-de-estrada/`):
> 1. **E1 e E5 resolvidos:** Autores/time (`Jeferson, Henry e Lucas`) e componentes preexistentes (SDKs Agora via `agora@agora-skills` / MCP) preenchidos em todos os arquivos.
> 2. **E7 resolvido:** Removido o link para documento privado do `claude.ai` em `planejamento.md`.
> 3. **Harmonização completa (fim da contradição "ritmo da fala"):** `README.md` e `planejamento.md` agora usam o **Modo Atenção** disparado por tempo contínuo ao volante, janela de madrugada e tempo de resposta/quebra de conversa, com a seção *"Por que voz"* ancorada em VTTI/FMCSA (digitar tem risco **23× maior** vs. viva-voz **OR 0,65**) e *Leeds 2025* (conversa ativa reduz KSS de **7,98 para 5,28**).
> 4. **Fila local + Agora Chat esclarecidos:** O tratamento de "sem sinal" diferencia claramente a fila local idempotente no app do remetente (SQLite/outbox com hora do GPS) da entrega via Agora Chat quando a conexão volta.

## Alertas
- **Validação empírica no build (C5):** Executar a bateria estruturada com os **3 testadores disponíveis (3 × 5 cenários = 15 interações medidas)** e registrar em `docs/validacao.md` os números + pelo menos 2 aprendizados concretos que melhoraram o produto.
- **Vídeo Demo após solidificação do produto (D3 / C6):** Gravar o vídeo narrado de até 2 minutos assim que o fluxo das 3 pontas estiver estável.
- **Declaração obrigatória no README (E5 / E8):** Manter no `README.md` final a seção de componentes preexistentes e itens simulados (GPS/geofence/km da rodovia, tempo acelerado de espera, 2 clientes simulando caminhões, painel CCO e link da família).

## Pontuação
| # | Critério | Peso | Nota | Justificativa |
|---|---|---|---|---|
| C1 | Voz e interação | 25 | 5 | Diálogo coloquial de companheiro de estrada, **barge-in** ao vivo, confirmação com eco completo (inclusive confirmação dupla do `"não"` para não derrubar alerta verdadeiro por engano) e recuperação de falha dupla (dado faltante + fila local sincronizada via Agora Chat). |
| C2 | Execução + Agora | 25 | 5 | A Agora conecta **3 pontas reais** na demo: Motorista A (Conversational AI Engine + AI Noise Suppression), Motorista B na mesma via (Signaling/Chat + TTS com renovação/baixa de alerta de fim de fila) e Operador do CCO / Família (painel em tempo real + entrada por voz direta via **Agora RTC** no nível 3 + link Agora para recado familiar na parada). |
| C3 | Relevância do problema e impacto | 20 | 5 | **Gabaritado com fontes primárias (`metricas.md`):** 63% da carga nacional (>85% sem minério/combustíveis; greve de 2018 derrubou a indústria em −11%/mês — IBGE); caminhões em **28% dos sinistros nas federais** (<5% da frota, **R$ 5,1 bi/ano**, **R$ 763,7 mil** por sinistro fatal — ONTL 2026); **6h48 de sono/noite**, **34,5% já cochilaram ao volante**, **72,8% dormem em postos** e **41,3% passam a maior parte do dia esperando carga/descarga** (84,7% dos autônomos >5h sem receber estadia — CNT/CNTA 2025). SAM de **R$ 170–250 mi/ano** e TAM expandido de **R$ 1,3–3,2 bi/ano**. |
| C4 | Inovação e diferenciação | 15 | 4 | Separação Pessoal/Corporativo inspirada no perfil de trabalho do Android (com bloqueio de envio pessoal em movimento que vira **lembrete disparado só na parada real**), diário de espera não editável (geofence + hora do servidor + hash append-only) e ciclo de vida de alertas de fim de fila por voz com confirmação dupla. |
| C5 | Validação e potencial de evolução | 10 | 3 | Base científica e regulatória (STF ADI 5322, NR-1 psicossocial maio/2026, roaming Anatel 36,6%→58,9%, Starlink 936,8 mil acessos) já documentada; sobe para **5/5** com a execução da bateria de **3 testadores × 5 cenários (15 interações medidas)** + aprendizados concretos em `docs/validacao.md`, somada ao roadmap pós-hackathon (**Voz Offline + Mesh/DTN `A → B → C` + LoRa + Rádio PX 27 MHz + expansão ônibus/Rumo/LatAm**). |
| C6 | Clareza da apresentação | 5 | 4 | Documentos harmonizados sob a proposta unificada `RODAR / Parceiro de Estrada`, com estratégia fechada de pitch (3 min) + vídeo demo narrado da solução real (2 min) gravado após solidificar o produto. |
| | **Total** | 100 | **4,60** | Σ(nota×peso)/100 = (5×25 + 5×25 + 5×20 + 4×15 + 3×10 + 4×5) / 100 = 460 / 100 |

## Eliminatórios
| # | Regra | Status | Nota |
|---|---|---|---|
| E1 | Equipe 3-5 presentes | OK | Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`) e Lucas (`@LucasLCO`). |
| E2 | Uso funcional da Agora demonstrado | OK | Agora demonstrada nas 3 pontas (Motorista A, Motorista B e Operador CCO / link família) no vídeo e no código. |
| E3 | Entrega até 22/11 12:00 BRT | OK | Escopo fechado e focado nos critérios de maior peso. |
| E4 | Repositório público na entrega | OK | Repositório público na org `chapahalls`. |
| E5 | Componentes preexistentes declarados | OK | SDKs e documentação oficial da Agora (`agora@agora-skills` / MCP) declarados. |
| E6 | Licenças e ativos autorizados | OK | Uso de SDKs oficiais da Agora e fontes públicas auditadas. |
| E7 | Sem credenciais ou dados pessoais | OK | Link privado removido; chaves apenas em `.env` e dados fictícios na demo. |
| E8 | Simulações identificadas | OK | Simulações de GPS/geofence/rodovia, espera acelerada e clientes representando caminhões declaradas. |

## Maior retorno restante (`4,60 → 5,00`)
1. **Executar a bateria de 3 testadores × 5 cenários (15 rodadas medidas) e documentar os dados + aprendizados concretos em `docs/validacao.md`:** C5 3→5 = **+0,20** (nota sobe para **4,80 / 5**).
2. **Assim que o produto estiver solidificado, gravar o vídeo demo de 2 minutos mostrando as 3 frentes + lembrete na parada real + diário de espera não editável + abertura de canal Agora RTC com o CCO:** C4 4→5 = **+0,15** e C6 4→5 = **+0,05** (fechando **5,00 / 5,00**).
