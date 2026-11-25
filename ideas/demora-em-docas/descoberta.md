# Demora em docas: descoberta do problema

25/11/2026 · Respostas às perguntas de descoberta (1 a 6), com fonte em cada número. Base do **impacto** (H3) e do **vídeo** (H4) do RODAR no Hack Brasil 2026, trilha Logística & automação ([`HACKATHON.md`](../../HACKATHON.md)). O posicionamento do produto está no [ADR-0001](../../docs/adr/0001-integracao-setup-e-tres-dores.md).

Legenda: **[F]** dado com fonte · **[I]** inferência nossa a partir dos dados · **[H]** hipótese que só entrevista ou teste confirma.

> **Propósito do RODAR:** o caminhão para horas na doca e no pátio, e quem está ao volante tem de 45 a 54 anos (numa faixa em que metade dos brasileiros é analfabeta funcional) e não pode digitar enquanto dirige.
>
> O RODAR é um **agente de IA de voz** que avisa o recebedor antes da chegada, conta a espera, prova cada hora parada e só chama a central quando alguém precisa decidir. A **voz é o diferencial de acessibilidade**.
>
> O que vendemos é a **camada de integração (setup)**: cada fala vira evento estruturado e é entregue aos sistemas que a transportadora já usa (TMS, rastreador, financeiro). O **dashboard** é a vitrine e atende quem não tem sistema.
>
> O pitch fala de três dores:
> - **caminhoneiro:** horas paradas sem pagamento;
> - **dono:** o caminhão parado custa;
> - **financeiro:** estadia que ninguém fatura.

## 0. Como o problema entra na nota

| Regra do Hack Brasil | Consequência |
|---|---|
| H3 mede o efeito **sobre o problema e o público da trilha** | O impacto que conta é logístico: horas paradas, custo da hora e estadia não faturada. A acessibilidade explica **por que o produto chega a quem os sistemas atuais não alcançam** |
| O enquadramento é condição | O problema (caminhão parado) e o público (transportadora, motorista, recebedor) estão em "mover bens e informação de forma mais eficiente". Além disso, a trilha cita **"conectores e integrações entre sistemas"** e **"automação de fluxos de trabalho"** como exemplos: é o que o RODAR vende. A acessibilidade não deve virar o problema, senão o projeto parece da trilha Educação |
| O júri não precisa instalar nada e **não é de logística** | O vídeo explica doca e estadia em uma frase, com um número |
| Desempate: H1 → **H3** | Um número de impacto com fonte vale mais que uma tela a mais. Um conector anunciado e inexistente pesa contra os dois |
| Os READMEs de código hoje não citam números de impacto | É a alavanca mais barata de H3 antes de 30/11 |

## 0.1. Números revisados (só os marcados como confirmados vão para README, vídeo e slides)

| Afirmação | Situação | O que dá para afirmar |
|---|---|---|
| 11h40 de espera nos CDs (2025) | **Confirmado** | IER 2025 (IPTC/SETCESP), Grande SP, 175 recebedores: CDs 11h40, atacadistas 5h56, home centers 4h33, média 5h09, a maior em 10 anos [F1] |
| "Mais de 90% não recebem estadia" | **Confirmado, com ressalva** | 84,7% + 6,6% = **91,3% não recebem**, e só 8,6% recebem. A amostra da CNTA (2.002 autônomos) não é probabilística [F2] |
| 87% sem vaga exclusiva | **Confirmado, ano incerto** | Só 13% dos recebedores têm vaga para carga e descarga [F3] |
| 73% dão nota 0 a 5 à infraestrutura (CNTTT) | **Não encontrado** | Não usar |
| Alimentos 32,26% a 40% dos roubos | **Não confirmado na NTC** | nstech: 33,3% do prejuízo no 1º sem/2025 [F4] |
| Roubo ligado à fila na doca | **Sem evidência direta** | Só sabemos que a noite é o período de maior risco [F5] |
| Faixa de 46-50 anos | **Aproximado** | Média de 45 anos (CNT 2025) [F6] e 46 anos (CNTA 2025) [F7]; 54 anos para o motorista profissional (Ilos/Senatran) [F8] |
| Escolaridade baixa | **Confirmado** | 43,6% até o fundamental [F6]; 43,8% com fundamental incompleto [F7] |
| Analfabetismo funcional na faixa etária | **Confirmado (população geral)** | INAF 2024: 29% dos brasileiros de 15 a 64 anos; **51% entre 50 e 64 anos** [F29]. Não há recorte de caminhoneiros [I] |
| Hora parada ~R$ 146 | **Estimativa nossa** | R$ 80,79 (NTC 2016) corrigidos pelo índice da estadia da ANTT. Cálculo em [`impacto-e-custos.md`](../parceiro-de-estrada/impacto-e-custos.md) |
| "Portos já resolveram a fila" (versão anterior deste documento) | **Errado, corrigido** | O agendamento tirou a fila da rodovia em Paranaguá, mas a espera foi para o pátio: 6h43 em média no pico de 2023 [F23]. Em Santos, o caminhoneiro paga até ~R$ 800 por 24h de pátio regulador [F25]. Em Miritituba, a fila chegou a 25-45 km e a espera a até 3 dias na safra 2025/26 [F26] |

