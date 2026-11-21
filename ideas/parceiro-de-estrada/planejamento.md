# Parceiro de Estrada — Planejamento

Versão de 21/11/2026. Fonte viva: [doc no Claude](https://claude.ai/artifact/7Gz8rWwKweRo3EWrUfP9Wa) (este arquivo é uma cópia para o time).

## Visão

Copiloto de voz para caminhoneiros: cada fala do motorista vira um evento estruturado e vai para um de três destinos — Pessoal, Corporativo ou Comunidade.

- **Problema:** o transporte rodoviário de cargas move o Brasil, e caminhões parados, tombados ou com motorista exausto são rotina. Hoje o motorista avisa o CCO digitando mensagens pré-programadas no rastreador, dirigindo.
- **Proposta:** a voz substitui o teclado, faz companhia na viagem, sugere pausa quando o cansaço aparece e avisa outros motoristas do que vem pela frente.
- **Tese de valor:** o motorista usa porque a frente Pessoal é dele; a transportadora paga pelo Corporativo e pelo CCO; a Comunidade cria o efeito de rede.
- **ODS:** 3 (meta 3.6, mortes no trânsito); secundários 8 e 9.

## As 3 frentes

Toda fala é Pessoal por padrão; Corporativo e Comunidade só recebem depois de confirmação por voz.

| | 1. Pessoal | 2. Corporativo | 3. Comunidade |
|---|---|---|---|
| Quem lê | Só o motorista | Transportadora (CCO) e embarcador | Caminhoneiros na mesma rodovia e sentido, CCOs (anonimizado) |
| Conteúdo | Histórias, família, pet, desabafo, recado para casa | RDO do trecho: paradas, tempo de espera, avarias, ocorrências, jornada | Acidente, desvio, blitz, buraco, parada segura |
| Quando | Conversa livre | O agente pergunta na parada: "Como foi o trecho?" | Na hora |
| Confirmação | Não precisa | Motorista aprova e pode editar o RDO | "Vou avisar: acidente na BR-116, km 230, sentido norte. Confirma?" |
| Validade | Permanente | Permanente, para auditoria | Expira em poucas horas |
| Ferramenta Agora | Conversational AI + Chat | STT + Chat | Signaling + Chat |
| Valor | Companhia, recado da família | Prova de tempo de espera, sinistro, jornada (5h30 de direção / 30 min de pausa) | Aviso antes de chegar ao problema |

## Núcleo comum e roteamento

As três frentes compartilham um único pipeline: a diferença está só no destino que o roteador escolhe.

```
Motorista ⇄ Agente de voz (Convo AI) → Extrator (fala vira evento) → Roteador ─┬→ 1. Pessoal
   ▲                                                    padrão: Pessoal        ├→ 3. Comunidade
   │                                                    outros: confirma voz   └→ 2. Corporativo → Operador CCO
   └──────────────────── voz direta (RTC), só no nível 3 ──────────────────────────────────────────┘
```

## CCO e escalonamento de cansaço

O CCO só entra quando há risco real ou quando o motorista pede; cansaço comum nunca vira punição.

**O que a voz resolve que o CCO de hoje não resolve**

1. Mensagem digitada dirigindo: a voz substitui as macros do rastreador e traz contexto.
2. Excesso de alertas: o operador recebe a ocorrência já resumida e priorizada.
3. Falta de contato: operador e motorista falam no mesmo canal de voz.

| Nível | Gatilho | Ação | Quem sabe |
|---|---|---|---|
| 1 | Ritmo da fala caindo ou 4h30 ao volante | Agente puxa conversa | Só o motorista |
| 2 | Sinal persiste ou passa de 5h30 | Agente sugere a próxima parada segura | Só o motorista |
| 3 | Sem resposta ao agente, ou "preciso de ajuda" | Abre canal de voz com o operador | CCO |

- **O CCO recebe:** ocorrências estruturadas com resumo de uma linha, RDO aprovado, status de jornada, escalonamentos de nível 3, eventos da Comunidade anonimizados.
- **O CCO não recebe:** nada da frente Pessoal, áudio bruto, curva de fala, sinais de nível 1 e 2.
- **Tela do operador:** fila priorizada (emergência, sinistro, atraso), mapa com veículos e eventos, botão "falar" que entra no canal do motorista, RDOs do dia.

## Stack Agora

Tudo roda na rede da Agora; nenhum produto dela funciona offline, então o "sem sinal" é resolvido com entrega adiada do Chat.

| Produto | Uso | Atenção |
|---|---|---|
| [Conversational AI Engine](https://www.agora.io/en/products/conversational-ai-engine/) | Copiloto de voz, interrupção, LLM próprio | Português não confirmado na página: testar ASR e TTS primeiro |
| [Signaling](https://www.agora.io/en/products/signaling/) | Alertas da Comunidade em tempo real, presença online/offline | Sem limite de tamanho de mensagem documentado na página |
| [Chat](https://www.agora.io/en/products/chat/) | Entrega quando o sinal volta; Pessoal e RDO | Cifra no servidor (TLS + arquivos cifrados), não ponta a ponta |
| [RTC](https://www.agora.io/en/products/agora-rtc/) | Canal de voz operador ↔ motorista (nível 3) | — |
| [AI Noise Suppression](https://www.agora.io/en/products/ai-noise-suppression/) | Ruído da cabine | Motor e vento não citados: testar |
| [Media Services](https://www.agora.io/en/products/media-services/) | Transcrição para o RDO | — |
| [Analytics](https://www.agora.io/en/products/agora-analytics/) | Opcional: qualidade de rede por trecho | — |

- [ ] Testar português no Conversational AI Engine antes de qualquer outra coisa
- [ ] Definir LLM reserva hospedado, trocável por variável de ambiente

## Escopo

O MVP é 100% online via Agora; tudo que depende de operação offline ou de hardware que não temos fica fora.

**Dentro**

- Copiloto de voz em português com interrupção
- Extrator de eventos e roteador para as 3 frentes, com confirmação por voz
- Comunidade: alerta entre dois clientes na mesma rodovia e sentido
- Cansaço: tempo ao volante + ritmo da fala, escalonamento em 3 níveis
- Painel CCO: fila, mapa, botão "falar", RDOs
- RDO gerado no fim do trecho, aprovado pelo motorista
- Pessoal: histórico guardado e recado para a família

**Fora (e por quê)**

| Item | Motivo |
|---|---|
| Rede mesh | Alcance de Wi-Fi/Bluetooth é de metros; caminhões ficam a km. Nenhum produto Agora suporta |
| LoRa | Sem hardware; fora do ecossistema Agora. Vai para "próximos passos" |
| Modo offline / implantação privada da Agora | Exige servidor próprio e contato com suporte |
| ConvoAI Device Kit | Só via formulário de vendas; citar como hardware do produto final |
| Câmera de fadiga e OBD | Fora da proposta de voz; já existe no mercado |
| Integração com rastreadores reais | API por fabricante; simular na demo |
| Rádio PX | Áudio ruidoso e captura exige hardware; opcional com gravações limpas, declarado no README |

## Cronograma

Cada fase só começa quando o gate da anterior passa; se a fase 1 não passar até 14h, aciona o LLM reserva.

| Prazo | Fase | Gate |
|---|---|---|
| Sáb 14h | 1. Canal de voz | Português, resposta abaixo de 2 s, interrupção, LLM reserva definido |
| Sáb 19h | 2. Comunidade | Extrator sem invenção, roteador com confirmação, alerta entre 2 clientes |
| Sáb 23h | 3. Cansaço e CCO | 3 níveis funcionando, sem falso positivo na sessão desperta, painel CCO |
| Dom 7h | 4. Corporativo e Pessoal | RDO aprovado pelo motorista, Pessoal isolado dos outros destinos |
| Dom 9h | 5. Validação | 6 ou mais testadores externos, números em `docs/validacao.md` |
| Dom 11h | 6. Entrega | Repo com tag, vídeo de 2 min, 10 slides, demo ensaiada (prazo final 12h) |

A ordem segue o valor na demo: Comunidade impressiona mais e vem antes; Pessoal é só armazenamento e fica por último.

## Demo, validação e entrega

**Roteiro da demo**

1. Motorista A fala "acidente no km 230"; o agente confirma e publica na Comunidade.
2. Motorista B, atrás, é avisado por voz; o evento aparece no mapa do CCO.
3. A responde cada vez mais devagar; o agente puxa conversa (nível 1) e sugere parada (nível 2).
4. A deixa de responder; nível 3 abre o canal e o operador do CCO entra por voz.
5. Na parada, A conta como foi o trecho; o RDO aparece no painel. Ele grava um recado para a filha, que fica no Pessoal.

**Validação**

- 6 ou mais testadores externos, sem saber o que dispara o alerta.
- Cansaço induzido por tarefa paralela (conta de cabeça enquanto conversam), comparado com sessão sem tarefa.
- Medir: latência de resposta do agente, acerto do roteamento (zero vazamento do Pessoal), eventos extraídos sem invenção, falsos positivos de cansaço.
- Números em `docs/validacao.md`; dados reais fora do repositório.

**Entrega**

- [ ] Repositório público com tag e README (planos B declarados)
- [ ] Vídeo de 2 minutos
- [ ] 10 slides, incluindo "próximos passos" (LoRa, Device Kit, rastreadores)
- [ ] Demo ensaiada

## Riscos e mitigação

O maior risco técnico é a latência em português; o maior risco de produto é o motorista se sentir vigiado.

| Risco | Impacto | Mitigação |
|---|---|---|
| Português ou latência > 2 s no Conversational AI | Demo ao vivo quebra | Testar primeiro; LLM reserva trocável por variável de ambiente |
| Motorista calado (microssono é silêncio) | Cansaço não é detectado | Agente puxa conversa; tempo de resposta vira o sinal |
| Fala pessoal roteada para Corporativo ou Comunidade | Perda total de confiança | Pessoal por padrão; confirmação por voz para os outros destinos |
| Corporativo vira fiscalização | Motorista para de usar | Níveis 1 e 2 nunca saem do motorista; RDO só com aprovação |
| Prometer "criptografado, ninguém vê" | Banca derruba | Dizer "cifrado no servidor"; o áudio passa por STT e LLM na nuvem |
| Validação circular do cansaço | Banca questiona | Testadores externos, cansaço induzido por tarefa paralela |
| Falha no nível 3 com acidente real | Responsabilidade | Posicionar como apoio, não garantia; escrito no README |
| LGPD (voz e jornada são dados do motorista) | Jurídico | Consentimento por destino; tela "o que a empresa vê" |
| Sem sinal na rodovia | Alerta não chega | Entrega adiada via Chat; LoRa como próximo passo |

Pendências: nome do time e integrantes.
