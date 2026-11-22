# Parceiro de Estrada: ajustes após a mentoria

21/11/2026 · revisão do `contexto-produto.md`, do `problemas-e-decisoes.md` e do `impacto-e-custos.md` contra os feedbacks da mentoria (Terron/NewHack e banca de mentores).

## 1. Foco e add-ons (decidido)

**O foco é o caminhão parado.** Tudo o que o agente faz serve para reduzir ou provar o tempo parado em torno da **janela de descarga combinada com o recebedor**.

| Momento                | O que o agente faz                                           | Por que ataca o caminhão parado                     |
| ---------------------- | ------------------------------------------------------------ | --------------------------------------------------- |
| Na estrada, com atraso | avisa o CCO e o recebedor do novo horário previsto           | quem perde a janela espera mais na chegada          |
| Na aproximação         | avisa o recebedor e confirma doca e horário (ver item 2)     | antecipa a descarga; é condição para cobrar estadia |
| Na chegada             | cria a Task, inicia o contador de estadia e escala se o CCO não responder | o caso não fica sem dono                            |
| Parado                 | liga para o recebedor depois de 3 tentativas sem resposta do CCO | registra a resposta do outro lado como prova        |
| Na descarga            | encerra o contador com a confirmação por voz ou do CCO       | fecha a prova da espera                             |

Os demais recursos do `contexto-produto.md` (ocorrências, documentos, pedido da central) ficam como add-ons: aparecem na demo só se reforçarem a história da chegada, e entram no pitch como "o que mais o mesmo agente faz".

## 2. Aviso prévio ao recebedor (decidido, muda o fluxo 3.5)

Hoje o recebedor só é chamado depois de 3 tentativas sem resposta do CCO, já na chegada. **Passa a ser avisado na aproximação.**

