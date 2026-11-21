#!/usr/bin/env node
// Builds the project roadmap from git history alone:
//   - annotated tags `phase/<n>-<slug>` close phases (created by /phase)
//   - commit trailers Product:, Decision:, Pivot:, Dropped:, Next: carry the story
//
// Usage: node scripts/roadmap.mjs [--format md|html|status] [--repo <path>]
// No dependencies, Node 18+.

import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { basename, join, resolve } from 'node:path';

const argv = process.argv.slice(2);
const opt = (name, fallback) => {
  const i = argv.indexOf(`--${name}`);
  return i >= 0 && argv[i + 1] ? argv[i + 1] : fallback;
};
const FORMAT = opt('format', 'md');
const REPO = resolve(opt('repo', '.'));

const KEYS = ['Product', 'Decision', 'Pivot', 'Dropped', 'Next'];
const LABELS = {
  Product: 'Shipped',
  Decision: 'Decisions',
  Pivot: 'Pivots',
  Dropped: 'Dropped',
};
const US = '\x1f'; // field separator
const RS = '\x1e'; // record separator
const TS = '\x1c'; // trailer separator
// Bookkeeping commits made by /phase: not part of the story.
const SKIP = /^chore\(roadmap\)/;

function git(...args) {
  return execFileSync('git', ['-C', REPO, ...args], {
    encoding: 'utf8',
    maxBuffer: 64 * 1024 * 1024,
    stdio: ['ignore', 'pipe', 'pipe'],
  });
}

const records = out =>
  out
    .split(RS)
    .map(r => r.replace(/^\n/, ''))
    .filter(r => r.trim());

function readTags() {
  let out = '';
  try {
    out = git(
      'for-each-ref',
      'refs/tags/phase/',
      `--format=%(refname:short)${US}%(creatordate:iso-strict)${US}%(objecttype)${US}%(contents:subject)${US}%(contents:body)${RS}`,
    );
  } catch {
    return [];
  }
  return records(out)
    .map(r => {
      const [name, date, type, subject, body] = r.split(US);
      const m = name.match(/^phase\/(\d+)-?(.*)$/);
      return {
        name,
        date,
        annotated: type === 'tag',
        subject: (subject || '').trim(),
        body: (body || '').trim(),
        number: m ? Number(m[1]) : Number.MAX_SAFE_INTEGER,
        slug: m ? m[2] : name,
      };
    })
    .sort((a, b) => a.number - b.number || a.date.localeCompare(b.date));
}

function readCommits(range) {
  let out;
  try {
    out = git(
      'log',
      '--reverse',
      `--format=%h${US}%an${US}%aI${US}%P${US}%s${US}%(trailers:only,unfold,separator=%x1c)${RS}`,
      range,
      '--',
    );
  } catch {
    return [];
  }
  return records(out)
    .map(r => {
      const [sha, author, date, parents, subject, trailers] = r.split(US);
      const items = {};
      for (const t of (trailers || '').split(TS)) {
        const m = t.match(/^([A-Za-z-]+):\s*([\s\S]*)$/);
        if (!m) continue;
        const key = KEYS.find(k => k.toLowerCase() === m[1].toLowerCase());
        if (key && m[2].trim()) (items[key] ||= []).push(m[2].trim());
      }
      return {
        sha,
        author,
        date,
        merge: parents.trim().includes(' '),
        subject,
        items,
      };
    })
    .filter(c => !SKIP.test(c.subject));
}

function makePhase(meta, commits, start, end) {
  const items = Object.fromEntries(KEYS.map(k => [k, []]));
  const authors = new Map();
  for (const c of commits) {
    for (const k of KEYS) {
      for (const text of c.items[k] || []) {
        items[k].push({ text, sha: c.sha, author: c.author, date: c.date });
      }
    }
    if (!c.merge) authors.set(c.author, (authors.get(c.author) || 0) + 1);
  }
  const titleFromSlug = (meta.slug || '')
    .replace(/[-_]+/g, ' ')
    .replace(/^\w/, ch => ch.toUpperCase());
  return {
    ...meta,
    title:
      meta.title ||
      (meta.annotated && meta.subject ? meta.subject : titleFromSlug) ||
      meta.name,
    start: start || commits[0]?.date,
    end,
    commits: commits.filter(c => !c.merge).length,
    items,
    authors: [...authors].sort((a, b) => b[1] - a[1]),
  };
}

function projectName() {
  try {
    const first = readFileSync(join(REPO, 'PLAN.md'), 'utf8').match(
      /^#\s+(.+)$/m,
    );
    if (first && !first[1].includes('<')) return first[1].trim();
  } catch {
    /* no PLAN.md */
  }
  return basename(REPO);
}

