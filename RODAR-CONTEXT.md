# RODAR — Contexto de produto

> Documento de referência do time e dos agentes de código. Regras e prazos: [`HACKATHON.md`](HACKATHON.md). Problema com fontes: [`ideas/demora-em-docas/descoberta.md`](ideas/demora-em-docas/descoberta.md) (as referências [Fn] abaixo são de lá). Ideia no formato do judge: [`ideas/rodar.md`](ideas/rodar.md).

## 1. Propósito

**O RODAR é um agente de IA de voz que avisa o recebedor antes da chegada do caminhão, conta a espera na doca e prova cada hora parada, sem o motorista tocar no celular.**

- **Problema (logístico):** o caminhão para horas antes de descarregar, e ninguém responde por esse tempo.
  - **CDs de varejo e indústria:** 11h40 de espera na Grande SP em 2025 [F1].
  - **Atacadistas e atacarejos:** 5h56 [F1].
  - **Home centers e lojas de departamento:** 4h33 [F1].
  - **Média geral:** 5h09, contra 2h50 em 2019 [F1][F10].
  - **Portos:** pátios reguladores cheios. Em Santos, o motorista paga ~R$ 800 por 24h de pátio [F25]. Em Miritituba, filas de até 45 km e espera de até 3 dias na safra [F26].
- **Diferencial (acessibilidade):** os sistemas que existem pedem que o motorista **leia e digite**. Mas:
  - metade dos brasileiros de 50 a 64 anos é analfabeta funcional [F29];
  - o motorista profissional tem 54 anos em média [F8], e 43,6% estudaram até o fundamental [F6];
  - a lei proíbe segurar o celular dirigindo [F30].

  O RODAR troca a tela pela **conversa por voz**.
- **Resultado:** o recebedor prepara a doca antes; a espera vira prova com hora e valor em R$; a central só é chamada nas exceções.
- **O que vendemos ([ADR-0001](docs/adr/0001-integracao-setup-e-tres-dores.md)):** a **camada de integração**. A voz do motorista vira evento estruturado e é entregue aos sistemas que a transportadora já usa (TMS, rastreador, financeiro). O **dashboard** é a vitrine e atende o cliente que não tem sistema. Não é o diferencial.

## 2. As três dores (quem usa, quem decide, quem paga)

| Frente | A dor, com número | O que o RODAR entrega |
|---|---|---|
| **Caminhoneiro** (usuário; CLT ou autônomo) | Espera de 5h09 em média e 11h40 em CDs [F1]. 91% não recebem a estadia [F2]. Não pode digitar dirigindo [F30]. 51% dos brasileiros de 50 a 64 anos são analfabetos funcionais [F29]. No porto, paga até ~R$ 800 por 24h de pátio [F25] | Fala em vez de digitar. A espera fica registrada sem ele pedir, e a prova é dele também |
| **Dono** (transportadora ou autônomo dono do caminhão; quem decide a compra) | O caminhão parado custa ~R$ 146/h (estimativa em [`impacto-e-custos.md`](ideas/parceiro-de-estrada/impacto-e-custos.md)). O CCO vive de ligação e redigitação em vários sistemas | Aviso antecipado ao recebedor, CCO só nas exceções, eventos entregues ao TMS e ao rastreador sem redigitar |
| **Financeiro** (quem fatura e cobra) | A estadia devida não é faturada. Uma espera de 4h (~R$ 323) nunca é cobrada, porque fica abaixo da franquia. A estadia (R$ 75/h para 30 t) cobre só ~metade do custo da hora [F16] | Estadia devida por entrega, em R$, com prova (hora do servidor + GPS), pronta para faturar ou renegociar contrato; ranking de recebedores |

O **recebedor** (CD, atacado, home center, terminal) não compra. Ele recebe o aviso antecipado para preparar a doca e o conferente.

**Modelo de receita (ADR-0001):** setup de implantação e integração + assinatura por caminhão (~R$ 100/mês). O preço do setup está em aberto [H].

## 3. Fluxo do produto

