# Relatórios do judge

Gerados pelo workflow [`judge.yml`](../../.github/workflows/judge.yml) a cada push na `main` de
[rodar-backend](https://github.com/rodarglobal/rodar-backend), [rodar-web](https://github.com/rodarglobal/rodar-web),
[rodar-mobile](https://github.com/rodarglobal/rodar-mobile) e [rodar-keycloak](https://github.com/rodarglobal/rodar-keycloak).
Cada execução roda primeiro `/judge <repo>` no repo que disparou (nota em [`repos/<repo>/score.md`](../../repos/README.md)) e depois `/judge projeto` (skill e agente `judge`, rubrica de [`HACKATHON.md`](../../HACKATHON.md): H1-H4, 0-10 cada, 0-40)
sobre o estado atual dos quatro repositórios, não só do que disparou.

- **Último relatório:** [`LATEST.md`](LATEST.md) · resumo por repo: [`STATUS.md`](../../STATUS.md)
- **Rodar na mão:** aba *Actions* → *Judge* → *Run workflow*.
- A nota é uma estimativa de LLM: varia ±2 entre execuções sobre o mesmo código. Olhe a tendência, não um ponto.

## Histórico

| Quando (BRT) | Gatilho | Nota | Relatório |
|---|---|---|---|
| 2026-11-27 15:22 | rodar-web@97886f0 | 22/40 | [judge-20261127-1517.md](judge-20261127-1517.md) |
| 2026-11-27 15:27 | rodar-backend@f4a1bbd | 22/40 | [judge-20261127-1526.md](judge-20261127-1526.md) |
| 2026-11-27 15:31 | rodar-mobile@9d7cc33 | 22/40 | [judge-20261127-1530.md](judge-20261127-1530.md) |
| 2026-11-27 15:43 | rodar-web@b62e17c | 22/40 | [judge-20261127-1541.md](judge-20261127-1541.md) |
| 2026-11-27 16:04 | rodar-backend@7fe3475 | 22/40 | [judge-20261127-1602.md](judge-20261127-1602.md) |
