---
name: adr
description: Record a decision, pivot or scope cut. Writes docs/adr/NNNN-<slug>.md from the template, updates PLAN.md when the plan changes (phases, criteria, Dropped, Parking lot), and commits with Decision/Pivot/Dropped trailers. Use when the team changes direction, picks between real alternatives, or cuts a feature.
argument-hint: "<the decision, pivot or cut, in a sentence>"
---

# ADR

The decision: $ARGUMENTS

Use an ADR when someone will later ask "why did you do it this way?": a pivot, a cut, a choice between real alternatives. A one-line `Decision:` trailer in a normal commit is enough for small choices; don't write an ADR for those.

## 1. Understand it

From the input and the conversation, get: what forced it (context), what was chosen, what else was considered, and what changes in the plan. Ask one short message only for what's genuinely missing.

## 2. Write the record

- Next number: highest `docs/adr/NNNN-*.md` + 1, four digits.
- Copy `docs/adr/TEMPLATE.md` to `docs/adr/NNNN-<short-slug>.md` and fill it. Keep it under a page. Date with time (it's a hackathon).
- If it replaces an earlier ADR, set that one's status to `Superseded by ADR NNNN`.

## 3. Update PLAN.md if the plan changed

- **Pivot:** rewrite the affected phases' goals and criteria; the open phase stays open unless the user says otherwise. Mention the ADR next to what changed.
- **Cut:** move the item to *Dropped* with `(ADR-NNNN)`; remove its criteria.
- **New idea not for now:** *Parking lot*.

Never silently loosen the open phase's acceptance criteria: say in the ADR what was relaxed and why.

## 4. Commit

```
docs(adr): NNNN <decision in a few words>

<one-line context>

Decision: <what we chose> (ADR-NNNN)
Pivot: <from what to what, why>        ← only if it's a pivot
Dropped: <what was cut, why>            ← only if something was cut
Next: <what we do now>
```

Follow the trailer rules from `/commit` (last paragraph, no blank lines).

## 5. Report

One paragraph: the decision, what changed in PLAN.md, the ADR path.
