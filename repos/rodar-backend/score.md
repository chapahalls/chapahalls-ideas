# Judge: rodar-backend, 2026-11-27 23:55

Gatilho: push na main de rodar-backend eec39ea por HenryFacens. Commit avaliado: eec39ea.

**Nota do repo: 17 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d0h para 30/11 23h59 · Variação: +1 (era 16/20 em `c9c040c`)

Desde a rodada anterior (`c9c040c`) entrou 1 commit, `eec39ea`, que só muda documentação: `README.md` (1 linha) e `evidence/validacao.md` (+108 linhas). Ele atende o item 1 do *Maior retorno* da rodada passada:
- É a **primeira validação publicada contra o ambiente público** (`https://d3fy4m7zwukr3x.cloudfront.net`), não contra `localhost`. Foi feita sobre o `sha` `c9c040c`, com LLM e LiveKit reais e 4 rodadas na mesma sessão.
- **3d (atraso na estrada) passou 4 de 4** depois da regra determinística `corrigir_tipo_por_estado`.
- **4c falhou em 3 de 4 rodadas, 5e2 em 4 de 4 e 5e em 2 de 4.** As causas estão diagnosticadas com evidência do banco de produção: na 4c, os campos de `registrar_resposta_recebedor` saem `None` ou com o prefixo `"doca 4"`; na 5e2, `detalhar_ocorrencia` é chamada tarde e com texto genérico.

**Conferido nesta rodada:**
- `curl` às 23h55 (-03) em `https://d3fy4m7zwukr3x.cloudfront.net/health`: `ok: true`, `banco_ok: true`, **`sha: "c9c040c"`** e **`ligar_recebedor_na_aproximacao: true`**. Fecha o RISCO de H1 da rodada passada: a demo pública liga mesmo para o recebedor na aproximação. Continuam `twilio_configurado: false` e `recebedor_modo: rtc`, o que está declarado.
- `infra/envs/dev/ecs.tf:28` (`"true"`), README linha 93 e tabela da linha 460 (`true`) concordam.
- Testes: o commit não muda código, então não rodei a suíte de novo. Vale o resultado da rodada anterior: 397 passed.
- O `/health` mostra `c9c040c`, não `eec39ea`. Isso é esperado, porque `eec39ea` só mexe em docs. Se a CI publicar `eec39ea`, o `sha` muda sem mudar o comportamento.

## Alertas

- **RISCO (H1): a demo pública tem 2 etapas que quebram na maior parte das execuções.** São elas a 4c (a resposta do recebedor não vira doca e previsão estruturadas) e a 5e2 (o aprofundamento da fila não vira ocorrência detalhada). A 5e, que registra a ocorrência de fila, também falhou em 2 de 4 rodadas. O júri vê o resultado disso no painel: uma Task sem doca ou uma ocorrência com "não sei". Agora o problema está medido e documentado, o que é bom, mas continua aberto.
- **RISCO (S5), sem mudança:** o README não tem o link do vídeo. A linha 44 continua `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **Novo (H2, leitura do júri): o README e o código citam o júri simulado.** O README (linha 93) diz "alerta do júri, score.md 2026-11-27". Há o mesmo tipo de comentário em `main.py:90`, `main.py:95`, `ocorrencias.py:128`, `rotas.py:28` e `settings.py:86`, e `evidence/validacao.md` fala em "risco do júri de hoje". Um jurado real que ler isso vai concluir que o código foi escrito para a banca. Troque pela razão de domínio antes de 30/11.
- **Inconsistência no README:** a linha 40 diz "389 no backend" e "625 testes", mas a suíte tem 397.
- **O smoke ainda tem efeito colateral, sem mudança:** a cada deploy, `GET /rotas/1/ocoren` incrementa `Empresa.ultima_sequencia_ocoren` em produção.
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md` ainda é sobre `7fe3475`, 14 commits atrás):
  - Ele diz que a infra está numa "branch sem PR". Ela está na main, com HTTPS via CloudFront e deploy pela CI.
  - Ele cita 377 testes. São 397.
  - Ele diz que a voz não tem validação publicada. Tem, contra a AWS e com 4 rodadas.
  - A linha do OpenTofu em `decisoes.md` ("não chegou ao main") está superada.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | Sobe de 7. Agora há **prova** de que o fluxo roda no ar: o `/health` público mostra `c9c040c` com `ligar_recebedor_na_aproximacao: true`, e a validação de 34 etapas foi feita contra o CloudFront, com LLM e LiveKit reais, em 4 execuções. Deu 31 ou 32/34 em todas, com a ligação ao recebedor, a estadia, a escalada ao CCO e o OCOREN estáveis. A falha que mais pesava (3d) passou 4/4. Fica longe do 9 porque o critério é "nada quebra na mão do júri", e a 4c e a 5e2 quebram na maioria das execuções no próprio ambiente público. A telefonia real segue desligada, o que está declarado. |