1. **Viagem atribuída:** o motorista vê a rota no app e conversa com o agente por voz.
2. **Aproximação (geocerca):** o agente avisa o motorista, o recebedor e o CCO.
3. **Chegada:** o agente confirma por voz e cria a Task do CCO. O contador de estadia começa (Lei 11.442: franquia de 5h, R$ 2,50 por t·h) [F16].
4. **Espera:** o agente pergunta o status por voz. Quando o recebedor não responde, insiste com o CCO e, sem resposta, liga para o recebedor e registra a resposta como prova.
5. **Descarga:** o motorista confirma por voz; o contador fecha e o valor da estadia devida aparece no painel.

## 4. Arquitetura

| Repositório | Papel |
|---|---|
| [rodar-mobile](https://github.com/rodarglobal/rodar-mobile) | App do motorista (React Native/Expo): voz pela Agora, mapa, fila offline |
| [rodar-backend](https://github.com/rodarglobal/rodar-backend) | FastAPI + Postgres: tokens, `/join` `/leave` `/speak` `/call`, LLM próprio com ferramentas, geocerca, estadia, escalonamento, SSE |
| [rodar-web](https://github.com/rodarglobal/rodar-web) | Site e painel do CCO (React + Vite): frota, Tasks, linha do tempo com transcrição, indicadores de estadia |

A voz roda na **Agora Conversational AI** (ASR ARES, TTS MiniMax), e o LLM é da OpenAI. O áudio vai do aparelho direto para a nuvem da Agora; o backend é o plano de controle. Não guardamos áudio, só a transcrição.

**Integração por portas e adaptadores.** O backend define contratos em `backend/app/portas.py` (`typing.Protocol`). Cada porta tem um adaptador real em `backend/app/integracoes/` e um fake para teste. Um sistema de mercado entra como adaptador novo, sem mexer nas regras de domínio (estadia, geocerca, escalonamento).

| Sistema de mercado | Para quê | Estado |
|---|---|---|
| Agora (voz e chamada), OpenAI (LLM), Twilio (SIP) | Voz e ligação | **Adaptador real** |
| TMS via EDI OCOREN (Senior, TOTVS, Bsoft) | Ocorrências de chegada, espera e descarga sem redigitar | Roadmap |
| Rastreador/telemetria (Sascar, Omnilink, Autotrac) | Dupla prova real da posição (hoje simulada) | Roadmap |
| Financeiro/ERP | Estadia devida por entrega para faturar | Roadmap |
| Gerenciadora de risco | Ocorrências em rota | Roadmap |
| YMS / agendamento de docas; agendamento portuário (APS, Carga Online) | Aviso entra na janela; tempo de pátio registrado | Roadmap |

Só chamamos de integração o que está como **adaptador real** (ADR-0001).

## 5. Onde atuar primeiro

1. **CDs, atacados e home centers:** não há agendamento obrigatório nem autoridade, e a espera é diária. É onde o aviso antecipado e a prova mais mudam o resultado.
2. **Portos (próximo passo):** registrar o tempo de pátio, para decidir quem paga as 24h, e guiar o motorista por voz nos sistemas de agendamento (APS em Santos, Carga Online em Paranaguá). **Não está implementado**: depende de integração.

## 6. Limites e riscos

- A voz não cria doca: o efeito depende de o recebedor ou a transportadora agirem com o aviso e a prova.
- O ASR em cabine barulhenta e com sotaques regionais ainda não foi testado com motoristas reais.
- O GPS de celular é contestável. A dupla prova com o rastreador é simulada.
- A ligação telefônica real ao recebedor está desligada (falta um número). O plano B é um canal RTC.
- LGPD: só a transcrição é guardada, e nenhum dado de saúde.

## 7. Evolução

- Piloto com uma transportadora; teste de voz × formulário com motoristas de 50 anos ou mais.
- Conectores de mercado da tabela da seção 4, começando pelo TMS via EDI OCOREN, que é padrão do mercado.
- Voz offline para trechos sem sinal.
- Ranking público de recebedores por tempo de descarga.

Pesquisa de apoio (mercado, custos, concorrentes, riscos): [`ideas/parceiro-de-estrada/`](ideas/parceiro-de-estrada/README.md).
