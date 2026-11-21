# Project

<!-- /kickoff fills this section. Keep it short: the details live in PLAN.md and README.md. -->

- **What:** _(one line)_
- **Stack:** _(languages, frameworks, hosting)_
- **Run it:** _(the one command, or see README)_
- **Test it:** _(the one command)_

# Hackathon: UNMUTE by Agora

`HACKATHON.md` has the official rules, scoring rubric (C1-C6), disqualifiers (E1-E8) and deliverables (D1-D4). Every decision is weighed against it. Final deadline: **2026-11-22 12:00 (UTC-3)**.

- **Score first.** C1 voice/interaction (25%) and C2 execution + Agora (25%) are half the score and the first tie-breakers. When choosing what to build next, pick what moves C1/C2 in the demo.
- **Agora must be functional and visible** in the demo and video (E2). A feature that works without Agora in the path doesn't count for C2.
- **Declare** pre-existing components and anything simulated/mocked in `README.md` (E5, E8).
- Before submitting, and when asked "are we within the rules?": `/judge projeto` (runs `scripts/check-rules.sh` + the `judge` agent).

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
7. **Verifier and judge are read-only.** The verifier proves the acceptance criteria and writes only to `evidence/`; the judge scores and writes only to `ideas/scores/` and `evidence/`. Fixes go back to whoever owns the code.
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