function build() {
  const tags = readTags();
  const phases = [];
  let prev = null;
  for (const t of tags) {
    const range = prev
      ? `refs/tags/${prev.name}..refs/tags/${t.name}`
      : `refs/tags/${t.name}`;
    phases.push(makePhase(t, readCommits(range), prev?.date, t.date));
    prev = t;
  }
  let hasHead = true;
  try {
    git('rev-parse', '--verify', '-q', 'HEAD');
  } catch {
    hasHead = false;
  }
  const pending = hasHead
    ? readCommits(prev ? `refs/tags/${prev.name}..HEAD` : 'HEAD')
    : [];
  const current = makePhase(
    {
      name: null,
      title: 'In progress',
      number: prev ? (prev.number === Number.MAX_SAFE_INTEGER ? null : prev.number + 1) : null,
    },
    pending,
    prev?.date,
    new Date().toISOString(),
  );
  return { project: projectName(), phases, current, last: prev };
}

// ---------- formatting helpers ----------

const when = iso => (iso ? iso.slice(0, 16).replace('T', ' ') : '—');

function took(a, b) {
  if (!a || !b) return '—';
  const min = Math.max(0, Math.round((new Date(b) - new Date(a)) / 60000));
  const d = Math.floor(min / 1440);
  const h = Math.floor((min % 1440) / 60);
  const m = min % 60;
  if (d) return `${d}d ${h}h`;
  if (h) return `${h}h ${m}m`;
  return `${m}m`;
}

const cell = s => String(s).replace(/\|/g, '\\|').replace(/\n/g, ' ');
const esc = s =>
  String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
const stamp = () => new Date().toISOString().slice(0, 16).replace('T', ' ') + ' UTC';
const lastNext = p => p.items.Next.at(-1)?.text;

// ---------- markdown ----------

function renderMd(r) {
  const L = [];
  L.push(
    `# Roadmap: ${r.project}`,
    '',
    `> Generated from git history by \`scripts/roadmap.mjs\` on ${stamp()}. Do not edit by hand: phases come from \`phase/*\` tags, items from commit trailers.`,
    '',
  );
  const all = [...r.phases, ...(r.current.commits ? [r.current] : [])];
  if (!all.length) {
    L.push('_No history yet. Run `/kickoff` to start._');
    return L.join('\n') + '\n';
  }
  L.push(
    '| # | Phase | Closed | Took | Commits | Shipped | Decisions | Pivots |',
    '|---|---|---|---|---|---|---|---|',
  );
  for (const p of all) {
    L.push(
      `| ${p.number ?? ''} | ${cell(p.title)} | ${
        p.name ? when(p.end) : '_in progress_'
      } | ${took(p.start, p.end)} | ${p.commits} | ${p.items.Product.length} | ${
        p.items.Decision.length
      } | ${p.items.Pivot.length} |`,
    );
  }
  for (const p of all) {
    L.push('');
    L.push(
      p.name
        ? `## Phase ${p.number}: ${p.title}`
        : `## In progress${r.last ? ` (since \`${r.last.name}\`)` : ''}`,
    );
    L.push('');
    const meta = [
      p.name ? `\`${p.name}\`` : null,
      p.name ? `closed ${when(p.end)}` : `started ${when(p.start)}`,
      `took ${took(p.start, p.end)}`,
      `${p.commits} commit${p.commits === 1 ? '' : 's'}`,
    ].filter(Boolean);
    if (p.name && existsSync(join(REPO, 'evidence', `phase-${p.number}.md`))) {
      meta.push(`[verified](evidence/phase-${p.number}.md)`);
    }
    L.push(meta.join(' · '));
    if (p.body) L.push('', p.body);
    for (const k of Object.keys(LABELS)) {
      if (!p.items[k].length) continue;
      L.push('', `**${LABELS[k]}**`, '');
      for (const it of p.items[k]) {
        L.push(`- ${it.text} (\`${it.sha}\`, ${it.author})`);
      }
    }
    const next = lastNext(p);
    if (next) L.push('', `**Next${p.name ? ' at close' : ''}:** ${next}`);
    if (p.authors.length) {
      L.push(
        '',
        `**Who:** ${p.authors.map(([a, n]) => `${a} (${n})`).join(', ')}`,
      );
    }
  }
  return L.join('\n') + '\n';
}

// ---------- status (for /progress and agents) ----------

function renderStatus(r) {
  const L = [`Project: ${r.project}`];
  if (r.last) {
    const p = r.phases.at(-1);
    L.push(
      `Last closed phase: ${r.last.name} "${p.title}" at ${when(r.last.date)} (${took(
        r.last.date,
        new Date().toISOString(),
      )} ago)`,
    );
  } else {
    L.push('Last closed phase: none (run /kickoff)');
  }
  const c = r.current;
  L.push(
    `Open phase number (from git): ${c.number ?? '?'}`,
    `Commits since: ${c.commits}${
      c.authors.length ? ` by ${c.authors.map(([a, n]) => `${a} (${n})`).join(', ')}` : ''
    }`,
  );
  for (const k of Object.keys(LABELS)) {
    if (!c.items[k].length) continue;
    L.push(`${LABELS[k]} since:`);
    for (const it of c.items[k]) L.push(`  - ${it.text} (${it.sha}, ${it.author})`);
  }
  const next =
    lastNext(c) ?? [...r.phases].reverse().map(lastNext).find(Boolean);
  L.push(`Latest Next: ${next ?? '—'}`);
  return L.join('\n') + '\n';
}