## 1. Entender o problema

### Qual é o problema?

O caminhão chega ao recebedor (CD, atacado, loja, terminal portuário) e fica horas parado antes de descarregar. Na Grande SP, a média foi de 5h09 em 2025 e chegou a 11h40 nos CDs [F1]. Em 2019 era 2h50 [F10]: o problema está **piorando**. Ninguém responde por esse tempo:
- o recebedor não paga;
- o motorista não cobra;
- a transportadora não tem prova;
- o financeiro não fatura.

### Onde isso acontece?

**Varejo e indústria (Grande SP, IER 2025)** [F1]:

| Tipo de recebedor | Tempo médio de descarga |
|---|---|
| Centros de distribuição (varejo e indústria) | **11h40** |
| Atacadistas e atacarejos | **5h56** |
| Média geral da Grande SP (abastecimento urbano) | **5h09** |
| Home centers e lojas de departamento | **4h33** |
| Supermercados de bairro e lojas urbanas | Sem média isolada. O melhor recebedor do ano foi um supermercado (Joanin), com **2h** |

**Portos e terminais.** Em 2025, o Brasil movimentou 1,4 bilhão de t pelos portos (+6,1%), e Santos sozinho movimentou 142,8 mi t [F27].

| Porto / corredor | O que existe | A espera hoje |
|---|---|---|
| **Santos (SP)** | Agendamento obrigatório da Autoridade Portuária (APS), fila virtual e pátios reguladores. Contêiner e carga solta: tolerância de 3h depois da janela. Granel vegetal: janela de 6h [F24] | Em 2014, o agendamento com multa baixou a permanência de 9h15 para 5h30 [F12]. Em mar/2026, o Sindgran ameaçou parar ~5 mil caminhoneiros contra a cobrança de **~R$ 800 por 24h** de pátio; o acordo com a APS prevê discutir regras para **reduzir a espera nos pátios** [F25]. Ainda há horas de fila mesmo com agendamento [F13][F24] |
| **Paranaguá (PR)** | Carga Online: o caminhão só sai da origem com data e janela; há cota por terminal e um Pátio de Triagem com 1.000 vagas [F11][F22] | Sem fila na BR-277 desde 2011 [F11]. Foram **507.915 caminhões no pátio em 2025** (+29,5%) e um recorde de 2.523 em 24h [F22]. Permanência média de **6h43** no pico de jul/2023 [F23]; não achamos o dado de 2025 |
| **Miritituba (PA), Arco Norte** | Transbordo para barcaças; acesso pela BR-163 precário [F26] | Safra 2025/26: fila de **25 a 45 km**, espera de **2 a 3 dias**, "sem água ou banheiro" [F26] |
| **Itaqui (MA)** | Agendamento consolidado, 5 pátios, 2.480 vagas [F28] | O terminal de grãos chegou à capacidade máxima [F28]. Não achamos tempo de espera |
| **Rio Grande (RS)** | — | Sem dado de fila ou espera [H] |
| **Terminais aduaneiros de fronteira** | — | Sem dado [H] |

**[I] O que os portos ensinam:**
1. O agendamento tira a fila da rodovia, mas a espera continua: ela vai para o pátio, e em Santos o motorista ainda paga por ela.
2. Cada porto tem seu próprio sistema (APS, Carga Online, Itaqui), e o mesmo motorista lida com todos.
3. A fila no porto é sazonal e enorme (safra); a do varejo é diária e espalhada.

