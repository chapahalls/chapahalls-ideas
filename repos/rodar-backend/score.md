# Judge: rodar-backend, 2026-11-28 08:53

Gatilho: push na main de rodar-backend d8af042 por HenryFacens. Commit avaliado: d8af042.

**Nota do repo: 17 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 2d15h para 30/11 23h59 · Variação: 0 (era 17/20 em `62076bd`)

Desde a rodada anterior (`62076bd`) entrou 1 commit, **`d8af042` (chore, 15 arquivos, +212/−81)**. Ele executa o item 3 do *Maior retorno* anterior quase inteiro:
- **Higiene:** saíram as menções a "júri", "score.md" e "judge" dos 6 testes e de `docs/edi/ocoren-integracao.md`. Um `grep -i "score\.md|júri simulado|alerta do júri|judge"` em `backend/`, `infra/`, `docs/` e `scripts/` agora volta vazio. A seção "Para o júri" do README ficou, e é o certo: ela fala com o júri do Hack Brasil.
- **4c:** `extrair_doca_previsao` passou a usar `re.findall(...)[-1]`. Em "não é a doca 2, é a doca 4", a doca gravada é a 4. Há um teste novo para isso.
- **Smoke sem efeito colateral:** `GET /rotas/{id}/ocoren` ganhou `dry_run`, que devolve a próxima sequência sem gravar. O smoke do `ci.yml` usa `dry_run=true`, e um teste de API prova que a sequência fica em 0 com o `dry_run` e vai a 1 na chamada normal.
- **Deploy imutável por `:sha`:** a CI lê a task definition em uso, troca só o `image` para `:<sha>`, registra uma revision nova e aponta o serviço para ela. `ecs.tf` ganhou `lifecycle.ignore_changes = [task_definition]` para o `tofu apply` não desfazer isso, e a nova permissão IAM está justificada em `ci.tf`. Conferi que o `voice-agent` usa a mesma imagem da `api` com outro `command`, então trocar o `image` dos dois pela mesma tag está correto.

**Conferido nesta rodada:**
- Li o diff inteiro de `62076bd..d8af042`.
- Rodei `docker compose run --rm --build test pytest -q`: **425 passaram** em 40 s. Bate com o README (425 no backend, 661 no total).
- Às 08h55 (-03), `curl` em `https://d3fy4m7zwukr3x.cloudfront.net/health` devolveu `ok: true`, `banco_ok: true`, `sha: "62076bd"`, `llm_upstream: true` e `recebedor_modo: rtc`. A correção da 5e/5e2 (`62076bd`) **já está no ar**, mas `d8af042` ainda não: o deploy deste push deve estar rodando.
- `evidence/validacao.md` continua com a última medição em `8b3f0d4`. **Ainda não há rodada de `validar_fluxos.py` contra a AWS com a correção da fila.**

## Alertas

- **RISCO (H1): a correção da 5e/5e2 está no ar e continua sem medição.**
  - Com `sha: 62076bd` no `/health`, a medição já pode ser feita, e ela é o que separa o 8 do 9.
  - A última tabela publicada ainda mostra 5e em 1/4 e 5e2 em 0/4. Para quem lê `evidence/validacao.md`, a fila na doca continua quebrada.
- **RISCO novo (H1): o primeiro deploy pelo caminho `register-task-definition` acontece agora.**
  - O `jq` reconstrói a task definition à mão. Se algum campo vier `null` ou faltar (`runtimePlatform`, por exemplo, se um dia existir), o `register` falha. Nesse caso o serviço fica na revision anterior e nada cai.
  - O pior caso é a revision nova subir e não ficar saudável. Confira o job `deploy` deste push e o `/health` com `sha: d8af042` **antes** de qualquer outro commit.
  - Se falhar, o rollback documentado em `infra/README.md` já usa revision por sha.
- **Lacunas da correção da fila, sem mudança desde a rodada anterior:**
  - **Atraso já fechado:** `deve_abrir_fila_separada` só roda quando há ocorrência aberta. "Tem fila" depois de um atraso fechado cai no ramo `complemento` e vai para o atraso. Não há teste.
  - **Negação:** `_FILA_NA_DOCA = r"\bfila\b|..."` casa com "não tem fila". Com atraso aberto e o caminhão no destino, isso abre uma fila que não existe.
