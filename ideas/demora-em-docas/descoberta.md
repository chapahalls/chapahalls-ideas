# Demora em docas: descoberta do problema

25/11/2026 · As perguntas de descoberta (1 a 6), com fonte em cada número. Base do **impacto** (H3) e do **vídeo** (H4) do RODAR no Hack Brasil 2026, trilha Logística & automação ([`HACKATHON.md`](../../HACKATHON.md)).

Legenda: **[F]** dado com fonte · **[I]** inferência nossa a partir dos dados · **[H]** hipótese que só entrevista ou teste confirma.

> **Propósito do RODAR:** o caminhão para horas na doca e no pátio, e quem está ao volante é um público de 45 a 54 anos, em que metade dos brasileiros de 50 a 64 anos é analfabeta funcional, e que não pode digitar enquanto dirige. O RODAR é um **agente de IA de voz** que leva essa pessoa para dentro do fluxo logístico sem tela e sem portal: avisa o recebedor antes da chegada, conta a espera, prova cada hora parada e só chama a central quando alguém precisa decidir. A voz é o diferencial de **acessibilidade**; o resultado é logístico: menos caminhão parado sem dono.

## 0. Como o problema entra na nota

| Regra do Hack Brasil | Consequência |
|---|---|
| H3 mede o efeito **sobre o problema e o público da trilha** | O impacto que conta é logístico: horas paradas, custo da hora e informação que não chega ao recebedor. A acessibilidade explica **por que o produto chega a quem os sistemas atuais não alcançam** |
| O enquadramento é condição | O problema (caminhão parado) e o público (transportadora, motorista, recebedor) estão em "mover bens e informação de forma mais eficiente". A acessibilidade não deve virar o problema, senão o projeto parece da trilha Educação |
| O júri não precisa instalar nada e **não é de logística** | O vídeo explica doca e estadia em uma frase, com um número |
| Desempate: H1 → **H3** | Um número de impacto com fonte vale mais que uma tela a mais |
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
| Analfabetismo funcional na faixa etária | **Confirmado (população geral)** | INAF 2024: 29% dos brasileiros de 15 a 64 anos; **51% entre 50 e 64 anos** [F29]. Não há recorte específico de caminhoneiros [I] |
| "Portos já resolveram a fila" (versão anterior deste documento) | **Errado, corrigido** | O agendamento tirou a fila da rodovia em Paranaguá, mas a espera foi para o pátio: 6h43 em média no pico de 2023 [F23]. Em Santos, o caminhoneiro paga até ~R$ 800 por 24h de pátio regulador [F25]. Em Miritituba, a fila chegou a 25-45 km e a espera a até 3 dias na safra 2025/26 [F26]. Ver seção 1.1 |

## 1. Entender o problema

**Qual é o problema?** O caminhão chega ao recebedor (CD, atacado, loja, terminal portuário) e fica horas parado antes de descarregar. Na Grande SP, a média foi de 5h09 em 2025, e chegou a 11h40 nos CDs [F1]. Em 2019 era 2h50 [F10]: o problema está **piorando**.

### 1.1. Onde acontece

**Varejo e indústria (Grande SP, IER 2025)** [F1]:

| Tipo de recebedor | Tempo médio de descarga |
|---|---|
| Centros de distribuição (varejo e indústria) | **11h40** |
| Atacadistas e atacarejos | **5h56** |
| Média geral | **5h09** |
| Home centers e lojas de departamento | **4h33** |
| Melhor recebedor (supermercado Joanin) | **2h** |

**Portos e terminais.** Em 2025, o Brasil movimentou 1,4 bilhão de t pelos portos (+6,1%), e Santos sozinho movimentou 142,8 mi t [F27]. O grosso dessa carga chega de caminhão:

