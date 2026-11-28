# Judge: rodar-backend, 2026-11-28 00:17

Gatilho: push na main de rodar-backend 8b3f0d4 por HenryFacens. Commit avaliado: 8b3f0d4.

**Nota do repo: 17 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 2d23h para 30/11 23h59 · Variação: 0 (era 17/20 em `eec39ea`)

Desde a rodada anterior (`eec39ea`) entrou 1 commit, `8b3f0d4` (7 arquivos, +190/−4). Ele ataca o item 1 do *Maior retorno* da rodada passada, as duas etapas da voz que mais quebravam na demo pública:
- **4c (resposta do recebedor):** `ferramentas._resposta_recebedor` agora normaliza `doca` (`"doca 4"`→`"4"`, via `contingencia.normalizar_doca`). Quando o LLM manda `doca` ou `previsao` como `null`, os campos são extraídos da transcrição da ligação (`ligacoes.transcricao_recebedor`) com a mesma regex da contingência (`contingencia.extrair_doca_previsao`).
- **5e2 (ocorrência detalhada):** se o LLM não chamou nenhuma ferramenta no turno, o upstream respondeu e há uma ocorrência aberta com `faltantes`, `conversa._anexar_detalhe_sem_ferramenta` anexa a fala do motorista como detalhe. A regra de `contingencia.resposta_livre_ocorrencia` descarta perguntas e falas que mencionam outro tipo de ocorrência.
- O prompt não mudou, como foi recomendado.

**Conferido nesta rodada:**
- Li o diff inteiro de `eec39ea..8b3f0d4`.
- Rodei a suíte num Postgres 16 local: **413 passed** (26,6 s) e `ruff check .` limpo. Bate com a mensagem do commit (+16 testes: 6 de API com FakeLLM que reproduzem os erros vistos em produção e 10 unitários).
- `curl` às 00h19 (-03) em `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, **`sha: "eec39ea"`**. A correção **ainda não está no ar**: o push foi às 00h16 e o deploy da CI não tinha terminado. `ligar_recebedor_na_aproximacao: true` e `recebedor_modo: rtc` continuam, como declarado.
- **Não há validação nova contra a AWS.** `evidence/validacao.md` ainda mostra 4c em 1/4 e 5e2 em 0/4 sobre `c9c040c`.

## Alertas

- **RISCO (H1): a correção da 4c e da 5e2 está provada só com LLM fake, não no ambiente público.** O `/health` ainda mostra `eec39ea`, e a última medição publicada (4c 1/4, 5e2 0/4) continua sendo o que um jurado lê no README e em `evidence/validacao.md`. Enquanto não houver uma nova rodada de `validar_fluxos.py` contra o CloudFront com o `sha` `8b3f0d4`, a melhoria é promessa e não prova, e H1 não sobe.
- **RISCO novo (H1, falso positivo na 5e2):** `resposta_livre_ocorrencia` → `ocorrencias.extrair_varios` grava a fala inteira no **primeiro campo que falta**, sem checar se ela responde a pergunta. Com uma ocorrência de fila aberta, um "beleza, obrigado" ou "tô chegando" respondido pelo LLM só em texto vira `quantos = "beleza, obrigado"` na Task do CCO. Os dois filtros (é pergunta, menciona outro tipo) não pegam isso, e nenhum teste cobre esse caso. Num jurado que lê a Task no painel, isso é tão ruim quanto o "não sei" de antes.
- **Ressalva menor (4c):** `transcricao_recebedor` junta **todas** as falas do recebedor e `extrair_doca_previsao` pega a primeira `doca N`. Se o recebedor corrigir ("doca 4... não, doca 6"), fica a 4. É raro na demo, mas a regex deveria preferir a última ocorrência.
- **RISCO (S5), sem mudança:** o README não tem o link do vídeo. A linha 44 continua `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **Sem mudança (H2, leitura do júri): o README e o código citam o júri simulado.** Estão em README linha 93 ("alerta do júri, score.md 2026-11-27"), `main.py:90`, `main.py:95`, `ocorrencias.py:128`, `rotas.py:28` e `settings.py:86`. O commit novo não piorou isso: os comentários dele falam do domínio, que é o tom certo.
- **Inconsistência no README, agora maior:** a linha 40 diz "389 no backend" e "625 testes", mas a suíte tem **413**.
- **O smoke ainda tem efeito colateral, sem mudança:** `GET /rotas/1/ocoren` incrementa `Empresa.ultima_sequencia_ocoren` em produção a cada deploy.
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md` ainda descreve `7fe3475`):
  - Ele diz que a infra está numa "branch sem PR". Ela está na main, com HTTPS via CloudFront.
  - Ele cita 377 testes. São 413.
  - Ele diz que "o caminho de voz atual não tem validação publicada". Tem.
  - `decisoes.md` não registra a decisão "corrigir na borda das ferramentas, não no prompt", que é de repo e merece uma linha.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | Mantém. A demo pública segue no ar (`/health` 200, banco ok, flag de aproximação ligada), e a validação de 4 rodadas contra o CloudFront continua valendo para o resto do fluxo. O commit corrige as duas etapas que quebravam, mas **só há prova com LLM fake**. A versão no ar ainda é `eec39ea`, e a evidência publicada ainda mostra 4c 1/4 e 5e2 0/4. Para chegar a 9 ("nada quebra na mão do júri"), falta medir de novo no ambiente público e fechar o falso positivo da 5e2. |
| H2 | Implementação técnica | 9 | Mantém. É o tipo certo de correção para um sistema com LLM: guarda determinística na borda da ferramenta, reaproveitando a regra da contingência em vez de duplicar regex, e testes que reproduzem exatamente o erro observado em produção, incluindo o caso negativo "outra ferramenta foi chamada". Os comentários novos explicam o domínio. Continuam impedindo o 10: a heurística da 5e2 anexa qualquer fala ao 1º faltante, sem teste para "ok/obrigado"; os comentários que citam o "júri"; o GET com efeito colateral no smoke; a imagem `:latest`; e nenhum conjunto de avaliação versionado na CI. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **17/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork. A infra precisa continuar no ar até 15/12 |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx` e são fictícios. Os e-mails são `.test`. O commit novo não adiciona nenhum dado pessoal |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa. `recebedor_modo: rtc` e `twilio_configurado: false` estão declarados |
| Link da demo | README | OK | Painel publicado. A API no CloudFront responde 200 com banco |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS.
- Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE), X7/X8 (main em dia) e o prazo (faltam 2d23h). Em S4/S5, deram OK as instruções de execução, as dependências, a demo HTTPS e a declaração do que é simulado e de terceiros. Em X6, não há `.env` nem credenciais.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: telefones versionados em `.env.example:42`, `settings.py:36`, `seed.py:36` e `test_auth.py:12`. São fictícios, então não é falha.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S5 e S6.

