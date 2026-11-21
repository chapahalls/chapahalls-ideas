# Judge: RODAR / Parceiro de Estrada (Proposta Unificada), 2026-11-21 16:30

**Nota estimada (Modo Ideia): 4,75 / 5,00** · Eliminatórios da Ideia: OK  
**Tempo restante até o prazo final (22/11/2026 12:00 BRT):** **~19h30m**

## Alertas
- **Validação empírica no build (C5 — único critério ainda em 3/5 antes do código):** Executar a bateria estruturada com os **3 testadores disponíveis (3 × 5 cenários = 15 interações medidas)** e registrar em `docs/validacao.md` os números + pelo menos 2 aprendizados concretos que melhoraram o produto (`C5: 3 → 5 = +0,20`).
- **Atenção ao `scripts/check-rules.sh` para o futuro `/phase` (E7 falso-positivo):** O regex case-insensitive `sk-[A-Za-z0-9_-]{20,}` do script `scripts/check-rules.sh` está dando falso-positivo em 5 URLs dentro de `ideas/parceiro-de-estrada/` que contêm a palavra `...risk-management-...` (pois `sk-management-...` casa com `sk-`). Não há nenhuma chave vazada, mas será preciso ajustar esses 5 slugs de URL (ou usar URL curta/DOI) antes de fechar a Fase 1 no `/phase`.
- **Kickoff e Código (E2 / D4):** Como ainda estamos na fase pré-kickoff (definindo stack), o repositório ainda não tem código-fonte com SDK da Agora nem o `README.md` definitivo do projeto (que o `/kickoff` gera).

## Pontuação (Modo Ideia)
| # | Critério | Peso | Nota | Justificativa |
|---|---|---|---|---|
| C1 | Voz e interação | 25 | 5 | Diálogo coloquial de companheiro de estrada, **swap fluido de modo pela própria voz** (`"modo pessoal"` ⇄ `"modo corporativo"`), **barge-in** ao vivo, confirmação com eco completo (inclusive confirmação dupla do `"não"` para não derrubar alerta verdadeiro por engano) e recuperação de falha dupla (dado faltante + fila local sincronizada via Agora Chat). |
| C2 | Execução + Agora | 25 | 5 | A Agora conecta **3 pontas reais** na demo: Motorista A (Conversational AI Engine + AI Noise Suppression), Motorista B na mesma via (Signaling/Chat + TTS com renovação/baixa de alerta de fim de fila) e Operador do CCO / Família (painel em tempo real + entrada por voz direta via **Agora RTC** no nível 3 + link Agora para recado familiar na parada). |
| C3 | Relevância do problema e impacto | 20 | 5 | **Gabaritado com fontes primárias (`metricas.md`):** 63% da carga nacional (>85% sem minério/combustíveis; greve de 2018 derrubou a indústria em −11%/mês — IBGE); caminhões em **28% dos sinistros nas federais** (<5% da frota, **R$ 5,1 bi/ano**, **R$ 763,7 mil** por sinistro fatal — ONTL 2026); **6h48 de sono/noite**, **34,5% já cochilaram ao volante**, **72,8% dormem em postos** e **41,3% passam a maior parte do dia esperando carga/descarga** (84,7% dos autônomos >5h sem receber estadia — CNT/CNTA 2025). Benefício mensurável: voz reduz risco em **23× vs. digitar** (VTTI/FMCSA), conversa ativa reduz sonolência KSS de **7,98 para 5,28** (Leeds 2025), SAM de **R$ 170–250 mi/ano** e TAM expandido de **R$ 1,3–3,2 bi/ano**. |
| C4 | Inovação e diferenciação | 15 | 5 | **Subiu de 4 para 5/5:** O **modelo de conta inspirado no GitHub** (o caminhoneiro é dono vitalício da sua conta pessoal gratuita e vincula-se à Organização/CCO da transportadora onde trabalha) aliado ao **swap fluido por voz (`Pessoal` ⇄ `Corporativo`)** e à camada **Comunidade/Sociedade aberta nos dois modos** resolve o paradoxo de adoção do setor (privacidade do motorista + cobrança B2B na frota + efeito de rede contínuo na rodovia). Soma-se ao bloqueio de envio pessoal em movimento (que vira lembrete disparado só na parada real), ao diário de espera não editável (geofence + hora do servidor + hash append-only) e ao ciclo de alertas por voz com confirmação dupla. |
| C5 | Validação e potencial de evolução | 10 | 3 | Base científica e regulatória (STF ADI 5322, NR-1 psicossocial maio/2026, roaming Anatel 36,6%→58,9%, Starlink 936,8 mil acessos) já documentada; sobe para **5/5** com a execução da bateria de **3 testadores × 5 cenários (15 interações medidas)** + aprendizados concretos em `docs/validacao.md`, somada ao roadmap pós-hackathon (**Voz Offline + Mesh/DTN `A → B → C` + LoRa + Rádio PX 27 MHz + expansão ônibus/Rumo/LatAm**). |
| C6 | Clareza da apresentação | 5 | 4 | Tese comercial (*"GitHub do caminhoneiro: conta pessoal do motorista + organização corporativa do CCO + comunidade aberta na via"*) cristalina; sobe para **5/5** com o vídeo demo narrado de 2 minutos gravado após solidificar o produto. |
| | **Total** | 100 | **4,75** | Σ(nota×peso)/100 = (5×25 + 5×25 + 5×20 + 5×15 + 3×10 + 4×5) / 100 = 475 / 100 |

## Eliminatórios (Pré-Kickoff vs. Pré-Entrega)
| # | Regra | Status na Ideia | Status no Repo Agora (`check-rules.sh`) |
|---|---|---|---|
| E1 | Equipe 3-5 presentes | OK | Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`) e Lucas (`@LucasLCO`). |
| E2 | Uso funcional da Agora demonstrado | OK | Pendente iniciar o código no `/kickoff` (natural nesta etapa). |
| E3 | Entrega até 22/11 12:00 BRT | OK | **Faltam ~19h30m** — momento ideal para fechar a stack e rodar `/kickoff`. |
| E4 | Repositório público na entrega | OK | `github.com/chapahalls/chapahalls-ideas` público e sincronizado. |
| E5 | Componentes preexistentes declarados | OK | Declarado nas fichas; o `/kickoff` colocará a seção `## Componentes preexistentes` no `README.md` raiz. |
| E6 | Licenças e ativos autorizados | OK | Recomendado adicionar arquivo `LICENSE` (ex.: MIT) no `/kickoff`. |
| E7 | Sem credenciais ou dados pessoais | OK | Nenhum `.env` ou segredo real; limpar apenas os 5 falsos-positivos de URL `...risk-...` nos docs de pesquisa. |
| E8 | Simulações identificadas | OK | Declarado nas fichas; o `/kickoff` colocará a seção `## Simulações e mocks` no `README.md` raiz. |

## Maior retorno restante (`4,75 → 5,00`)
1. **Fechar a stack e rodar `/kickoff` para abrir a Fase 1 (Canal de voz Agora em pt-BR com barge-in e swap de modo por voz).**
2. **Executar a bateria de 3 testadores × 5 cenários (15 rodadas medidas) e documentar os dados + aprendizados concretos em `docs/validacao.md`:** C5 3→5 = **+0,20** (nota sobe para **4,95 / 5**).
3. **Assim que o produto estiver solidificado, gravar o vídeo demo de 2 minutos:** C6 4→5 = **+0,05** (fechando **5,00 / 5,00**).