| Porto / corredor | O que existe | A espera hoje |
|---|---|---|
| **Santos (SP)** | Agendamento obrigatório da Autoridade Portuária (APS), fila virtual e pátios reguladores. Contêiner e carga solta: tolerância de 3h depois da janela. Granel vegetal: janela de 6h [F24] | Em 2014, o agendamento com multa baixou a permanência de 9h15 para 5h30 [F12]. Em mar/2026, o sindicato Sindgran ameaçou parar ~5 mil caminhoneiros contra a cobrança de **~R$ 800 por 24h** de pátio regulador. O acordo com a APS prevê discutir regras para **reduzir o tempo de espera nos pátios** [F25]. Em 2025 houve filas nos terminais de contêiner [F24]. Ainda há horas de fila mesmo com agendamento [F13] |
| **Paranaguá (PR)** | Carga Online: o caminhão só sai da origem com data e janela; há cota por terminal e um Pátio de Triagem com 1.000 vagas [F11][F22] | Sem fila na BR-277 desde 2011 [F11]. O pátio recebeu **507.915 caminhões em 2025** (+29,5%) e bateu recorde de 2.523 em 24h [F22]. Permanência média de **6h43** no pico de jul/2023 [F23]; não achamos o dado de 2025 |
| **Miritituba (PA), Arco Norte** | Estação de transbordo para barcaças. O acesso pela BR-163 tem trechos precários [F26] | Safra 2025/26: fila de **25 a 45 km**, espera de **2 a 3 dias**, "sem água ou banheiro". A Abiove alertou que a fila poderia durar até abril [F26] |
| **Itaqui (MA)** | Agendamento consolidado, 5 pátios e 2.480 vagas [F28] | O terminal de grãos (Tegram) chegou à capacidade máxima e pediu ampliação da recepção de caminhões [F28]. Não achamos tempo de espera |
| **Rio Grande (RS)** | — | Não achamos dado de fila ou de espera [H] |

**[I] O que os portos ensinam:**
1. O agendamento **tira a fila da rodovia, mas não zera a espera**: ela vai para o pátio regulador, e em Santos o motorista ainda paga por ela.
2. Cada porto tem **seu próprio sistema** (APS, Carga Online, Itaqui), e o motorista que roda entre eles precisa lidar com todos.
3. A fila no porto é **sazonal e enorme** (safra), enquanto a do varejo é **diária e espalhada**.

**[I] Onde o RODAR entra primeiro:** nos **CDs, atacados e home centers**, onde não há agendamento obrigatório nem autoridade, e o aviso antecipado e a prova do tempo fazem mais diferença. Nos **portos**, o valor é outro: **registrar o tempo de pátio** (quem paga as 24h?) e **guiar o motorista por voz** num sistema de agendamento que ele não domina. Isso não está implementado e depende de integração [H].

**Quando acontece?** Na chegada sem janela, ou com janela que não é cumprida. Nos portos, o pico é a safra (fev-abr no Arco Norte [F26]). No varejo, o pico provável é o fim de ano [H].

**Com que frequência?** 46,1% dos autônomos enfrentam espera de 5h ou mais **sempre**, e 23,4% às vezes [F15].

**Qual é a gravidade?**
- **Dinheiro:** a hora parada custa ~R$ 146 (estimativa em [`impacto-e-custos.md`](../parceiro-de-estrada/impacto-e-custos.md)). A estadia só é paga depois de 5h e cobre cerca de metade disso: R$ 75/h para 30 t [F16].
- **Custo escondido:** uma espera de 4h (~R$ 323) não gera cobrança nenhuma, porque fica abaixo da franquia de 5h. [I]
- **No porto o custo se inverte:** o motorista ainda paga o pátio (~R$ 800 por 24h em Santos) [F25].
- **Condições:** até 3 dias sem água ou banheiro na fila de Miritituba [F26].
- **Segurança (só referência):** nos EUA, +15 min de espera média → +6,2% na taxa esperada de acidentes. Os dados são de 2013 e a FMCSA contestou a conclusão [F17].

**O que acontece se não resolver?** A espera piora (2h50 → 5h09 entre 2019 e 2025) [F1][F10] e a movimentação nos portos bate recorde ano a ano [F22][F27]. Isso acontece numa categoria que envelhece (54 anos em média [F8]). [I] Cada hora parada tira capacidade de uma frota que não se renova.