**Onde o RODAR entra primeiro [I]:**
- **CDs, atacados e home centers:** não há agendamento obrigatório nem autoridade, e o aviso antecipado e a prova fazem mais diferença.
- **Portos:** o valor é registrar o tempo de pátio (quem paga as 24h?) e integrar com os sistemas de agendamento. Isso depende de conectores que ainda não existem [H].

### Por que isso acontece?

As 7 causas levantadas pelo time, com o nível de evidência de cada uma (detalhe na seção 3):

| # | Causa | Evidência |
|---|---|---|
| 1 | **Ausência de punição financeira** (estadia não paga) | 91,3% não recebem a estadia [F2]; a lei existe [F16] |
| 2 | **Falta de vagas exclusivas** de carga e descarga | Só 13% dos recebedores têm vaga [F3] |
| 3 | **Infraestrutura precária e poucas docas** para o volume | Indireta: os CDs têm a pior média (11h40) [F1]; Itaqui chegou à capacidade máxima [F28]. O número de 73% da CNTTT não foi encontrado |
| 4 | **Falta de funcionários para conferência** | Citada pelo IPTC, sem percentual [F1][F3] |
| 5 | **Exigências na devolução de paletes e canhotos** | Citada pelo IPTC, sem percentual [F3] |
| 6 | **Falha na conciliação de horários e agendamento** | Fila em Santos mesmo com agendamento [F13]; a espera migra para o pátio [F23][F25] |
| 7 | **Divergências comerciais ou fiscais na portaria** | Sem fonte com número [H] |

### Quem é afetado?

Os 8 grupos do levantamento, agrupados pelas três frentes do ADR-0001:

| Frente | Grupo | Como é afetado |
|---|---|---|
| **Caminhoneiro** (usuário) | Autônomo (PJ/MEI e CPF) | Horas sem receber (91% sem estadia) [F2]; no porto, paga o pátio [F25] |
| | Motorista CLT | A espera conta como jornada (STF, ADI 5322) [F14] e trava a escala |
| **Dono** (decide a compra) | Transportadoras e operadores logísticos | Ativo parado a ~R$ 146/h; CCO vive de ligação e redigitação |
| **Financeiro** (fatura) | O financeiro da transportadora | Estadia devida não faturada; uma espera de 4h (~R$ 323) nunca é cobrada [I] |
| Outros (não compram) | Embarcadores e indústrias | Prazo e custo do frete |
| | Recebedores (CDs, atacados, supermercados) | Pátio e rua cheios; hoje não pagam pela espera |
| | Consumidor final | Custo embutido no frete [I, sem número] |
| | Seguradoras e segurança pública | Carga parada exposta; noite é o período de maior risco de roubo [F5]. Não há prova de roubo na fila |
| | Trânsito e moradores | Caminhão na rua, porque 87% dos recebedores não têm vaga [F3]; filas de km em rodovias de acesso a portos [F26] |

### Quando acontece?

Na chegada sem janela, ou com janela que não é cumprida. Nos portos, o pico é a safra (fev-abr no Arco Norte) [F26]. No varejo, o pico provável é o fim de ano [H].

### Com que frequência?

46,1% dos autônomos enfrentam espera de 5h ou mais **sempre**, e 23,4% às vezes [F15].

### Qual é a gravidade?

- **Caminhoneiro:** horas sem receber; no porto, até ~R$ 800 por 24h de pátio [F25]; até 3 dias sem água ou banheiro em Miritituba [F26].
- **Dono:** ~R$ 146/h de caminhão parado. Com 4h de espera na coleta e 4h na entrega, 9 fretes/mês dão ~72h paradas por caminhão por mês (cálculo em `impacto-e-custos.md`).
- **Financeiro:**
  - a estadia só vale depois de 5h e paga R$ 75/h para 30 t [F16], cerca de metade do custo da hora;
  - uma espera de 4h (~R$ 323) não gera cobrança nenhuma [I].
- **Segurança (só referência):** nos EUA, +15 min de espera média → +6,2% na taxa esperada de acidentes. Os dados são de 2013, e a FMCSA contestou a conclusão [F17].

### O que acontece se não for resolvido?

A espera piora (2h50 → 5h09 entre 2019 e 2025) [F1][F10], a movimentação nos portos bate recorde [F22][F27] e a categoria envelhece (54 anos em média) [F8]. [I] Cada hora parada tira capacidade de uma frota que não se renova, e o custo continua sem dono.

