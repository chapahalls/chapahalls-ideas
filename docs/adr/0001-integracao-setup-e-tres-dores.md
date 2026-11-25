# ADR 0001: RODAR é integração (setup), o dashboard é a vitrine, e o pitch fala de três dores

- **Status:** Accepted
- **Date:** 2026-11-25 15:58
- **Phase:** nenhuma aberta (`PLAN.md` ainda sem `/kickoff`)
- **Deciders:** time RODAR (Jeferson, Henry, Lucas, Eduardo)

## Context

O RODAR já tem app do motorista, backend e painel do CCO. O risco era vender "mais um dashboard". Transportadoras já pagam por TMS, rastreador, gerenciadora de risco e ERP. Recebedores e portos já têm agendamento e gestão de pátio. Nenhum desses sistemas ouve o motorista, e nenhum mede a espera na doca de ponta a ponta. A trilha Logística & automação cita "conectores e integrações entre sistemas" e "automação de fluxos de trabalho" como exemplos.

## Decision

1. **O produto é a camada de integração (setup).** O RODAR se conecta aos sistemas que a transportadora já usa. A voz do motorista vira evento estruturado (chegada, espera, ocorrência, descarga), e esse evento é entregue a esses sistemas. A venda é **implantação/integração (setup) + assinatura por caminhão** (~R$ 100/mês, valor já discutido; o preço do setup está em aberto).
2. **O dashboard continua, como vitrine e para o cliente sem sistema.** Ele mostra a operação e as exceções. Não é o que vendemos como diferencial.
3. **A base técnica é a arquitetura de portas e adaptadores que já existe no backend** (`backend/app/portas.py`: cada porta tem um adaptador real e um fake de teste). Cada sistema de mercado vira um adaptador novo, sem mexer no domínio.
4. **O pitch fala de três dores, cada uma com número e fonte** ([`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md)):
   - **Caminhoneiro:** horas paradas (5h09 em média; 11h40 em CDs), sem estadia (91% não recebem), sem poder digitar dirigindo. A voz é a acessibilidade.
   - **Dono (transportadora ou autônomo dono do caminhão):** o ativo parado custa ~R$ 146/h, e o CCO vive de ligação e redigitação.
   - **Financeiro:** a estadia devida não é faturada. A espera abaixo de 5h (~R$ 323 numa espera de 4h) nunca é cobrada. A estadia cobre só ~metade do custo da hora. No porto, o pátio ainda custa ao motorista (~R$ 800 por 24h em Santos).
5. **Só chamamos de "integração" o que existir como adaptador executável.** O resto é roadmap e aparece assim no README, no vídeo e nos slides.

## Alternatives considered

| Alternative | Why not |
|---|---|
| Vender o dashboard como produto principal | Concorre com TMS, telemetria e YMS que o cliente já paga; o diferencial (voz + espera de ponta a ponta) some na tela |
| App de voz isolado, sem integração | Os dados morrem no app: a transportadora redigita no TMS e o financeiro não fatura a estadia |
| Integrar direto com o recebedor (YMS, agendamento) primeiro | Quem não sente o custo é o recebedor, que não compra; ele entra como destino do aviso, não como cliente |

## Consequences

- **Good:**
  - Encaixa nos exemplos literais da trilha (conectores e automação de fluxo).
  - Cria receita de setup.
  - Faz o RODAR conviver com o que o cliente já tem, em vez de competir.
  - A arquitetura atual já é de portas e adaptadores.
- **Bad / risks:**
  - **Hoje os únicos adaptadores reais são de infraestrutura** (Agora, OpenAI, Twilio, tokens). Os de mercado (TMS, rastreador, ERP, agendamento portuário) **não existem**, e prometer integração sem um conector funcionando pesa contra H1 e H3.
  - Setup alonga o ciclo de venda e exige gente em campo nos primeiros clientes.
  - Cada TMS tem formato próprio. O caminho mais curto é um padrão do mercado, como o **EDI OCOREN (Proceda)**.
- **Plan changes:**
  - Os conectores de mercado entram no *Parking lot* do `PLAN.md`.
  - Antes de 30/11, só vale a pena um conector demonstrável.
  - Fora isso, o ADR muda o discurso (README, vídeo, painel) e não muda o escopo de código.