## Maior retorno

1. **Fechar o falso positivo da 5e2 e medir de novo contra a AWS.**
   - Em `resposta_livre_ocorrencia`, só anexe a fala se ela responder o campo (o `_DETECTA` do 1º faltante casa, ou há número/hora/sim/não) e descarte confirmações curtas ("ok", "beleza", "obrigado", "tô chegando"). Faça um teste para cada uma.
   - Na 4c, prefira a **última** `doca N` da transcrição.
   - Quando o `/health` mostrar `8b3f0d4` ou o commit seguinte, rode `validar_fluxos.py` contra o CloudFront em 4 rodadas e publique em `evidence/validacao.md`, atualizando a linha 36 do README.
   - Se 4c e 5e2 passarem 4/4, o fluxo inteiro fica estável no ar. **H1 8→9 = +1.**
2. **Tirar as menções ao júri simulado do README (linha 93) e dos comentários** (`main.py:90/95`, `ocorrencias.py:128`, `rotas.py:28`, `settings.py:86`). Troque pela razão de domínio, como o commit novo já faz. No mesmo commit, corrija a linha 40 (389→413, e o total de 625). **Protege o H2 9.**
3. **Link do vídeo no README (linha 44), smoke sem efeito colateral e imagem fixada por `:<sha>`.**
   - O vídeo tira o RISCO S5, que é entregável obrigatório e pesa no H4 do projeto.
   - O smoke sem efeito colateral e a imagem por `sha` removem os últimos defeitos de infra em H2.
   - Depois, rode `/registrar rodar-backend`.
   - **S5 RISCO→OK; H2 9→10 = +1.**

## Observações

- Faltam 2d23h, então ainda dá para fazer commit até 30/11 23h59. De 01/12 a 12/12 não pode haver commit, e a imagem que estiver no ar em 30/11 é a que o júri vê.
- Este é o primeiro commit que mexe no caminho da voz depois da validação publicada. Até alguém rodar `validar_fluxos.py` de novo contra o ambiente público, não dá para garantir que ele não piorou as etapas que já passavam 4/4. Nenhuma das 397 asserções antigas quebrou, mas elas usam LLM fake.
- O ideal é fazer o item 1 hoje (28/11) e o 3 até o dia 29. Deixe o dia 30 só para o link do vídeo e a conferência do `/health`: uma regressão de última hora na voz custa mais H1 do que qualquer ganho de H2.
- A frase "corrigir na borda das ferramentas, com a mesma regra da contingência, sem mexer no prompt" é um bom argumento técnico para o júri de dados e ML. Ela mostra que o time separa o que o modelo decide do que o sistema garante. Vale citar no pitch junto com a tabela de rodadas.
