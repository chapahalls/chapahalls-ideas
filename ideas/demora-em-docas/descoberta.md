# Demora em docas: descoberta do problema

25/11/2026 · Respostas às perguntas de descoberta (1 a 6), com fonte em cada número.

Legenda: **[F]** dado com fonte · **[I]** inferência nossa a partir dos dados · **[H]** hipótese que só entrevista ou teste confirma.

> Base já pesquisada no repo: [`parceiro-de-estrada/impacto-e-custos.md`](../parceiro-de-estrada/impacto-e-custos.md) (custo da hora parada, estadia, TMD) e [`docs/arquitetura-avisai.md`](../../docs/arquitetura-avisai.md) (diário de espera, geocerca, ligação ao recebedor). Este documento não repete o cálculo de custo; aponta para lá.

## 0. Correções aos números trazidos (antes de usar no pitch)

| Afirmação | Situação | O que dá para afirmar |
|---|---|---|
| 11h40 de espera nos CDs (2025) | **Confirmado** | IER 2025 (IPTC/SETCESP), Grande SP, 175 recebedores: CDs 11h40, atacadistas 5h56, home centers 4h33, média 5h09 (maior em 10 anos). [F1] |
| "Mais de 90% não recebem estadia" | **Confirmado com ressalva** | 84,7% não recebem nem denunciam + 6,6% não recebem mas denunciam = **91,3% não recebem**; só 8,6% recebem. Amostra **não probabilística** (CNTA, 2.002 autônomos). [F2] |
| 87% sem vaga exclusiva / 13% com vaga | **Confirmado, ano incerto** | 13% dos recebedores têm vaga para carga e descarga; 87% reservam vagas para clientes. A página não diz o ano da edição. [F3] |
| 73% dão nota 0 a 5 à infraestrutura (CNTTT) | **Não encontrado** | Não achamos a fonte. **Não usar** até ter o link do relatório. |
| Alimentos 32,26% a 40% dos roubos | **Não confirmado na NTC** | nstech: alimentos = 33,3% do prejuízo no 1º sem/2025 (2º lugar, atrás de fracionada). Outra reportagem: 26,5%. [F4] |
| Roubo ligado à espera na doca | **Sem evidência direta** | Nenhuma fonte liga roubo à fila de descarga. Só há: noite é o período de maior risco [F5]. Tratar como [H]. |
| Faixa 46-50 anos | **Aproximado** | CNT 2025: média **45 anos** [F6]; CNTA 2025: **46 anos** [F7]; Ilos/Senatran (motorista profissional): **54 anos**, contra 47 em 2011 [F8]. |
| Escolaridade baixa | **Confirmado** | CNT 2025: **43,6% até o fundamental** [F6]; CNTA: **43,8% fundamental incompleto**, 1,1% com superior [F7]. |
| Dificuldade digital acima de 50 anos (Viva/Motz) | **Declaração, não pesquisa** | É fala do CEO da Motz, sem número [F8]. Contraponto: **91% dos autônomos usam app de carga** [F9]. |

## 1. Entender o problema

**Qual é o problema?** O caminhão chega ao recebedor e fica parado horas antes de descarregar. Média de 5h09 na Grande SP em 2025, 11h40 em CDs [F1]. Em 2019 a média era 2h50 [F10]: **o problema está piorando**.

**Onde acontece?** Pior caso medido: CDs de varejo e indústria (11h40), depois atacadistas/atacarejos (5h56) e home centers (4h33) [F1]. Supermercados de bairro aparecem no topo do ranking de eficiência (Joanin, 2h) [F1].
- **Portos e terminais de safra** já têm solução que funciona (agendamento obrigatório + pátio regulador): Paranaguá sem filas na BR-277 desde 2011 [F11]; Santos caiu de 9h15 para 5h30 de permanência após agendamento + multa [F12]. Ainda há filas residuais em safra [F13]. **[I] Portos são o mercado mais resolvido; varejo urbano é o menos.**
- **Terminais de fronteira:** sem dado coletado. [H]

**Por que acontece?** Ver seção 3.

**Quem é afetado?** Autônomo (perde frete e estadia), transportadora (ativo parado, ~R$ 146/h por caminhão, estimativa em `impacto-e-custos.md`), motorista CLT (jornada: o STF, na ADI 5322, conta espera como jornada [F14]), embarcador (prazo e custo do frete), recebedor (pátio cheio, mas hoje **não paga** pela espera), consumidor (custo embutido no frete; [I], sem número), trânsito/moradores (fila na rua, porque 87% não têm vaga [F3]). Seguradoras: só [H] (ver tabela 0).

