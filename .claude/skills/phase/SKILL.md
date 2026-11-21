---
name: phase
description: Close the open phase. Has the verifier agent prove the acceptance criteria from PLAN.md, and only if they pass creates the annotated phase/N-slug tag, marks the phase done, opens the next one, regenerates ROADMAP.md and pushes. The only way phases close.
argument-hint: "[\"close anyway: <reason>\" to accept known gaps]"
disable-model-invocation: true
---

# Close the open phase

Extra input: $ARGUMENTS

## 1. Preconditions

1. Read `PLAN.md`; find the phase with `Status: open`. None → stop and say so.
2. `git status --porcelain` must be empty. Uncommitted work → stop and offer `/commit` first.
3. If there's a remote: `git fetch --tags origin`, then `git rev-list --count HEAD..origin/main` must be `0`. Behind → stop; the user pulls first (another teammate may have closed this phase).
4. Check no `phase/<n>-*` tag already exists for this number: `git tag -l 'phase/<n>-*'`.
5. If there's a remote, **push the branch now** (`git push -u origin HEAD`), before verifying: the verifier clones the remote, because that is what the judges will clone. Unpushed work would fail the fresh-clone check for the wrong reason.

## 2. Verify

Delegate to the **verifier** subagent. Give it, verbatim: the phase number and title, its acceptance criteria, the demo path, the run/test commands from `CLAUDE.md`, and whether the branch is pushed (clone the remote) or there is no remote (clone the local repo). It writes `evidence/phase-<n>.md` and returns a verdict per criterion. The demo path describes the finished product: steps a later phase delivers are reported as informational, not failures.

- **All PROVEN** (NEEDS HUMAN items confirmed by the user) → continue.
- **Any FAILED or unconfirmed** → stop. Show the failures and what to fix. Don't tag. After the fix is committed and pushed, run `/phase` again: the verifier re-runs everything and keeps the earlier failure in the report as history.
- The user may override with "close anyway: <reason>". Then continue, and the accepted gaps go into the tag message and `PLAN.md`.

For NEEDS HUMAN items, ask the user to confirm them in one message (list them), and record their answer in the evidence file's last section.

**Rules check, every phase:** run `sh scripts/check-rules.sh` too and show its E2 (Agora) and E7 (credentials) lines: a leaked key or Agora missing from the path is a stop, whatever the phase. On the **last phase** (submission), also run the `judge` agent in project mode: any disqualifier FAILED blocks the tag, just like a FAILED criterion.

## 3. Tag

Slug: 1-3 words from the phase title, kebab-case. Summary: 2-4 lines on what the phase achieved and the state of the demo, plus accepted gaps if any.

```bash
git tag -a phase/<n>-<slug> -m "<Phase title>" -m "<summary>"
```

The tag goes on the current HEAD (the last work commit), **before** the bookkeeping commit below.

## 4. Update the plan

In `PLAN.md`:

- Closed phase: `Status: done (<YYYY-MM-DD HH:MM> · phase/<n>-<slug>)` with the real time from `date '+%Y-%m-%d %H:%M'` (don't guess it), tick its criteria (`[x]`), note accepted gaps.
- Next `planned` phase → `Status: open`. If its acceptance criteria are vague or missing, propose concrete ones and ask the user to confirm (one message). Opening without checkable criteria makes the next `/phase` meaningless.

## 5. Roadmap and commit

```bash
node scripts/roadmap.mjs --format md > ROADMAP.md
git add PLAN.md ROADMAP.md evidence/
git commit -m "chore(roadmap): close phase <n>"
```

`chore(roadmap)` commits are skipped by the roadmap: no roadmap trailers here. The evidence report and its raw files are committed on purpose: they are the proof behind the tag.

## 6. Push

If there's a remote, push the branch and the tag together (the Action then sees both):

```bash
git push --atomic origin HEAD refs/tags/phase/<n>-<slug>
```

## 7. Report

Phase closed (tag), time it took (from `node scripts/roadmap.mjs --format status`), what's shipped, the next phase's goal and criteria.
