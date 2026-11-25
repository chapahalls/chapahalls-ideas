# RODAR

> Para transportadoras: um agente de voz que avisa o recebedor, conta a espera na doca e prova cada hora parada, sem o motorista tocar no celular, e entrega esses eventos ao TMS, ao rastreador e ao financeiro que a empresa já usa ([ADR-0001](docs/adr/0001-integracao-setup-e-tres-dores.md)).

- **Event:** Hack Brasil 2026 · trilha Logística & automação · submissão até **2026-11-30 23:59 (UTC-3)** · repos congelados 12-01 → 12-12 · final presencial **2026-12-12** (São Paulo).
- **Rules & scoring:** `HACKATHON.md` (`/judge` scores against it)
- **Chosen idea:** RODAR (`ideas/rodar.md`); problema detalhado em `ideas/demora-em-docas/descoberta.md`
- **Team:** RODAR — Jeferson (`@STT4jeferson`), Henry (`@HenryFacens`), Lucas (`@LucasLCO`), Eduardo. 4 = máximo do Hack Brasil (X9). Conferir no painel.
- **Definition of done:** the demo path below works from a fresh clone, following `README.md`.

## Demo path

<!-- The exact steps you will show the judges (2 min demo). The verifier walks this at every phase close.
     Score-driven (HACKATHON.md): the product working end to end on the public demo (H1), the effect on the truck stopped at the dock (H3), one failure + recovery. Fits the 3-min video. -->

1. <step>
2. <step>
3. <step>

## Phases

<!--
Exactly one phase is `open` at a time. `/phase` verifies and closes it, then opens the next.
Acceptance criteria are written BEFORE the work starts and must be checkable
(a command, a URL, a visible result). The verifier checks exactly these, nothing invented.
Status values: planned | open | done (<date> · phase/<n>-<slug>)
-->

### Phase 1: <title>

- **Status:** open
- **Goal:** <one sentence>
- **Acceptance criteria:**
  - [ ] <checkable criterion>
  - [ ] <checkable criterion>
- **Out of scope:** <what we will not do in this phase>

### Phase 2: <title>

- **Status:** planned
- **Goal:** <one sentence>
- **Acceptance criteria:**
  - [ ] <checkable criterion>

## Parking lot

<!-- Ideas we are not doing now. Pull one into a phase via /adr if the plan changes. -->

Conectores de mercado (ADR-0001). Cada um vira um adaptador em `rodar-backend/backend/app/integracoes/`, atrás de uma porta:

- **TMS** via EDI OCOREN (Proceda): Senior, TOTVS, Bsoft. Ocorrências de chegada, espera e descarga.
- **Rastreador/telemetria** (Sascar, Omnilink, Autotrac): troca o GPS simulado pela dupla prova real.
- **Financeiro/ERP:** estadia devida por entrega, para faturar ao embarcador ou recebedor.
- **Gerenciadora de risco:** ocorrências em rota.
- **Agendamento de docas e pátio** (YMS) e **agendamento portuário** (APS Santos, Carga Online Paranaguá): o aviso de chegada vai para a janela, e o tempo de pátio é registrado.
- **Telefonia real** para o recebedor (SIP; avaliar Nvoip).

## Dropped

<!-- What we cut, with a link to the ADR or commit that explains why. -->