**Quando acontece?** Na chegada sem janela ou com janela não cumprida. Picos prováveis: safra (portos, fev-jul) e fim de ano no varejo [H, sem fonte]. Roubo: noite é o período de maior risco [F5].

**Com que frequência?** 46,1% dos autônomos enfrentam espera de 5h+ **sempre** e 23,4% às vezes [F15]. 41,3% passam a maior parte da jornada esperando carga/descarga (CNT 2025, já no repo).

**Qual a gravidade?**
- Dinheiro: hora parada ~R$ 146/h; estadia paga só após 5h e cobre ~metade disso (R$ 75/h para 30 t a R$ 2,50/t·h) [F16] (cálculo em `impacto-e-custos.md`).
- Segurança: nos EUA, +15 min de espera média → **+6,2% na taxa esperada de acidentes**; perda de US$ 1,1-1,3 bi/ano em renda dos motoristas [F17]. **Ressalva:** dados de 2013, e a FMCSA contestou a conclusão.

**O que acontece se não resolver?** A tendência já é de piora (2h50 → 5h09 de 2019 para 2025) [F1][F10]. Somado ao envelhecimento e à falta de motoristas (motorista profissional médio com 54 anos [F8]), cada hora parada reduz a capacidade de uma frota que já não se renova. [I]

**Por que ainda não foi resolvido?**
1. **A punição existe no papel.** A Lei 11.442, art. 11, já prevê estadia após 5h e multa de até 5% do valor da carga para quem não registra horários [F16][F18]. O que falta é **cobrança**, não lei.
2. **Assimetria de poder.** 67,1% dos autônomos conhecem a Lei da Estadia [F2] e mesmo assim 91% não recebem. [I] Não é falta de informação: cobrar arrisca perder o próximo frete.
3. **A estadia paga pouco.** Começa só depois de 5h e cobre cerca de metade do custo da hora [F16]. Para muitos, não compensa brigar. [I]
4. **Fiscalização reativa.** A ANTT depende de denúncia (Ouvidoria 166 / Fala.BR) [F18]; só 6,6% denunciam [F2].
5. **As soluções existentes servem quem tem o pátio.** Agendamento de docas e YMS (Trackage, Opendock, Doca Certa) são vendidos ao recebedor [F19][F20]. Quem não sente o custo (o recebedor) é quem teria de comprar.

## 2. Entender as pessoas afetadas

**Quem são?** Foco escolhido: o caminhoneiro. Perfil: 99,7% homens, média de 45-46 anos, 43,6% até o fundamental, 59% autônomos na amostra CNT [F6][F7]. Jornada média de ~14h/dia, 25 dias/mês (autônomos) [F7].

**Como lidam hoje?** Esperam, dormem na cabine, aceitam não cobrar (84,7% não recebem nem denunciam) [F2]. Comunicação por WhatsApp e apps de frete (91% usam app de carga) [F9]. [H] Fotos de canhoto e áudios como prova informal.

**Maiores dificuldades?** Não saber quando vai descarregar; não ter onde parar (87% sem vaga [F3]); exigências extras como devolução de paletes, exclusividade de veículo e restrição de horário [F3]; portais de agendamento diferentes por cliente [F8]. **[H] As três primeiras precisam de entrevista para ordenar.**

**O que mais gostariam de melhorar?** Sem dado direto sobre a doca. Indireto: nas paradas, valorizam chuveiro (79%), restaurante (67,8%) e pátio vigiado (55,8%) (CNT 2025, já no repo). [H] Previsibilidade do horário e receber a estadia.

**Já tentaram solução?** Denúncia (6,6%) [F2]. Apps de terminal específico, como o Caminho Ágil da Santos Brasil [F21], funcionam só naquele terminal. **Por que não basta:** cada recebedor tem seu portal, e o motorista roda entre vários. [I]

**Ponto fraco da premissa "dificuldade com tecnologia":** 91% dos autônomos já usam app de carga [F9]. O motorista não é analfabeto digital. [I] A fricção está em **portais complexos e diferentes por cliente** e em digitar ao volante, não em usar o celular. O pitch "quem nunca ajudou alguém com dificuldade em tecnologia" pode soar condescendente com um público que já usa app; use "um portal diferente em cada CD".

## 3. Investigar as causas

