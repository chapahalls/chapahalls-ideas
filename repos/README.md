# Um diretório por repositório de código

Tudo fica na `main`, numa pasta por repositório. Assim o judge do projeto lê o contexto inteiro num só checkout, e os skills existem em uma cópia só.

| Repositório | Status (tem / falta) | Decisões | Nota do repo |
|---|---|---|---|
| [rodar-backend](https://github.com/rodarglobal/rodar-backend) | [`STATUS.md`](rodar-backend/STATUS.md) | [`decisoes.md`](rodar-backend/decisoes.md) | [`score.md`](rodar-backend/score.md) |
| [rodar-web](https://github.com/rodarglobal/rodar-web) | [`STATUS.md`](rodar-web/STATUS.md) | [`decisoes.md`](rodar-web/decisoes.md) | [`score.md`](rodar-web/score.md) |
| [rodar-mobile](https://github.com/rodarglobal/rodar-mobile) | [`STATUS.md`](rodar-mobile/STATUS.md) | [`decisoes.md`](rodar-mobile/decisoes.md) | [`score.md`](rodar-mobile/score.md) |

O painel do projeto inteiro é o [`STATUS.md`](../STATUS.md) da raiz.

## Quem escreve o quê

| Arquivo | Quem escreve | Quando |
|---|---|---|
| `repos/<repo>/STATUS.md` | quem mudou o repo, via `/registrar` | depois de entregar ou cortar algo nesse repo |
| `repos/<repo>/decisoes.md` | `/registrar` (decisão local) ou `/adr` (decisão que muda o plano) | quando a decisão acontece |
| `repos/<repo>/score.md` | só o judge: `/judge <repo>` | na CI, a cada push na `main` do repo; ou na mão |
| `STATUS.md` (raiz) | só o judge: `/judge projeto` | na CI, logo depois do judge do repo |

## Fluxo da CI

```
push na main de rodar-<repo>
  └─ .github/workflows/judge.yml (no repo de código) ─ repository_dispatch "judge" ─►
     rodar-ideas/.github/workflows/judge.yml
       1. /judge rodar-<repo>   → repos/rodar-<repo>/score.md
       2. /judge projeto        → docs/report/judge-*.md + STATUS.md
       3. commit na main

push na main do rodar-ideas mudando repos/*/score.md (judge de repo rodado na mão)
  └─ mesmo workflow, só o passo 2
```

Decisões que mudam o plano continuam com numeração única em [`docs/adr/`](../docs/adr/). O `decisoes.md` de cada repo só aponta para elas.
