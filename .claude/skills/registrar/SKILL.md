---
name: registrar
description: Registra no rodar-ideas o que mudou num repositório de código (rodar-backend, rodar-web, rodar-mobile) para o contexto nunca se perder. Atualiza repos/<repo>/STATUS.md (tem / falta) e repos/<repo>/decisoes.md. Use SEMPRE depois de entregar, cortar ou decidir algo num repo de código, antes de encerrar a sessão, e quando perguntarem "o que já tem / o que falta no <repo>?". Não pontua: a nota é do /judge.
argument-hint: "<repo> [o que mudou]"
---

# Registrar

Alvo: $ARGUMENTS

## 1. Achar os dois lados

- O repo de código: `rodar-backend`, `rodar-web` ou `rodar-mobile` (aceite `backend`, `web`, `mobile`). Sem argumento, use o repo onde a sessão está.
- O `rodar-ideas`: o diretório atual, ou `../rodar-ideas`. Se não existir, clone `https://github.com/rodarglobal/rodar-ideas` ao lado.

## 2. Ver o que mudou

No repo de código: `git log --oneline <commit verificado no STATUS.md>..HEAD` (o commit está na segunda linha do `STATUS.md`). Leia só o que esses commits mudaram.

## 3. Atualizar `repos/<repo>/STATUS.md`

- Troque o estado de cada item afetado (**Bloqueia**, **Promessa**, **Parcial**, **Contradição**, **Ok**) com a evidência: arquivo, teste, URL.
- Item novo que falta: entra na tabela da seção certa e, se ameaça a entrega, no *Resumo*.
- Atualize a data e o commit verificado na segunda linha.
- Só escreva o que você conferiu no código ou rodou. O que não conferiu fica marcado como "não reconferido".

## 4. Atualizar `repos/<repo>/decisoes.md`

Uma linha por decisão nova, a mais nova no topo: data, decisão, por quê, fonte (commit, PR ou ADR). Se a decisão muda fases, critérios ou escopo do `PLAN.md`, pare e use `/adr`; aqui fica só o link do ADR.

## 5. Não tocar

`repos/*/score.md` e o `STATUS.md` da raiz são do judge. Não pontue aqui.

## 6. Commit

Pelo `/commit` no `rodar-ideas`: `docs(<repo>): ...`, sem trailers. Ao chegar na `main`, isso não dispara o judge; o judge roda no próximo push na `main` do repo de código.

Responda em até 5 linhas: o que mudou de estado e o que ainda bloqueia.