| H2 | Implementação técnica | 9 | Mantém, porque não houve mudança de código. A medição em várias rodadas com causa confirmada no banco é o tipo de rigor que um júri de dados e ML valoriza. Continuam impedindo o 10: o GET com efeito colateral no smoke, a imagem `:latest` mutável, a extração de argumentos das ferramentas sem validação determinística (normalizar `"doca 4"`→`"4"` é trivial e não foi feito) e nenhum conjunto de avaliação versionado na CI. Os comentários que citam o "júri" também pesam contra. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **17/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork. A disponibilidade da infra até 15/12 está assumida por escrito |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx` e são fictícios. Os e-mails são `.test` e o seed está declarado como fictício. A validação nova traz só IDs e um CNPJ da NF-e de demo |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. O ID da conta AWS aparece em `decisoes.md`, mas não é segredo |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa. `recebedor_modo: rtc` e `twilio_configurado: false` estão declarados |
| Link da demo | README | OK | Painel na Vercel. A API no CloudFront responde 200 com banco e a flag ligada |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS. Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE), X7/X8 (main em dia) e prazo (3d0h). Em S4/S5, deram OK as instruções, as dependências, o link HTTPS da demo e a declaração do que é simulado e de terceiros. Em X6, sem `.env` e sem credenciais.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: há telefones versionados em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. São fictícios, então não é falha.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S5 e S6.

## Maior retorno

1. **Tornar a 4c e a 5e2 determinísticas na borda das ferramentas, sem mexer no prompt.**
   - Na 4c, normalizar `doca` (tirar o prefixo "doca", ficar só com o número) e, quando o LLM mandar `None`, extrair doca e previsão da própria transcrição da ligação com uma regex simples.
   - Na 5e2, quando houver uma ocorrência aberta com aprofundamento pendente e a fala seguinte do motorista não for de outra ferramenta, anexar essa fala como detalhe da ocorrência, sem esperar o LLM chamar `detalhar_ocorrencia`.
   - Fazer um teste com LLM fake que erra em cada caso e rodar `validar_fluxos.py` de novo contra a AWS.
   - É o que separa "falhas documentadas" de "nada quebra na mão do júri". **H1 8→9 = +1.**
2. **Tirar as menções ao júri simulado do README (linha 93), dos comentários (`main.py`, `ocorrencias.py`, `rotas.py`, `settings.py`) e de `evidence/validacao.md`.** Escreva a razão de domínio ("a demo pública precisa mostrar se a ligação na aproximação está ativa"). No mesmo commit, corrigir a contagem de testes na linha 40 (389→397). Um jurado real que ler "score.md" no código desconta qualidade. **Protege o H2 9.**
3. **Link do vídeo no README (linha 44), smoke sem efeito colateral (trocar o `GET /ocoren` por uma leitura pura ou usar uma rota de teste) e imagem fixada por `:<sha>`.**
   - Tira o RISCO S5, que pesa no H4 do projeto e é entregável obrigatório.
   - Remove os dois últimos defeitos de infra em H2.
   - Depois, `/registrar rodar-backend`.
   - **S5 RISCO→OK; H2 9→10 = +1.**

## Observações

- Faltam 3 dias, então commits ainda são permitidos até 30/11 23h59. De 01/12 a 12/12 não pode haver commit, e a imagem que estiver no ar em 30/11 é a que o júri vê. Não deixe o item 1 para o dia 30: uma regressão de última hora na voz custa mais H1 do que a 5e2 aberta.
- A seção "3d está determinístico agora; 4c e 5e2 são duas ambiguidades diferentes" é o melhor texto técnico do repo para um júri de dados e ML. Ela tem tabela de rodadas, causa confirmada no banco e a decisão explícita de não mexer no prompt sem medir. Use esse trecho no pitch como prova de rigor.
- A validação ainda é por texto, sem ASR, latência nem barge-in, e o próprio arquivo diz isso. O teste com pessoas falando é o que o vídeo precisa mostrar.
