---
name: commit
description: Commit conventions for this repo. Use whenever you commit, and when the user says "commit", "save this", "checkpoint". Writes a conventional subject, a one-line why, and roadmap trailers (Product, Decision, Pivot, Dropped, Next) only when the change is product-level, so scripts/roadmap.mjs can build the project's story.
argument-hint: "[optional hint: what this change means for the product]"
---

# Commit

Extra context from the user: $ARGUMENTS

## 1. Look at the change

```bash
git status --short
git diff --staged --stat
```

If nothing is staged, stage the files that belong to this change (by name, not `git add -A`). Never stage `.env`, keys, or large generated files; warn if you see them.

## 2. Is it product-level?

Product-level = after this commit, a user, a judge or the team's plan sees something different:

- a new capability or a visible change in the demo path → `Product:`
- a choice between options that someone will ask "why?" about later (library, API, data source, architecture, scope) → `Decision:`
- abandoning an approach for another → `Pivot:` (and run `/adr` if it changes PLAN.md)
- cutting a feature or criterion → `Dropped:` (and move it to *Dropped* in PLAN.md)
- the obvious next step is now clear → `Next:`

**Not** product-level: refactors, typo fixes, styling tweaks, test-only changes, dependency bumps, WIP. Those get **no trailers**. Most commits have none: the roadmap should read like a story, not a log.

If you can't tell the *why* from the diff and the conversation, ask one short question.

## 3. Write the message

```
type(scope): what changed, imperative, ≤ 72 chars

Why, in 1-3 lines (optional for trivial changes).

Product: <what a user can now do / see>
Decision: <what we chose> over <alternative> (<reason>)[ (ADR-NNNN)]
Next: <what comes right after>
```

Rules git enforces for trailers to be read:

- They are the **last paragraph**, one `Key: value` per line, **no blank lines** between them.
- Repeat a key for several items (two `Product:` lines is fine).
- Write them for a reader who wasn't there: "Decision: SQLite over Postgres (no infra, single-user demo)", not "Decision: db".

Types: `feat fix refactor docs test chore perf style`. Never use `chore(roadmap)` (reserved for `/phase`; the roadmap skips it).

Commit with a heredoc so newlines survive:

```bash
git commit -F - <<'EOF'
...
EOF
```

Add a `Co-Authored-By:` trailer if your environment asks for one; it goes in the same final block.

## 4. Don'ts

- Don't amend or rebase commits that are already pushed.
- Don't push unless the user asked or it's part of `/phase`.
- Don't create `phase/*` tags (only `/phase` does).