// ---------- html (GitHub Pages) ----------

function renderHtml(r) {
  const all = [...r.phases, ...(r.current.commits ? [r.current] : [])];
  const totals = {
    phases: r.phases.length,
    commits: all.reduce((n, p) => n + p.commits, 0),
    decisions: all.reduce((n, p) => n + p.items.Decision.length, 0),
    pivots: all.reduce((n, p) => n + p.items.Pivot.length, 0),
    span: took(all[0]?.start, all.at(-1)?.end),
  };
  const list = (label, items) =>
    items.length
      ? `<h4>${label}</h4><ul>${items
          .map(
            it =>
              `<li>${esc(it.text)} <span class="meta">${esc(it.sha)} · ${esc(
                it.author,
              )}</span></li>`,
          )
          .join('')}</ul>`
      : '';
  const cards = all
    .map(p => {
      const next = lastNext(p);
      return `<section class="phase${p.name ? '' : ' open'}">
  <div class="dot"></div>
  <header>
    <span class="num">${p.name ? `Phase ${p.number}` : 'In progress'}</span>
    <h3>${esc(p.title)}</h3>
    <p class="meta">${p.name ? `closed ${esc(when(p.end))}` : `since ${esc(when(p.start))}`} · took ${esc(
        took(p.start, p.end),
      )} · ${p.commits} commits${
        p.authors.length ? ` · ${esc(p.authors.map(([a]) => a).join(', '))}` : ''
      }</p>
  </header>
  ${p.body ? `<p class="body">${esc(p.body).replace(/\n/g, '<br>')}</p>` : ''}
  ${Object.keys(LABELS)
    .map(k => list(LABELS[k], p.items[k]))
    .join('')}
  ${next ? `<p class="next"><b>Next${p.name ? ' at close' : ''}:</b> ${esc(next)}</p>` : ''}
</section>`;
    })
    .join('\n');
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Roadmap: ${esc(r.project)}</title>
<style>
:root{--bg:#fbfaf8;--fg:#1d1b18;--muted:#6b665e;--line:#e4e0d8;--card:#fff;--accent:#c2410c;--pivot:#7c3aed}
@media (prefers-color-scheme:dark){:root{--bg:#161412;--fg:#ece8e1;--muted:#9d968b;--line:#2f2b26;--card:#1f1c19;--accent:#f97316;--pivot:#a78bfa}}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);font:15px/1.55 system-ui,-apple-system,Segoe UI,Roboto,sans-serif}
main{max-width:820px;margin:0 auto;padding:40px 16px 80px}
h1{font-size:28px;margin:0 0 4px}
.sub{color:var(--muted);margin:0 0 24px;font-size:13px}
.stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(110px,1fr));gap:8px;margin-bottom:32px}
.stat{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:10px 12px}
.stat b{display:block;font-size:22px}
.stat span{color:var(--muted);font-size:12px}
.timeline{position:relative;padding-left:28px}
.timeline:before{content:"";position:absolute;left:8px;top:6px;bottom:6px;width:2px;background:var(--line)}
.phase{position:relative;background:var(--card);border:1px solid var(--line);border-radius:12px;padding:16px 18px;margin-bottom:16px}
.phase .dot{position:absolute;left:-26px;top:20px;width:14px;height:14px;border-radius:50%;background:var(--accent);border:3px solid var(--bg)}
.phase.open .dot{background:var(--bg);border-color:var(--accent)}
.num{color:var(--accent);font-size:12px;font-weight:700;letter-spacing:.06em;text-transform:uppercase}
h3{margin:2px 0 4px;font-size:19px}
h4{margin:14px 0 4px;font-size:13px;color:var(--muted);text-transform:uppercase;letter-spacing:.05em}
ul{margin:0;padding-left:18px}
li{margin:2px 0}
.meta{color:var(--muted);font-size:12px;margin:0}
.body{white-space:normal}
.next{margin:12px 0 0;padding-top:10px;border-top:1px dashed var(--line)}
</style>
</head>
<body>
<main>
<h1>${esc(r.project)}</h1>
<p class="sub">Roadmap generated from git history on ${esc(stamp())}</p>
<div class="stats">
<div class="stat"><b>${totals.phases}</b><span>phases closed</span></div>
<div class="stat"><b>${esc(totals.span)}</b><span>elapsed</span></div>
<div class="stat"><b>${totals.commits}</b><span>commits</span></div>
<div class="stat"><b>${totals.decisions}</b><span>decisions</span></div>
<div class="stat"><b>${totals.pivots}</b><span>pivots</span></div>
</div>
<div class="timeline">
${cards || '<p>No history yet.</p>'}
</div>
</main>
</body>
</html>
`;
}

const report = build();
const render = { md: renderMd, html: renderHtml, status: renderStatus }[FORMAT];
if (!render) {
  console.error(`Unknown --format ${FORMAT} (use md, html or status)`);
  process.exit(2);
}
process.stdout.write(render(report));