**Por que ainda não foi resolvido?**
1. **A lei existe:** estadia depois de 5h e multa de até 5% do valor da carga [F16][F18]. Falta cobrança.
2. **Assimetria de poder:** 67,1% conhecem a lei e 91% não recebem a estadia [F2].
3. **A estadia paga pouco e tarde** [F16].
4. **A fiscalização depende de denúncia** [F18], e só 6,6% denunciam [F2].
5. **As ferramentas são do pátio e da tela.** Agendamento, gestão de pátio e portais portuários são vendidos ao recebedor ou ao terminal [F19][F20] e pedem que o motorista leia e digite. [I] Isso exclui justamente o público com mais dificuldade de leitura e que está dirigindo.

## 2. Entender as pessoas afetadas

**Quem são?**
- **Usuário: o caminhoneiro.** 99,7% são homens. A média de idade é de 45-46 anos, chegando a 54 entre motoristas profissionais. 43,6% estudaram até o fundamental [F6][F7][F8].
- **Comprador: a transportadora.** O preço discutido no repo é R$ 100 por caminhão por mês.
- **Também afetados:** o recebedor (CD, atacado, terminal), o embarcador e a cidade (fila na rua; 87% dos recebedores não têm vaga [F3]).

**Acessibilidade: por que a voz.**
- **Leitura:** metade dos brasileiros de 50 a 64 anos é analfabeta funcional (INAF 2024) [F29]. É a faixa para onde a categoria caminha [F8]. Não há recorte para caminhoneiros, mas com 43,6% até o fundamental [F6] é razoável supor que a proporção seja alta. [I]
- **Mãos e olhos ocupados:** segurar ou manusear o celular ao volante é infração **gravíssima**, e fone de ouvido também é infração (CTB, art. 252) [F30]. Digitar mensagem multiplica por ~23 o risco de evento crítico em caminhões, contra nenhum aumento ao falar em viva-voz (Olson et al., FMCSA 2009) [F31]. Com a voz pelo alto-falante, o celular fica no suporte e o motorista não toca nele.
- **O celular ele já usa:** 91% dos autônomos usam app de carga [F9]. A barreira não é ter o aparelho. É **ler, digitar e navegar num portal diferente em cada CD e em cada porto** [F8]. A dificuldade com ferramentas digitais de trabalho é maior acima de 50 anos (declaração do CEO da Motz, sem número) [F8].

**Como lidam hoje?** Esperam, dormem na cabine e não cobram (84,7%) [F2]. Comunicam-se por áudio de WhatsApp e apps de frete [F9]. Nos portos, alguns pagam o pátio [F25].

**Maiores dificuldades:**
- não saber quando vai descarregar;
- não ter onde parar [F3];
- exigências extras, como paletes e restrição de horário [F3];
- um sistema de agendamento diferente em cada porto ou cliente [F24][F11];
- pagar pela espera no porto [F25].

A ordem entre elas é [H].

**O que gostariam de melhorar?** Não há dado direto. Indícios: em Santos, a pauta do sindicato é reduzir o tempo e o custo do pátio [F25]; no Arco Norte, ter condições básicas na fila [F26]. [H] Previsibilidade e receber pela espera.

**Já tentaram alguma solução?** Denúncia (6,6%) [F2], greve ou paralisação (Santos, mar/2026) [F25] e apps de terminal único, como o Caminho Ágil da Santos Brasil [F21]. **Por que não basta:** cada solução cobre um terminal, e todas pressupõem tela e leitura. [I]

**Cuidado no pitch:** fale de **acessibilidade**, não de "pessoa com dificuldade em tecnologia". O motorista usa o celular. O que o exclui é o portal escrito e a lei que o proíbe de tocar no aparelho dirigindo.

## 3. Investigar as causas

**Causa principal:** o tempo do caminhão não custa nada a quem o retém. [I] Nos portos, o custo chega a ser transferido ao motorista [F25].

