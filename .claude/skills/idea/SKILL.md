---
name: idea
description: Registra uma nova ideia de projeto para o Hack Brasil 2026 em ideas/<slug>.md a partir do template, preenchendo o que der com a conversa, e já roda o judge nela. Use quando alguém disser "tive uma ideia", "anota essa ideia", "e se a gente fizesse...".
argument-hint: "<a ideia em uma ou duas frases>"
---

# Nova ideia

Ideia: $ARGUMENTS

1. Escolha um slug curto (kebab-case, 1 a 3 palavras). Se `ideas/<slug>.md` já existir, pergunte se é para atualizar a existente.
2. Copie `ideas/TEMPLATE.md` para `ideas/<slug>.md` e preencha **só o que o usuário disse ou o que dá para deduzir com segurança**. Deixe o resto como está no template: campo vazio é sinal honesto para o judge. Sugestões suas vão marcadas como `_(sugestão)_`, para o time aceitar ou não.
3. Sempre preencha *Trilha e enquadramento*, nem que seja como sugestão: um projeto fora da trilha pode ficar inelegível (X10 em `HACKATHON.md`).
4. Rode `/judge <slug>`.
5. Responda com a nota, o alerta principal e **até 3 perguntas** cujas respostas mais subiriam a nota.
