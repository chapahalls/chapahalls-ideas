# rodar-backend: o que falta, contra o que prometemos

28/11/2026 · commit verificado: `09e6a6b` (main de [rodarglobal/rodar-backend](https://github.com/rodarglobal/rodar-backend)). Substitui a leitura de 28/11 00h55 sobre `4d01768`; 6 commits de diferença. O que mudou de lá para aqui está marcado "atualizado em 28/11 (tarde)" nas linhas que trocaram de estado.

**Resumo dos 6 commits:** a ocorrência de fila na doca (5e/5e2), que antes se fundia com o atraso aberto na estrada, agora abre uma ocorrência nova e separada — a mesma técnica determinística por estado da 3d, na direção contrária (`62076bd`); o fallback sem ferramenta parou de gravar confirmações genéricas ("beleza, obrigado") como se fossem a resposta do campo que falta (`62076bd`); saiu do código e dos testes toda referência ao júri simulado/`score.md` (`d8af042`); a doca/previsão do recebedor (4c) passou a usar a última menção da fala, não a primeira, para o caso do recebedor se corrigir na mesma ligação (`d8af042`); o smoke do deploy ganhou um `dry_run` e parou de gastar uma sequência de OCOREN de produção a cada push (`d8af042`); e o deploy passou a travar a imagem do ECS por `:<sha>` numa revision nova da task definition, em vez de reapontar a tag mutável `:latest` (`d8af042`) — a 1ª tentativa desse mecanismo falhou de forma segura (o serviço ficou na revision antiga, sem queda) por um detalhe de como o `aws-cli` lê `cli-input-json`, e foi corrigida e confirmada contra a AWS de verdade no commit seguinte (`8b303db`). Com o mecanismo novo confirmado no ar, a fila na doca foi medida 4 vezes contra a AWS pública (`a51e4e3`): **5e em 3/4 e 5e2 em 4/4** — acima do piso de 3/4, então o item 1 do Resumo anterior ("Maior retorno") está **resolvido**, com uma ressalva nova (ver seção 1). Por fim (`09e6a6b`), corrigido um exagero que o próprio README tinha sobre esse resultado (dizia "34/34" e "determinista" para a 5e, quando uma das 4 rodadas deu 33/34 e a falha que sobra não é de estado) e descartada a hipótese de a tentativa de medição descartada ter sido causada por um `5xx` da API (conferido nos logs do CloudWatch: todas as 22 chamadas a `GET /ligacoes` da sessão devolveram 200).

**O que prometemos** está em [`ADR-0001`](../../docs/adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../../HACKATHON.md).

**Como conferi:**
- Li o diff de `4d01768..09e6a6b` (6 commits) e o código atual de `backend/app`, em especial `dominio/ocorrencias.py` (`indica_fila_na_doca`, `deve_abrir_fila_separada`).
- Rodei a suíte inteira num Postgres 16 local (Docker Compose do próprio repo): **425 testes passaram**, `ruff check .` limpo. Bate com o README (linha 40: "425 no backend, 661 no total").
- Rodei `scripts/validar_fluxos.py` direto contra `https://d3fy4m7zwukr3x.cloudfront.net` (não `localhost`) 4 vezes nesta sessão, com `sha: 8b303db` no ar (confirmado antes da 4ª medição): 3×34/34, 1×33/34 (falha isolada na 5e) — ver seção 1. Uma 5ª tentativa, antes da 1ª rodada válida, quebrou com `TypeError` num `GET /ligacoes`; descartada.
- Conferi direto no banco de produção (`GET /eventos?rota_id=...`) os eventos `ocorrencia`/`ocorrencia_detalhada` das 4 rotas usadas, incluindo a causa raiz da única falha.
- Conferi nos logs do CloudWatch (`/ecs/rumolog-dev/api`) se a tentativa descartada foi causada por um `5xx` da API: as 22 chamadas a `GET /ligacoes`/`GET /ligacoes/{id}` na janela da sessão (as 4 rodadas + a tentativa descartada) devolveram todas `200` — não foi a API.
- Acompanhei os deploys das duas rodadas de documentação (`a51e4e3`, `09e6a6b`) pela CI (`gh run watch`, job `deploy` verde) e confirmei `curl .../health` → `sha` de cada um depois.
- Itens que não reconferi nesta rodada (sem commit relevante no diff `4d01768..09e6a6b`, herdados da leitura anterior) ficam marcados "não reconferido nesta rodada".

Legenda:
- **Bloqueia:** ameaça a submissão ou o primeiro desempate (H1).
- **Promessa:** está no pitch ou no ADR e não existe.
- **Parcial:** existe, mas menor que o prometido.
- **Ok:** entregue.

## Resumo: o que fazer até 30/11 às 23h59

Depois disso, os repositórios ficam congelados até 12/12.

| # | O que falta | Por que importa | Esforço |
|---|---|---|---|
| 1 | **Vídeo de 3 min** no README "Para o júri" (linha 44, ainda o placeholder `<!-- Vídeo de 3 min do Hack Brasil... -->`) | RISCO S5 nos eliminatórios, pesa em H4 | Baixo |
| 2 | **Exportação da estadia por entrega** (CSV ou JSON) | A dor do financeiro é o terceiro pilar do pitch; hoje a estadia só aparece no painel | Baixo |
| 3 | **Dois casos novos de falso-positivo/falso-negativo na fila da doca** (achados nesta rodada, não corrigidos: ver seção 1) — "não tem fila" casa com `_FILA_NA_DOCA` (`\bfila\b`) e abriria uma ocorrência indevida; e se o atraso da estrada já foi encerrado antes de "tem fila" chegar, `deve_abrir_fila_separada` não dispara (exige `tipo_aberto == "atraso"`) e a fala cai no fallback genérico sem teste cobrindo o caso | Mesma categoria do item 1 anterior, mas menor: nenhum dos dois apareceu nas 4 rodadas medidas contra a AWS, são achados de leitura de código, não falhas observadas | Baixo (negação: checar `não` antes da palavra; atraso-já-fechado: decidir o comportamento certo com teste) |

A fila na doca que se fundia com o atraso (item 1 do Resumo anterior, "Maior retorno" do `score.md`) saiu desta lista: medida 4/4 e 3/4 contra a AWS, acima do piso — ver seção 1.

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Demo HTTPS no ar durante a avaliação (S4, itens 7.2 e 7.3) | **Ok** (não reconferido nesta rodada; sem mudança desde 28/11 00h55) | `https://d3fy4m7zwukr3x.cloudfront.net/health` responde 200 com TLS válido; confirmado agora com `sha: 09e6a6b` | — |
| Links da demo e do vídeo no README | **Parcial** (sem mudança) | README linha 38: demo do painel (Vercel) e tour em vídeo de 1 min já publicados | Só falta o vídeo de até 3 min "Para o júri" (linha 44) |
| Deploy trava a imagem do ECS por `:sha`, não mais por `:latest` mutável | **Ok, novo** (atualizado em 28/11 tarde) | `d8af042`: a CI lê a task definition em uso, troca o campo `image` do container pra `:<sha deste commit>` e registra uma revision nova (`ecs:RegisterTaskDefinition`), em vez de só repintar a tag `:latest` no ECR. `aws_ecs_service.api`/`voice_agent` ganharam `lifecycle.ignore_changes=[task_definition]` em `ecs.tf`, pra um `tofu apply` não devolver o serviço pra revision antiga. A 1ª tentativa (ainda em `d8af042`) falhou com `ParamValidation` ao ler o JSON de `file:///dev/stdin`; o serviço **ficou seguro na revision anterior**, sem queda. Corrigido em `8b303db` (JSON como string literal numa variável de shell, testado contra a AWS de verdade antes do push) e confirmado em mais dois deploys seguidos (`a51e4e3`, `09e6a6b`): CI verde, `/health` e `aws ecs describe-services` mostram a imagem certa (`:8b303db` → `:a51e4e3` → `:09e6a6b`) nos dois serviços, sempre travada no sha do commit | `ecs:RegisterTaskDefinition`/`ecs:DescribeTaskDefinition` só aceitam `resource="*"` na AWS — não tem como restringir por família de task; documentado em `infra/envs/dev/ci.tf` e em `decisoes.md` |
| O smoke do deploy tem efeito colateral em produção | **Ok, resolvido** (atualizado em 28/11 tarde; era "Risco menor" em 28/11 00h55) | `d8af042`: `GET /rotas/{id}/ocoren` ganhou `dry_run=true`, usado pelo smoke do `ci.yml` — devolve o arquivo sem incrementar `Empresa.ultima_sequencia_ocoren`. Teste novo confere que `dry_run` não consome a sequência | — |
| Números de impacto no "Para o júri" | **Ok** (não reconferido nesta rodada) | README linhas ~48–52 citam fonte (IER 2025, CNTA 2025); nenhum commit do diff tocou essas linhas | — |
| Ações da central exigem papel `cco` | **Ok** (não reconferido nesta rodada) | `settings.auth_obrigatoria = True` por padrão; nenhum commit do diff tocou isso | — |
| Validação ponta a ponta do caminho de voz atual (LiveKit + LLM real) | **Ok, resolvido o item 1 do Resumo anterior** (atualizado em 28/11 tarde) | `evidence/validacao.md` (entrada de 28/11 09h11, commit `8b303db`): 4 rodadas contra `https://d3fy4m7zwukr3x.cloudfront.net` com LLM e LiveKit reais, já com `62076bd`/`d8af042`/`8b303db` no ar. **3d, 4c e 5e2 em 4/4; 5e em 3/4** — acima do piso de 3/4 pedido, caminho inteiro estável. A única falha (rodada 4) tem causa raiz diferente da que esta correção atacou: confirmado no banco (rota 27) que o LLM não chamou nenhuma ferramenta na 1ª fala da fila ("Tem uma fila de caminhões aqui na portaria"), só na 2ª — a fila abriu separada e detalhada corretamente, um turno depois do que a etapa 5e exige. A linha do README sobre esse resultado exagerava ("34/34", "determinista" pra 5e); corrigida em `09e6a6b` pra "3 de 4 rodadas em 34/34, 1 em 33/34" e deixando claro que a falha que sobra é de o LLM não chamar ferramenta, não de estado da rota | Resta a mesma variabilidade do LLM de não chamar ferramenta na 1ª fala ambígua — é comportamento de modelo, não de estado da rota; ver também os dois casos novos do item 3 do Resumo (negação e atraso-já-fechado), achados de leitura de código, ainda sem teste nem correção |
| Testes e CI | **Ok** (atualizado em 28/11 tarde: eram 413) | 425 passando (conferido agora) + CI com ruff + pytest a cada push, builda a imagem e atualiza `api`+`voice-agent` na AWS numa revision nova travada por `:sha`. README já corrigido para "425 no backend, 661 no total" | — |
| `/health` expõe o commit no ar e falha (503) com o banco fora do ar | **Ok** (não reconferido nesta rodada) | `git_sha` em `Settings`, exposto em `GET /health` | — |
| `GET /rotas` sempre na mesma ordem | **Ok** (não reconferido nesta rodada) | `order_by(Rota.id)` | — |
| Comentários e README sem referência ao júri simulado/`score.md` | **Ok, reforçado** (atualizado em 28/11 tarde) | `d8af042`: mais 6 arquivos de teste, `infra/README.md` e `docs/edi/ocoren-integracao.md` trocaram a referência ao júri/`score.md` pela razão de domínio real de cada teste/comentário (a seção "Para o júri" do README, endereçada ao júri do Hack Brasil, ficou de fora — não é uma autorreferência ao relatório) | — |

## 2. Integração: o que vendemos (ADR-0001)

Nenhum commit do diff `4d01768..09e6a6b` tocou esta área — tabela herdada, **não reconferida nesta rodada**.

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
| Aviso na aproximação ao CCO **e ao recebedor** | **Ok** (não reconferido nesta rodada) | `LIGAR_RECEBEDOR_NA_APROXIMACAO=true` em produção; `ligar_recebedor_na_aproximacao: true` em `/health` | `recebedor_modo="rtc"`: o recebedor continua atendendo numa **página web**, não por telefone |
| Atraso na estrada avisa o recebedor com o novo horário, com a classificação certa | **Ok** (não reconferido nesta rodada) | `38c765a`: `corrigir_tipo_por_estado()`. Validado 4/4 contra a AWS com LLM real | — |
| CCO só nas exceções, com escalonamento | **Parcial** (não reconferido nesta rodada) | `tasks.loop_escalonamento`; 3º canal liga de verdade (Twilio PSTN → LiveKit RTC) | Push de verdade (FCM/SMS) continua fora |
| Regra de escalonamento por transportadora | **Parcial** (não reconferido nesta rodada) | `RegraEscalonamento` existe, mas `tasks._regra` ignora `intervalo_s`/`acao_final` | Só 2 dos 4 campos foram ligados |
| Motorista pede o contato da central | **Promessa** (não reconferido nesta rodada) | Não há telefone do CCO no modelo nem no prompt | Não modelado |
| Indicadores e ranking de recebedores | **Ok** (não reconferido nesta rodada) | `metricas.calcular`, `ranking_recebedores` | — |
| Resposta do recebedor (doca/previsão) registrada corretamente | **Ok, reforçado** (atualizado em 28/11 tarde) | `normalizar_doca()` + `extrair_doca_previsao()`. Desde `d8af042`, usa `re.findall(...)[-1]`: se o recebedor se corrige na mesma ligação ("não é a doca 2, é a doca 4"), vale a última doca dita, não a primeira — a ressalva que estava aberta na leitura anterior. Validado 4/4 contra a AWS | — |
| Ocorrência de fila na doca (depois da chegada) separada do atraso da estrada | **Ok, resolvido** (atualizado em 28/11 tarde; era "Parcial" na leitura anterior) | `62076bd`: `indica_fila_na_doca()`/`deve_abrir_fila_separada()` — depois que a rota chega (`no_destino`), se há um `atraso` aberto e a fala indica fila, abre uma ocorrência `fila` nova e fecha o `atraso`, em vez de anexar o detalhe no atraso. Medido 4/4 contra a AWS (a fila nunca mais se fundiu com o atraso nas 4 rodadas) | Dois casos novos achados na leitura de código desta rodada, ainda sem teste: (a) `_FILA_NA_DOCA` (`\bfila\b`) também casa com "não tem fila" — falso positivo de negação; (b) `deve_abrir_fila_separada` exige `tipo_aberto == "atraso"`, então se o atraso já tiver sido encerrado antes de "tem fila" chegar, a fala cai no fallback genérico sem abrir a fila nova. Nenhum dos dois apareceu nas 4 rodadas medidas — achados de leitura, não falhas observadas |
| Fallback sem ferramenta não grava confirmação genérica como resposta do campo | **Ok, novo** (atualizado em 28/11 tarde) | `62076bd`: `resposta_livre_ocorrencia` só anexa a fala como detalhe se casar com o padrão do campo (`_DETECTA`), tiver número, duração ou um sim/não explícito — "ok"/"beleza"/"obrigado"/"tô chegando" são descartados (um teste por fala). Antes, "beleza, obrigado" virava `quantos = "beleza, obrigado"` na Task do CCO | — |

## 5. Dor do caminhoneiro e acessibilidade (o diferencial)

Nenhum commit do diff tocou esta área diretamente — **não reconferida nesta rodada**.

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

Sem mudança.

| Promessa | Estado | Por que falta |
|---|---|---|
| Registrar o tempo de pátio regulador (quem paga as 24h) | **Promessa (roadmap)** | Backend não tem conceito de pátio nem de janela portuária |
| Guiar o motorista por voz no agendamento portuário | **Promessa (roadmap)** | Depende das APIs da APS e do Carga Online |

Nada aqui precisa entrar até 30/11, mas o vídeo e os slides devem chamar portos de próximo passo.

---

## O que já está entregue e não precisa ser refeito

- Fluxo completo: rota publicada → retirada por voz → relatório inicial → aproximação (CCO + recebedor, ligação de fato ativa) → chegada confirmada por voz → estadia → escalonamento → resposta do recebedor (doca/previsão deterministas, última menção vale) → ocorrência de fila na doca separada do atraso da estrada → descarga.
- Infra OpenTofu (ECS Fargate + RDS + CloudFront) no main, com HTTPS — deploy automático pela própria CI a cada push, travando a imagem do ECS por `:<sha>` numa revision nova (não mais a tag mutável `:latest`).
- `/health` expõe o `sha` no ar e falha com 503 se o banco estiver fora; `GET /rotas` sempre na mesma ordem; o smoke do deploy (`GET /rotas/{id}/ocoren?dry_run=true`) não tem mais efeito colateral em produção.
- Classificação `atraso`×`fila` na estrada (3d), doca/previsão do recebedor com a última menção (4c) e fila na doca separada do atraso (5e/5e2) deterministas por estado da rota, validadas 4/4, 4/4 e 3-4/4 contra a AWS com LLM e LiveKit reais.
- Estadia pela Lei 11.442 com capacidade do veículo; ranking de recebedores; contingência sem LLM; LGPD (só transcrição); JWT e papel `cco` obrigatório por padrão; limite de ligações.
- Voz em LiveKit + Gemini Live; conector EDI OCOREN 5.0/3.1; 3º canal de escalonamento liga de verdade para a central.
- 425 testes no backend (661 no total com web+mobile) e CI; nenhuma referência ao júri simulado/`score.md` no código, testes ou docs.

## Correções no nosso discurso (deck e documentos)

- "Avisa o recebedor antes da chegada": verdade, de fato ligado no ambiente público. Ainda é **pela página web (RTC)**, não por telefone — diga isso no vídeo.
- "Validação ponta a ponta 33/33" (documentos antigos, era do provedor de voz Agora): **superada**. A validação atual (LiveKit + LLM real, publicada em `evidence/validacao.md`) ficou em 34/34 em 3 das 4 rodadas e 33/34 numa, com a única falha diagnosticada (o LLM não chamou ferramenta na 1ª fala de um assunto novo, não a fusão fila×atraso) — e o README agora descreve exatamente isso, sem arredondar pra cima.
- "425 testes no backend, 661 no total": confirmado agora (28/11); eram 413 mais cedo no mesmo dia, 377 em 27/11 e 299 em 25/11.
- "Deploy por `:sha`, imutável": confirmado contra a AWS de verdade em 3 deploys seguidos (`describe-task-definition` mostra `:8b303db`, depois `:a51e4e3`, depois `:09e6a6b` nos dois serviços, nunca `:latest`), depois de uma 1ª tentativa que falhou de forma segura.
- A tentativa de medição que quebrou com `TypeError` (`GET /ligacoes`) **não foi causada por um bug da API**: conferido nos logs do CloudWatch, todas as 22 chamadas do endpoint na sessão devolveram 200.
- "Integração com TMS, rastreador e ERP": o **TMS via EDI OCOREN já existe**; rastreador e ERP continuam **roadmap** até existir o adaptador.
- "Prova não editável" (documentos antigos): hoje a prova não tem proteção contra edição. Use "prova com hora do servidor e GPS".
- "Deploy fixo resolve a demo": a AWS (ECS + RDS + CloudFront) é a demo principal, com HTTPS e compromisso de disponibilidade escrito até 15/12. A Vercel é só o espelho temporário sem banco, documentado como tal.
