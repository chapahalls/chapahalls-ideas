# rodar-backend: o que falta, contra o que prometemos

27/11/2026 · commit verificado: `7fe3475` (main de [rodarglobal/rodar-backend](https://github.com/rodarglobal/rodar-backend)). Substitui a leitura de 25/11 sobre `b353d12`; o que mudou de lá para aqui está marcado "atualizado em 27/11" nas linhas que trocaram de estado.

**Atualização 27/11 (tarde), fora do main**: infra nova na AWS (conta dev `140147589257`, OpenTofu) na branch `infra/setup-opentofu-aws` (commit `5f0a4a9`, **ainda não tem PR aberto pro main**). Isso resolve o item 1 do Resumo (banco configurado, migração rodada) só nessa branch — ver seção 1.

**O que prometemos** está em [`ADR-0001`](../../docs/adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../../HACKATHON.md).

**Como conferi:**
- Li o código em `backend/app`.
- Rodei a suíte inteira num Postgres 16 local: **377 testes passaram** (46 s). Em 25/11 eram 299; o README do repo ainda cita 332 (linha 40 de `README.md`), desatualizado — há um PR aberto (`#12`) que corrige para 379 (depois de mais 2 testes de `/health`).
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
| 1 | **Mesclar a infra AWS no main e trocar pra HTTPS** (hoje só HTTP, numa branch não mesclada) | É requisito da submissão (S4) e o primeiro desempate. A Vercel continua sem `DATABASE_URL` (500 em toda rota que toca o banco), **mas existe agora um deploy alternativo funcionando de ponta a ponta** (ECS Fargate + RDS novo, banco migrado e populado) na branch `infra/setup-opentofu-aws`, ainda sem PR pro main. Falta: abrir o PR, mesclar, e — mais importante — colocar TLS na frente (hoje é só `http://`, que o navegador bloqueia quando chamado de uma página HTTPS do GitHub Pages) — ver seção 1 | Baixo (abrir o PR) + Médio (CloudFront ou ACM na frente do ALB pra ter HTTPS) |
| 2 | **Vídeo de 3 min** no README "Para o júri" | O júri avalia por ele e pode não instalar nada (item 7.4). Os links de demo (painel e app) já existem (atualizado em 27/11); só o vídeo falta | Baixo |
| 3 | **Exportação da estadia por entrega** (CSV ou JSON) | A dor do financeiro é o terceiro pilar do pitch, e hoje a estadia só aparece no painel | Baixo |

Números de impacto (atualizado em 27/11: já estão no README, com fonte) e um conector de mercado demonstrável (atualizado em 27/11: EDI OCOREN existe, `conectores/edi/`) saíram desta lista — ver seções 1 e 2.

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Demo HTTPS no ar durante a avaliação (S4, itens 7.2 e 7.3) | **Bloqueia** (atualizado em 27/11 à tarde, troca de motivo de novo) | A Vercel ([rodar-backend-five.vercel.app](https://rodar-backend-five.vercel.app)) continua sem `DATABASE_URL`: toda rota que toca o banco devolve 500, não reconferido de novo hoje. **Mas agora existe um segundo deploy, na AWS dev (`140147589257`, us-east-1), rodando de ponta a ponta**: `http://rumolog-dev-alb-1860916568.us-east-1.elb.amazonaws.com/health` responde `{"ok":true,"banco_ok":true,"livekit_configurada":true,...}` (testado com `curl` em 27/11, 19h56 -03) — ECS Fargate (`rumolog-cluster-dev`) com RDS Postgres novo (`rumolog-dev-db`), `alembic upgrade head` + seed confirmados no log do container. Infra 100% OpenTofu, na branch `infra/setup-opentofu-aws`, **sem PR aberto pro main ainda** | Falta (a) abrir o PR e mesclar, e (b) HTTPS: o ALB só tem listener `:80`; uma página HTTPS do GitHub Pages (`rodarglobal.github.io/rodar-web`) não consegue chamar um endpoint `http://` por mixed-content block do navegador — só abrir a URL direto no navegador funciona hoje. Precisa CloudFront (TLS grátis em `*.cloudfront.net`, sem domínio próprio) ou ACM + domínio custom no ALB |
| Links da demo e do vídeo no README | **Parcial** (atualizado em 27/11) | README, linha 36: demo do painel ([rodarglobal.github.io/rodar-web](https://rodarglobal.github.io/rodar-web/)) e do app ([rodarglobal.github.io/rodar-mobile](https://rodarglobal.github.io/rodar-mobile/)) já publicadas. Só falta o vídeo: linha 44, `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->` | Links de demo foram resolvidos; o vídeo de até 3 min ainda não existe |
| Números de impacto no "Para o júri" | **Ok** (atualizado em 27/11) | README, linhas 48–52: 11h40 (IER 2025/IPTC-SETCESP), 5h09 de média em 2025, 91% dos autônomos sem estadia (CNTA 2025) e um cálculo de R$ 525/entrega e ~R$ 113 mil/mês numa frota de 50, com fonte em cada número | — |
| Ações da central exigem papel `cco` | **Ok** (atualizado em 27/11) | `settings.auth_obrigatoria = True` por padrão desde `555db92` (25/11, depois do commit lido na leitura anterior). README, linha 63: "JWT ... exigido em toda escrita (padrão)" | Era `False` por padrão quando lemos `b353d12`; a mudança já está em `main` |
| Validação ponta a ponta 33/33 | **Parcial** | `evidence/validacao.md`: "LLM upstream: não (contingência)", e é da era do provedor de voz anterior (Agora ConvoAI) — o próprio README já rotula esse link como "histórica, anterior à troca do provedor de voz". **O caminho de voz atual (LiveKit + Gemini Live) não tem nenhuma validação ponta a ponta publicada**; `scripts/validar_fluxos.py` já foi reescrito para o LiveKit, mas não há evidência de uma execução dele registrada em `evidence/` | Rodar de novo exige credenciais reais de LiveKit/Gemini (custo); não foi feito |
| Testes e CI | **Ok** | 377 passando (conferido em 27/11; eram 299 em 25/11) e CI com ruff + pytest. O README do repo ainda cita 332 no backend (desatualizado; PR `#12` corrige para 379) | — |

## 2. Integração: o que vendemos (ADR-0001)

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Arquitetura de portas e adaptadores | **Ok** | `app/portas.py` (Protocols) + `app/integracoes/` + fakes nos testes | — |
| Adaptadores reais | **Ok, só de infraestrutura** (atualizado em 27/11: trocou de provedor de voz) | `integracoes/livekit.py` (tokens, dispatch de agente, SIP — não mais `agora_rest.py`/`tokens.py`, que não existem mais no repo), `openai_llm.py`, `openai_stt.py`, `twilio.py`, `tunel.py` | — |
| TMS via EDI OCOREN (Senior, TOTVS, Bsoft) | **Ok** (atualizado em 27/11) | `conectores/edi/` (`ocoren.py`, `motor.py`, `layouts/ocoren_31.py`, `layouts/ocoren_50.py`, `codigos.py`, `nfe.py`), commit `335c827`: conector OCOREN 5.0/3.1 por perfil de parceiro, sem adapter por versão | Era "Promessa" em 25/11; já é código, com testes próprios em `tests/conectores/edi/` |
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
| Aviso na aproximação ao CCO **e ao recebedor** | **Ok, com ressalva** | `rotas.on_aproximacao` → `ligacoes.ligar(motivo="aproximacao")` com `ligar_recebedor_na_aproximacao=True`. Mas `recebedor_modo="rtc"`: o recebedor atende numa **página web**, não por telefone | A ligação telefônica (plano A, agora via trunk SIP do LiveKit — atualizado em 27/11: não é mais Agora) está implementada e testada com mock, mas o time não tem trunk/número configurado de verdade |
| Atraso na estrada avisa o recebedor com o novo horário | **Ok** | `tasks.py:252`; teste `test_atraso_na_estrada_liga_para_o_recebedor_com_novo_horario` | Era lacuna (❌) em 22/11, corrigida em `a63909a` |
| CCO só nas exceções, com escalonamento | **Parcial** (atualizado em 27/11: o 3º canal deixou de ser um rótulo) | `tasks.loop_escalonamento` sobe a prioridade; o 3º canal (`"ligacao"`) agora chama `chamadas_agente.ligar(c, rota_id, "operador", motivo)` de verdade (`c3085e3`, `tasks.py:161`), não é mais só um rótulo — cascata Twilio PSTN → sala LiveKit RTC. O 1º canal (`"push"`) continua sendo só a notificação do navegador no painel (README, linha 483: "Não há serviço de push/SMS externo"), igual já era em 25/11 | Push de verdade (FCM/SMS) para a central continua fora; a ligação do 3º canal já funciona |
| Regra de escalonamento por transportadora | **Parcial** | `RegraEscalonamento` existe, mas `tasks._regra` ignora `intervalo_s` e `acao_final` (usa `CCO_INTERVALO_S` global) e não há endpoint para editar | Só 2 dos 4 campos foram ligados |
| Motorista pede o contato da central | **Promessa** | Não há telefone do CCO no modelo nem no prompt (matriz CP-3.3c; reconferido) | Não modelado |
| Indicadores e ranking de recebedores | **Ok** | `metricas.calcular`, `ranking_recebedores` | Vários KPIs só têm teste de "a chave existe" (matriz AR-6.2.x) |

## 5. Dor do caminhoneiro e acessibilidade (o diferencial)

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Conversa por voz em tempo real, pt-BR | **Ok** (atualizado em 27/11: trocou de provedor) | **LiveKit Agents + Gemini Live** (LiveKit Inference), não mais Agora ConvoAI/ASR ARES/TTS MiniMax (`774e5c2`, "atualizado do Agora para LiveKit"); `integracoes/livekit.py`, `/agent/start`, `/sessions` | — |
| O agente pergunta só o que falta e confirma em voz alta | **Ok** | `reportes.registrar` → `pergunte_so_isto`; chegada confirmada por voz (`test_voz_confirma_e_valida_a_chegada`) | — |
| Funciona sem LLM ou com a nuvem fora | **Ok** | `dominio/contingencia.py` (palavras-chave) | — |
| Reconhecimento de voz em cabine barulhenta e com sotaques | **Promessa (não testada)** | Nenhum teste ou evidência com áudio real; `scripts/avaliar_conversas.py` avalia texto | Exige teste com motoristas reais (planejado para 01–12/12) |
| Latência da voz | **Parcial** | `latencia_voz_ms` mede só o nosso LLM até o 1º trecho, sem ASR, TTS e rede | Medir ponta a ponta exige telemetria do LiveKit/Gemini Live (atualizado em 27/11: não é mais da Agora, que não está mais no projeto) |
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
- Contingência sem LLM; LGPD (só transcrição); JWT e papel `cco` **obrigatório por padrão** desde `555db92` (atualizado em 27/11: era desligado por padrão em 25/11); limite de ligações.
- Voz em LiveKit + Gemini Live (atualizado em 27/11: trocou de provedor, `774e5c2`); conector EDI OCOREN 5.0/3.1 (atualizado em 27/11, `335c827`); 3º canal de escalonamento liga de verdade para a central (atualizado em 27/11, `c3085e3`).
- 377 testes e CI; README com o que é simulado e o que é de terceiros, e agora com números de impacto com fonte.

## Correções no nosso discurso (deck e documentos)

- "Avisa o recebedor antes da chegada": verdade, mas **pela página web (RTC)**, não por telefone. Diga isso no vídeo.
- "Validação ponta a ponta 33/33": foi com o LLM **em contingência**, e é da era do provedor de voz anterior (Agora). O caminho de voz atual (LiveKit + Gemini Live) **não tem validação ponta a ponta publicada**; rodar de novo exige credenciais reais (custo), ou diga isso explicitamente — o README já faz essa ressalva.
- "568 testes"/"512 testes": confirmei os **377 do backend** em 27/11 (era 299 em 25/11); os 127 do web e os 109 do mobile não rodei.
- "Integração com TMS, rastreador e ERP": o **TMS via EDI OCOREN já existe** (atualizado em 27/11, `conectores/edi/`); rastreador e ERP continuam **roadmap** até existir o adaptador.
- "Prova não editável" (documentos antigos): hoje a prova não tem proteção contra edição. Use "prova com hora do servidor e GPS".
- "Deploy fixo resolve a demo": a Vercel está no ar, mas sem banco configurado (ver seção 1) — ainda não é uma demo funcional por essa URL até alguém configurar `DATABASE_URL` no painel ou migrar para um host com estado persistente.
