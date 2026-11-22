# Parceiro de Estrada — Impacto do problema e da solução

21/11/2026 · Henry (`@HenryFacens`) · versão viva no Claude Docs: <https://claude.ai/artifact/NcmYJ5xaNEUu79NUxUt9X8>

## Resumo

O problema mais caro e mais fácil de provar é a espera no recebimento. Em São Paulo, a descarga levou em média **5h09 em 2025**, acima da franquia legal de 5h. Mesmo assim, **84,7% dos caminhoneiros autônomos** que esperam 5h ou mais não recebem a estadia nem denunciam.

A causa é a mesma nos cinco problemas: falta um registro confiável de chegada, espera, status e ocorrências que o CCO receba na hora e que o recebedor não consiga contestar. O Parceiro de Estrada cria esse registro por voz e GPS, sem o motorista tirar a mão do volante.

## Impacto do problema

### 1. Gargalo de comunicação

Hoje o status da viagem chega por ligação ou WhatsApp, atrasado, incompleto e sem estrutura. Para saber onde está a carga, o CCO precisa ligar para um motorista que está dirigindo. Esse motorista já trabalha em média **14h por dia, 25 dias por mês** ([CNTA 2025](https://mundologistica.com.br/noticias/realidade-dos-caminhoneiros-autonomos-brasil-2025)). Cada ligação no meio da estrada soma distração à fadiga.

Não encontrei dado público sobre o custo desse gargalo. **Validar com uma transportadora:** quantas ligações o CCO faz por viagem e quanto tempo leva para saber de uma ocorrência.

### 2. Multas e retenção na fiscalização

Se a fiscalização para o motorista e ele não tem a nota fiscal, ou tem uma nota que não bate com a carga, a mercadoria pode ser apreendida. A multa é calculada sobre o valor da carga e as regras mudam de estado para estado:

- **ES:** 30% do valor da mercadoria ou do frete, com mínimo de 1.000 VRTEs (cerca de R$ 3,2 mil em 2017) e sem direito a redução ([SEFAZ-ES](https://sefaz.es.gov.br/governador-sanciona-lei-que-aumenta-punicao-n)).
- **MG:** cobra o ICMS, uma multa de revalidação e uma multa isolada de 40% do valor da operação. A carga é apreendida com Termo de Apreensão e Depósito, e o transportador responde junto com o dono da carga ([CC/MG, acórdão 17.264/05](https://www.fazenda.mg.gov.br/secretaria/conselho_contribuintes/acordaos/2005/1/17264051.pdf)).
- **ANTT:** CIOT ausente no MDF-e dá multa de R$ 10.500, segundo a Resolução ANTT 6.078 ([Mundo Logística, abr/2026](https://mundologistica.com.br/noticias/piso-minimo-frete-como-evitar-multas)).

Além da multa, há o tempo parado. Num posto fiscal da Bahia, cada caminhão ficava em média 48h retido, a um custo de R$ 760 por veículo por dia ([Prosperity Consulting, 2014](https://mundologistica.com.br/noticias/empresas-brasileiras-gastam-11-da-receita-com-logistica)). O dado é antigo, mas dá a ordem de grandeza.

Com um caminhão retido, a entrega atrasa, o cliente pode recusar e a carga perecível corre risco.

### 3. Perda de carga por espera longa

Em perecíveis, a perda de qualidade por temperatura é **cumulativa e irreversível** ([Ciência e Tecnologia de Alimentos, 2010](https://www.redalyc.org/pdf/3959/395940099024.pdf)). Cada hora parada na doca com o motor ou a refrigeração no limite aumenta o risco de recusa e devolução. Na disputa, transportadora e recebedor discutem de quem é a culpa sem um horário confiável de chegada.

Não encontrei número público de perda causada especificamente pela espera.

### 4. Demora na tomada de decisão

O CCO só descobre uma avaria, um bloqueio ou um atraso quando o motorista liga. Aí a janela de entrega no cliente já foi perdida e não dá mais tempo de replanejar. A espera também não é escalada: ninguém na central é avisado de que o caminhão está há 4h na porta do cliente.

### 5. Recebedor sem cobrança para se organizar

- O tempo médio de descarga em São Paulo foi de **5h09 em 2025** ([IER/IPTC via SETCESP](https://setcesp.org.br/noticias/a-demora-que-compromete-a-eficiencia-2/)).
- Só **13% dos estabelecimentos** têm vagas para carga e descarga; 87% têm vagas reservadas para clientes (mesma fonte).
- **84,7%** dos autônomos que esperam 5h ou mais não recebem a estadia e não denunciam; só **8,6%** recebem ([CNTA 2025](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-aceitam-frete-abaixo-do-piso-por-necessidade)).
- A estadia é de **R$ 2,50 por tonelada/hora** desde abril de 2026. Exemplo: 12 t, 8h no cliente, 3h excedentes = R$ 90 ([ANTT via Mundo Logística](https://mundologistica.com.br/noticias/antt-reajusta-estadia-tempo-adicional-carga-descarga)).

Como a espera não custa nada ao recebedor, ele não tem motivo para agendar a descarga, abrir doca ou ter equipe pronta. O custo fica com quem está parado.

## Quanto tempo a carga fica parada e quanto custa

Não existe uma média nacional publicada de tempo de espera para entrega. As melhores referências ficam entre **4h e 5h por operação**, com casos de 11h.

| Referência | Tempo parado | Fonte |
| --- | --- | --- |
| Grande São Paulo, 2025 (TMD) | 5h09 por descarga | [IER/IPTC via SETCESP](https://setcesp.org.br/noticias/a-demora-que-compromete-a-eficiencia-2/) |
| Transportadora em SP, MG e RJ (Anacirema), 2026 | até 4h em média por carga ou descarga | [Mundo Logística](https://mundologistica.com.br/noticias/pnl-2050-futuro-da-infraestrutura-transporte-rodoviario-de-cargas) |
| Grande São Paulo, 2019 | 2h50 por descarga (3h22 em 2018); alguns locais chegam a 11h | [SETCESP](https://setcesp.org.br/noticias/longa-espera/) |
| Posto fiscal na Bahia, 2014 | 48h por veículo | [Prosperity Consulting](https://mundologistica.com.br/noticias/empresas-brasileiras-gastam-11-da-receita-com-logistica) |

**Custo para a logística brasileira.** Os custos logísticos foram de **15,5% do PIB em 2025** e devem chegar a **R$ 2,2 trilhões (16,1% do PIB) em 2026**. Transporte sozinho fica perto de 9% do PIB ([ILOS via Mundo Logística](https://mundologistica.com.br/noticias/custos-logisticos-brasil-2026)). Nenhum estudo público separa quanto disso é espera.

**Custo por caminhão (estimativa nossa).** Pela NTC, a hora parada de um cavalo mecânico com furgão custava **R$ 80,79 em 2016**, só de custo fixo ([NTC via SETCESP](https://setcesp.org.br/noticias/a-lei-13-103-e-a-hora-parada/)). Um autônomo faz em média 9 fretes por mês ([CNTA 2025](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-trabalham-25-dias-por-mes)). Com 4h de espera na coleta e 4h na entrega, são 72h parado por mês, cerca de **R$ 5,8 mil por caminhão por mês** em valores de 2016.

**O impacto que quase ninguém vê:** a lei dá 5h de franquia antes da estadia. Uma espera de 4h custa cerca de R$ 323 ao transportador e não dá direito a cobrança nenhuma. A maior parte do custo da espera fica abaixo da franquia, então nunca é cobrada.

## Estimativa: quanto custa a falta de comunicação

No cenário base, a falta de comunicação custa **cerca de R$ 231 por entrega** em caminhão parado e **R$ 8 por viagem** em tempo do CCO. A espera custa quase 30 vezes mais, então o pitch deve começar por ela.

### Premissas

| Premissa | Valor | Base |
| --- | --- | --- |
| Hora parada de um caminhão | R$ 146/h | R$ 80,79 da NTC (2016) corrigidos pelo mesmo índice que a ANTT usa na estadia (R$ 1,38 → R$ 2,50, × 1,81) |
| Espera média na descarga | 5h09 | [IER/IPTC 2025](https://setcesp.org.br/noticias/a-demora-que-compromete-a-eficiencia-2/) |
| Espera de quem se organiza bem | 2h | Supermercados Joanin, melhor IER de 2025 (mesma fonte) |
| Espera evitável | 3h09 por entrega | diferença entre as duas |
| Parte evitável só com comunicação (aviso de chegada, Task no CCO) | 25% / 50% / 75% | **premissa nossa — validar** |
| Fretes por mês por caminhão | 9 | [CNTA 2025](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-trabalham-25-dias-por-mes) |
| Custo do analista de CCO | R$ 41/h | R$ 4.277/mês no Sudeste ([CAGED via Salário.com.br](https://www.salario.com.br/profissao/analista-de-torre-de-controle-cbo-252715/)) × 1,8 de encargos ÷ 186 h/mês |
| Contatos CCO↔motorista por viagem | 6, de 4 min cada | **premissa nossa — validar** |
| Parte que a IA responde sozinha (status, local, documentos) | 30% / 50% / 70% | no varejo, 25–35% dos contatos são "cadê meu pedido" ([Radial](https://www.radial.com/?p=53007)) |

### Resultado

| Cenário | Espera evitada por entrega | Custo da espera por entrega | Por caminhão/mês | CCO por viagem | CCO para 100 caminhões/mês |
| --- | --- | --- | --- | --- | --- |
| Conservador | 0,8 h | R$ 115 | R$ 1.037 | R$ 5 | R$ 4.462 (0,6 analista) |
| Base | 1,6 h | R$ 231 | R$ 2.075 | R$ 8 | R$ 7.437 (1 analista) |
| Otimista | 2,4 h | R$ 346 | R$ 3.112 | R$ 12 | R$ 10.412 (1,4 analista) |

Para uma frota de 100 caminhões no cenário base, isso dá **R$ 2,5 milhões por ano** em espera e R$ 89 mil por ano em CCO.

### Como ler

- **A estadia não cobre o custo.** Uma carreta de 30 t recebe R$ 75/h de estadia (30 × R$ 2,50), cerca de metade dos R$ 146/h que ela custa parada, e só depois de 5h. Mesmo quando cobrada, a estadia só cobre parte do prejuízo.
- **No CCO, o ganho é de capacidade, não de dinheiro.** Liberar um analista a cada 100 caminhões permite crescer a frota sem contratar e cobrir 24h.
- **As linhas marcadas "validar" são as que um jurado vai atacar.** Troquem pelos números de uma transportadora real antes do pitch.

## Impacto de resolver o problema

Resolver muda quem carrega o custo da espera e quanto tempo o CCO leva para agir.

- **Comunicação:** o reporte chega estruturado e completo, porque o agente pede só o que faltou. O CCO sabe onde está a carga sem ligar, e o motorista não precisa largar o volante.
- **Multas e retenção:** antes da saída, o agente confere se NF-e, CT-e, MDF-e e CIOT estão no app e batem com a carga. Na fiscalização, o motorista pede o documento por voz e mostra na tela. Isso evita apreensão e multa por documento faltando, mas não corrige um documento emitido errado.
- **Perda de carga:** o aviso de aproximação e a contagem de espera alertam o CCO antes de a carga perecível passar do limite. Isso dá tempo de negociar a descarga ou desviar a carga.
- **Decisão:** uma ocorrência registrada por voz chega ao CCO em minutos, não horas. A espera vira uma Task que aumenta de prioridade sozinha.
- **Recebedor:** cada entrega gera horas de espera documentadas e o valor da estadia calculado. Com isso a transportadora pode cobrar, renegociar o contrato ou montar um ranking de recebedores. A espera deixa de ser invisível e passa a ter custo para quem atrasa.

## Como medir o impacto

Para o pitch, cada impacto precisa de uma métrica que o próprio produto gera.

| Problema | Métrica | De onde vem no produto |
| --- | --- | --- |
| Gargalo de comunicação | Ligações CCO↔motorista por viagem; % de reportes completos na 1ª resposta | Reporte + validação de campos |
| Multas e retenção | % de viagens que saem com todos os documentos conferidos; autuações e horas retidas por viagem | Checklist de documentos no início da viagem + ocorrência de fiscalização |
| Perda de carga | Horas paradas por entrega com carga perecível | Contador de estadia + tipo de carga |
| Demora na decisão | Tempo entre ocorrência e ação do CCO | Ocorrência → TaskCCO confirmada |
| Recebedor sem cobrança | Estadia devida × estadia cobrada (R$); TMD por recebedor | Estadia + ranking de recebedores |

## Limites da tese

Cinco pontos que um jurado pode atacar:

- **A estadia em si é pouco dinheiro.** R$ 90 por evento não paga o produto. O impacto real é o caminhão parado (frete que deixa de rodar) e a pressão sobre o recebedor. O pitch deve vender produtividade e prova, não a cobrança.
- **A prova vem só de um lado.** GPS do celular e do caminhão são da transportadora. Sem um registro do recebedor (QR na portaria, canhoto), a cobrança ainda pode ser contestada.
- **Cobrar o cliente tem custo comercial.** Se 84,7% não cobram, parte disso é medo de perder o cliente, não só falta de prova. Ter dados não elimina esse medo.
- **Os dados são limitados.** O TMD de 5h09 é só da Grande São Paulo. A pesquisa CNTA usa amostra não probabilística, então não representa toda a categoria.
- **Comunicação e decisão não têm número público.** Esses impactos são hipóteses até medir num piloto.

## Fontes

- [Lei 11.442/2007, art. 11 — prazo de 5h, estadia e multa de até 5%](https://www.legjur.com/legislacao/art/lei_00114422007-11)
- [ANTT reajusta estadia para R$ 2,50/t·h — Mundo Logística, abr/2026](https://mundologistica.com.br/noticias/antt-reajusta-estadia-tempo-adicional-carga-descarga)
- [A demora que compromete a eficiência — SETCESP (IER/IPTC 2025)](https://setcesp.org.br/noticias/a-demora-que-compromete-a-eficiencia-2/)
- [CNTA 2025: estadia e piso do frete — Mundo Logística](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-aceitam-frete-abaixo-do-piso-por-necessidade)
- [CNTA 2025: jornada dos autônomos — Mundo Logística](https://mundologistica.com.br/noticias/realidade-dos-caminhoneiros-autonomos-brasil-2025)
- [CNTA 2025: 9 fretes por mês — Mundo Logística](https://mundologistica.com.br/noticias/caminhoneiros-autonomos-trabalham-25-dias-por-mes)
- [Avaliação de temperaturas na cadeia do frio — Ciência e Tecnologia de Alimentos, 2010](https://www.redalyc.org/pdf/3959/395940099024.pdf)
- [SEFAZ-ES — multa de 30% por transporte sem documento fiscal (2017)](https://sefaz.es.gov.br/governador-sanciona-lei-que-aumenta-punicao-n)
- [CC/MG — acórdão 17.264/05: apreensão e multa isolada de 40%](https://www.fazenda.mg.gov.br/secretaria/conselho_contribuintes/acordaos/2005/1/17264051.pdf)
- [Multa de R$ 10.500 por CIOT ausente no MDF-e — Mundo Logística, abr/2026](https://mundologistica.com.br/noticias/piso-minimo-frete-como-evitar-multas)
- [Posto fiscal da BA: 48h e R$ 760/dia por veículo — Mundo Logística, 2014](https://mundologistica.com.br/noticias/empresas-brasileiras-gastam-11-da-receita-com-logistica)
- [Espera de até 4h por operação (Anacirema) — Mundo Logística, nov/2026](https://mundologistica.com.br/noticias/pnl-2050-futuro-da-infraestrutura-transporte-rodoviario-de-cargas)
- [Longa espera: 2h50 em 2019, até 11h em alguns locais — SETCESP](https://setcesp.org.br/noticias/longa-espera/)
- [Custos logísticos: R$ 2,2 tri em 2026 (ILOS) — Mundo Logística, out/2026](https://mundologistica.com.br/noticias/custos-logisticos-brasil-2026)
- [A Lei 13.103 e a hora parada (NTC, 2016) — SETCESP](https://setcesp.org.br/noticias/a-lei-13-103-e-a-hora-parada/)
- [Salário de Analista de Torre de Controle (CAGED) — Salário.com.br, nov/2026](https://www.salario.com.br/profissao/analista-de-torre-de-controle-cbo-252715/)
- [WISMO: 25–35% dos contatos no varejo — Radial](https://www.radial.com/?p=53007)
