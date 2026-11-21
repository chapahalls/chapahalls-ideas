# Judge: rodar, 2026-11-21 15:25

**Nota estimada: 4,60 / 5** · Eliminatórios: OK (Atenção documental em E5/E8 no README final)

## Alertas
- **Validação empírica no build (C5):** Executar a bateria estruturada com os **3 testadores disponíveis (3 × 5 cenários = 15 interações medidas)** e registrar em `docs/validacao.md` os números + pelo menos 2 aprendizados concretos que melhoraram o produto (na rubrica oficial, nota 5 em C5 exige *"aprendizados concretos + roadmap crível"*, não tamanho grande de amostra).
- **Vídeo Demo após solidificação do produto (D3 / C6):** Gravar o vídeo narrado de até 2 minutos assim que o fluxo das 3 pontas estiver estável.
- **Declaração obrigatória no README (E5 / E8):** Manter a seção de componentes preexistentes (SDKs Agora) e itens simulados (GPS/geofence/km da rodovia, tempo acelerado de espera, 2 clientes simulando caminhões e painel CCO).

## Pontuação
| # | Critério | Peso | Nota | Justificativa |
|---|---|---|---|---|
| C1 | Voz e interação | 25 | 5 | O escopo do vídeo demo e da implementação fecha todos os requisitos da nota máxima: conversa fluida (`< 1,5 s`) de companhia ativa (Modo Atenção), **barge-in** no meio da fala para reportar acidente e **recuperação de falha** dupla (cobrança de dado faltante no relato + transição honesta de fila `enfileirada → confirmada`). |
| C2 | Execução + Agora | 25 | 5 | A Agora é o coração do produto conectando **3 pontas reais** na demo: Motorista A (Conversational AI Engine + AI Noise Suppression), Motorista B na mesma via (Signaling/Chat + TTS para alertas da Comunidade) e Operador do CCO (relato detalhado + entrada por voz direta via **Agora RTC** na cabine). |
| C3 | Relevância do problema e impacto | 20 | 5 | **Gabaritado com fontes primárias (`metricas.md`):** 63% da carga nacional (>85% sem minério/combustíveis; greve de 2018 derrubou a indústria em −11%/mês — IBGE); caminhões em **28% dos sinistros nas federais** (<5% da frota, **R$ 5,1 bi/ano**, **R$ 763,7 mil** por sinistro fatal — ONTL 2026); **6h48 de sono/noite**, **34,5% já cochilaram ao volante**, **~28% usam estimulantes**, **72,8% dormem em postos** e **41,3% passam a maior parte do dia esperando carga/descarga** (84,7% dos autônomos >5h sem receber estadia — CNT/CNTA 2025). Benefício mensurável: voz reduz risco em **23× vs. digitar** (VTTI/FMCSA), conversa interativa reduz sonolência KSS de **7,98 para 5,28** (Leeds 2025) e SAM de **R$ 170–250 mi/ano** (TAM expandido de **R$ 1,3–3,2 bi/ano**). |
| C4 | Inovação e diferenciação | 15 | 4 | Entrada única por voz com **Orquestrador de Intenções** nas 3 frentes (**1. Pessoal & Modo Atenção**, **2. Corporativa/CCO com diário de espera não editável**, **3. Comunidade na via**), privacidade pessoal por padrão (0% de vazamento para o CCO provado lado a lado) e confirmação vocal para alertas externos. |
| C5 | Validação e potencial de evolução | 10 | 3 | Base científica e regulatória (STF ADI 5322, NR-1 psicossocial maio/2026, roaming Anatel 36,6%→58,9%, Starlink 936,8 mil acessos) já documentada; com a bateria estruturada de **3 testadores × 5 cenários (15 interações medidas)** + declaração honesta de `n = 3` + registro de aprendizados concretos aplicados ao produto, sobe para **5/5** na entrega, somada ao roadmap pós-hackathon (**Voz Offline + Mesh/DTN `A → B → C` + Rádio PX 27 MHz + expansão ônibus/Rumo/LatAm**). |
| C6 | Clareza da apresentação | 5 | 4 | Narrativa macro e micro fechada com headlines verificadas, lista explícita de números proibidos ("Não usar no pitch") e estratégia de pitch (3 min) + vídeo demo narrado da solução real (2 min). |
| | **Total** | 100 | **4,60** | Σ(nota×peso)/100 = (5×25 + 5×25 + 5×20 + 4×15 + 3×10 + 4×5) / 100 = 460 / 100 |

## Eliminatórios
| # | Regra | Status | Nota |
|---|---|---|---|
| E1 | Equipe 3-5 presentes | OK | Jeferson, Henry e Lucas alinhados. |
| E2 | Uso funcional da Agora demonstrado | OK | Agora demonstrada nas 3 pontas (Motorista A, Motorista B e Operador CCO) no vídeo e no código. |
| E3 | Entrega até 22/11 12:00 BRT | OK | Escopo fechado, alcançável em ~24h e focado nos critérios de maior peso. |
| E4 | Repositório público na entrega | OK | Repositório público na org `chapahalls`. |
| E5 | Componentes preexistentes declarados | OK (map.) | Mapeado para declaração explícita no `README.md` final. |
| E6 | Licenças e ativos autorizados | OK | Uso de SDKs oficiais da Agora e fontes públicas auditadas. |
| E7 | Sem credenciais ou dados pessoais | OK | Chaves apenas em `.env` e dados fictícios na demo. |
| E8 | Simulações identificadas | OK (map.) | Simulações de GPS/geofence/rodovia, espera acelerada e clientes representando caminhões mapeadas para o `README.md`. |

## Maior retorno restante (`4,60 → 5,00`)
1. **Executar a bateria de 3 testadores × 5 cenários (15 rodadas medidas) e documentar os dados + aprendizados concretos em `docs/validacao.md`:** C5 3→5 = **+0,20** (nota sobe para **4,80 / 5**).
2. **Assim que o produto estiver solidificado, gravar o vídeo demo de 2 minutos mostrando as 3 frentes + diário de espera não editável + abertura de canal Agora RTC com o CCO:** C4 4→5 = **+0,15** e C6 4→5 = **+0,05** (fechando **5,00 / 5,00**).

## Observações
- Com a incorporação do levantamento de métricas (`ideas/parceiro-de-estrada/metricas.md`, `mercado-e-evidencias.md` e `expansao-e-por-que-agora.md`) após o merge da `main`, **C1 (25%), C2 (25%) e C3 (20%) — que juntos somam 70% da nota e são os três critérios oficiais de desempate — atingem 5/5 projetado**.