### Por que ainda não foi resolvido?

1. **A lei existe:** estadia depois de 5h e multa de até 5% do valor da carga [F16][F18]. Falta cobrança.
2. **Assimetria de poder:** 67,1% conhecem a lei, e 91% não recebem [F2].
3. **A estadia paga pouco e tarde** [F16].
4. **A fiscalização depende de denúncia** [F18], e só 6,6% denunciam [F2].
5. **As ferramentas são do pátio e da tela.** Agendamento, gestão de pátio e portais portuários são vendidos ao recebedor ou ao terminal [F19][F20] e pedem que o motorista leia e digite [I].
6. **Os sistemas da transportadora não conversam com a espera.** TMS, rastreador e financeiro não recebem a hora de chegada e de descarga de forma estruturada; o CCO redigita. [I, a confirmar nas entrevistas]

## 2. Entender as pessoas afetadas

### Quem são as pessoas afetadas?

- **Caminhoneiro (usuário):** 99,7% homens; média de 45-46 anos, chegando a 54 entre motoristas profissionais; 43,6% estudaram até o fundamental [F6][F7][F8]. Os autônomos trabalham ~14h/dia, 25 dias por mês [F7].
- **Dono (comprador):** transportadora ou autônomo dono do caminhão. Paga setup + assinatura (~R$ 100 por caminhão por mês; o preço do setup está em aberto) [H].
- **Financeiro:** quem fatura frete e estadia na transportadora.

**Acessibilidade: por que a voz.**
- **Leitura:** metade dos brasileiros de 50 a 64 anos é analfabeta funcional (INAF 2024) [F29], e é para essa faixa que a categoria caminha [F8]. Com 43,6% até o fundamental [F6], a proporção entre caminhoneiros deve ser alta [I].
- **Mãos e olhos ocupados:**
  - segurar ou manusear o celular ao volante é infração gravíssima, e fone de ouvido também é infração (CTB, art. 252) [F30];
  - digitar multiplica por ~23 o risco de evento crítico, e falar em viva-voz não aumenta (Olson et al., FMCSA 2009) [F31].
- **O celular ele já usa:** 91% dos autônomos usam app de carga [F9]. A barreira é ler, digitar e navegar num portal diferente em cada CD e porto [F8].

### Como lidam com o problema hoje?

- **Caminhoneiro:** espera, dorme na cabine e não cobra (84,7%) [F2]; avisa por áudio de WhatsApp [F9]; no porto, às vezes paga o pátio [F25].
- **Dono/CCO:** liga para o motorista e para o recebedor e redigita no TMS [I].
- **Financeiro:** sem prova, não fatura a estadia [I].

### Quais são as maiores dificuldades?

- Não saber quando vai descarregar.
- Não ter onde parar [F3].
- Exigências extras, como paletes e restrição de horário [F3].
- Um sistema de agendamento diferente em cada porto ou cliente [F11][F24].
- Pagar pela espera no porto [F25].
- Do lado da empresa: não ter prova do tempo.

A ordem entre elas é [H].

### O que elas mais gostariam de melhorar?

Não há dado direto. Indícios:
- em Santos, a pauta do sindicato é reduzir o tempo e o custo do pátio [F25];
- no Arco Norte, ter condições básicas na fila [F26].

[H] Previsibilidade e receber pela espera.

### Já tentaram alguma solução? Por que não funcionou?

| Tentativa | Por que não resolveu |
|---|---|
| Denúncia à ANTT (6,6%) [F2] | Medo de perder frete; a fiscalização é reativa [F18] |
| Paralisação (Santos, mar/2026) [F25] | Resolve o caso pontual, não o fluxo |
| Apps de terminal único (Caminho Ágil, da Santos Brasil) [F21] | Servem um terminal; o motorista roda entre vários |
| Agendamento e gestão de pátio [F19][F20] | São do recebedor e da tela. Não chegam a quem dirige nem ao sistema da transportadora [I] |

**Cuidado no pitch:** fale de **acessibilidade**, não de "pessoa com dificuldade em tecnologia". O motorista usa o celular. O que o exclui é o portal escrito e a lei que o proíbe de tocar no aparelho dirigindo.

## 3. Investigar as causas

### Qual é a causa principal?

