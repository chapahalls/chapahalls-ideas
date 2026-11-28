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
| 2026-11-27 16:51 | rodar-backend@f45b6cc | 22/40 | [judge-20261127-1650.md](judge-20261127-1650.md) |
| 2026-11-27 17:01 | rodar-web@e6b1683 | 22/40 | [judge-20261127-1659.md](judge-20261127-1659.md) |
| 2026-11-27 20:18 | rodar-backend@2b0eb7e | 23/40 | [judge-20261127-2016.md](judge-20261127-2016.md) |
| 2026-11-27 20:50 | rodar-backend@e3a8879 | 23/40 | [judge-20261127-2048.md](judge-20261127-2048.md) |
| 2026-11-27 21:32 | rodar-backend@7c60ad2 | 23/40 | [judge-20261127-2130.md](judge-20261127-2130.md) |
| 2026-11-27 21:36 | rodar-web@2368b3c | 23/40 | [judge-20261127-2134.md](judge-20261127-2134.md) |
| 2026-11-27 21:45 | rodar-web@830d6a4 | 23/40 | [judge-20261127-2143.md](judge-20261127-2143.md) |
| 2026-11-27 21:56 | rodar-backend@25dcce7 | 23/40 | [judge-20261127-2154.md](judge-20261127-2154.md) |
| 2026-11-27 22:36 | rodar-backend@bdc14e5 | 23/40 | [judge-20261127-2234.md](judge-20261127-2234.md) |
| 2026-11-27 23:07 | rodar-backend@f630043 | 23/40 | [judge-20261127-2305.md](judge-20261127-2305.md) |
| 2026-11-27 23:37 | rodar-backend@c9c040c | 23/40 | [judge-20261127-2336.md](judge-20261127-2336.md) |
| 2026-11-27 23:58 | rodar-backend@eec39ea | 23/40 | [judge-20261127-2356.md](judge-20261127-2356.md) |
| 2026-11-28 00:21 | rodar-backend@8b3f0d4 | 23/40 | [judge-20261128-0020.md](judge-20261128-0020.md) |
| 2026-11-28 00:59 | rodar-backend@4d01768 | 23/40 | [judge-20261128-0057.md](judge-20261128-0057.md) |
| 2026-11-28 01:12 | rodar-mobile@91ad99e | 23/40 | [judge-20261128-0110.md](judge-20261128-0110.md) |
| 2026-11-28 08:45 | rodar-backend@62076bd | 23/40 | [judge-20261128-0843.md](judge-20261128-0843.md) |
| 2026-11-28 08:58 | rodar-backend@d8af042 | 23/40 | [judge-20261128-0856.md](judge-20261128-0856.md) |
| 2026-11-28 09:01 | rodar-backend@8b303db | 23/40 | [judge-20261128-0900.md](judge-20261128-0900.md) |
| 2026-11-28 09:21 | rodar-backend@a51e4e3 | 23/40 | [judge-20261128-0919.md](judge-20261128-0919.md) |
| 2026-11-28 09:33 | rodar-backend@09e6a6b | 23/40 | [judge-20261128-0931.md](judge-20261128-0931.md) |
