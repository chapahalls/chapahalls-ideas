# rodar-backend: o que falta, contra o que prometemos

28/11/2026 · commit verificado: `4d01768` (main de [rodarglobal/rodar-backend](https://github.com/rodarglobal/rodar-backend)). Substitui a leitura de 27/11 sobre `7fe3475`; 27 commits de diferença. O que mudou de lá para aqui está marcado "atualizado em 28/11" nas linhas que trocaram de estado.

**Resumo das 27 commits:** a infra OpenTofu (que em 27/11 estava numa branch sem PR) foi mesclada ao main e ganhou HTTPS via CloudFront; o deploy da AWS passou a rodar pela própria CI a cada push; `/health` passou a devolver 503 com o banco fora do ar e a expor o `sha` do commit no ar; a classificação `atraso`×`fila` (etapa 3d da validação de voz) ficou determinística; a ligação ao recebedor na aproximação, que já existia no código, foi de fato ativada no ambiente público; e as falhas de voz que sobravam (4c, 5e e 5e2) ganharam correção determinística na borda das ferramentas — 4c resolvida (4/4), 5e/5e2 só parcialmente (5e falha em 3/4 e 5e2 em 4/4 — ver seção 1). Também saiu do código e do README toda menção ao júri simulado/score.md, e a contagem de testes do README foi corrigida.

**O que prometemos** está em [`ADR-0001`](../../docs/adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../../HACKATHON.md).

**Como conferi:**
- Li o diff de `7fe3475..4d01768` (27 commits) e o código atual de `backend/app`.
- Rodei a suíte inteira num Postgres 16 local (Docker Compose do próprio repo): **413 testes passaram** (51 s), `ruff check .` limpo. Bate com o README (linha 40: "413 no backend").
- Rodei `scripts/validar_fluxos.py` direto contra `https://d3fy4m7zwukr3x.cloudfront.net` (não `localhost`) 4 vezes nesta sessão, com `sha: 8b3f0d4` e depois `sha: 4d01768` no ar: 1×33/34, 3×32/34 — ver seção 1.
- `curl https://d3fy4m7zwukr3x.cloudfront.net/health` agora (28/11): `{"ok":true,"banco_ok":true,"sha":"4d01768","ligar_recebedor_na_aproximacao":true,"recebedor_modo":"rtc","twilio_configurado":false}`.
- Itens que não reconferi nesta rodada (sem commit relevante no diff `7fe3475..4d01768`, herdados da leitura de 27/11) ficam marcados "não reconferido nesta rodada".

Legenda:
- **Bloqueia:** ameaça a submissão ou o primeiro desempate (H1).
- **Promessa:** está no pitch ou no ADR e não existe.
- **Parcial:** existe, mas menor que o prometido.
- **Ok:** entregue.

## Resumo: o que fazer até 30/11 às 23h59

Depois disso, os repositórios ficam congelados até 12/12.

| # | O que falta | Por que importa | Esforço |
|---|---|---|---|
| 1 | **Fechar o falso positivo da 5e/5e2 e medir 4/4 contra a AWS** — hoje `_anexar_detalhe_sem_ferramenta`/`resposta_livre_ocorrencia` reaproveita `extrair_varios`, que grava a fala inteira no 1º campo que falta sem checar se ela responde a pergunta (um "beleza, obrigado" viraria `quantos = "beleza, obrigado"` na Task do CCO); nenhum teste cobre esse caso ainda. Além disso, em produção o LLM de verdade às vezes reusa a ocorrência de `atraso` já aberta em vez de abrir uma de `fila` separada, e às vezes chama uma ferramenta sem persistir efeito — nenhum dos dois é coberto pelo fallback atual | É o item 1 do "Maior retorno" do `score.md` de 28/11 00h17 (apontado pelo próprio judge, não só por nós). H1 preso em 8 até isso fechar | Baixo-médio (teste + filtro de confirmações curtas); o caso de reaproveitar a ocorrência errada exige decisão de prompt que a sessão anterior optou por não fazer |
| 2 | **Vídeo de 3 min** no README "Para o júri" (linha 44, ainda o placeholder `<!-- Vídeo de 3 min do Hack Brasil... -->`) | RISCO S5 nos eliminatórios, pesa em H4 | Baixo |
| 3 | **Exportação da estadia por entrega** (CSV ou JSON) | A dor do financeiro é o terceiro pilar do pitch; hoje a estadia só aparece no painel | Baixo |

Infra mesclada ao main com HTTPS (item 1 da leitura de 27/11) e validação ponta a ponta do caminho de voz atual publicada contra a AWS pública (item antigo da seção 1) saíram desta lista — ver seção 1.

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Demo HTTPS no ar durante a avaliação (S4, itens 7.2 e 7.3) | **Ok** (atualizado em 28/11: resolvido desde 27/11 à noite) | A infra OpenTofu foi mesclada ao main (`e3a8879`, `2b0eb7e`) e ganhou **CloudFront na frente do ALB** (`813d71f`): `https://d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com TLS válido no domínio compartilhado `*.cloudfront.net`, sem precisar de domínio próprio. `/health` confirmado agora com `sha: 4d01768`. A Vercel continua no ar só como espelho **temporário e sem banco**, documentado como tal no README — não é mais a demo principal | Nada; o compromisso de disponibilidade até 15/12 está em `f630043` e em `infra/README.md` |
| Links da demo e do vídeo no README | **Parcial** (sem mudança) | README linha 38: demo do painel (Vercel, `rodar-web-beta.vercel.app`) e tour em vídeo de 1 min do site/painel/app já publicados | Só falta o vídeo de até 3 min "Para o júri" (linha 44) |
| Números de impacto no "Para o júri" | **Ok** (não reconferido nesta rodada) | README linhas ~48–52 citavam fonte (IER 2025, CNTA 2025) na leitura de 27/11; nenhum commit do diff tocou essas linhas | — |
| Ações da central exigem papel `cco` | **Ok** (não reconferido nesta rodada) | `settings.auth_obrigatoria = True` por padrão desde `555db92`; nenhum commit do diff tocou isso | — |
| Validação ponta a ponta do caminho de voz atual (LiveKit + LLM real) | **Parcial** (atualizado em 28/11: antes não existia nenhuma; agora existe, publicada contra a AWS, com 1 falha mapeada e diagnosticada) | `evidence/validacao.md` (entrada de 28/11, commit `8b3f0d4`): 4 rodadas contra `https://d3fy4m7zwukr3x.cloudfront.net` com LLM e LiveKit reais. A etapa 3d (`atraso`×`fila`) e a 4c (doca/previsão do recebedor) ficaram deterministas e passaram **4/4**. A ocorrência de fila na doca continua instável: **5e falhou em 3/4 e 5e2 em 4/4**, mas agora com causa raiz em evidência de banco (rotas 12/14/16/18), não mais "o modelo esquece a ferramenta" — ver item 1 do Resumo | Falta fechar a 5e/5e2: um filtro de confirmações curtas no fallback (teste simples) e, separadamente, uma decisão de prompt para o LLM parar de reaproveitar a ocorrência `atraso` para "fila" depois da aproximação — essa segunda parte está fora do que a sessão decidiu arriscar sem medir |
| Testes e CI | **Ok** (atualizado em 28/11: eram 377 em 27/11) | 413 passando (conferido agora) + CI com ruff + pytest a cada push, builda a imagem e atualiza `api`+`voice-agent` na AWS (`25dcce7`). README já corrigido para "413 no backend, 649 no total" (era "389"/"625", desatualizado desde antes de 27/11) | — |
| `/health` expõe o commit no ar e falha (503) com o banco fora do ar | **Ok, novo** (não existia na leitura de 27/11) | `bdc14e5`: `git_sha` em `Settings`, exposto em `GET /health`; `JSONResponse(..., status_code=200 if banco else 503)`. A CI confere isso no smoke do deploy | — |
| `GET /rotas` sempre na mesma ordem | **Ok, novo** | `332205b`: `order_by(Rota.id)` — sem isso o smoke do deploy e `validar_fluxos.py` dependiam de uma ordem do Postgres não garantida | — |
| O smoke do deploy tem efeito colateral em produção | **Risco menor, não estava documentado em 27/11** | O passo "Confere /health (sha) e um GET do OCOREN" do job `deploy` em `ci.yml` chama `GET /rotas/{id}/ocoren`, que incrementa `Empresa.ultima_sequencia_ocoren` a cada deploy em produção (apontado pelo `score.md` de 28/11) | Baixo risco prático (OCOREN não é consumido por ninguém de verdade ainda), mas é sujeira que um jurado técnico pode notar |
| Comentários e README sem referência ao júri simulado/`score.md` | **Ok, novo** | `4d01768`: `main.py`, `ocorrencias.py`, `settings.py`, `rotas.py`, README (linha 93) e `evidence/validacao.md` trocaram "alerta do júri, score.md 2026-11-27" pela razão de domínio (ex.: "a demo pública precisa mostrar se a ligação na aproximação está ativa") | — |

## 2. Integração: o que vendemos (ADR-0001)

Nenhum commit do diff `7fe3475..4d01768` tocou esta área — tabela herdada da leitura de 27/11, **não reconferida nesta rodada**.

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Arquitetura de portas e adaptadores | **Ok** | `app/portas.py` (Protocols) + `app/integracoes/` + fakes nos testes | — |
| Adaptadores reais | **Ok, só de infraestrutura** | `integracoes/livekit.py`, `openai_llm.py`, `openai_stt.py`, `twilio.py`, `tunel.py` | — |
| TMS via EDI OCOREN (Senior, TOTVS, Bsoft) | **Ok** | `conectores/edi/` (`ocoren.py`, `motor.py`, `layouts/*`, `codigos.py`, `nfe.py`) | Conector OCOREN 5.0/3.1 por perfil de parceiro, sem adapter por versão |
| Rastreador real (Sascar, Omnilink, Autotrac) | **Promessa** | GPS do rastreador é simulado (`scripts/simular_rota.py`) | Exige contrato e API de cada fornecedor; README declara como simulado |
| Financeiro / ERP | **Promessa** | Nenhuma saída para faturamento (ver seção 3) | Mesmo motivo do TMS |
| Gerenciadora de risco | **Promessa** | Nada | Fora do MVP |
| YMS e agendamento portuário (APS, Carga Online) | **Promessa** | Nada | Fora do MVP; próximo passo no `PLAN.md` |
| API própria para o cliente integrar | **Parcial** | REST, SSE (`/cco/stream`) e OpenAPI automático | Feita para os dois fronts do RODAR, não para terceiros |

**Para o pitch:** "temos API e arquitetura de adaptadores" é verdade. "Integramos com TMS, rastreador e ERP" **ainda não** é.

## 3. Dor do financeiro

Nenhum commit do diff tocou esta área — **não reconferida nesta rodada**.

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Estadia pela Lei 11.442 (franquia de 5h, R$ 2,50 por t·h) | **Ok** | `dominio/estadia.py:calcular`, usa a capacidade do veículo | — |
| Estadia devida por entrega, pronta para faturar | **Parcial** | `metricas.calcular`/`ranking_recebedores` dão o total e por recebedor | Não há exportação por entrega (CSV/PDF/JSON) com a prova anexa |
| Estadia devida × **faturada/cobrada** | **Promessa** | Não existe registro de cobrança | Não havia fluxo de faturamento no MVP |
| Franquia e valor por contrato ou cliente | **Parcial** | Só globais, por variável de ambiente | Simplificação do MVP |
| Prova que resiste a contestação | **Parcial** | Hora do servidor + GPS do celular + rastreador (simulado) + transcrição | Não há registro à prova de edição (hash ou append-only) |

## 4. Dor do dono e do CCO

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Aviso na aproximação ao CCO **e ao recebedor** | **Ok, agora de fato no ar** (atualizado em 28/11: antes só o padrão do código dizia isso, o ambiente público não) | `c9c040c`: `LIGAR_RECEBEDOR_NA_APROXIMACAO=true` aplicado em [`infra/envs/dev/ecs.tf`](../../../rodar-backend/infra/envs/dev/ecs.tf) e exposto em `GET /health`. Confirmado agora: `ligar_recebedor_na_aproximacao: true` em produção | `recebedor_modo="rtc"`: o recebedor continua atendendo numa **página web**, não por telefone — o time não tem trunk/número configurado de verdade |
| Atraso na estrada avisa o recebedor com o novo horário, com a classificação certa | **Ok, reforçado** (atualizado em 28/11) | `38c765a`: `corrigir_tipo_por_estado()` corrige `fila`→`atraso` quando a rota ainda está `em_transito` (não existe fila de caminhões antes de chegar no recebedor), aplicado antes de persistir. Validado 4/4 contra a AWS com LLM real | — |
| CCO só nas exceções, com escalonamento | **Parcial** (não reconferido nesta rodada; herdado de 27/11) | `tasks.loop_escalonamento`; 3º canal liga de verdade (Twilio PSTN → LiveKit RTC) | Push de verdade (FCM/SMS) continua fora |
| Regra de escalonamento por transportadora | **Parcial** (não reconferido nesta rodada) | `RegraEscalonamento` existe, mas `tasks._regra` ignora `intervalo_s`/`acao_final` | Só 2 dos 4 campos foram ligados |
| Motorista pede o contato da central | **Promessa** (não reconferido nesta rodada) | Não há telefone do CCO no modelo nem no prompt | Não modelado |
| Indicadores e ranking de recebedores | **Ok** (não reconferido nesta rodada) | `metricas.calcular`, `ranking_recebedores` | — |
| Resposta do recebedor (doca/previsão) registrada corretamente | **Ok, novo** (atualizado em 28/11) | `8b3f0d4`: `normalizar_doca()` ("doca 4"→"4") + `extrair_doca_previsao()` (regex na transcrição da ligação quando o LLM manda `null`). Validado **4/4** contra a AWS com LLM real, confirmado no banco (`LigacaoRecebedor.doca="4"`, nunca `None`/`"doca 4"`) | Ressalva menor (apontada pelo `score.md`): se o recebedor se corrige na mesma ligação ("doca 4... não, doca 6"), a regex pega a primeira, não a última |
| Ocorrência detalhada por voz sem o LLM chamar a ferramenta (5e/5e2) | **Parcial, novo** (atualizado em 28/11) | `8b3f0d4`: `conversa._anexar_detalhe_sem_ferramenta()` anexa a fala como detalhe quando nenhuma ferramenta foi chamada no turno. **5e em 1/4 e 5e2 em 0/4 em produção** — ver item 1 do Resumo para as duas causas | Falta o filtro de confirmações curtas (risco apontado pelo judge) e uma correção pro caso em que o LLM reusa a ocorrência de `atraso` em vez de abrir uma de `fila` |

## 5. Dor do caminhoneiro e acessibilidade (o diferencial)

Nenhum commit do diff tocou esta área diretamente (fora as duas correções de voz já citadas acima) — demais linhas **não reconferidas nesta rodada**.

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Conversa por voz em tempo real, pt-BR | **Ok** | LiveKit Agents + Gemini Live; `integracoes/livekit.py`, `/agent/start`, `/sessions` | — |
| O agente pergunta só o que falta e confirma em voz alta | **Ok** | `reportes.registrar` → `pergunte_so_isto` | — |
| Funciona sem LLM ou com a nuvem fora | **Ok** | `dominio/contingencia.py` (palavras-chave); reaproveitado pelo fallback determinístico da 5e2 | — |
| Reconhecimento de voz em cabine barulhenta e com sotaques | **Promessa (não testada)** | Nenhum teste ou evidência com áudio real | Exige teste com motoristas reais |
| Latência da voz | **Parcial** | `latencia_voz_ms` mede só o nosso LLM até o 1º trecho | Medir ponta a ponta exige telemetria do LiveKit/Gemini Live |
| Métrica "voz × formulário" no grupo 50+ | **Promessa** | Não existe formulário de comparação | Depende do teste com usuários |
| GPS sem sinal gera alerta ao CCO | **Parcial (não reconferido)** | Fica `nao_validado`, mas sem alerta | Não priorizado |

## 6. Portos

Sem mudança desde 27/11.

| Promessa | Estado | Por que falta |
|---|---|---|
| Registrar o tempo de pátio regulador (quem paga as 24h) | **Promessa (roadmap)** | Backend não tem conceito de pátio nem de janela portuária |
| Guiar o motorista por voz no agendamento portuário | **Promessa (roadmap)** | Depende das APIs da APS e do Carga Online |

Nada aqui precisa entrar até 30/11, mas o vídeo e os slides devem chamar portos de próximo passo.

---

## O que já está entregue e não precisa ser refeito

- Fluxo completo: rota publicada → retirada por voz → relatório inicial → aproximação (CCO + recebedor, ligação **de fato ativa** no ambiente público) → chegada confirmada por voz → estadia → escalonamento → resposta do recebedor (doca/previsão deterministas) → descarga.
- Infra OpenTofu (ECS Fargate + RDS + CloudFront) **no main, com HTTPS** (atualizado em 28/11: estava numa branch sem PR em 27/11) — deploy automático pela própria CI a cada push.
- `/health` expõe o `sha` no ar e falha com 503 se o banco estiver fora; `GET /rotas` sempre na mesma ordem.
- Classificação `atraso`×`fila` (etapa 3d), doca/previsão do recebedor (etapa 4c) deterministas, validadas 4/4 contra a AWS com LLM e LiveKit reais.
- Estadia pela Lei 11.442 com capacidade do veículo; ranking de recebedores; contingência sem LLM; LGPD (só transcrição); JWT e papel `cco` obrigatório por padrão; limite de ligações.
- Voz em LiveKit + Gemini Live; conector EDI OCOREN 5.0/3.1; 3º canal de escalonamento liga de verdade para a central.
- 413 testes no backend (649 no total com web+mobile) e CI; README sem referência ao júri simulado, com números de impacto com fonte e com a contagem de testes corrigida.

## Correções no nosso discurso (deck e documentos)

- "Avisa o recebedor antes da chegada": verdade, **agora de fato ligado no ambiente público** (antes era só o padrão do código). Ainda é **pela página web (RTC)**, não por telefone — diga isso no vídeo.
- "Validação ponta a ponta 33/33" (documentos antigos, era do provedor de voz Agora): **superada**. A validação atual (LiveKit + LLM real, publicada em `evidence/validacao.md`) está em 32-33/34 dependendo da rodada; as etapas que falham de forma repetida são 5e (3/4) e 5e2 (4/4), ambas na ocorrência de fila na doca, com causa raiz documentada.
- "413 testes no backend, 649 no total": confirmado agora (28/11); eram 377 em 27/11 e 299 em 25/11.
- "Integração com TMS, rastreador e ERP": o **TMS via EDI OCOREN já existe**; rastreador e ERP continuam **roadmap** até existir o adaptador.
- "Prova não editável" (documentos antigos): hoje a prova não tem proteção contra edição. Use "prova com hora do servidor e GPS".
- "Deploy fixo resolve a demo": **agora sim** — a AWS (ECS + RDS + CloudFront) é a demo principal, com HTTPS e compromisso de disponibilidade escrito até 15/12. A Vercel é só o espelho temporário sem banco, documentado como tal.
