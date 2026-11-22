# Parceiro de Estrada — Contexto do Produto (MVP Hackathon UNMUTE / Agora)

> Copiloto de voz para caminhoneiros, integrado à central (CCO) da transportadora.
> Prazo: domingo 22/11, 12h. Tecnologia Agora obrigatória (voz em tempo real).

---

## 1. Atores

| Ator | Papel |
|---|---|
| **Empresa / Central (CCO)** | Cadastra rotas, define regras de reporte, recebe status e confirmações. |
| **Motorista** | Usa o app só por voz durante a viagem. |
| **Agente de voz** | Intermediário: pergunta, valida, registra, escala e responde. |

---

## 2. Integração com a empresa (painel da central)

A empresa cadastra:

1. **Rota** — origem, destino, trajeto previsto.
2. **Motorista** responsável pela rota.
3. **Break points opcionais** — pontos/momentos da rota em que o agente deve chamar o motorista.
4. **Intervalos de atualização** — a cada X tempo o agente coleta:
   - status da carga
   - descrição da viagem
   - localização
   - outros campos configuráveis
5. **Campos obrigatórios por reporte** — lista que o agente usa para validar a resposta do motorista.
6. **Documentos** da entrega/transporte (NF, CT-e, MDF-e, ordem de coleta etc.).

---

## 3. Fluxo do app (motorista)

### 3.1 Início da viagem
- App recebe a rota da central.
- **Relatório inicial por voz:** estado do caminhão, carga coletada, posição atual, destino.

### 3.1.1 Confirmação de retirada e chegada por GPS (dupla prova)
- O agente monitora o **GPS do celular do motorista** e o **GPS/rastreador do caminhão**.
- Ao entrar na geocerca da **origem**, o agente pergunta: "Confirma a retirada da carga?" → registra o evento `RETIRADA`.
- Ao entrar na geocerca do **destino**, o agente pergunta: "Confirma a chegada?" → registra o evento `CHEGADA`, que inicia a estadia.
- Cada evento guarda: posição do celular, posição do caminhão, horário, confirmação por voz (áudio + transcrição).
- **Divergência** (posições distantes ou um GPS sem sinal) → o evento é marcado como `nao_validado` e o CCO é alertado.

### 3.2 Durante a viagem — reportes periódicos
- A cada X tempo (ou ao atingir um break point) o agente pergunta o status da viagem.
- **Validação de completude:** se o motorista não cobrir todos os campos obrigatórios, o agente identifica o que faltou e pergunta só isso.
  - Ex.: motorista fala "tudo certo, trânsito tranquilo" → agente: "E a carga, sem avarias?"

### 3.3 Acionamento pelo motorista (comando de voz / wake word)
O motorista pode, a qualquer momento:
- passar informação
- pedir informação (rota, prazo, contato da central)
- **registrar ocorrência** (acidente, avaria, atraso, bloqueio, fiscalização)
- **solicitar documentos** da carga: os documentos ficam no app e a IA lê e responde perguntas sobre eles

### 3.4 Solicitação da central
- A central pode pedir uma informação pelo painel → o agente pergunta ao motorista → resposta volta estruturada para a central.

