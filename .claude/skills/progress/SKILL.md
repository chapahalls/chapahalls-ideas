---
name: progress
description: Answer "where are we?" for the hackathon project. Combines PLAN.md (open phase, acceptance criteria, deadline) with git history (scripts/roadmap.mjs --format status) into a short standup-style report. Use when the user asks about progress, status, time left, what's next, or before deciding what to work on.
allowed-tools: Read, Grep, Glob, Bash(node scripts/roadmap.mjs:*), Bash(git log:*), Bash(git status:*), Bash(git tag:*), Bash(date:*)
---

# Progress

Read-only: this skill changes nothing.

1. Run `node scripts/roadmap.mjs --format status` and `date`.
2. Read `PLAN.md`: open phase, its acceptance criteria, deadline, demo path.
3. For each criterion of the open phase, give a **quick, unverified** read from the code and commits: likely done / in progress / not started. Say plainly that only `/phase` verifies.

Report, at most ~15 lines:

- **Phase:** number, title, time in this phase, time left to the deadline.
- **Criteria:** one line each with the quick read.
- **Since last phase:** what shipped, decisions, pivots (from the status output).
- **Next:** the latest `Next:` and what you'd do now to close the phase.
- **Risk:** only if real: the demo path is broken, a criterion has no progress with little time left, or the remaining phases don't fit the time left (then suggest an `/adr` to cut scope).