O tempo do caminhão não custa nada a quem o retém [I]. No porto, o custo chega a ser transferido ao motorista [F25].

### Quais fatores contribuem?

As causas 2 a 7 da seção 1:
- vagas, docas e pátios insuficientes [F3][F28];
- falta de conferentes;
- paletes e canhotos;
- janelas não cumpridas [F13];
- divergência fiscal;
- acesso rodoviário precário (BR-163) [F26];
- picos de safra acima da capacidade [F26][F28].

### Falta de informação, tempo, recursos ou processo?

- **Recursos** (docas, conferentes, pátio) e **processo** (agendamento): são do recebedor ou do terminal.
- **Incentivo:** depende do contrato entre embarcador, transportadora e recebedor.
- **Informação:** é onde o RODAR atua. O aviso chega antes ao recebedor; o tempo vira registro auditável; o evento chega ao sistema da transportadora; e o motorista participa **falando**.

### Existe alguma causa que não é tão evidente?

Sim. **O fluxo logístico pressupõe que o motorista leia e digite.** Grande parte do público não consegue fazer isso, ou não pode fazer isso dirigindo [F29][F30]. E **os sistemas da empresa não recebem a espera**. [I] Sem registro na origem, a espera fica sem dono do caminhão ao financeiro.

**5 porquês (CD):**
1. O caminhão fica 11h no CD → porque não há doca livre.
2. Não há doca livre → porque o CD não controla a chegada.
3. O CD não controla a chegada → porque esperar não lhe custa nada.
4. Esperar não custa nada → porque ninguém registra nem fatura o tempo.
5. Ninguém registra → porque o registro depende de um motorista que dirige, de portais escritos e de redigitação no TMS.

**5 porquês (porto):**
1. O caminhão fica horas no pátio regulador → porque o terminal não chama.
2. O terminal não chama → porque a janela não casou com a capacidade do dia.
3. A janela não casou → porque o agendamento é feito longe do motorista e não se ajusta ao atraso real.
4. O motorista paga o pátio → porque não há registro de quem causou a espera.

### Se eu resolver uma das causas, o problema realmente diminui?

- **A favor:** Paranaguá tirou a fila da rodovia com cota e janela [F11]; o agendamento com multa reduziu a permanência em Santos [F12]; o Joanin descarrega em 2h [F1].
- **Contra:** a espera migrou para o pátio [F23][F25], e em Santos há fila mesmo com agendamento [F13].
- **[I] Conclusão honesta:** a voz não cria doca. O efeito do RODAR vem de:
  - (a) **antecipar a chegada**, para o recebedor preparar a doca;
  - (b) **tornar o tempo comprovável** e entregá-lo ao financeiro, que pode cobrar.

  A acessibilidade faz isso acontecer **em toda entrega**, e não só quando o motorista consegue digitar.

## 4. Pensar na solução

### Como esse problema poderia ser resolvido?

Três alavancas, da mais forte para a mais fraca:
1. Regra imposta por quem controla o acesso (portos).
2. Custo contratual da espera.
3. Informação e prova.

O RODAR atua na 3 e, via integração com o financeiro, alimenta a 2.

### Já existe alguma solução que funciona?

- **Portos:** agendamento obrigatório [F11][F24].
- **Varejo:** agendamento de docas e gestão de pátio, vendidos ao recebedor [F19][F20]. Os números de redução de espera desses sistemas são **do fabricante** [F19].

### O que poderia ser feito de maneira diferente?

Inverter o ponto de partida. Em vez de começar no pátio e na tela do recebedor, começar **na voz do motorista** e terminar **nos sistemas da transportadora**:

| Barreira de hoje | Como o RODAR resolve | Estado |
|---|---|---|
| Não pode tocar no celular dirigindo [F30] | Conversa por voz em tempo real, celular no suporte (Agora Conversational AI) | Implementado |
| Leitura difícil para quase metade do público [F6][F29] | O agente pergunta o que falta ("qual doca?") e confirma em voz alta | Implementado |
| Um portal diferente em cada cliente e porto [F8][F24] | Um único interlocutor, em português falado | Implementado |
| O recebedor não sabe que o caminhão está chegando | Aviso na aproximação (geocerca) ao recebedor e ao CCO | Implementado |
| A espera não tem prova | Contador de estadia com hora do servidor e GPS em dupla prova | Implementado (o rastreador é simulado) |
| Recebedor que não responde | Escalonamento: insiste com o CCO e, sem resposta, liga para o recebedor | Implementado (ligação real desligada; plano B por RTC) |
| O CCO redigita no TMS | Evento entregue ao TMS (EDI OCOREN) | **Roadmap** |
| O financeiro não fatura a estadia | Estadia devida por entrega entregue ao financeiro/ERP | **Roadmap** (hoje, só no painel) |
| Ninguém sabe quem atrasa | Indicadores de estadia por recebedor | Implementado (painel) |