**Causa principal:** o tempo do caminhão não custa nada a quem o retém. [I] A espera vira "estoque gratuito" do recebedor (formulação de vocês; os dados de 91% sem estadia [F2] a sustentam).

**Fatores que contribuem:** capacidade física (poucas docas e vagas [F3]), falta de conferentes, devolução de paletes e canhotos, divergência fiscal na portaria, agendamento sem cumprimento [F3][F1]. Os percentuais isolados desses fatores **não existem** nas fontes: só o de vagas (13%).

**Informação, tempo, recursos ou processo?**
- Recursos (docas, conferentes): do recebedor.
- Processo (agendamento que não é cumprido): do recebedor.
- Incentivo (estadia não cobrada): do contrato entre embarcador, transportadora e recebedor.
- **Informação:** é a única causa que um app do motorista ataca diretamente: hora de chegada comprovada e tempo de espera auditável.

**Causa pouco evidente:** **A franquia de 5h esconde o custo.** Uma espera de 4h custa ~R$ 323 à transportadora e não gera cobrança nenhuma (já calculado no repo). A maior parte do prejuízo fica abaixo da linha da estadia. [I]

**5 porquês (exemplo):** O caminhão fica 11h no CD → porque não há doca livre → porque o CD recebe mais caminhões do que descarrega por hora → porque não controla a chegada (sem janela ou sem cumprir) → porque esperar não lhe custa nada → porque o motorista não cobra (medo de perder frete) e a transportadora não tem prova barata do tempo.

**Se eu resolver uma causa, o problema diminui?** Só se quem controla a capacidade for obrigado a agir.
- **A favor:** Paranaguá eliminou a fila com cota diária por terminal + caminhão só sai da origem com vaga [F11]. Santos reduziu 9h15 → 5h30 com agendamento **e multa** [F12].
- **Contra:** em Santos, mesmo com agendamento, ainda há horas de fila [F13]. Agendamento voluntário sem penalidade não funciona.
- **[I] Conclusão:** dar prova ao motorista sozinho **não reduz a espera**; ele já sabe que tem direito e não cobra. A prova só muda o comportamento se chegar a quem tem poder de cobrar: a transportadora e o embarcador, no contrato.

## 4. Pensar na solução

**Como poderia ser resolvido?** Três alavancas, do mais forte ao mais fraco: (1) regra imposta por quem controla o acesso (porto, autoridade); (2) custo contratual da espera (estadia cobrada, ranking de recebedores); (3) informação (hora de chegada, previsão de doca, aviso de atraso).

**Já existe algo que funciona?** Sim, nos portos (Carga Online [F11], agendamento de Santos [F12]). No varejo: YMS e agendamento de docas (Trackage diz reduzir até 60% da fila na portaria, e a meta com DHL é -50% de espera, **números do fabricante** [F19]; Opendock em 63 plantas da Cascades [F20]).

**O que fazer diferente:** os sistemas atuais são do recebedor e de um pátio só. [I] O espaço vazio é do lado do **motorista e da transportadora, entre vários recebedores**: um registro único, à prova de edição, da espera em qualquer cliente, alimentado por voz.

**Por que seria melhor que as alternativas?**
- Funciona em qualquer recebedor, sem integração (a Santos Brasil só cobre o próprio terminal [F21]).
- Voz em vez de portal para um público de 45+ anos com 43,6% até o fundamental [F6].
- Agrega dados entre motoristas → ranking de recebedores (o TMD por recebedor que o IER só publica uma vez por ano [F1]).
- **Onde é pior:** não cria doca nem conferente. Sem o recebedor aderir, não reduz a espera daquele dia; só documenta e pressiona.

**Menor versão útil (MVP):** um motorista, um recebedor. Ao entrar na geocerca, o agente pergunta por voz "chegou no CD X?", registra a hora no servidor, pergunta de hora em hora o status, encerra na descarga e gera um relatório com o tempo e o valor da estadia devida. Isso já existe desenhado no AvisAI (diário de espera + contador de estadia, P0/P1 em `docs/arquitetura-avisai.md`).

**Recursos necessários:** Agora Conversational AI (voz), app mobile com geolocalização, backend com registro append-only, um parceiro transportadora para dados reais. Custo Agora estimado no repo: ~R$ 83 por caminhão/mês.

## 5. Validar a ideia

**Como confirmar que o problema existe?** Já confirmado por dado secundário [F1][F2]. O que **falta** é confirmar **qual parte** dói mais para o seu usuário: horas perdidas, estadia não paga ou incerteza do horário.

