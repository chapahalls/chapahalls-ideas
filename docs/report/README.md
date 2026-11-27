# Relatórios do judge

Gerados pelo workflow [`judge.yml`](../../.github/workflows/judge.yml) a cada push na `main` de
[rodar-backend](https://github.com/rodarglobal/rodar-backend), [rodar-web](https://github.com/rodarglobal/rodar-web),
[rodar-mobile](https://github.com/rodarglobal/rodar-mobile) e [rodar-keycloak](https://github.com/rodarglobal/rodar-keycloak).
Cada execução roda `/judge projeto` (skill e agente `judge`, rubrica de [`HACKATHON.md`](../../HACKATHON.md): H1-H4, 0-10 cada, 0-40)
sobre o estado atual dos quatro repositórios, não só do que disparou.

- **Último relatório:** [`LATEST.md`](LATEST.md)
- **Rodar na mão:** aba *Actions* → *Judge* → *Run workflow*.
- A nota é uma estimativa de LLM: varia ±2 entre execuções sobre o mesmo código. Olhe a tendência, não um ponto.

## Histórico

| Quando (BRT) | Gatilho | Nota | Relatório |
|---|---|---|---|
