# rodar-web: decisões

Decisões que valem só para este repositório. Uma linha por decisão, a mais nova no topo. Decisão que muda o plano (fases, critérios, escopo) vai por `/adr` em [`docs/adr/`](../../docs/adr/), e aqui fica só o link.

| Data | Decisão | Por quê | Fonte |
|---|---|---|---|
| 2026-11-27 | Único hospedeiro de deploy do rodar-web é a Vercel; GitHub Pages removido (workflow, config do repositório e comentário do `vite.config.ts`) | `vite.config.ts` (`base: '/'`, para a Vercel) e `.github/workflows/demo-pages.yml` (`--base /rodar-web/`) divergiam, com risco de deploy duplicado; o GitHub Pages já respondia 404 nas publicações de 27/11 | commit [`69cdfab`](https://github.com/rodarglobal/rodar-web/commit/69cdfab) na `develop`, merge [`b62e17c`](https://github.com/rodarglobal/rodar-web/commit/b62e17c) na `main` |
| 2026-11-25 | Vender a integração (setup) com TMS, rastreador e financeiro; o painel é a vitrine | Ver o ADR | [ADR-0001](../../docs/adr/0001-integracao-setup-e-tres-dores.md) |