**Fatores que contribuem:**
- docas, vagas e pátios insuficientes [F3][F28];
- falta de conferentes, paletes e canhotos, divergência fiscal;
- janelas de agendamento que não são cumpridas [F1][F3][F13];
- acesso rodoviário precário (BR-163) [F26];
- picos de safra acima da capacidade dos terminais [F26][F28].

**Informação, tempo, recursos ou processo?**
- **Recursos** (docas, conferentes, pátio) e **processo** (agendamento): são do recebedor ou do terminal.
- **Incentivo:** depende do contrato entre embarcador, transportadora e recebedor.
- **Informação e acesso a ela:** é onde o RODAR atua. O aviso chega ao recebedor antes da chegada, o tempo vira registro auditável, e o motorista participa **falando**, sem tela.

**Causa pouco evidente:** o fluxo logístico pressupõe que o motorista leia e digite, e uma parte grande do público não consegue fazer isso, ou não pode fazer isso dirigindo [F29][F30]. [I] Quando ele não registra a chegada, não avisa o atraso e não guarda a prova, a espera fica sem dono.

**5 porquês (CD):**
1. O caminhão fica 11h no CD → porque não há doca livre.
2. Não há doca livre → porque o CD não controla a chegada.
3. O CD não controla a chegada → porque esperar não lhe custa nada.
4. Esperar não custa nada → porque ninguém registra o tempo.
5. Ninguém registra o tempo → porque o registro depende de um motorista que dirige e de portais escritos.

**5 porquês (porto):**
1. O caminhão fica horas no pátio regulador → porque o terminal não chama.
2. O terminal não chama → porque a janela não casou com a capacidade do dia.
3. A janela não casou → porque o agendamento é feito longe do motorista e não se ajusta ao atraso real.
4. O motorista paga o pátio → porque não há registro de quem causou a espera.

**Se eu resolver uma causa, o problema diminui?**
- **A favor:** Paranaguá tirou a fila da rodovia com cota e janela [F11]. O agendamento com multa reduziu a permanência em Santos [F12]. O Joanin descarrega em 2h [F1].
- **Contra:** a espera migrou para o pátio [F23][F25], e em Santos há fila mesmo com agendamento [F13].
- **[I] Conclusão honesta:** a voz não cria doca. O efeito do RODAR vem de (a) **antecipar a chegada**, para o recebedor preparar a doca, e (b) **tornar o tempo comprovável** para quem pode cobrar. A acessibilidade garante que isso aconteça **em toda entrega**, e não só quando o motorista consegue digitar.

## 4. Pensar na solução

**Como poderia ser resolvido?** Três alavancas, da mais forte para a mais fraca:
1. Regra imposta por quem controla o acesso (portos).
2. Custo contratual da espera.
3. Informação e prova.

O RODAR atua na 3 e alimenta a 2.

**Já existe algo que funciona?** Nos portos há agendamento obrigatório [F11][F24]. No varejo há sistemas de agendamento e de gestão de pátio, vendidos ao recebedor [F19][F20]. Os números de redução de espera desses sistemas são **do fabricante** [F19].

**O diferencial do RODAR: IA de voz como acessibilidade.**

| Barreira de hoje | Como o RODAR resolve | Onde está no produto |
|---|---|---|
| O motorista não pode tocar no celular dirigindo [F30] | Conversa por voz em tempo real, com o celular no suporte (Agora Conversational AI) | app + backend |
| Leitura difícil para quase metade do público [F6][F29] | O agente pergunta o que falta ("qual doca?") e confirma em voz alta. Nenhum formulário | app |
| Um portal diferente em cada cliente e porto [F8][F24] | Um único interlocutor, em português falado, para qualquer recebedor | app |
| O recebedor não sabe que o caminhão está chegando | Aviso na **aproximação** (geocerca) ao recebedor e ao CCO | backend |
| A espera não tem prova | Contador de estadia com hora do servidor e GPS em dupla prova | backend + painel |
| Recebedor que não responde | Escalonamento: insiste com o CCO e, sem resposta, **liga para o recebedor** e registra a resposta | backend (ligação real desligada; plano B por canal RTC) |
| Ninguém sabe quem atrasa | Indicadores de estadia por recebedor | painel |

