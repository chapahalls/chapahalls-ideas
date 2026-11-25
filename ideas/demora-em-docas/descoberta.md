# Demora em docas: descoberta do problema (Hack Brasil 2026)

25/11/2026 · As perguntas de descoberta (1 a 6), com fonte em cada número, lidas pelas regras do **Hack Brasil 2026, trilha Logística & automação** ([`HACKATHON.md`](../../HACKATHON.md)).

Legenda: **[F]** dado com fonte · **[I]** inferência nossa a partir dos dados · **[H]** hipótese que só entrevista ou teste confirma.

> **Para que serve este documento no Hack Brasil:** é a base do **H3 Impacto** ("efeito sobre o problema e o público da trilha") e do **H4 Comunicação** (o vídeo de 3 min para um júri que não é de logística). Os números entram no README "Para o júri" dos três repositórios e no roteiro do vídeo. O produto já existe ([rodar-backend](https://github.com/rodarglobal/rodar-backend), [rodar-web](https://github.com/rodarglobal/rodar-web), [rodar-mobile](https://github.com/rodarglobal/rodar-mobile)); as seções 4 a 6 partem dele.

## 0. O que o Hack Brasil muda na leitura do problema

| Regra | Consequência para o problema |
|---|---|
| H3 mede o efeito **sobre o problema e o público da trilha** (item 9.1) | O impacto que conta é **logístico**: horas de caminhão parado, custo da hora e informação que não chega ao recebedor. Sono, solidão e acidentes (o pitch do UNMUTE) ficam fora do foco, porque são Saúde, não Logística |
| Enquadramento é condição (itens 5.4 e 5.5) | Problema e público precisam estar na trilha. "Mover bens e informação de forma mais eficiente" encaixa: o caminhão parado é um bem que não se move, e o aviso ao recebedor é informação que não circula |
| O júri não precisa instalar nada (item 7.4) e **não é de logística** | Em uma frase e com um número, o vídeo precisa fazer alguém de ML ou finanças entender o que é estadia e doca |
| Desempate: H1 → **H3** | Impacto é o segundo desempate. Um número de impacto **com fonte** vale mais que uma tela a mais |
| Hoje os READMEs dos repos de código citam **zero** números de impacto | Maior alavanca de H3 com custo baixo antes de 30/11 (ver seção 6) |

## 0.1. Correções aos números trazidos (antes de ir para README, vídeo ou slides)

| Afirmação | Situação | O que dá para afirmar |
|---|---|---|
| 11h40 de espera nos CDs (2025) | **Confirmado** | IER 2025 (IPTC/SETCESP), Grande SP, 175 recebedores: CDs 11h40, atacadistas 5h56, home centers 4h33, média 5h09 (maior em 10 anos). [F1] |
| "Mais de 90% não recebem estadia" | **Confirmado com ressalva** | 84,7% não recebem nem denunciam + 6,6% não recebem mas denunciam = **91,3% não recebem**. Só 8,6% recebem. A amostra da CNTA (2.002 autônomos) **não é probabilística**. [F2] |
| 87% sem vaga exclusiva / 13% com vaga | **Confirmado, ano incerto** | 13% dos recebedores têm vaga para carga e descarga; 87% reservam vagas para clientes. [F3] |
| 73% dão nota 0 a 5 à infraestrutura (CNTTT) | **Não encontrado** | **Não usar** até ter o link do relatório. |
| Alimentos 32,26% a 40% dos roubos | **Não confirmado na NTC** | nstech: alimentos = 33,3% do prejuízo no 1º sem/2025 (2º lugar). Outra reportagem: 26,5%. [F4] |
| Roubo ligado à espera na doca | **Sem evidência direta** | Só há: a noite é o período de maior risco [F5]. Tratar como [H]. |
| Faixa de 46-50 anos | **Aproximado** | Média de 45 anos (CNT 2025) [F6], 46 anos (CNTA 2025) [F7] e 54 anos para o motorista profissional (Ilos/Senatran) [F8]. |
| Escolaridade baixa | **Confirmado** | CNT 2025: **43,6% até o fundamental** [F6]. CNTA: **43,8% com fundamental incompleto** [F7]. |
| Dificuldade digital acima de 50 anos (Viva/Motz) | **É declaração, não pesquisa** | Fala do CEO da Motz, sem número [F8]. Contraponto: **91% dos autônomos usam app de carga** [F9]. |

## 1. Entender o problema

**Qual é o problema?** O caminhão chega ao recebedor e fica horas parado antes de descarregar. A média na Grande SP foi de 5h09 em 2025, e de 11h40 nos CDs [F1]. Em 2019 era 2h50 [F10]: **o problema está piorando**.

**Onde acontece?** Pior caso medido: CDs de varejo e indústria (11h40), depois atacadistas e atacarejos (5h56) e home centers (4h33) [F1]. O recebedor mais eficiente, um supermercado (Joanin), descarrega em **2h** [F1]. Esse é o benchmark de que a espera é gestão, não destino.
- **Portos e terminais de safra** já têm solução: Paranaguá está sem filas na BR-277 desde 2011 com o Carga Online [F11], e em Santos a permanência caiu de 9h15 para 5h30 com agendamento e multa [F12]. Ainda há filas residuais na safra [F13]. **[I] O mercado do RODAR é o varejo e o abastecimento urbano, não o porto.**
- **Terminais de fronteira:** sem dado. [H]

**Por que acontece?** Ver a seção 3.

**Quem é afetado?** No foco da trilha:
- **Transportadora e autônomo:** ativo parado, ~R$ 146/h por caminhão (estimativa em [`impacto-e-custos.md`](../parceiro-de-estrada/impacto-e-custos.md)).
- **Embarcador:** prazo e custo do frete.
- **Recebedor:** pátio cheio, mas hoje **não paga** pela espera.
- **Cidade:** fila na rua, porque 87% dos recebedores não têm vaga [F3].

Fora do foco: o motorista CLT (pela ADI 5322 do STF, a espera conta como jornada [F14]) e o consumidor (custo embutido no frete, [I]).

**Quando acontece?** Na chegada sem janela, ou com janela que não é cumprida. Picos prováveis: safra nos portos e fim de ano no varejo [H, sem fonte].

**Com que frequência?** 46,1% dos autônomos enfrentam espera de 5h ou mais **sempre**, e 23,4% às vezes [F15].

**Qual é a gravidade?**
- **Dinheiro:** a hora parada custa ~R$ 146. A estadia só é paga depois de 5h e cobre cerca de metade disso: R$ 75/h para 30 t a R$ 2,50/t·h [F16].
- **Custo escondido:** uma espera de 4h custa ~R$ 323 e **não gera cobrança nenhuma**, porque fica abaixo da franquia de 5h. [I]
- **Segurança (só referência, fora do foco da trilha):** nos EUA, +15 min de espera média → +6,2% na taxa esperada de acidentes [F17]. Os dados são de 2013, e a FMCSA contestou a conclusão.

**O que acontece se não resolver?** O problema já está piorando (2h50 → 5h09 entre 2019 e 2025) [F1][F10], numa categoria que envelhece e encolhe (motorista profissional com média de 54 anos [F8]). Cada hora parada tira capacidade de uma frota que não se renova. [I]

**Por que ainda não foi resolvido?**
1. **A punição existe no papel.** A Lei 11.442, art. 11, já prevê estadia depois de 5h e multa de até 5% do valor da carga para quem não registra os horários [F16][F18]. Falta cobrança, não lei.
2. **Assimetria de poder.** 67,1% conhecem a lei [F2] e 91% não recebem. [I] Cobrar arrisca perder o próximo frete.
3. **A estadia paga pouco e tarde** [F16].
4. **Fiscalização reativa:** depende de denúncia [F18], e só 6,6% denunciam [F2].
5. **As ferramentas são do pátio.** Os sistemas de agendamento e de gestão de pátio (YMS) são vendidos ao recebedor, que não sente o custo [F19][F20].

## 2. Entender as pessoas afetadas

**Quem são?** O usuário do app é o caminhoneiro: 99,7% homens, média de 45-46 anos, 43,6% até o fundamental [F6][F7]. Os autônomos trabalham ~14h/dia, 25 dias por mês [F7]. **O comprador é a transportadora** (preço discutido no repo: R$ 100 por caminhão por mês).

**Como lidam hoje?** Esperam, dormem na cabine e não cobram (84,7%) [F2]. Comunicam-se por WhatsApp e apps de frete (91% usam app de carga) [F9].

**Maiores dificuldades:**
- não saber quando vai descarregar;
- não ter onde parar (87% dos recebedores sem vaga) [F3];
- exigências extras, como devolução de paletes e restrição de horário [F3];
- um portal de agendamento diferente em cada cliente [F8].

A ordem entre elas é [H].

**O que gostariam de melhorar?** Não há dado direto. [H] Previsibilidade e receber a estadia.

**Já tentaram alguma solução?** A denúncia (6,6%) [F2] e apps de terminal único, como o Caminho Ágil da Santos Brasil [F21]. Esses apps não servem a quem roda entre vários recebedores. [I]

**Ponto fraco da premissa "dificuldade com tecnologia":** 91% já usam app [F9]. A fricção é **digitar ao volante** e **ter um portal diferente em cada CD**, não usar o celular. [I] No vídeo, evite "quem nunca ajudou alguém com dificuldade em tecnologia", que soa condescendente. Prefira "um portal diferente em cada CD, e ele está dirigindo".

## 3. Investigar as causas

**Causa principal:** o tempo do caminhão não custa nada a quem o retém. [I] A espera vira "estoque gratuito" do recebedor, o que os 91% sem estadia sustentam [F2].

**Fatores que contribuem:** poucas docas e vagas [F3], falta de conferentes, paletes e canhotos, divergência fiscal na portaria e janela de agendamento que não se cumpre [F1][F3]. Só o fator das vagas tem percentual isolado nas fontes (13%).

**Informação, tempo, recursos ou processo?**
- **Recursos** (docas, conferentes) e **processo** (agendamento): são do recebedor.
- **Incentivo** (estadia não cobrada): depende do contrato entre embarcador, transportadora e recebedor.
- **Informação:** é o que o RODAR ataca. O recebedor fica sabendo **antes** da chegada, e o tempo parado vira um registro auditável.

**Causa pouco evidente:** a franquia de 5h esconde a maior parte do custo (ver *Gravidade*).

**5 porquês:**
1. O caminhão fica 11h no CD → porque não há doca livre.
2. Não há doca livre → porque chegam mais caminhões do que o CD descarrega por hora.
3. Chegam mais caminhões → porque o CD não controla a chegada.
4. O CD não controla a chegada → porque esperar não lhe custa nada.
5. Esperar não custa nada → porque o motorista não cobra, por medo de perder frete, e a transportadora não tem prova barata do tempo.

**Se eu resolver uma causa, o problema diminui?** Só se quem controla a capacidade agir.
- **A favor:** Paranaguá acabou com a fila com cota por terminal e liberando o caminhão só quando há vaga [F11]. Santos reduziu a permanência com agendamento **e multa** [F12]. O Joanin descarrega em 2h [F1].
- **Contra:** em Santos ainda há horas de fila mesmo com agendamento [F13].
- **[I] Conclusão honesta para o H3:** dar prova ao motorista, sozinho, não reduz a espera, porque ele já sabe que tem direito. O efeito do RODAR vem de duas coisas: (a) o **aviso antecipado**, que deixa o recebedor preparar a doca e o conferente; (b) a **prova agregada**, que vai para quem tem poder de cobrar, a transportadora. Não prometa "acabar com a fila": prometa "a espera fica visível e tem dono".

## 4. Pensar na solução

**Como poderia ser resolvido?** Três alavancas, da mais forte para a mais fraca:
1. Regra imposta por quem controla o acesso (porto ou autoridade).
2. Custo contratual da espera (estadia cobrada, ranking de recebedores).
3. Informação (aviso de chegada, hora comprovada).

O RODAR atua na 3 e alimenta a 2.

**Já existe algo que funciona?** Nos portos, sim [F11][F12]. No varejo há sistemas de agendamento e de gestão de pátio, vendidos ao recebedor. A Trackage diz reduzir em até 60% a fila na portaria e tem como meta -50% de espera com a DHL, mas esses **números são do fabricante** [F19]. O Opendock roda em 63 plantas da Cascades [F20].

**O que o RODAR faz diferente (já implementado, conforme os READMEs dos repos):**

| Causa (seção 3) | O que o RODAR faz | Onde está |
|---|---|---|
| Falha na conciliação de horário | O agente avisa o recebedor e o CCO na **aproximação** (geocerca) | backend + app |
| Estadia não cobrada, sem prova | Na chegada, conta a estadia (franquia de 5h, R$ 2,50/t·h) com hora do servidor e GPS em dupla prova | backend + painel |
| CCO sobrecarregado, digitação ao volante | O motorista fala; o agente cria a Task e só chama o CCO quando alguém precisa decidir | app (voz Agora) + painel |
| Recebedor que não responde | Escalonamento: insiste com o CCO e, sem resposta, **liga para o recebedor** e registra a resposta como prova | backend (ligação real desligada; plano B por canal RTC) |
| Ninguém sabe quem atrasa | Indicadores de estadia por recebedor no painel | painel |

**Por que é melhor que as alternativas:** funciona em qualquer recebedor, sem integração (o app da Santos Brasil só serve o próprio terminal [F21]). Usa voz em vez de portal para um público de 45 anos ou mais. E agrega dados entre motoristas, enquanto o IER só publica um ranking por ano [F1].

**Onde é pior:** não cria doca nem conferente. Se o recebedor ignorar o aviso, o RODAR só documenta e pressiona.

**Menor versão útil:** já existe. São 512 testes automatizados e uma validação ponta a ponta de 33/33 etapas, segundo os READMEs. O que **falta para o júri ver** é a demo pública no ar e o vídeo (seção 6).

**Recursos necessários:** Agora ConvoAI (voz), um número de telefone para a ligação real ao recebedor e um parceiro transportadora para validar. [H] O **Nvoip Pro de 3 meses**, liberado a participantes com rascunho aprovado, pode suprir o número. Falta confirmar se ele integra com a chamada de saída da Agora.

## 5. Validar a ideia

**Como confirmar que o problema existe?** Por dados secundários já está confirmado [F1][F2]. Falta saber **qual parte** dói mais para o comprador, a transportadora: as horas perdidas, a estadia não cobrada ou o CCO sobrecarregado.

**Como conversar com os afetados?**
- 10 motoristas em postos perto de polos de CD (Cajamar, Guarulhos, Barueri) e da CEAGESP.
- 2 a 3 transportadoras pequenas (gestor de frota ou CCO).
- Pergunte sobre o **passado**: "Na última entrega, quanto tempo esperou? Cobrou a estadia? Por que não?"

**Quando validar:** use o **congelamento de 01/12 a 12/12**. O código não pode mudar, mas entrevistas e números podem ir para os slides e para a apresentação da final, que tem notas novas, do zero (item 9.3).

**Como testar sem mexer no código:** coloque 2 ou 3 motoristas para usar a demo pública numa entrega real, sem dado pessoal no repo (X6). Ou faça um "Mágico de Oz" com áudio de WhatsApp na chegada e na descarga.

**Como saber se funcionou (métricas para a final):**
- % de entregas com chegada e descarga registradas por voz.
- Minutos entre o aviso antecipado e a chegada (tempo que o recebedor ganhou para preparar a doca).
- Estadia devida identificada (R$) e quanto a transportadora cobrou.
- Taxa de conclusão por voz nos motoristas com 50 anos ou mais.

## 6. Planejar o desenvolvimento

**Objetivo principal:** tornar o caminhão parado na doca visível, comprovável e com dono, avisando o recebedor antes e chamando a central só quando precisa.

**Tempo disponível:** **até 30/11/2026 23h59** (5 dias a partir de hoje) para fechar a submissão. Depois, os repos ficam congelados até a final de **12/12**, em São Paulo, onde o time termina o projeto no local.

**O que fazer primeiro (ordem por retorno na nota):**
1. **S4 · Demo pública HTTPS no ar** e estável até o fim da avaliação (**H1**, primeiro desempate). Os três READMEs ainda têm o comentário "Demo publicada ... incluir antes de 30/11".
2. **S5 · Vídeo de até 3 min** sem login (**H4**). Roteiro: a dor em uma frase com número ("11h40 parado num CD de SP; 9 em cada 10 autônomos não recebem pela espera") → o produto funcionando (aviso, chegada, estadia, escalonamento) → o resultado (estadia comprovada em R$).
3. **H3 · Números de impacto com fonte** no bloco "Para o júri" dos três READMEs: 5h09 / 11h40 [F1], 91% sem estadia [F2] e o benchmark de 2h [F1]. Use só os que estão marcados como confirmados na tabela 0.1.
4. **Enquadramento:** a frase de apresentação no painel fala de logística (doca, estadia, recebedor), não de segurança do motorista.

**Funcionalidades indispensáveis:** já estão no produto (aviso, chegada, estadia, escalonamento, painel). Não abra feature nova antes de 1 a 3 estarem prontos.

**Tecnologias e conhecimentos:** as que já estão no produto (FastAPI, Postgres, React/Vite, Expo, Agora ConvoAI, Docker), mais hospedagem pública com HTTPS para a demo.

**Principais dificuldades:**
- A demo cair durante a avaliação: o júri passa a ver só o vídeo e o código (item 7.3).
- A voz real depende de chaves e créditos da Agora. Se a demo pública usar o modo Demo ou mock, isso precisa estar declarado e o vídeo precisa mostrar a voz real.
- Comprador ≠ usuário: o motorista sente a dor, quem paga é a transportadora. O vídeo precisa mostrar os dois.
- A prova por GPS de celular pode ser contestada na Justiça: a dupla prova com o rastreador é simulada hoje.
- **Commit depois de 30/11 23h59 desclassifica** (X8).

## Fontes

- [F1] [A demora que compromete a eficiência — SETCESP (IER/IPTC 2025)](https://setcesp.org.br/noticias/a-demora-que-compromete-a-eficiencia-2/)
- [F2] [CNTA 2025: estadia e frete abaixo do piso — Mundo Logística](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-aceitam-frete-abaixo-do-piso-por-necessidade)
- [F3] [A demora que compromete a eficiência (edição anterior) — SETCESP](https://setcesp.org.br/noticias/a-demora-que-compromete-a-eficiencia/)
- [F4] [Roubo de cargas cai quase 17% em 2025 — CNN Brasil](https://www.cnnbrasil.com.br/infra/roubo-de-cargas-cai-quase-17-em-2025-mas-prejuizo-segue-bilionario/) · [Sudeste segue liderando roubo de carga — Monitor Mercantil](https://monitormercantil.com.br/sudeste-segue-liderando-roubo-de-carga-neste-ano/)
- [F5] [Noite é o período de maior risco para roubos de carga — Monitor Mercantil](https://monitormercantil.com.br/noite-e-o-periodo-de-maior-risco-para-roubos-de-carga/)
- [F6] [CNT divulga Pesquisa Perfil e Preferências dos Caminhoneiros 2025 — SETCESP](https://setcesp.org.br/noticias/cnt-divulga-pesquisa-perfil-e-preferencias-dos-caminhoneiros-de-2025-que-mostra-como-os-motoristas-avaliam-sua-rotina-de-trabalho/)
- [F7] [Realidade dos caminhoneiros autônomos 2025 (CNTA) — Mundo Logística](https://mundologistica.com.br/noticias/realidade-dos-caminhoneiros-autonomos-brasil-2025)
- [F8] [Envelhecimento já afeta transporte — Viva (Ilos/Senatran; fala do CEO da Motz)](https://viva.com.br/dinheiro/envelhecimento-ja-afeta-transporte-e-numero-de-caminhoneiros-cai-no-brasil.html)
- [F9] [Digitalização e perspectivas para a safra de grãos — Monitor Mercantil](https://monitormercantil.com.br/digitalizacao-e-perspectivas-para-safra-de-graos-em-2024/)
- [F10] [Longa espera (2h50 em 2019) — SETCESP](https://setcesp.org.br/noticias/longa-espera/)
- [F11] [Porto de Paranaguá completa quatro anos sem filas — SETCESP](https://setcesp.org.br/noticias/porto-de-paranagua-completa-quatro-anos-sem-filas-de-caminhoes/) · [Recorde sem filas com o Carga Online — Mundo Logística](https://mundologistica.com.br/noticias/porto-de-paranagua-registra-maior-recebimento-de-caminhoes-da-historia-sem-a-formacao-de-filas-nas-estradas)
- [F12] [Porto de Santos diminuiu tempo de espera com agendamento — JB, 2014](https://www.jb.com.br/pais/noticias/2014/05/07/amp/porto-de-santos-diminiu-tempo-de-espera-com-agendamento-2.html) · [Multas afastam caminhões — Exame](https://exame.com/brasil/multas-afastam-caminhoes-de-vias-para-o-porto-de-santos)
- [F13] [Mesmo com agendamento, horas de fila em Santos — Canal Rural](https://www.canalrural.com.br/agricultura/boleia-mesmo-com-agendamento-motoristas-enfrentam-horas-filas-para-descarregar-cargas-porto-santos-24247/) · [Congestionamentos nos pátios reguladores — Fatec, 2024](https://ric.cps.sp.gov.br/bitstream/123456789/28274/1/logistica_2024_2_rodrigues_oscongestionamentosgeradospelospatiosreguladores.pdf)
- [F14] ADI 5322 (STF, 2023): ver as fontes em [`parceiro-de-estrada/impacto-e-custos.md`](../parceiro-de-estrada/impacto-e-custos.md)
- [F15] [Caminhoneiros autônomos trabalham 25 dias por mês (CNTA) — Mundo Logística](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-trabalham-25-dias-por-mes)
- [F16] [ANTT reajusta estadia para R$ 2,50/t·h — Mundo Logística](https://mundologistica.com.br/noticias/antt-reajusta-estadia-tempo-adicional-carga-descarga) · [Lei 11.442/2007, art. 11](https://www.legjur.com/legislacao/art/lei_00114422007-11)
- [F17] [Driver detention increases crash risk and costs — DOT OIG, 2018](https://www.oig.dot.gov/sites/default/files/FMCSA%20Driver%20Detention%20Final%20Report.pdf) · [Resumo — CCJ](https://www.ccjdigital.com/driver-detention-costs-carriers-and-drivers-big-bucks-contributes-to-crashes-report-says/)
- [F18] [Nota Técnica ANTT 4102 (carga e descarga)](https://www.gov.br/antt/pt-br/assuntos/cargas/carga-descarga/sei_41736493_nota_tecnica___antt_4102.pdf)
- [F19] [DHL Supply Chain e Trackage lançam solução de gestão de pátio — Mundo Logística](https://mundologistica.com.br/noticias/dhl-supply-chain-e-trackage-lancam-solucao-para-gestao-de-patio)
- [F20] [Case Cascades — Opendock](https://lp.opendock.com/hubfs/5041527/%5BCASE%5D%20Cascades%20BR-PT.pdf)
- [F21] [Santos Brasil desenvolve app para caminhoneiros — Mobile Time](https://www.mobiletime.com.br/noticias/21/05/2021/santos-brasil-desenvolve-app-para-caminhoneiros-e-chega-a-mais-de-1-mil-maus-em-2-meses/)
- [Regulamento do Hack Brasil 2026](https://hackbrasil.com/regulamento) (atualização de 18/11/2026)
