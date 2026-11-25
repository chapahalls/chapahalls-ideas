# RODAR

- **Autor(es):** Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`), Lucas (`@LucasLCO`), Eduardo
- **Status:** escolhida
- **Nota do judge:** _(rodar `/judge projeto`)_
- **Código:** [rodar-backend](https://github.com/rodarglobal/rodar-backend) · [rodar-web](https://github.com/rodarglobal/rodar-web) · [rodar-mobile](https://github.com/rodarglobal/rodar-mobile)
- **Pesquisa do problema, com fontes:** [`demora-em-docas/descoberta.md`](demora-em-docas/descoberta.md) (as referências [Fn] abaixo são de lá)

> **Agente de IA de voz que avisa o recebedor antes da chegada, conta a espera na doca e prova cada hora parada, sem o motorista tocar no celular.**

## Trilha e enquadramento

- **Trilha:** Logística & automação.
- **Por que encaixa:** a trilha pede projetos que "movem bens, informação ou trabalho de forma mais eficiente". O RODAR move **informação** (o aviso de chegada ao recebedor, o status da espera ao CCO) para que o **bem** (o caminhão e a carga) não fique parado, e **automatiza** o fluxo do CCO: só chama a central quando alguém precisa decidir.
- **Cuidado:** a acessibilidade é o **diferencial** (o "como"), não o problema. O problema é logístico: o caminhão parado sem dono.

## Impacto (H3)

- **Quem (três frentes, [ADR-0001](../docs/adr/0001-integracao-setup-e-tres-dores.md)):**
  - **caminhoneiro**, o usuário;
  - **dono** (transportadora ou autônomo dono do caminhão), que decide a compra;
  - **financeiro**, que fatura a estadia.

  O recebedor (CD, atacado, home center, terminal) recebe o aviso, mas não compra.
- **Problema concreto:**
  - **CDs, atacados e lojas:** na Grande SP, a descarga levou 5h09 em média em 2025 e **11h40 nos CDs**; nos atacadistas e atacarejos, 5h56; nos home centers, 4h33 [F1]. 91% dos autônomos que esperam mais de 5h não recebem a estadia [F2].
  - **Portos:** em Santos, o motorista chega a pagar ~R$ 800 por 24h de pátio regulador [F25]. Em Paranaguá, foram 507 mil caminhões no pátio em 2025 [F22]. Em Miritituba, a fila chegou a 45 km e a espera a até 3 dias [F26].
- **Por que o problema sobrevive:** a lei já prevê a estadia [F16], mas o tempo parado não tem registro nem dono. E os sistemas que existem (agendamento, gestão de pátio, portais portuários) **pressupõem que o motorista lê e digita** [F19][F24].
- **A dor de cada frente:**
  - **Caminhoneiro:** horas paradas, estadia não paga, proibido de digitar dirigindo [F30], e no porto ainda paga o pátio [F25].
  - **Dono:** o caminhão parado custa ~R$ 146/h, e o CCO vive de ligação e redigitação.
  - **Financeiro:** a estadia devida não é faturada. Uma espera de 4h (~R$ 323) nunca é cobrada, e a estadia cobre só ~metade do custo da hora [F16].
- **Efeito esperado:**
  - o recebedor sabe da chegada **antes** e prepara a doca (o melhor recebedor de SP descarrega em 2h [F1]);
  - cada hora parada vira **prova com hora do servidor**, e a estadia devida vira um valor em R$;
  - o CCO só é acionado nas exceções.
- **Como vamos mostrar o efeito:** na demo, a estadia calculada em R$. Na final, as entrevistas e o teste de voz × formulário com motoristas de 50 anos ou mais ([descoberta, seção 5](demora-em-docas/descoberta.md#5-validar-a-ideia)).

## O diferencial: IA de voz como acessibilidade

| Quem está ao volante | Por que a tela o exclui | O que a voz muda |
|---|---|---|
| Média de 45 a 54 anos [F6][F8] | **51% dos brasileiros de 50 a 64 anos são analfabetos funcionais** (INAF 2024) [F29] | O agente pergunta e confirma em voz alta; não há formulário |
| 43,6% estudaram até o fundamental [F6] | Portais diferentes por cliente e por porto [F8][F24] | Um único interlocutor, em português falado, para qualquer recebedor |
| Está dirigindo | Segurar o celular é infração gravíssima, e fone de ouvido também é infração (CTB art. 252) [F30]. Digitar multiplica o risco por ~23 [F31] | O celular fica no suporte. Fala e escuta pelo alto-falante, sem tocar no aparelho |
| Já usa o celular (91% usam app de carga) [F9] | A barreira não é o aparelho, é ler e digitar | Ele usa o que já sabe fazer: falar |

**Por que não basta áudio de WhatsApp:** áudio solto não vira dado. O agente transforma a fala em **evento estruturado** (chegada, doca, atraso, descarga) com hora e localização, cria a Task do CCO e calcula a estadia. [I]

## Execução técnica (H1)

- **O que funciona de ponta a ponta (segundo os READMEs dos repos):**
  1. O motorista fala com o agente pelo app (voz real pela Agora Conversational AI).
  2. Na aproximação (geocerca), o agente avisa o recebedor e o CCO.
  3. Na chegada, o agente cria a Task do CCO e começa a contar a estadia (franquia de 5h, R$ 2,50 por t·h).
  4. O agente insiste com o CCO e, sem resposta, liga para o recebedor (plano B por canal RTC) e registra a resposta como prova.
  5. O painel mostra a frota, as Tasks, a linha do tempo com transcrição e os indicadores de estadia.
- **Qualidade declarada:** 512 testes automatizados e validação ponta a ponta de 33/33 etapas.
- **Demo pública (HTTPS):** **falta publicar.** É requisito da submissão e o primeiro desempate.
- **Falha e recuperação:** contingência local do LLM por palavras-chave; fila offline no app.
- **Simulado (declarado nos READMEs):** login sem senha, GPS da rota, rastreador, documentos fiscais, seed fictício, estadia acelerada e ligação telefônica real desligada.

## Implementação técnica (H2)

- **O que vendemos:** a **camada de integração** com os sistemas que a transportadora já usa (TMS, rastreador, financeiro, agendamento). O dashboard é a vitrine e atende o cliente sem sistema (ADR-0001).
- **Portas e adaptadores:** os contratos ficam em `rodar-backend/backend/app/portas.py`, e cada um tem um adaptador real e um fake. Hoje os adaptadores reais são de infraestrutura (Agora, OpenAI, Twilio). Os de mercado (TMS via EDI OCOREN, rastreador, ERP, agendamento portuário) estão no roadmap. **Não chamar de integração o que não existe como adaptador.**
- **Arquitetura:** o app do motorista (Expo) fala com a nuvem da Agora. O backend (FastAPI + Postgres) é o plano de controle (tokens, join/leave/speak/call, LLM próprio com ferramentas, regras). O painel do CCO (React + Vite) recebe eventos por SSE.
- **Por que essas tecnologias:** a Agora entrega áudio em tempo real com interrupção (barge-in) e telefonia. O LLM próprio permite ferramentas e regras de negócio (estadia, escalonamento).
- **Qualidade:** CI com lint e testes nos três repos, JWT assinado, papel `cco`, CORS restrito e limite de ligações.
- **Terceiros:** Agora ConvoAI (ASR ARES, TTS MiniMax), OpenAI (LLM), SDK `agora-agents` e cloudflared. Todos declarados nos READMEs.

## Comunicação (H4)

- **Roteiro do vídeo (≤ 3 min):**
  1. "11h40 parado num CD de SP. 9 em cada 10 autônomos não recebem pela espera."
  2. "Quem está ao volante não pode digitar, e metade dos brasileiros de 50 a 64 anos não lê com fluência."
  3. O produto por voz: aviso, chegada, estadia, escalonamento.
  4. O mesmo evento chegando ao sistema da transportadora (se houver conector demonstrável) e ao painel.
  5. "Estadia comprovada: R$ X", com as três frentes: o motorista para de esperar sem dono, o dono recupera hora de caminhão, o financeiro fatura.
- **Para um júri que não é de logística:** "o caminhão fica horas parado esperando para descarregar, ninguém paga por isso, e quem poderia avisar está dirigindo".

## Escopo até o prazo (30/11/2026 23h59)

- **Maior risco:** a demo pública não ficar no ar durante a avaliação; a voz real depender de chaves e créditos.
- **Limitações conhecidas:**
  - não cria doca;
  - não integra com o agendamento dos portos (APS, Carga Online);
  - o ASR em cabine barulhenta e com sotaques regionais ainda não foi testado;
  - o GPS de celular é contestável (a dupla prova com o rastreador é simulada).
- **Antes de 30/11, se der tempo:** um conector de mercado demonstrável, sem integração com nenhum cliente real. O mais barato é gerar a ocorrência no formato **EDI OCOREN** a partir dos eventos de chegada e descarga. Isso é código no `rodar-backend` (responsável: Lucas).
- **Próximos passos (final, 12/12):**
  - validação com motoristas de 50 anos ou mais;
  - número telefônico real para o recebedor;
  - piloto com uma transportadora;
  - registro do tempo de pátio nos portos.
