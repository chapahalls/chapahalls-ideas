# Judge: rodar-backend, 2026-11-28 09:30

Gatilho: push na main de rodar-backend 09e6a6b por HenryFacens. Commit avaliado: 09e6a6b.

**Nota do repo: 18 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 2d14h para 30/11 23h59 · Variação: **0** (era 18/20 em `a51e4e3`)

Desde a rodada anterior (`a51e4e3`) entrou 1 commit, **`09e6a6b` (docs(evidence), 2 arquivos, +9/−3)**. Ele não toca em `backend/`, na CI nem na infra. Mexe só na linha "Ver sem instalar nada" do README e num parágrafo de `evidence/validacao.md`. Resolve dois dos alertas da rodada anterior, mas nenhum dos que travam o 10.

**Conferido nesta rodada:**
- Li o diff inteiro de `a51e4e3..09e6a6b`. Como não há mudança de código, não rodei os testes de novo. Continuam os 425 da rodada de `8b303db`.
- Às 09h30 (-03), o `/health` em `https://d3fy4m7zwukr3x.cloudfront.net/health` devolveu `ok: true`, `banco_ok: true`, `llm_upstream: true` e `auth_obrigatoria: true`, com **`sha: "a51e4e3"`**.
  - O deploy de `09e6a6b` provavelmente ainda estava rodando. Como os dois commits mexem só em documentação, o código no ar é o mesmo do HEAD.
- O painel `https://rodar-web-beta.vercel.app/login` responde 200.
- **O exagero do README foi corrigido.** A frase agora diz "3 de 4 rodadas em 34/34, 1 em 33/34". Também deixou de dizer que a 5e é determinista: diz que ela "ainda falha 1 de 4 vezes" e explica por quê. Agora o README bate com a evidência.
- **O `TypeError` em `GET /ligacoes` foi investigado.** Segundo `evidence/validacao.md`, os logs do CloudWatch mostram as 22 chamadas da janela com status `200` e nenhum `5xx`. Isso descarta a hipótese de a API ter falhado na mão do júri.
  - O próprio arquivo admite que o script não confere o status antes de ler o corpo. Essa fragilidade é da ferramenta de validação, não do produto.
  - Não vi os logs, só o que o arquivo relata. A afirmação é verificável e específica, então a aceito.
- Conferi `ocorrencias.py:137` (`_FILA_NA_DOCA = r"\bfila\b|..."`) e `tasks.py:283-291`. **As duas lacunas da fila continuam no código, sem teste.**
- README linha 44: o vídeo de 3 min continua como placeholder (`<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`).

## Alertas

- **RISCO (S5), sem mudança: o README ainda não tem o link do vídeo de até 3 min.** A linha 44 é um comentário HTML de placeholder. Este é o único entregável deste repo ainda em aberto.
- **As lacunas da correção da fila continuam sem mudança e sem teste:**
  - **Atraso já fechado:** depois de um atraso fechado, "tem fila" cai no ramo `complemento` (`aberta is None`, `tasks.py:283`) e não passa por `deve_abrir_fila_separada`.
  - **Negação:** `_FILA_NA_DOCA` casa com "não tem fila" e "sem fila". "Aqui não tem fila não" é uma fala comum de motorista, e o sistema abriria uma ocorrência de fila.