Motivo jurídico: uma decisão da 3ª Turma Recursal do TJMT (23/06/2026) condicionou o direito à estadia ao dever do transportador de comunicar previamente ao expedidor ou destinatário a estimativa de chegada da carga, com base no art. 11 da Lei 11.442/2007 ([TJMT, via Legjur](https://www.legjur.com/jurisprudencia/eme/892.4612.0077.2649)). É uma decisão de turma recursal (juizado especial), não uma regra geral do tribunal, e não é parecer jurídico: confirmar com advogado.

Motivo operacional: os mentores pediram antecipação. O recebedor mais organizado do IER 2025 descarregou em 2h, contra 5h09 de média ([IER/IPTC via SETCESP](https://setcesp.org.br/noticias/a-demora-que-compromete-a-eficiencia-2/)).

Novo fluxo:

```
aproximação (GPS, X min antes)
   → avisa o CCO
   → avisa o recebedor (mensagem ou ligação): placa, NF, horário previsto
       confirma → registra doca e horário, avisa o motorista
       não recebe hoje → aplica a regra da transportadora, avisa CCO e motorista
       não atende → registra a tentativa (prova)
chegada → Task + contador de estadia (fluxo atual, sem mudança)
```

## 3. Áudio: corrigir a contradição (a decidir)

- O `mercado-e-evidencias.md` decidiu **nunca guardar áudio** (LGPD).
- O modelo de dados do `contexto-produto.md` guarda `audio_url` em `EventoGeo` e em `LigacaoRecebedor`.

Escolher um dos dois:

- **Só transcrição** (recomendado): tirar `audio_url` do modelo. Menos risco de LGPD e menos atrito com o motorista.
- **Guardar áudio:** manter, registrar a finalidade no termo do motorista e o agente dizer ao recebedor, no início da ligação, que ela é registrada.

Atenção: a escolha afeta o item 5. Só com a transcrição, a resposta do recebedor vira uma prova fraca (ele pode negar o que a transcrição diz).

## 4. Pontos em aberto

- **Reporte periódico com o caminhão andando.** O `contexto-produto.md` diz que a atualização é obrigatória e não pode ser dispensada; a decisão 4 permite adiar 2 min. O Terron alertou que conveniência por voz não implica segurança durante a condução. Opções: reporte só com o veículo parado, ou fora da demo. Até decidir, a demo usa só o caminhão parado.

## 4.1 Saúde do motorista (decidido: sai do produto)

O campo "saúde/estado do motorista" sai do reporte periódico e do modelo de dados. Não é o foco (o foco é o caminhão parado) e evita tratar dado sensível pela LGPD num canal novo, com terceiros (Agora e LLM). A decisão 2 do `problemas-e-decisoes.md` fica substituída por esta.

## 5. Resposta à decisão 11 (registro do destinatário)

A decisão 11 foi descartada (QR na portaria, assinatura, canhoto). Mesmo assim, o produto já gera uma prova do outro lado: **a resposta do recebedor na ligação do agente** ("a doca libera em 40 minutos", "não recebemos hoje") fica registrada na Task, com horário. Usar isso como resposta quando a banca disser que a prova vem só da transportadora.

## 6. Inconsistências para corrigir no repositório

| Onde              | Problema                                                     | Correção                                                     |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Nome              | Parceiro de Estrada, Despacho por Voz e RODAR                | escolher um nome só para o pitch                             |
| Preço             | **Atualizado no commit `05be239`:** a Agora cobra hoje só US$ 0,10/min (≈ R$ 83/caminhão/mês); o preço passou a R$ 100 nos arquivos de custo. O tamanho de mercado ainda usa R$ 30–40 | confirmar R$ 100 com o time e recalcular o tamanho de mercado |
| ROI principal     | `planejamento.md` e `rodar.md` abrem com "payback em uma única estadia" (já corrigido para R$ 225 e R$ 100/mês no commit `05be239`) | abrir com horas de caminhão parado, como no `impacto-e-custos.md`; a estadia vira prova e pressão sobre o recebedor |
| Valor da estadia  | `mercado-e-evidencias.md` trata R$ 2,41 como vigente "não confirmado" | R$ 2,50 por t/h desde abril de 2026 ([ANTT via Mundo Logística](https://mundologistica.com.br/noticias/antt-reajusta-estadia-tempo-adicional-carga-descarga)) |
| Tempo de descarga | `mercado-e-evidencias.md` usa 2h50 (2019)                    | 5h09 em 2025 (IER/IPTC), já no `impacto-e-custos.md`         |

## 7. Concorrente que faltava: agendamento de doca e gestão de pátio

Sistemas do lado do recebedor já reduzem a espera: a Cassol caiu de 4h para 15 min com a Tempo Certo ([Mundo Logística](https://mundologistica.com.br/noticias/cassol-adota-tecnologia-e-tempo-de-carga-e-descarga-cai-de-4-horas-para-15-minutos)); DHL e Trackage prometem até 50% menos espera num CD da Unilever ([Mundo Logística](https://mundologistica.com.br/noticias/dhl-supply-chain-e-trackage-lancam-solucao-para-gestao-de-patio)); fornecedores dos EUA falam em 40% (dado de fornecedor). O próprio IER 2025 cita "janelas de agendamento mal definidas" como gargalo ([SETCESP](https://setcesp.org.br/noticias/a-demora-que-compromete-a-eficiencia-2/)).

Resposta para a banca: quando o recebedor tem agendamento, o agente usa esse sistema (confirma o horário, avisa o atraso); quando não tem (a maioria dos supermercados e pequenos recebedores), a ligação do agente vira o agendamento.

## 8. Ajustes da revisão crítica (confirmar com o time)

- **A promessa muda de "esperar menos" para "não perder a janela, decidir rápido e provar cada hora parada".** Avisar antes não cria doca: se a doca está cheia, o aviso só muda a ordem da fila. A redução da espera fica como cenário otimista; os casos de 40 a 50% são do recebedor reorganizando a doca.
- **A voz vai para o centro da demo:** o agente ligando para o recebedor e negociando ("a doca 4 libera em 40 minutos?") e o motorista explicando uma exceção. Geocerca, Task e contador são o palco.
- **O registro é vendido como dado para renegociar o contrato com o embarcador** ("o seu cliente X nos custou 40 horas paradas no mês"), não como cobrança contra o recebedor, que costuma ser cliente do embarcador.
- **O aviso na aproximação contata o recebedor em toda entrega:** soma minutos da Agora e ligações SIP ao custo de R$ 83. Para contar no critério C2, o aviso da demo tem de ser a ligação por voz pela Agora, não mensagem de WhatsApp.
- **SIP de saída testado ainda hoje;** se não funcionar até ~2h, assumir o plano B (segundo cliente Agora RTC, declarado como simulação).
- **Confirmar o time (eliminatório E1):** os documentos listam 3 autores num time chamado "Quarteto".
- **Entrevistas:** acrescentar "por que vocês não cobram a estadia?" e "quando o cliente é avisado antes, a espera diminui? quanto?".
