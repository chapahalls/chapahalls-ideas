# Judge: Parceiro de Estrada (ideia), 2026-11-21 15:47

**Nota estimada: 3,30 / 5** · Eliminatórios: 0 FALHAS · 4 RISCOS · resto N/A ainda

> **E2 não é risco alto.** A Agora está no caminho principal: o Conversational AI Engine é o próprio copiloto, e o Signaling e o RTC levam o alerta e a voz do CCO. A ideia não funciona igual sem a Agora. O risco de E2 é de **execução** (pt-BR não validado, escopo grande), não de a Agora ser enfeite.

Tempo restante até o prazo (22/11 12:00, UTC−3): **~20h12**. O gate da fase 1 do próprio cronograma ("Sáb 14h: português, < 2 s, interrupção, LLM reserva") já passou e não há evidência de que tenha sido cumprido.

## Alertas
- RISCO E2 (médio): o pt-BR e a latência < 2 s no Conversational AI Engine seguem "não confirmados" no README e no planejamento, e o gate das 14h já venceu. Se o canal de voz não estiver de pé até o início da noite, a demo inteira cai.
- RISCO E5: o campo "Preexistente" está como `_(preencher)_`.
- RISCO E1: autores e integrantes estão como `_(preencher)_` / "Pendências: nome do time e integrantes". Não dá para verificar 3-5 pessoas.
- RISCO E7 (leve): o planejamento linka um doc privado no claude.ai como "fonte viva", e `metricas.md` expõe o empregador de um integrante. As duas coisas vão para um repositório público. Revisar antes de tornar público.
- Inconsistência interna que a banca vai ler: o README e o planejamento vendem "a fala é o sensor de cansaço / ritmo da fala caindo", e o `mercado-e-evidencias.md` diz que isso foi **retirado** do pitch (~70% UAR em laboratório) e que o tema é "Não usar no pitch". Detalhes em *Observações*.

## Pontuação
| # | Critério | Peso | Nota | Justificativa |
|---|---|---|---|---|
| C1 | Voz e interação | 25 | 3 | O diálogo é concreto, e o README define barge-in ("corta o agente… no meio da sugestão de parada"), confirmação com eco (tipo, km, sentido) e recuperação ("pede para repetir só o dado que faltou"). Mas a latência alvo é "< 2 s", que não é baixa, e o pt-BR nunca foi testado. Tudo ainda é intenção. |
| C2 | Execução + Agora | 25 | 3 | A Agora é o coração do desenho ("microfone → Agora Conversational AI → extrator → roteador → Signaling/Chat/RTC"). Só que o escopo pede 5+ produtos Agora, painel CCO, mapa, log com hash e link para a família em 6 fases dentro de ~20h. A "entrega quando o sinal volta (Agora Chat)" depende de fila local do remetente, que o Chat não resolve sozinho. A consistência fica improvável. |
| C3 | Problema | 20 | 4 | Público nítido (TRC + CCO) e dor com número oficial ou setorial: 41,3% esperam a maior parte da jornada, 84,7% não recebem estadia, 28% dos sinistros com < 5% da frota, R$ 763,7 mil por sinistro fatal. Não chega a 5 porque o benefício se espalha por 3 frentes e o próprio `embasamento.md` admite que a dor de comunicação com o CCO "não está provada". |
| C4 | Inovação | 15 | 4 | A voz habilita o que o texto não faz, porque o motorista está dirigindo. O ciclo de vida do alerta com confirmação dupla do "não" por voz é diferenciado (o próprio Waze tem isso como pedido aberto). O argumento escrito em "Por que voz" ainda se apoia na tese de "sensor de cansaço" que a pesquisa do time derrubou. |
| C5 | Validação | 10 | 3 | O plano é acima da média: 6+ testadores externos, cansaço induzido por tarefa paralela, métricas de vazamento, invenção e falso positivo, limitações honestas ("não substitui o controle oficial de jornada", depende de sinal) e roadmap. Ainda não há nenhum dado. As 5 ligações com caminhoneiros sugeridas no embasamento não aparecem como feitas. |
| C6 | Clareza | 5 | 2 | O roteiro de 5 passos (Comunidade A→B, 3 níveis de cansaço, CCO por voz, chegada com tempo acelerado, lembrete e recado da esposa) não cabe em 2 min. Há dois roteiros diferentes (5 passos no planejamento, 4 cenas no mercado-e-evidencias com "agente de escuta"), dois nomes e dois posicionamentos. |
| | **Total** | 100 | **3,30** | (3×25 + 3×25 + 4×20 + 4×15 + 3×10 + 2×5) / 100 = (75 + 75 + 80 + 60 + 30 + 10) / 100 = **3,30** |

## Eliminatórios
| # | Regra | Status | Nota |
|---|---|---|---|
| E1 | Equipe 3-5 presentes | RISCO | Autores e integrantes não preenchidos. Precisa de humano para confirmar. |
| E2 | Agora funcional e demonstrada | RISCO (médio) | O desenho põe a Agora no caminho crítico (ConvoAI + Signaling + RTC na demo). O risco é não ter o pt-BR ou a latência funcionando a tempo. Validar com o MCP de docs da Agora quais ASR/TTS em pt-BR o ConvoAI aceita, em vez de deixar "não confirmado". |
| E3 | Entregas no prazo | N/A ainda | Escopo grande para ~20h. Ver *Maior retorno* 1. |
| E4 | Repositório público | N/A ainda | — |
| E5 | Preexistentes identificados | RISCO | Campo "Preexistente" vazio. Se não houver nada, escrever "nenhum". |
| E6 | Licenças/autorizações | N/A ainda | Atenção a tiles de mapa (licença), gravações de PX se usadas e vozes de TTS. |
| E7 | Sem credenciais/dados pessoais | RISCO (leve) | Link para doc privado do claude.ai no planejamento, empregador de integrante em `metricas.md` e futura `docs/validacao.md` com caminhoneiros (o embasamento já diz "sem nomes nem telefones"; manter). |
| E8 | Simulações identificadas | OK (completar) | A lista de simulados existe (GPS, geofence, tempo acelerado, rastreadores, dois notebooks, cansaço induzido). Falta acrescentar: operador CCO e "esposa" interpretados pelo time, motoristas simulados no canal (se a cena de escuta entrar) e eventos da Comunidade semeados. |