- **A 5e ainda falha 1 em 4 vezes** porque o LLM não chama nenhuma ferramenta na primeira fala. Agora isso está declarado com honestidade no README, mas continua sendo uma falha que o júri pode ver.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` ainda descreve `4d01768`.
  - Ele cita 413 testes. São 425.
  - Ele diz que a 5e está em 1/4 e a 5e2 em 0/4. A evidência atual dá 3/4 e 4/4.
  - Ele ainda lista como risco o smoke com efeito colateral no OCOREN, que foi resolvido em `d8af042` (`dry_run`).
  - Ele trata o falso positivo "beleza, obrigado" como item 1 em aberto.
  - `decisoes.md` não registra o deploy por revision `:sha`, o `dry_run` nem a investigação do `TypeError` nos logs.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 9 | Mantém. A demo pública responde com banco, LLM e auth ligada. A evidência mostra 4 rodadas contra o CloudFront: 3d e 4c em 4/4, 5e em 3/4, 5e2 em 4/4, e a tentativa descartada agora tem explicação (sem 5xx nos logs). Não chega a 10 por dois motivos: a 5e ainda falha 1 vez em 4, e não há prova de voz com pessoas reais (ASR, barge-in), que o próprio arquivo reconhece. |
| H2 | Implementação técnica | 9 | Mantém. Este commit não muda código. As barreiras para o 10 são as mesmas: as duas lacunas da fila sem teste e nenhuma avaliação do LLM versionada com taxa de acerto publicada. O script de validação que não confere o status HTTP é uma mancha pequena, agora declarada. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo falta no README. |
| | **Total** | **18/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork. O compromisso de manter a infra no ar até 15/12 está em `infra/README.md` |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx`. Os e-mails usam o domínio `.test`. São fictícios. O commit novo não acrescenta nenhum dado pessoal |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. O commit é só documentação |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" continua completa |
| Link da demo | README | OK | API no CloudFront: 200 com banco. Painel na Vercel: 200 |
| Link do vídeo | README | RISCO | Ausente (placeholder na linha 44) |

Saída resumida de `sh scripts/check-rules.sh ../rodar-backend`:
- **0 FALHAS e 2 RISCOS.**
- Deram OK:
  - X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE) e X7/X8 (main em dia).
  - Em S4/S5: instruções, dependências, link da demo HTTPS e a declaração do que é simulado e de terceiros.
  - Em X6: não há `.env` nem credenciais.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: telefones em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi e são fictícios.
- Ficam para checagem humana: X2, X9, X10, S1 e S3-S6.

## Maior retorno

1. **Link do vídeo de 3 min no README, na linha 44 ("Para o júri").**
   - Fecha o último RISCO de entregável deste repo e é a base do H4 do projeto.
   - **S5 RISCO→OK.** É o item mais barato e o único que pode custar a submissão.
2. **Fechar as duas lacunas da fila, com um teste para cada uma, num commit pequeno em 29/11.**
   - Fazer `deve_abrir_fila_separada` valer também no ramo `complemento`, para quando o atraso já foi fechado.
   - Ignorar "não tem fila" e "sem fila" em `_FILA_NA_DOCA`.
   - Depois, uma rodada de `validar_fluxos.py` contra o CloudFront para confirmar que nada regrediu.
   - Junto com o item 3: **H2 9→10 = +1**. Sozinho, protege o H1 9 contra "aqui não tem fila não".
3. **Avaliação do LLM versionada, com a taxa de acerto em `evidence/`.**
   - Um conjunto pequeno de falas com a ferramenta e o campo esperados para cada uma: "tem fila", "não tem fila", "trânsito parado", "doca 2... não, doca 4", "beleza, obrigado" e o caso da 5e (a ferramenta chamada já na primeira fala).
   - Rodar com o LLM real, por script ou job manual.
   - Para um júri de dados/ML, é a prova de que o modelo é medido, e não só testado com fake. **H2 9→10 = +1**, junto com o item 2.
   - De quebra, fazer o script conferir o status HTTP antes de ler o corpo da resposta.

## Observações

- **Este commit corrigiu exatamente o que foi pedido, e corrigiu bem.** O README ficou mais fraco que antes e agora bate com a evidência. A hipótese de 5xx foi conferida nos logs, não descartada no chute. Para um júri de dados/ML, essa consistência entre a frase e o dado vale mais que o 34/34.
- A nota não sobe porque não houve mudança de código. Os dois pontos que faltam para o 20/20 estão no H2 (itens 2 e 3 acima), não em documentação.
- Na próxima rodada, confira se o `/health` mostra `09e6a6b`. Às 09h30 ainda mostrava `a51e4e3`, o que é esperado com um deploy recém-disparado. Se continuar assim, o deploy contínuo travou.
- A partir de 29/11, nada de pipeline nem Terraform. O item 2 é a última mudança de código razoável. Se não couber em 29/11, deixe como está.
- Em 30/11, só três coisas: o link do vídeo, conferir que o `/health` mostra o último `sha` e uma rodada final de `validar_fluxos.py`. Não mexa na voz no último dia.
- De 01/12 a 12/12 não pode haver commit (X8). A imagem no ar em 30/11 é a que o júri vê.