### Como a solução seria melhor do que as alternativas?

- Os sistemas atuais são do pátio e da tela. O RODAR é **do motorista e da voz**. Do lado do recebedor, não precisa de integração: o aviso chega por voz ou ligação.
- Ele integra com o que a transportadora já tem, em vez de competir com o TMS, a telemetria ou o YMS. A arquitetura de portas e adaptadores já existe no backend (ADR-0001).
- Áudio de WhatsApp é voz, mas não vira dado: não gera aviso estruturado, Task, prova com hora nem fatura [I].
- **Onde é pior:**
  - não cria doca;
  - nenhum conector de mercado existe hoje;
  - sem integração com o agendamento portuário, não ajusta a janela;
  - o reconhecimento de voz em cabine barulhenta e com sotaques ainda não foi testado [H].

### Qual é a menor versão da solução que já seria útil?

Já existe: app, backend e painel, com 512 testes e uma validação ponta a ponta de 33/33 etapas (segundo os READMEs). Ela serve ao cliente **sem sistema**, via dashboard. Para o cliente **com sistema**, a menor versão útil acrescenta **um conector**: a ocorrência de chegada e descarga no formato **EDI OCOREN**, padrão dos TMS brasileiros.

### Quais recursos seriam necessários?

- Agora ConvoAI (voz) e um LLM.
- Um número de telefone para a ligação real. O Nvoip Pro dos participantes pode servir, mas falta confirmar a integração com a Agora [H].
- Especificação do EDI OCOREN (Proceda) e um TMS de teste.
- Uma transportadora parceira para o piloto.
- Para portos, acesso às APIs de agendamento [H].

## 5. Validar a ideia

### Como posso confirmar que esse problema realmente existe?

Por dados secundários já está confirmado [F1][F2][F25][F26]. Falta confirmar, com a transportadora:
- qual frente dói mais (as horas do caminhão, a estadia não faturada, o pátio ou o CCO sobrecarregado);
- **quais sistemas ela usa** (TMS, rastreador, ERP), para priorizar conectores.

### Como posso conversar com pessoas afetadas?

- **Caminhoneiros:** 10 em postos perto de polos de CD (Cajamar, Guarulhos, Barueri) e no pátio regulador de Cubatão (Santos).
- **Donos e financeiro:** 2 a 3 transportadoras pequenas (gestor de frota, CCO e quem fatura).
- Pergunte sobre o **passado**:
  - "Na última entrega, quanto tempo esperou? Cobrou? Pagou o pátio?"
  - "Quanto de estadia vocês faturaram no último mês? Em que sistema registram a chegada?"

### Como posso testar antes de desenvolver o projeto completo?

O produto base existe. O que falta testar antes de construir são os **conectores** e a **acessibilidade**:
- **Conector:** gerar à mão um arquivo OCOREN a partir de uma viagem da demo e pedir a uma transportadora que o importe no TMS dela.
- **Setup:** perguntar quanto pagariam pela implantação antes de escrever o conector.
- **Acessibilidade:** comparar voz e formulário com motoristas de **50 anos ou mais**: taxa de conclusão do check-in, tempo e pedidos de ajuda.

**Quando:** de 01/12 a 12/12, com os repositórios congelados. Entrevistas e números vão para os slides da final, que tem notas novas.

### Como vou saber se a solução funcionou?

- **Caminhoneiro:** % de entregas com chegada e descarga registradas por voz; conclusão por voz × formulário no grupo com 50 anos ou mais.
- **Dono:** minutos entre o aviso e a chegada; ligações do CCO evitadas.
- **Financeiro:** estadia devida identificada (R$) × estadia faturada.

### Quais resultados demonstrariam que o projeto foi bem-sucedido?