- **RISCO (S5), sem mudança:** o README ainda não tem o link do vídeo de até 3 min.
- **Detalhe menor:** com `dry_run`, `_proxima_sequencia` faz `SELECT ... FOR UPDATE` e retorna sem `commit`. O lock só sai quando a sessão fecha. Não causa erro, mas um `with_for_update` condicional seria mais limpo.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` ainda descreve `4d01768`.
  - Ele cita 413 testes. São 425.
  - O item 1 do resumo diz que o falso positivo "beleza, obrigado" e o reaproveitamento do atraso não estão resolvidos. Os dois entraram em `62076bd`.
  - Ele lista o smoke com efeito colateral no OCOREN como risco. Isso foi resolvido em `d8af042`.
  - `decisoes.md` não registra "fila depois da chegada é ocorrência nova", nem `dry_run` no OCOREN, nem o deploy por revision `:sha`.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | Mantém. A demo pública responde com banco e LLM, e as etapas 3d e 4c foram provadas 4/4 contra a AWS. A correção da fila na doca já está no ar (`62076bd`), mas **sem nenhuma rodada medida**, e a evidência publicada ainda mostra 5e e 5e2 falhando. O 9 exige `validar_fluxos.py` contra o CloudFront com 5e e 5e2 em pelo menos 3/4. |
| H2 | Implementação técnica | 9 | Mantém, agora com mais folga. O deploy passou a ser auditável por sha, com IAM justificado e drift do Terraform tratado. O smoke ficou sem efeito colateral e tem teste. A 4c pega a última doca, também com teste. A higiene está limpa. Rodei 425 testes e todos passaram. O 10 continua barrado por três coisas: as duas lacunas da correção da fila (atraso fechado e negação), sem teste; nenhum conjunto de avaliação do LLM rodando na CI; e o caminho de deploy novo ainda sem uma execução bem-sucedida comprovada. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo falta no README. |
| | **Total** | **17/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork. O compromisso de manter a infra no ar até 15/12 está escrito |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx` e são fictícios. O commit novo não traz nenhum dado pessoal |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. `terraform.tfvars.example` traz o ID da conta AWS no URI do ECR: não é segredo, mas dá para trocar por um placeholder |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa |
| Link da demo | README | OK | A API no CloudFront responde 200 com banco. O painel está na Vercel |
| Link do vídeo | README | RISCO | Ausente |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- **0 FALHAS e 2 RISCOS.**
- Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE) e X7/X8 (main em dia). Em S4/S5, deram OK as instruções, as dependências, a demo HTTPS e a declaração do que é simulado e de terceiros. Em X6, não há `.env` nem credenciais.
- RISCO S5: o README não tem o link do vídeo.
- RISCO X6: telefones em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi e são fictícios.

## Maior retorno

1. **Medir a fila na doca no ar, hoje.**
   - Primeiro, fechar as duas lacunas em um commit pequeno, cada uma com um teste:
     - pôr `deve_abrir_fila_separada` também no ramo `complemento`, para o atraso fechado;
     - ignorar "não tem fila" e "sem fila".
   - Esperar o `/health` mostrar o novo sha, rodar `validar_fluxos.py` contra o CloudFront pelo menos 4 vezes (8 é melhor) e publicar a tabela por etapa em `evidence/validacao.md`, atualizando a linha 38 do README.
   - Com 5e e 5e2 em pelo menos 3/4, a parte da voz que o júri vai testar na doca fica provada. **H1 8→9 = +1.**
2. **Link do vídeo de 3 min no README "Para o júri".**
   - Tira o único RISCO de entregável deste repo e é a base do H4 do projeto.
   - **S5 RISCO→OK.**
3. **Avaliação do LLM versionada e rodando na CI.**
   - Um conjunto pequeno de falas reais ("tem fila", "trânsito parado", "doca 2... não, doca 4", "beleza"), com o resultado esperado por ferramenta e campo.
   - Pode rodar num job agendado ou manual contra o LLM real, e publicar a taxa de acerto.
   - Para um júri de dados/ML, é a prova de que "o modelo decide, o sistema garante" é medido e não só afirmado.
   - **H2 9→10 = +1**, junto com as lacunas do item 1.

## Observações

- O time executou o item 3 da rodada anterior em 13 minutos, sem quebrar nenhum teste, e foi além do pedido com o deploy por revision `:sha`. É uma escolha de engenharia boa de mostrar, mas é **o último dia para mexer em infra**. A partir de 29/11, nada de pipeline nem Terraform.
- O deploy por sha deixa a prova de "o que o júri vê é este commit" mais forte. Vale citar no README "Para o júri" junto do `/health`.
- Em 30/11, só três coisas: o link do vídeo, conferir que o `/health` mostra o último `sha` e uma rodada final de `validar_fluxos.py`. Não mexa na voz no último dia.
- De 01/12 a 12/12 não pode haver commit (X8). A imagem no ar em 30/11 é a que o júri vê.