**Por que é melhor que as alternativas:**
- Os sistemas atuais são do pátio e da tela. O RODAR é **do motorista e da voz**, e funciona em qualquer recebedor sem integração.
- Áudio de WhatsApp é voz, mas não vira dado: nenhum aviso estruturado, nenhuma Task, nenhuma prova com hora. [I]

**Onde é pior:**
- Não cria doca.
- Nos portos, sem integração com o agendamento (APS, Carga Online), não ajusta a janela; só registra e avisa [H].
- O reconhecimento de voz em cabine barulhenta e com sotaques regionais é um risco técnico [H].

**Menor versão útil:** já existe. São 512 testes e uma validação ponta a ponta de 33/33 etapas, segundo os READMEs. Faltam a demo pública e o vídeo (seção 6).

**Recursos necessários:**
- Agora ConvoAI (voz).
- Um número de telefone para a ligação real. [H] O Nvoip Pro dos participantes pode servir, mas falta confirmar a integração com a Agora.
- Um parceiro transportadora para validar.
- Para portos, acesso às APIs de agendamento [H].

## 5. Validar a ideia

**Como confirmar que o problema existe?** Por dados secundários já está confirmado [F1][F2][F25][F26]. Falta saber, junto à transportadora, qual parte dói mais: as horas perdidas, a estadia não cobrada, o custo do pátio ou o CCO sobrecarregado.

**Como conversar com os afetados?**
- 10 motoristas em postos perto de polos de CD (Cajamar, Guarulhos, Barueri) e no pátio regulador de Cubatão (Santos).
- 2 a 3 transportadoras pequenas.
- Pergunte sobre o **passado**: "Na última entrega, quanto tempo esperou? Cobrou? Pagou o pátio?"

**Como testar a acessibilidade:** compare voz e formulário com motoristas de **50 anos ou mais**. Meça a taxa de conclusão do check-in, o tempo e quantas vezes o motorista pediu ajuda.

**Quando validar:** de 01/12 a 12/12, com os repositórios congelados. As entrevistas e os números vão para os slides da final, que tem notas novas.

**Como saber se funcionou:**
- % de entregas com chegada e descarga registradas por voz.
- Taxa de conclusão por voz × formulário, no grupo com 50 anos ou mais.
- Minutos entre o aviso e a chegada.
- Estadia devida identificada (R$) e cobrada.

## 6. Planejar o desenvolvimento

**Objetivo principal:** com voz, colocar no fluxo logístico o motorista que os portais excluem, e tornar o caminhão parado visível, comprovável e com dono.

**Tempo disponível:** até **30/11/2026 23h59**. Depois, os repositórios ficam congelados até a final de **12/12** (São Paulo).

**Ordem por retorno na nota:**
1. **Demo pública HTTPS no ar** (H1, primeiro desempate).
2. **Vídeo de até 3 min** (H4). Roteiro em quatro tempos:
   - "11h40 parado num CD de SP; 9 em cada 10 autônomos não recebem pela espera";
   - "e quem está ao volante não pode digitar, e metade dos brasileiros de 50 a 64 anos não lê com fluência";
   - o produto por voz: aviso, chegada, estadia, escalonamento;
   - a estadia comprovada em R$.
3. **Números com fonte** no bloco "Para o júri" dos três READMEs, só os confirmados da tabela 0.1.
4. **Frase do painel:** logística primeiro, acessibilidade como o "como". Exemplo: "Agente de voz que avisa o recebedor, conta a espera na doca e prova cada hora parada, sem o motorista tocar no celular".

**Funcionalidades indispensáveis:** já estão no produto. Não abra feature nova antes de 1 a 3 estarem prontos.

**Principais dificuldades:**
- A demo cair durante a avaliação.
- A voz real depende de chaves e créditos.
- O comprador não é o usuário.
- O GPS de celular é contestável (a dupla prova com o rastreador é simulada).
- Portos exigem integração que não existe.
- **Commit depois de 30/11 23h59 desclassifica.**

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