## Entregáveis (modo projeto)
| # | Entregável | Status |
|---|---|---|
| D1-D4 | — | N/A (modo ideia) |

## Maior retorno
1. **Cortar o escopo para 3 cenas e um roteiro único** (Comunidade A→B com "ainda tá lá?"; modo atenção → nível 3 com o operador entrando por RTC; chegada com espera e excedente em ~20 s). Ficam ConvoAI + Signaling + RTC, feitos de forma consistente. Chat, recado para a família, Media Services, swap Pessoal/Corporativo e lembrete viram slide ou bônus. **C2 3→4 = +0,25** e **C6 2→3 = +0,05**, total **+0,30**. Também reduz o risco de E3.
2. **Provar C1 ao vivo**: barge-in no meio da sugestão de parada, recuperação mostrada (km não entendido → agente pede só o km; rede cortada → evento enfileirado localmente e reentregue) e p50/p95 de latência medidos e mostrados (meta < 1,5 s). **C1 3→4 = +0,25**. Com latência baixa medida e as duas coisas na demo, 3→5 = +0,50.
3. **Harmonizar os documentos e trazer números reais**: um nome só, um termo só ("registro do trecho" ou "diário de bordo"), "modo atenção por tempo ao volante e horário" no lugar de "ritmo da fala" no README e no planejamento, e "prova complementar de espera" em todo lugar. Fazer as 5 ligações com caminhoneiros e os 6 testadores com resultados em `docs/validacao.md`. **C5 3→4 = +0,10** (e protege C4 = 4 e C3 = 4 no Q&A).

## Observações

**Inconsistências que a banca lê no repositório** (não mudam a nota diretamente, mas pesam em C4, C6 e no Q&A):

| Tema | README / planejamento | mercado-e-evidencias / metricas / expansao |
|---|---|---|
| Gatilho de cansaço | "A própria fala é o sensor de cansaço (tempo de resposta, ritmo)" (README:29); nível 1 = "Ritmo da fala caindo" (planejamento:235); escopo "tempo ao volante + ritmo da fala" (planejamento:269) | "Modo atenção" por tempo contínuo e hora do dia; "Detecção de fadiga pela voz… por isso saiu do pitch"; "a frase 'detecta fadiga' não aparece" |
| Nome | "Parceiro de Estrada" | "RODAR" (títulos de mercado, métricas e expansão) |
| Registro | "registro do trecho" | "diário de bordo (inteligente)" |
| Jornada | "não substitui o controle oficial de jornada… prova complementar" (README:74, planejamento:148, 335) | "prova de espera **e jornada**", "transportadora ganhando **controle de jornada** que resiste à Justiça" (conclusão), "a ETC cumpre o controle de jornada" |
| Pilares | Pessoal / Corporativo / Comunidade | diário de bordo / **agente de escuta de canais por rodovia** / modo atenção (o agente de escuta não existe no planejamento) |
| Roteiro da demo | 5 passos | 4 cenas diferentes |
| Áudio | recado "gravado" que a família "ouve por link" | "Só transcrição em texto, nunca áudio" |
| Parar | "sugere parada" (nível 2) | "não manda parar, sempre nomeia a pausa" (compatível, mas o tom precisa ser o mesmo no pitch) |
| RDO editável | o README e o planejamento já dizem "não editável" | o mercado afirma que eles ainda descrevem um "RDO que o motorista pode editar". Essa nota está **desatualizada** e é ela que precisa sair |

Escolher **um** posicionamento antes do pitch. O mais defensável pela própria pesquisa é "prova da viagem + alertas por voz + modo atenção como apoio". Com ele, o README e o planejamento precisam de ajuste, e a seção "Por que voz" precisa de um argumento novo: mãos e olhos ocupados, digitar com OR ≈ 23 contra viva-voz com OR 0,65, confirmação falada.

**Outras notas técnicas:**
- O "sem sinal → entregue quando a conexão volta (Agora Chat)" mistura duas coisas. O Chat guarda mensagens para o **destinatário** offline. Com o **remetente** sem rede, o evento precisa de fila local no app. Isso é código do time, não produto Agora, e precisa estar descrito assim para não parecer integração que não existe.
- O `mercado-e-evidencias.md` diz que o modo atenção "precisa rodar no aparelho, sem rede". Se fizerem isso, essa parte sai do caminho da Agora e não conta para C2. Na demo, mostrar a versão online pelo ConvoAI.
- O C1 depende de a interrupção e o pt-BR funcionarem no ConvoAI. A pendência "testar português" está aberta desde a manhã, então é a primeira coisa a fechar, usando o skill `agora` e o MCP de docs em vez de suposição.
- A banca do jantar é do mercado financeiro. O material de TAM/SAM e os comparáveis (Legora, Samsara) servem lá, mas não pontuam na rubrica e não devem tomar tempo dos 3 minutos de pitch.
- Ranking: é a única ideia pontuada até agora, então não há empate a resolver. A atualização da tabela em `ideas/README.md` fica com o `/judge`.
