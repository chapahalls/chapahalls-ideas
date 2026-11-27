# rodar-backend: o que falta, contra o que prometemos

25/11/2026 · commit verificado: `b353d12` (main de [rodarglobal/rodar-backend](https://github.com/rodarglobal/rodar-backend)).

**O que prometemos** está em [`ADR-0001`](../../docs/adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../../HACKATHON.md).

**Como conferi:**
- Li o código em `backend/app`.
- Rodei a suíte inteira num Postgres 16 local: **299 testes passaram** (27 s).
- Reconferi no código os itens da matriz do próprio repositório (`evidence/rastreabilidade.md`, de 22/11) citados aqui. Itens que eu não reconferi estão marcados.

Legenda:
- **Bloqueia:** ameaça a submissão ou o primeiro desempate (H1).
- **Promessa:** está no pitch ou no ADR e não existe.
- **Parcial:** existe, mas menor que o prometido.
- **Ok:** entregue.

## Resumo: o que fazer até 30/11 às 23h59

Depois disso, os repositórios ficam congelados até 12/12.

| # | O que falta | Por que importa | Esforço |
|---|---|---|---|
| 1 | **Demo pública estável** (deploy com URL fixa) | É requisito da submissão (S4) e o primeiro desempate. Hoje a demo depende de um túnel numa máquina ligada | Médio |
| 2 | **Links da demo e do vídeo** no README "Para o júri" | O júri avalia por eles e pode não instalar nada (item 7.4) | Baixo |
| 3 | **Números de impacto com fonte** no README | O impacto (H3) é o segundo desempate; hoje o README não cita nenhum | Baixo |
| 4 | **Um conector de mercado demonstrável** (EDI OCOREN) | O ADR-0001 vende integração e nenhum conector existe | Médio |
| 5 | **Exportação da estadia por entrega** (CSV ou JSON) | A dor do financeiro é o terceiro pilar do pitch, e hoje a estadia só aparece no painel | Baixo |

Se só der para fazer três, faça 1, 2 e 3. Sem o 4, o vídeo e o README precisam chamar integração de **roadmap**.

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Demo HTTPS no ar durante a avaliação (S4, itens 7.2 e 7.3) | **Bloqueia** | Não há config de deploy (só `docker-compose.yml`). A URL pública vem de um túnel (`make url`, `integracoes/tunel.py`), que muda a cada reinício e depende da máquina de alguém ligada | O projeto nasceu para uma demo presencial de 2 min; ninguém precisou de servidor fixo até agora |
| Links da demo e do vídeo no README | **Bloqueia** | README, linha 38: `<!-- Demo publicada e vídeo de 3 min do Hack Brasil: incluir ... antes de 30/11 -->` | Ainda não existem demo publicada nem vídeo |
| Números de impacto no "Para o júri" | **Promessa** | O README não cita 11h40, 5h09, 91% sem estadia ou portos | A pesquisa ficou no `rodar-ideas`; ninguém levou os números para o README |
| Ações da central exigem papel `cco` | **Parcial** | `settings.auth_obrigatoria = False` por padrão. O README cita JWT e papel `cco` como segurança, mas sem `AUTH_OBRIGATORIA=true` qualquer pessoa na demo pública age como CCO e dispara ligações (há limite de ligações) | Ficou desligado para a demo local não pedir login |
| Validação ponta a ponta 33/33 | **Parcial** | `evidence/validacao.md`: "LLM upstream: não (contingência)". O fluxo validado foi o de palavras-chave, não o LLM real | A validação foi rodada sem chave do LLM |
| Testes e CI | **Ok** | 299 passando (conferido) e CI com ruff + pytest | — |

## 2. Integração: o que vendemos (ADR-0001)

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Arquitetura de portas e adaptadores | **Ok** | `app/portas.py` (Protocols) + `app/integracoes/` + fakes nos testes | — |
| Adaptadores reais | **Ok, só de infraestrutura** | `agora_rest.py`, `openai_llm.py`, `twilio.py`, `tokens.py`, `tunel.py` | — |
| TMS via EDI OCOREN (Senior, TOTVS, Bsoft) | **Promessa** | Nada em `app/` (busquei `ocoren`, `proceda`, `tms`) | Decidido em 25/11 (ADR-0001), depois do código. Nenhum conector de mercado foi escopo do MVP |
| Rastreador real (Sascar, Omnilink, Autotrac) | **Promessa** | O GPS do rastreador é simulado (`scripts/simular_rota.py`, `fonte=rastreador`) | Exige contrato e API de cada fornecedor; o README declara como simulado |
| Financeiro / ERP | **Promessa** | Nenhuma saída para faturamento (ver seção 3) | Mesmo motivo do TMS |
| Gerenciadora de risco | **Promessa** | Nada | Fora do MVP |
| YMS e agendamento portuário (APS, Carga Online) | **Promessa** | Nada | Fora do MVP; é próximo passo no `PLAN.md` (Parking lot) |
| API própria para o cliente integrar | **Parcial** | Existem REST (`/rotas`, `/events`, `/tasks`), SSE (`/cco/stream`) e OpenAPI automático do FastAPI. Não há webhook de saída nem formato padrão do mercado | Feita para os dois fronts do RODAR, não para terceiros |

**Para o pitch:** "temos API e arquitetura de adaptadores" é verdade. "Integramos com TMS, rastreador e ERP" **ainda não** é.

## 3. Dor do financeiro

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Estadia pela Lei 11.442 (franquia de 5h, R$ 2,50 por t·h) | **Ok** | `dominio/estadia.py:calcular`. Usa a capacidade do veículo desde `a63909a`; sem capacidade informada, cai no peso da carga | — |
| Estadia devida por entrega, pronta para faturar | **Parcial** | Há o total (`metricas.calcular → estadia_devida_total`) e o valor por recebedor (`ranking_recebedores`). **Não há** exportação por entrega (CSV, PDF ou JSON de faturamento) com a prova anexa | O painel foi o único consumidor previsto |
| Estadia devida × **faturada/cobrada** | **Promessa** | Não existe registro de cobrança; o KPI só tem a devida (matriz AR-6.2.2) | Não havia fluxo de faturamento no MVP |
| Franquia e valor por contrato ou cliente | **Parcial** | Só globais, por variável de ambiente (`ESTADIA_FRANQUIA_H`, `ESTADIA_VALOR_T_H`); nenhum teste troca o valor | Simplificação do MVP; contratos reais variam |
| Prova que resiste a contestação | **Parcial** | Hora do servidor + GPS do celular + rastreador (simulado) + transcrição no `EventoGeo`. **Não há** registro à prova de edição (hash ou append-only), que os documentos antigos prometiam como "diário não editável" | Não priorizado; na prática, uma linha no Postgres pode ser editada |

## 4. Dor do dono e do CCO

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Aviso na aproximação ao CCO **e ao recebedor** | **Ok, com ressalva** | `rotas.on_aproximacao` → `ligacoes.ligar(motivo="aproximacao")` com `ligar_recebedor_na_aproximacao=True`. Mas `recebedor_modo="rtc"`: o recebedor atende numa **página web**, não por telefone | A ligação telefônica (SIP, plano A) está implementada e testada com mock, mas o time não tem número importado na Agora |
| Atraso na estrada avisa o recebedor com o novo horário | **Ok** | `tasks.py:252`; teste `test_atraso_na_estrada_liga_para_o_recebedor_com_novo_horario` | Era lacuna (❌) em 22/11, corrigida em `a63909a` |
| CCO só nas exceções, com escalonamento | **Parcial** | `tasks.loop_escalonamento` sobe a prioridade, mas o **canal (push → painel → ligação) é só um rótulo**: nenhum push ou ligação real é enviado à central | Push e telefonia para a central ficaram fora (declarado no README) |
| Regra de escalonamento por transportadora | **Parcial** | `RegraEscalonamento` existe, mas `tasks._regra` ignora `intervalo_s` e `acao_final` (usa `CCO_INTERVALO_S` global) e não há endpoint para editar | Só 2 dos 4 campos foram ligados |
| Motorista pede o contato da central | **Promessa** | Não há telefone do CCO no modelo nem no prompt (matriz CP-3.3c; reconferido) | Não modelado |
| Indicadores e ranking de recebedores | **Ok** | `metricas.calcular`, `ranking_recebedores` | Vários KPIs só têm teste de "a chave existe" (matriz AR-6.2.x) |

## 5. Dor do caminhoneiro e acessibilidade (o diferencial)

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Conversa por voz em tempo real, pt-BR | **Ok** | Agora ConvoAI (ASR ARES, TTS MiniMax), `/agent/start`, `/sessions` | — |
| O agente pergunta só o que falta e confirma em voz alta | **Ok** | `reportes.registrar` → `pergunte_so_isto`; chegada confirmada por voz (`test_voz_confirma_e_valida_a_chegada`) | — |
| Funciona sem LLM ou com a nuvem fora | **Ok** | `dominio/contingencia.py` (palavras-chave) | — |
| Reconhecimento de voz em cabine barulhenta e com sotaques | **Promessa (não testada)** | Nenhum teste ou evidência com áudio real; `scripts/avaliar_conversas.py` avalia texto | Exige teste com motoristas reais (planejado para 01–12/12) |
| Latência da voz | **Parcial** | `latencia_voz_ms` mede só o nosso LLM até o 1º trecho, sem ASR, TTS e rede | Medir ponta a ponta exige telemetria da Agora |
| Métrica "voz × formulário" no grupo 50+ | **Promessa** | Não existe formulário de comparação nem métrica de conclusão | É métrica de validação; depende do teste com usuários |
| GPS sem sinal gera alerta ao CCO | **Parcial (não reconferido)** | Matriz CP-3.1.1f: fica `nao_validado`, mas sem alerta | Não priorizado |

## 6. Portos

| Promessa | Estado | Por que falta |
|---|---|---|
| Registrar o tempo de pátio regulador (quem paga as 24h) | **Promessa (roadmap)** | Os documentos já dizem que depende de integração; o backend não tem conceito de pátio nem de janela portuária |
| Guiar o motorista por voz no agendamento portuário | **Promessa (roadmap)** | Depende das APIs da APS e do Carga Online |

Nada aqui precisa entrar até 30/11, mas o vídeo e os slides devem chamar portos de próximo passo.

---

## O que já está entregue e não precisa ser refeito

- Fluxo completo: rota publicada → retirada por voz → relatório inicial → aproximação (CCO + recebedor) → chegada confirmada por voz → estadia → escalonamento → resposta do recebedor → descarga.
- Estadia pela Lei 11.442 com capacidade do veículo; atraso avisa o recebedor; ranking de recebedores.
- Contingência sem LLM; LGPD (só transcrição); JWT e papel `cco` (desligados por padrão); limite de ligações.
- 299 testes e CI; README com o que é simulado e o que é de terceiros.

## Correções no nosso discurso (deck e documentos)

- "Avisa o recebedor antes da chegada": verdade, mas **pela página web (RTC)**, não por telefone. Diga isso no vídeo.
- "Validação ponta a ponta 33/33": foi com o LLM **em contingência**. Ou rode de novo com o LLM real, ou diga "com contingência".
- "512 testes": confirmei os **299 do backend**; os 127 do web e os 86 do mobile não rodei.
- "Integração com TMS, rastreador e ERP": é **roadmap** até existir o adaptador.
- "Prova não editável" (documentos antigos): hoje a prova não tem proteção contra edição. Use "prova com hora do servidor e GPS".