- **No Hack Brasil:** pelo menos 20/40 na fase online, para ir à final.
- **No piloto:**
  - uma transportadora importando os eventos no próprio sistema;
  - estadia faturada que antes não era;
  - motoristas de 50 anos ou mais concluindo o fluxo por voz sem ajuda.

## 6. Planejar o desenvolvimento

### Qual é o objetivo principal do projeto?

Com voz, colocar no fluxo logístico o motorista que os portais excluem, e entregar a espera, comprovada, aos sistemas de quem pode cobrá-la. Assim o caminhão parado passa a ter dono do motorista ao financeiro.

### O que precisa ser desenvolvido primeiro?

Por ordem de retorno na nota, até 30/11:
1. **Demo pública HTTPS no ar** (H1, primeiro desempate).
2. **Vídeo de até 3 min** (H4):
   - "11h40 parado num CD de SP; 9 em cada 10 autônomos não recebem pela espera";
   - "quem está ao volante não pode digitar, e metade dos brasileiros de 50 a 64 anos não lê com fluência";
   - o produto por voz: aviso, chegada, estadia, escalonamento;
   - o mesmo evento chegando ao painel (e ao sistema da transportadora, se o conector existir);
   - "estadia comprovada: R$ X". O motorista deixa de esperar sem dono, o dono recupera hora de caminhão, o financeiro fatura.
3. **Números com fonte** no bloco "Para o júri" dos três READMEs, só os confirmados da tabela 0.1.
4. **Frase do painel:** logística primeiro, acessibilidade como o "como", integração como o que vendemos.
5. **Se sobrar tempo:** o conector EDI OCOREN no `rodar-backend` (responsável: Lucas).

### Quais funcionalidades são indispensáveis?

As que já estão no produto:
- voz;
- aviso na aproximação;
- chegada e contador de estadia;
- escalonamento;
- dashboard.

Para a venda (pós-hackathon): pelo menos um conector de TMS.

### Quais tecnologias e conhecimentos serão necessários?

- **No produto:** React Native/Expo (app), FastAPI + Postgres (backend), React + Vite (painel), Agora Conversational AI (voz), OpenAI (LLM), Docker e hospedagem HTTPS para a demo.
- **Para integrar:** EDI OCOREN (Proceda), APIs de rastreadores e de agendamento portuário.
- **Do domínio:** Lei 11.442 (cálculo da estadia), LGPD e CTB art. 252.

### Quais são as principais dificuldades?

- A demo cair durante a avaliação.
- A voz real depende de chaves e créditos.
- O comprador não é o usuário.
- **Nenhum conector de mercado existe hoje**: não anunciar integração que não roda.
- O setup alonga o ciclo de venda.
- O GPS de celular é contestável (a dupla prova com o rastreador é simulada).
- O reconhecimento de voz em cabine ainda não foi testado.
- **Commit depois de 30/11 23h59 desclassifica.**

### Quanto tempo temos?

