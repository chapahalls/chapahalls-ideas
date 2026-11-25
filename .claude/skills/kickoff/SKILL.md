---
name: kickoff
description: Start the hackathon project. Turns the idea into PLAN.md (pitch, demo path, phases with acceptance criteria), ADR 0001 for the stack, the Project section of CLAUDE.md, and tags phase/0-kickoff so the roadmap starts with the idea. Run once, at the very beginning.
argument-hint: "[idea, stack, team, deadline — anything you already know]"
disable-model-invocation: true
---

# Kickoff

Input from the user: $ARGUMENTS

## 0. Hackathon rules and the chosen idea

Read `HACKATHON.md` (rubric, disqualifiers, deliverables) and `ideas/README.md`. If an idea is marked `escolhida`, start from `ideas/<slug>.md` and its score in `ideas/scores/`. If none is chosen, suggest the top of the ranking and ask. Then:

- The **demo path** must show the product working end to end on a public HTTPS demo (H1 execução is the first tie-breaker, and the jury may not install anything), with one failure and its recovery. It has to fit the 3-minute video.
- The **last phase** is "Submission" and ends before **2026-11-30 23:59 (UTC-3)**. Its acceptance criteria: `sh scripts/check-rules.sh` exits 0 on the three code repos; demo HTTPS link up; video ≤ 3 min without login; panel submission with name, tagline, description, track, repo links, demo and video (S1-S6). After that, no commits until the final on 2026-12-12.
- Tools are free (item 6.3). For anything touching Agora (our voice stack), use the `agora` skill / Agora docs MCP instead of guessing APIs.
- The README you write must have the sections that `scripts/check-rules.sh` looks for: how to run, dependencies/requirements, pre-existing/third-party components, simulations, demo link and video link.

## 1. Gather what's missing

You need: the idea and who it's for, the demo the judges will see, the stack, the team names, the deadline. Take what's in the input and the repo; ask **one** message with only the missing items (at most 5 short questions). Don't ask about things with an obvious default: pick it and say so.

## 2. Write PLAN.md

Fill the template already in `PLAN.md`:

- **Pitch:** one line, user + value.
- **Demo path:** 3-6 concrete steps the team will show. This is the definition of done.
- **Phases:** 3-5 phases sized to the time available. Typical shape: walking skeleton (end-to-end, ugly) → core feature → the "wow" → polish and demo prep. Leave the last ~15% of the time for demo prep.
- **Phase 1** gets `Status: open` and full acceptance criteria. Later phases get a goal and rough criteria (`planned`); they are refined when opened.
- Acceptance criteria must be **checkable** by someone else: a command that passes, a URL that returns something, a visible result in the UI. "Works well" is not a criterion.

## 3. Write ADR 0001

Copy `docs/adr/TEMPLATE.md` to `docs/adr/0001-stack.md`: the stack choice, why, and what was considered.

## 4. Fill the Project section of CLAUDE.md

What, stack, run command, test command. Short.

Rewrite `README.md` for the project: name, pitch, requirements, how to install and run the demo path, in the exact commands a stranger would type on a fresh clone (the verifier follows them literally). Keep only the *How it works*, *Working agreement* and *Commands* sections from the kit's README, under a "Project workflow" heading; drop the kit's *Setup* and *Layout* sections once the repo settings are done.

## 5. Setup, commit, tag

```bash
sh scripts/setup.sh
```

Commit everything with a message like:

```
chore: kickoff <project name>

<pitch>

Product: <pitch in user terms>
Decision: <stack in one line> (ADR-0001)
Next: <phase 1 goal>
```

Then tag the start of the story (annotated, so the roadmap shows the pitch):

```bash
git tag -a phase/0-kickoff -m "Kickoff: <project name>" -m "<pitch>. Demo: <demo path in one line>."
```

Push if the repo has a remote, setting the upstream so later "is main behind?" checks work: `git push -u --atomic origin HEAD refs/tags/phase/0-kickoff`.

## 6. Report

Show the phases (one line each) and phase 1's acceptance criteria, and say what to build first.