**Como conversar com os afetados?**
- Postos e pátios perto de polos de CD (Cajamar, Guarulhos, Barueri, SP) e da CEAGESP: 10 motoristas, 15 min cada.
- 2-3 transportadoras pequenas (gestor de frota/CCO).
- Perguntar sobre o **passado**, não opinião: "Na última entrega, quanto tempo esperou? Cobrou estadia? Por que não?" [H, método]

**Como testar antes de construir?** "Mágico de Oz": por uma semana, os motoristas mandam áudio de WhatsApp na chegada e na descarga para um número do time; o time monta o relatório à mão. Se ninguém mandar o segundo áudio, o app também não resolve.

**Como saber se funcionou?** E quais resultados demonstram sucesso:
- % de entregas com hora de chegada e de descarga registradas (meta [H]: >80%).
- Taxa de conclusão por voz nos motoristas 50+ contra formulário.
- Estadia devida identificada (R$) e quanto a transportadora efetivamente cobrou.
- No prazo longo: queda do TMD nos recebedores que entraram no ranking.

## 6. Planejar o desenvolvimento

**Objetivo principal:** tornar o tempo parado na doca visível e comprovável para quem pode cobrá-lo (transportadora), usando voz para o motorista registrar sem digitar.

**O que vem primeiro:** a entrevista e o teste Mágico de Oz (seção 5), depois o diário de espera por voz.

**Funcionalidades indispensáveis:** geocerca de chegada, check-in e check-out por voz, registro não editável (hora do servidor), relatório de estadia por entrega.
**Dispensáveis no MVP:** ranking público, ligação ao recebedor, agendamento de doca, frentes "dono" e "financeiro".

**Tecnologias e conhecimentos:** Agora ConvoAI + RTC, Expo/React Native, Node, geolocalização, a Lei 11.442 (cálculo da estadia). Arquitetura já escrita em `docs/arquitetura-avisai.md`.

**Principais dificuldades:**
- Quem paga: o motorista sente a dor, mas o autônomo não tem dinheiro nem poder; o comprador provável é a transportadora (preço já discutido no repo: R$ 100/caminhão/mês).
- Valor jurídico da prova: GPS do celular pode ser contestado.
- Adoção: o motorista precisa lembrar de abrir o app; o check-in por geocerca reduz isso.
- O recebedor pode reagir mal ao ranking.

**Tempo disponível:** **em aberto.** O prazo do hackathon (22/11/2026 12h) já passou. Definir o novo prazo antes de planejar fases.

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
- [F14] ADI 5322 (STF, 2023): ver fontes em [`parceiro-de-estrada/impacto-e-custos.md`](../parceiro-de-estrada/impacto-e-custos.md)
- [F15] [Caminhoneiros autônomos trabalham 25 dias por mês (CNTA) — Mundo Logística](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-trabalham-25-dias-por-mes)
- [F16] [ANTT reajusta estadia para R$ 2,50/t·h — Mundo Logística](https://mundologistica.com.br/noticias/antt-reajusta-estadia-tempo-adicional-carga-descarga) · [Lei 11.442/2007, art. 11](https://www.legjur.com/legislacao/art/lei_00114422007-11)
- [F17] [Driver detention increases crash risk and costs — DOT OIG, 2018](https://www.oig.dot.gov/sites/default/files/FMCSA%20Driver%20Detention%20Final%20Report.pdf) · [Resumo — CCJ](https://www.ccjdigital.com/driver-detention-costs-carriers-and-drivers-big-bucks-contributes-to-crashes-report-says/)
- [F18] [Nota Técnica ANTT 4102 (carga e descarga)](https://www.gov.br/antt/pt-br/assuntos/cargas/carga-descarga/sei_41736493_nota_tecnica___antt_4102.pdf)
- [F19] [DHL Supply Chain e Trackage lançam solução de gestão de pátio — Mundo Logística](https://mundologistica.com.br/noticias/dhl-supply-chain-e-trackage-lancam-solucao-para-gestao-de-patio)
- [F20] [Case Cascades — Opendock](https://lp.opendock.com/hubfs/5041527/%5BCASE%5D%20Cascades%20BR-PT.pdf)
- [F21] [Santos Brasil desenvolve app para caminhoneiros — Mobile Time](https://www.mobiletime.com.br/noticias/21/05/2021/santos-brasil-desenvolve-app-para-caminhoneiros-e-chega-a-mais-de-1-mil-maus-em-2-meses/)
