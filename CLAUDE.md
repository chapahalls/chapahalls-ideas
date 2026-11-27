# Project

- **What:** RODAR — agente de IA de voz que avisa o recebedor antes da chegada do caminhão, conta a estadia na doca (Lei 11.442) e só chama a central (CCO) quando alguém precisa decidir. A voz é o diferencial de acessibilidade. O que vendemos é a integração (setup) com os sistemas da transportadora (TMS, rastreador, financeiro); o dashboard é a vitrine. O pitch fala de três dores: caminhoneiro, dono e financeiro ([ADR-0001](docs/adr/0001-integracao-setup-e-tres-dores.md)).
- **Stack:** FastAPI + Postgres (backend), React + Vite (painel CCO), React Native/Expo (app do motorista), Agora Conversational AI (voz). Docker.
- **Código:** [rodar-backend](https://github.com/rodarglobal/rodar-backend) · [rodar-web](https://github.com/rodarglobal/rodar-web) · [rodar-mobile](https://github.com/rodarglobal/rodar-mobile). Este repo (`rodar-ideas`) guarda só pesquisa e decisões.
- **Run it / Test it:** ver o README de cada repositório de código.

# Hackathon: Hack Brasil 2026 (trilha Logística & automação)

`HACKATHON.md` has the official rules, scoring (H1-H4, 0-10 each, equal weight), disqualifiers (X1-X10) and submission items (S1-S6). Every decision is weighed against it. **Submission deadline: 2026-11-30 23:59 (UTC-3).** Repos are **frozen** from 12-01 to the final on **2026-12-12** (São Paulo): no commits in that window.

- **Score first.** H1 execução técnica (works and is complete) and H3 impacto (effect on the logistics problem and public) are the tie-breakers, in that order. When choosing what to build next, pick what makes the product visibly work end to end in the demo and the 3-min video.
- **The jury may not install or run anything** (item 7.4): a live HTTPS demo and the video are what they see. Keep the demo up during evaluation.
- **Fit the track** (Logística & automação): frame the problem as trucks idle at docks and information flow between motorista, recebedor and CCO, not as driver health or safety.
- **Tools are free choice.** Agora is our choice for voice, not a requirement; it counts under H2 like any other tech. The Agora plugin (`agora@agora-skills`, Agora docs MCP) stays enabled: use it for anything touching Agora instead of guessing APIs.
- **Declare** pre-existing/third-party components and anything simulated in each code repo's README. No real personal data in the demo (X6).
- Before submitting, and when asked "are we within the rules?": `/judge projeto` (runs `scripts/check-rules.sh` on the three code repos + the `judge` agent).

# How we work

`PLAN.md` is the source of truth for what we are building and in which phase we are. `ROADMAP.md` and the Pages site are **generated** from git (`scripts/roadmap.mjs`): never edit them by hand.

## You are the orchestrator

The main Claude session in each teammate's terminal is the hub. Subagents (like `verifier`) report back to you, never to each other. Keep agents few: in a codebase changing this fast, parallel writers mostly produce merge conflicts.

## Rules

1. **Work on the open phase only.** Ideas outside it go to the *Parking lot* in `PLAN.md`. Never change a phase's acceptance criteria silently: that is a decision (`/adr`) or the user's explicit call.
2. **Definition of done:** the demo path in `PLAN.md` works from a fresh clone, following `README.md`. Nothing gets merged that breaks it.
3. **Commits** follow the `/commit` conventions: conventional subject, a one-line why, and roadmap trailers **only** when the change is product-level. Small fixes stay plain.
4. **Never squash, never rewrite pushed history.** The roadmap is built from commit trailers: a squash merge or a force-push erases them. Merge with a merge commit or rebase-and-merge.
5. **Decisions and pivots** that change the plan go through `/adr` (record + `PLAN.md` update + trailers).
6. **Phases close only through `/phase`.** Never create or move `phase/*` tags by hand.
7. **Verifier and judge are read-only.** The verifier proves the acceptance criteria and writes only to `evidence/`; the judge scores and writes only to `ideas/scores/` and `docs/report/` (CI runs it on every push to a code repo's main). Fixes go back to whoever owns the code.
8. **Demo first.** Prefer the working, slightly ugly version now over the polished one later. Hard-code before you abstract.
9. **No secrets in git.** Keys go in `.env` (ignored); document the variable names in `README.md`.

## Skills

| Skill | When |
|---|---|
| `/kickoff` | Once, at the start: writes `PLAN.md`, ADR 0001, this file's Project section, tags `phase/0-kickoff` |
| `/commit` | Every commit (Claude uses its conventions whenever it commits) |
| `/adr` | A decision worth remembering, a pivot, or cutting scope |
| `/phase` | The open phase's acceptance criteria look met: verify, tag, update roadmap |
| `/idea` | Capture a project idea in `ideas/` and score it |
| `/judge` | Score ideas or the project against the rubric and check the rules (`/judge`, `/judge <slug>`, `/judge projeto`) |
| `/progress` | "Where are we?": open phase, what's done since the last tag, time spent |