### 3.5 Aviso automático de chegada (sem falar com o motorista)
- Via GPS + rota, ao se aproximar do destino o agente avisa a central que a carga está chegando.
- **Aviso prévio ao recebedor:** na aproximação, o agente avisa o CCO **e o recebedor** (placa, NF, horário previsto) e registra a resposta:
  - confirma doca e horário → registra e avisa o motorista;
  - não recebe hoje → aplica a regra da transportadora e avisa CCO e motorista;
  - não atende → registra a tentativa como prova.
  - Motivo: uma decisão da 3ª Turma Recursal do TJMT (jun/2026) condicionou o direito à estadia à comunicação prévia da chegada ao expedidor ou destinatário ([Legjur](https://www.legjur.com/jurisprudencia/eme/892.4612.0077.2649)); é decisão de turma recursal, não regra geral do tribunal. Na demo, o aviso é a ligação por voz pela Agora (conta para o C2), não mensagem.
- **Escalonamento:** se a central não confirmar em X tempo, a prioridade sobe e o canal muda a cada tentativa: push → destaque no painel → ligação para a central.
- **Último nível (após 3 tentativas sem resposta):** o agente liga direto para o responsável pelo recebimento da carga (seção 3.5.1).

- Ao detectar a chegada, o sistema **cria uma Task para o CCO**: "carga da rota X chegou ao destino".
- Enquanto a task não for confirmada, o CCO é **re-notificado a cada X tempo** com o **tempo parado** e a **estadia acumulada**, e a prioridade sobe.
- Número de tentativas, intervalo e canais seguem a norma da transportadora (`RegraEscalonamento`); padrão da demo: 3 tentativas.

```
aproximação (GPS, X min antes)
   → avisa o CCO
   → avisa o recebedor (ligação Agora): placa, NF, horário previsto
       confirma → registra doca e horário, avisa o motorista
       não recebe hoje → aplica a regra da transportadora, avisa CCO e motorista
       não atende → registra a tentativa (prova)
chegada detectada (GPS + check-in)
   → cria Task no CCO (status: pendente)
   → inicia contador de estadia (inicio = chegada_em)
   → tentativa 1..3, a cada X min: notifica tempo parado + franquia restante (5h) + estadia (R$)
        canal sobe a cada tentativa: push → painel em destaque → ligação para a central
   → CCO respondeu? sim → CCO assume a Task e trata com o recebedor
   → 3 tentativas sem resposta → agente liga para o responsável pelo recebimento (3.5.1)
   → motorista (voz) ou CCO confirma a descarga → Task concluída, estadia encerrada
```

### 3.5.1 CCO sem resposta: agente liga para o recebedor

Depois de 3 tentativas sem resposta do CCO (é o **segundo** contato com o recebedor; o primeiro foi o aviso na aproximação):

1. O agente **avisa o CCO e o motorista** que vai ligar para o recebedor ("O CCO não respondeu em 3 tentativas. Estou ligando para o recebimento.").
2. O agente **liga para o responsável pelo recebimento** cadastrado na rota (ligação telefônica feita pelo agente via Agora Conversational AI + SIP de saída). Ele se apresenta como assistente virtual da transportadora e informa: placa, carga, nota fiscal, horário de chegada e tempo parado.
3. O agente pergunta e registra a **resposta do recebedor**: previsão de descarga, doca, motivo da espera ou pedido de documento.
4. O agente **repassa a resposta** ao CCO (registro na Task, com transcrição e áudio) e ao motorista (por voz: "O recebimento disse que a doca 4 libera em 40 minutos.").
5. Se o recebedor não atender, o agente registra a tentativa na Task (prova para a estadia) e avisa o motorista e o CCO.

```
3 tentativas sem resposta do CCO
   → avisa CCO e motorista: "ligando para o recebimento"
   → liga para responsavel_recebimento (Agora SIP)
       atendeu → registra resposta (previsão, doca, motivo) → envia ao CCO (Task) e ao motorista (voz)
       não atendeu → registra tentativa (horário, número) → avisa CCO e motorista
   → contador de estadia continua até a confirmação da descarga
```

### 3.6 Chegada — check-in por voz
Motorista informa:
- status final da carga
- tempo de viagem
- problemas e ocorrências

→ **Central recebe a confirmação de chegada.**

---

## 4. Modelo de dados (rascunho)

```
Empresa
Motorista
Rota { origem, destino, trajeto, motorista_id, status, responsavel_recebimento { nome, telefone_e164 } }
BreakPoint { rota_id, gatilho (tempo | local), campos_requeridos[] }
RegraReporte { rota_id, intervalo, campos_obrigatorios[] }
Reporte { rota_id, timestamp, localizacao, campos{}, transcricao, completo: bool }
Ocorrencia { rota_id, tipo, descricao, localizacao, timestamp }
Documento { rota_id, tipo, arquivo }
SolicitacaoCentral { rota_id, pergunta, resposta, status }
RegraEscalonamento { empresa_id, niveis[], tempo_por_nivel, acao_final }
TaskCCO { rota_id, tipo: "chegada", status (pendente|confirmada|escalada_recebedor), prioridade, tentativas (0..3), canal_atual (push|painel|ligacao), criada_em, ultima_notificacao, confirmado_em, confirmado_por }
LigacaoRecebedor { task_id, rota_id, numero, iniciada_em, atendida: bool, resposta { previsao, doca, motivo }, transcricao, audio_url, enviada_cco_em, enviada_motorista_em }
EventoGeo { rota_id, tipo (RETIRADA|CHEGADA|DESCARGA), gps_celular{lat,lng,precisao,ts}, gps_caminhao{lat,lng,ts}, distancia_m, confirmacao_voz{audio_url, transcricao, ts}, status (validado|nao_validado) }
Estadia { rota_id, inicio (= chegada_em), fim, franquia_h: 5, capacidade_t, valor_t_h (config ANTT), horas_excedentes, valor_acumulado }
```

---

## 5. Escopo do MVP (demo)

**Foco:** o caminhão parado, em torno da janela de descarga combinada com o recebedor. Os demais itens são add-ons e aparecem na demo só se reforçarem a história da chegada.

**Dentro:**
- Cadastro de 1 rota + regras no painel (pode ser seed/mock)
- Relatório inicial, 1 ciclo de reporte com validação de campos faltantes
- Registro de ocorrência por voz
- Pedido da central → pergunta ao motorista
- Aviso de aproximação ao CCO e ao recebedor (ligação) e aviso de chegada com escalonamento (GPS simulado)
- CCO sem resposta após 3 tentativas → agente liga para o recebedor e repassa a resposta ao CCO e ao motorista
- Check-in de chegada

**Fora:**
- Offline / mesh / LoRa
- Leitura de rádio PX
- Integração real com ERP/TMS da transportadora
- Integração real com rastreador do caminhão (simulado)

---

## 6. Decisões tomadas

- **Escalonamento / "ficar parado":** o comportamento final segue as normas de cada transportadora. Vira uma regra configurável no painel (`RegraEscalonamento { niveis[], tempo_por_nivel, acao_final }`). A demo usa uma regra padrão mockada.
- **Chegada sem retorno → contagem de estadia:**
  - Ao chegar, o sistema cria uma **task para o CCO**: "carga chegou".
  - A cada X tempo, o sistema notifica o CCO com o tempo que o caminhão está parado.
  - Um contador de **estadia** começa na hora de chegada registrada por GPS e check-in.
  - Base legal: Lei 11.442/2007, art. 11, alterada pela Lei 13.103/2015. A franquia é de 5h desde a chegada; depois disso é devido valor por tonelada/hora, calculado sobre a capacidade total do veículo.
  - O sistema mostra a franquia restante e, depois de esgotada, a estadia acumulada (horas × toneladas × valor vigente).
  - **Não fixar o valor no código:** ele é atualizado pela ANTT. Deixar configurável.
  - O registro com horário (GPS + check-in de voz) serve de **prova para cobrar estadia** do embarcador ou destinatário.
- **Prova de retirada/chegada:** GPS do celular + GPS do caminhão + confirmação por voz do motorista. Os três ficam juntos em um `EventoGeo`.
- **CCO sem resposta após 3 tentativas:** o agente avisa o CCO e o motorista, liga para o responsável pelo recebimento (Agora Conversational AI, chamada SIP de saída) e envia a resposta do recebedor ao CCO e ao motorista. A ligação e a resposta ficam na Task como prova da espera.
- **Documentos:** são enviados ao app pela central e **interpretados pela IA de voz**. O motorista pode perguntar ("qual o peso da NF?", "qual o número do CT-e?") e o agente responde com base no documento.
- **Atualização periódica:** é obrigatória e não pode ser dispensada. Ponto em aberto: reporte com o caminhão andando conflita com o alerta da mentoria de que voz não implica segurança na condução. Até decidir, a demo usa só o caminhão parado.

## 7. Riscos que continuam

> Status atualizado: o time respondeu cada risco em [`problemas-e-decisoes.md`](problemas-e-decisoes.md). Lá vale a decisão final.


- **Alucinação na leitura de documentos:** número de NF, peso e valores não podem ser "aproximados". O agente responde só com campos extraídos do documento, cita qual documento usou e diz "não encontrei" quando não achar.
- **Atualização obrigatória × manobra:** manter obrigatória, mas permitir adiar por poucos minutos ("me pergunta em 2 min"). Se o motorista não responder dentro do limite, o agente escala para a central. Assim a atualização continua obrigatória sem forçar resposta em um momento de risco.
- **Re-notificação sem mudar o canal vira ruído:** se a central ignora o push, mais pushes não resolvem. A prioridade precisa trocar de canal (push → painel em destaque → ligação/WhatsApp para o supervisor).
- **"Chegou" × "está chegando":** a regra anterior avisava na aproximação. Avisar só na chegada elimina a antecedência e aumenta a espera. Sugestão: notificar na aproximação e criar a Task na chegada.
- **Motorista fora do loop:** ele não sabe se o CCO confirmou. O agente deve avisar quando a Task for confirmada.
- **Ligação ao recebedor depende de SIP trunk:** a chamada de saída da Agora exige um SIP trunk (ex.: Twilio) e um número com caller ID. Se não ficar pronto até a demo, simular a ligação com um segundo cliente Agora RTC e declarar como simulado no README (E8).
- **O agente liga para um terceiro:** ele deve se identificar como assistente virtual da transportadora logo no início e não pode prometer nada em nome do CCO. O número do recebedor vem do cadastro da rota, não de busca.
- **Contradição sobre áudio:** `mercado-e-evidencias.md` decidiu nunca guardar áudio, mas `EventoGeo` e `LigacaoRecebedor` guardam `audio_url`. Decisão pendente: só transcrição (recomendado) ou guardar áudio com finalidade no termo e aviso ao recebedor de que a ligação é registrada. Só com a transcrição, a resposta do recebedor vira uma prova mais fraca (ele pode negar o que foi transcrito).
- **Conectividade em rodovia:** mesmo sem offline no MVP, reportes precisam de fila e reenvio.
- **Wake word em cabine ruidosa:** validar a taxa de acionamento falso e ter um botão físico/no volante como alternativa.
- **Validação de completude:** a extração de campos via LLM pode marcar como "respondido" algo vago. Definir um critério por campo.
- **Início da estadia:** a lei conta a partir da chegada ao endereço, não da confirmação do CCO. Usar a geocerca do destino + check-in como prova. Se o GPS falhar, o horário de chegada fica contestável.
- **Fim da estadia:** é preciso um evento claro de "descarga concluída" (motorista por voz ou CCO). Sem isso, o contador nunca para.
- **As duas provas vêm do mesmo lado:** celular e caminhão são da transportadora/motorista. Para o embarcador, isso prova que o caminhão estava lá, mas não a hora em que ele foi recebido. Um registro do destinatário (QR na portaria, assinatura, canhoto) seria uma prova independente.
- **GPS do celular é falsificável** (apps de fake GPS). O rastreador do caminhão é a prova forte; o celular é complementar. Detectar mock location no Android (`isMock`).
- **Localização em segundo plano:** Android/iOS restringem o acesso. É preciso foreground service e permissão "sempre", e há impacto na bateria.
- **Rastreador do caminhão no MVP:** a integração real (Sascar, Omnilink etc.) fica fora. Simular com um segundo stream de GPS.
- **Aplicabilidade:** a regra de 5h vale para TAC/ETC. Contratos podem prever franquia diferente, então `franquia_h` também deve ser configurável.