Até **30/11/2026 23h59** para submeter. De 01/12 a 12/12, repositórios congelados (só entrevistas, slides e ensaio). Final presencial em **12/12** (São Paulo), onde o time termina o projeto no local.

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
- [F17] [Driver detention increases crash risk and costs — DOT OIG, 2018](https://www.oig.dot.gov/sites/default/files/FMCSA%20Driver%20Detention%20Final%20Report.pdf)
- [F18] [Nota Técnica ANTT 4102 (carga e descarga)](https://www.gov.br/antt/pt-br/assuntos/cargas/carga-descarga/sei_41736493_nota_tecnica___antt_4102.pdf)
- [F19] [DHL Supply Chain e Trackage lançam solução de gestão de pátio — Mundo Logística](https://mundologistica.com.br/noticias/dhl-supply-chain-e-trackage-lancam-solucao-para-gestao-de-patio)
- [F20] [Case Cascades — Opendock](https://lp.opendock.com/hubfs/5041527/%5BCASE%5D%20Cascades%20BR-PT.pdf)
- [F21] [Santos Brasil desenvolve app para caminhoneiros — Mobile Time](https://www.mobiletime.com.br/noticias/21/05/2021/santos-brasil-desenvolve-app-para-caminhoneiros-e-chega-a-mais-de-1-mil-maus-em-2-meses/)
- [F22] [Pátio de Triagem de Paranaguá recebe mais de meio milhão de caminhões em 2025 — Governo do PR](https://www.parana.pr.gov.br/Audio/Novo-recorde-Patio-de-Triagem-de-Paranagua-recebe-mais-de-meio-milhao-de-caminhoes-em-2025) · [Recorde de 2,5 mil caminhões em 24h — Governo do PR](https://www.parana.pr.gov.br/Audio/Porto-de-Paranagua-registra-movimento-historico-de-mais-de-25-mil-caminhoes-em-24-horas)
- [F23] [Porto de Paranaguá recebe o maior volume de caminhões da história no Pátio de Triagem (permanência de 6h43, jul/2023) — AEN-PR](https://www.parana.pr.gov.br/aen/Noticia/Porto-de-Paranagua-recebe-o-maior-volume-de-caminhoes-da-historia-no-Patio-de-Triagem)
- [F24] [Norma de agendamento de caminhões no Porto de Santos muda de fase — Sindicomis](https://sindicomis.com.br/norma-de-agendamento-de-caminhes-no-porto-de-santos-muda-de-fase-em-1-de-janeiro/) · [Panorama de 2025: contêineres no Porto de Santos — Rodoquick (blog de transportadora, fonte fraca)](https://rodoquick.com.br/blog/panorama-de-2025-como-foi-o-transporte-de-containers-no-brasil-e-no-porto-de-santos/)
- [F25] [APS e Sindgran suspendem paralisação de caminhoneiros no Porto de Santos — Agência Infra, mar/2026](https://agenciainfra.com/blog/aps-e-sindgran-suspendem-paralisacao-de-caminhoneiros-no-porto-de-santos/) · [Cobrança de ~R$ 800 por dia no pátio — Click Petróleo e Gás](https://clickpetroleoegas.com.br/cerca-de-5-mil-caminhoneiros-vao-parar-o-porto-de-santos-por-24-horas-na-quarta-feira-contra-uma-cobranca-de-800-reais-por-dia-btl96/)
- [F26] [Fila de 45 km e até 3 dias sem água ou banheiro em Miritituba — Compre Rural](https://comprerural.com/caminhoneiros-enfrentam-fila-de-45-km-e-ate-3-dias-sem-agua-ou-banheiro-para-descarregar-soja-no-para/) · [Engarrafamento retarda exportação de soja no Pará — Forbes, fev/2026](https://forbes.com.br/forbes-agro/2026/02/engarrafamento-de-caminhoes-retardam-exportacao-recorde-de-soja-no-para/) · [Fila pode durar até abril, diz Abiove — Compre Rural](https://comprerural.com/preocupacao-fila-de-caminhoes-com-soja-no-para-pode-durar-ate-abril-diz-abiove/)
- [F27] [Antaq: portos movimentam 1,4 bi de toneladas em 2025 — IstoÉ](https://istoe.com.br/antaq-portos-movimentam-14-bi-de-toneladas-em-2025-alta-anual-de-61-e-recorde-historico)
- [F28] [Plano Safra — apresentação do MPor (Itaqui: agendamento, 5 pátios, 2.480 vagas), 2024](https://www.gov.br/portos-e-aeroportos/pt-br/assuntos/noticias/2024/02/apresentacao-plano-safra-mpor-1/@@download/file) · [Porto de Itaqui chega ao limite para grãos — InfoMoney](https://www.infomoney.com.br/?p=2391294)
- [F29] [INAF 2024: analfabetismo funcional em 29% — UNICEF Brasil](https://www.unicef.org/brazil/comunicados-de-imprensa/analfabetismo-funcional-nao-apresenta-melhora-e-alcanca-29-por-cento-dos-brasileiros-mesmo-patamar-de-2018-aponta-novo-levantamento-do-inaf) · [51% entre 50 e 64 anos — Viva](https://viva.com.br/carreira-e-educacao/analfabetismo-funcional-alcanca-51-dos-brasileiros-entre-50-e-64-anos.html)
- [F30] [Artigo 252 do CTB — Âmbito Jurídico](https://ambitojuridico.com.br/artigo-252-do-ctb/)
- [F31] [Driver Distraction in Commercial Vehicle Operations — Olson et al., FMCSA/VTTI, 2009](https://www.fmcsa.dot.gov/sites/fmcsa.dot.gov/files/docs/DriverDistractionStudy.pdf)
- [Regulamento do Hack Brasil 2026](https://hackbrasil.com/regulamento)
