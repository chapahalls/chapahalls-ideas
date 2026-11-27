# RODAR: ideias e pesquisa

Repositório do time com a **pesquisa, as ideias e as decisões** do RODAR no **Hack Brasil 2026** (trilha Logística & automação, submissão até 30/11/2026 23h59). O código fica em [rodar-backend](https://github.com/rodarglobal/rodar-backend), [rodar-web](https://github.com/rodarglobal/rodar-web) e [rodar-mobile](https://github.com/rodarglobal/rodar-mobile). O repositório usa o hackathon kit (roadmap gerado do git, skills de commit, ADR, fases e judge).

| O quê | Onde |
|---|---|
| Regras, rubrica, eliminatórios, entregáveis | [`HACKATHON.md`](HACKATHON.md) |
| Ideias (uma por arquivo) + ranking | [`ideas/`](ideas/README.md) |
| Nova ideia | `/idea <descrição>` no Claude Code, ou copie `ideas/TEMPLATE.md` |
| **Status do projeto** (nota, o que tem, o que falta) | [`STATUS.md`](STATUS.md), gerado pelo judge |
| Status, decisões e nota de cada repo de código | [`repos/`](repos/README.md) · `/registrar <repo>` depois de mudar um repo |
| Pontuar ideias / checar regras | `/judge` (todas), `/judge <slug>`, `/judge rodar-backend` (só o repo), `/judge projeto` (pré-entrega) |
| Checagem mecânica das regras | `sh scripts/check-rules.sh` (procura os três repos de código ao lado deste) |
| Propósito e contexto do produto | [`RODAR-CONTEXT.md`](RODAR-CONTEXT.md) · [`ideas/rodar.md`](ideas/rodar.md) |
| Pesquisa do problema (demora em docas), com fontes | [`ideas/demora-em-docas/descoberta.md`](ideas/demora-em-docas/descoberta.md) |
| Decisões | [`docs/adr/`](docs/adr/) (ADR-0001: integração, dashboard e três dores) |
| Skill + docs MCP da Agora | já configurado em `.claude/settings.json`: ao abrir o Claude Code no repo, aceite instalar o plugin `agora`. Manual: `/plugin marketplace add AgoraIO/skills` e `/plugin install agora@agora-skills` |

Fluxo: a ideia escolhida é o [`rodar`](ideas/rodar.md) → `/judge projeto` checa os repositórios de código antes de 30/11 → decisões novas via `/adr`.

## Judge na CI

A `main` sempre tem a nota do projeto inteiro. A cada push na `main` de um repositório de código, o [`judge.yml`](.github/workflows/judge.yml) roda dois judges em sequência:

1. **`/judge <repo>`**: avalia só o repositório que mudou e grava em `repos/<repo>/score.md`.
2. **`/judge projeto`**: avalia os repositórios juntos, publica o relatório em [`docs/report/`](docs/report/README.md) e atualiza o [`STATUS.md`](STATUS.md).

Para rodar na mão: aba *Actions* → *Judge* → *Run workflow*. O fluxo completo está em [`repos/README.md`](repos/README.md).

---

# Hackathon kit

A repo template for building a project fast with Claude Code **and** coming out with the story of how you built it: phases, decisions, pivots and what got cut, generated from git history with no infra beyond GitHub.

> `/kickoff` rewrites this README for your project and keeps the *How it works*, *Working agreement* and *Commands* sections.

## How it works

```
/kickoff ──► PLAN.md (phases + acceptance criteria) + ADR 0001 + tag phase/0-kickoff
   │
   ├─ work ──► /commit  ──► commits with roadmap trailers (only product-level ones)
   ├─ change of plan ──► /adr ──► docs/adr/NNNN + PLAN.md + Decision/Pivot/Dropped trailers
   │
/phase ──► verifier agent proves the criteria (evidence/phase-N.md)
       ──► annotated tag phase/N-slug ──► ROADMAP.md regenerated ──► push
                                              │
GitHub Action on every push to main ──────────┴──► job summary + Pages site (optional)
```

The roadmap is built **only** from git: `phase/*` tags mark phase boundaries; commit trailers carry the story.

| Trailer | Meaning |
|---|---|
| `Product:` | what a user or judge can now do or see |
| `Decision:` | what we chose and why (points to an ADR when there is one) |
| `Pivot:` | what changed direction and why |
| `Dropped:` | what we cut and why |
| `Next:` | what comes right after |

Example:

```
feat(upload): accept phone photos of receipts

Most testers uploaded photos, not PDFs.

Product: receipts can be uploaded as photos
Decision: local OCR instead of a cloud API (offline demo, no keys)
Next: confidence threshold for blurry photos
```

## Setup

1. On GitHub: **Use this template** (or push this folder to a new repo, branch `main`).
2. Repo settings → **General → Pull Requests**: allow *merge commits* and/or *rebase merging*, **disable squash merging** (squash erases trailers).
3. Each teammate, after cloning:

   ```bash
   sh scripts/setup.sh
   ```

   This sets the commit template (`.gitmessage`) and a hint-only `commit-msg` hook, so teammates without Claude follow the same convention.
4. Optional, the Pages site: **Settings → Pages → Source: GitHub Actions**, then **Settings → Secrets and variables → Actions → Variables**: `ROADMAP_PAGES = true`. (Pages on private repos needs a paid GitHub plan; without it the roadmap still shows up in each run's job summary.)
5. Open Claude Code in the repo and run `/kickoff`.

Requirements: git, Node 18+ (only for `scripts/roadmap.mjs`, no dependencies).

## Working agreement

- One phase open at a time; acceptance criteria written before the work.
- Phases close only through `/phase` (it verifies first). Never tag `phase/*` by hand.
- No squash merges, no force-push on `main`.
- Trailers only on product-level commits. "fix typo" stays plain.
- One Claude session per person, each on their own branch or worktree.

## Commands

| What | How |
|---|---|
| See the roadmap now | `node scripts/roadmap.mjs` (markdown), `--format html > roadmap.html`, `--format status` |
| Where are we? | `/progress` |
| Record a decision / pivot | `/adr <what>` |
| Close the open phase | `/phase` |

## Layout

| Path | What |
|---|---|
| `CLAUDE.md` | Rules for every Claude session: orchestrator role, definition of done, conventions |
| `PLAN.md` | Source of truth: pitch, demo path, phases with acceptance criteria, parking lot |
| `ROADMAP.md` | Generated at every phase close. Don't edit |
| `docs/adr/` | Decision records (`TEMPLATE.md`) |
| `evidence/` | Verifier reports per phase |
| `.claude/skills/` | `kickoff`, `commit`, `adr`, `phase`, `progress` |
| `.claude/agents/verifier.md` | Read-only verifier |
| `scripts/roadmap.mjs` | Roadmap generator (md, html, status) |
| `scripts/hooks/commit-msg` | Hint-only hook |
| `.github/workflows/roadmap.yml` | Job summary + Pages on every push to `main` |
