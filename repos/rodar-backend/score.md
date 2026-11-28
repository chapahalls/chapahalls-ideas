# Judge: rodar-backend, 2026-11-28 08:59

Gatilho: push na main de rodar-backend 8b303db por HenryFacens. Commit avaliado: 8b303db.

**Nota do repo: 17 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 2d15h para 30/11 23h59 · Variação: 0 (era 17/20 em `d8af042`)

Desde a rodada anterior (`d8af042`) entrou 1 commit, **`8b303db` (fix(ci), 1 arquivo, +6/−4)**. Ele confirma o RISCO que a rodada anterior apontou: **o primeiro deploy pelo caminho `register-task-definition` falhou.** O `aws ecs register-task-definition --cli-input-json file:///dev/stdin` não leu o JSON vindo do pipe. A correção monta o JSON numa variável (`TD_JSON`) e passa o texto direto na flag. Segundo a mensagem do commit, o time registrou e desregistrou uma revision de teste contra a AWS real antes do push.

**Conferido nesta rodada:**
- Li o diff inteiro de `d8af042..8b303db`. Só o `ci.yml` mudou, sem nenhuma mudança em `backend/`. Não rodei os testes de novo: o código é o mesmo da rodada anterior (425 passando).
- Às 08h59 (-03), o `/health` em `https://d3fy4m7zwukr3x.cloudfront.net/health` devolveu `ok: true`, `banco_ok: true`, `llm_upstream: true` e **`sha: "62076bd"`**. Quando o deploy falhou, o serviço ficou na revision anterior e a demo não caiu. Isso prova que o desenho falha para o lado seguro. O que está no ar ainda não tem `d8af042` (o `dry_run` do OCOREN e a doca pela última fala).
- O `sha` do `/health` vem do `--build-arg GIT_SHA` da imagem, e não de uma variável da task definition. Trocar só o `image` atualiza o sha mostrado, então o smoke que compara os shas é válido.
- Não consegui ler o resultado do job `deploy` deste push, porque o `gh` não tem token na CI. **Precisa de humano.**
- `evidence/validacao.md` não mudou. **A correção da fila na doca (5e/5e2) continua sem medição contra a AWS.**

## Alertas

- **RISCO (H1): o deploy por `:sha` continua sem nenhuma execução bem-sucedida comprovada.**
  - A primeira tentativa (`d8af042`) falhou. Esta é a segunda, e o teste manual que a mensagem do commit cita não aparece na CI.
  - Antes de qualquer outro commit, confira o job `deploy` de `8b303db` e o `/health` com `sha: "8b303db"`.
  - Se falhar de novo, volte ao `force-new-deployment` de antes em vez de tentar uma terceira variação. Faltam 2 dias e meio, e a demo no ar vale mais que o deploy auditável.
- **RISCO (H1), sem mudança: a correção da 5e/5e2 está no ar desde `62076bd` e continua sem medição.**
  - A tabela publicada ainda mostra 5e em 1/4 e 5e2 em 0/4. Para quem lê a evidência, a fila na doca continua quebrada.
- **Lacunas da correção da fila, sem mudança:**
  - **Atraso já fechado:** "tem fila" depois de um atraso fechado cai no ramo `complemento`, sem `deve_abrir_fila_separada`. Não há teste.
  - **Negação:** `_FILA_NA_DOCA` casa com "não tem fila". Não há teste.
- **RISCO (S5), sem mudança:** o README ainda não tem o link do vídeo de até 3 min.
- **Infra mexida no último dia combinado:** a rodada anterior recomendou parar com pipeline e Terraform a partir de 29/11. Este commit ainda está dentro do prazo, mas ele mostra o custo: uma mudança de "higiene" de deploy gerou um deploy quebrado.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` ainda descreve `4d01768`.
  - Ele cita 413 testes. São 425.
  - Ele diz que o falso positivo "beleza, obrigado" está em aberto. Isso foi resolvido em `62076bd`.
  - Ele trata o smoke com efeito colateral no OCOREN como risco. Isso foi resolvido em `d8af042`.
  - `decisoes.md` não registra o deploy por revision `:sha`, nem a falha e a correção dele, nem o `dry_run`.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | Mantém. A demo pública responde com banco e LLM, e as etapas 3d e 4c foram provadas 4/4 contra a AWS. O deploy quebrado não derrubou nada: o `/health` seguiu `ok` em `62076bd`. Mas o que está no ar está dois commits atrás, e a fila na doca segue **sem rodada medida**. O 9 exige `validar_fluxos.py` contra o CloudFront com 5e e 5e2 em pelo menos 3/4, com o `/health` no sha atual. |
| H2 | Implementação técnica | 9 | Mantém, com menos folga. A correção é pequena, está explicada e foi testada contra a AWS real. O desenho (revision nova, falha sem derrubar o serviço, smoke que compara o sha) se provou na prática. Ainda assim, um job de deploy foi para a main sem nenhuma execução prévia e quebrou na primeira vez. O 10 segue barrado por quatro coisas: as duas lacunas da fila sem teste, nenhuma avaliação do LLM na CI e o deploy por `:sha` ainda sem sucesso comprovado. |
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
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx` e são fictícios. O commit novo não mexe em dados |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. A CI usa `secrets.*` e `vars.*`, e o JSON da task definition só circula em memória no runner |
| Mocks e terceiros | Declarados no README | OK | "Simulado / pré-existente" está completo, inclusive o login sem senha |
| Link da demo | README | OK | A API no CloudFront responde 200 com banco. O painel está na Vercel |
| Link do vídeo | README | RISCO | Ausente |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- **0 FALHAS e 2 RISCOS.**
- Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE) e X7/X8 (main em dia). Em S4/S5, deram OK as instruções, as dependências, a demo HTTPS e a declaração do que é simulado e de terceiros. Em X6, não há `.env` nem credenciais.
- RISCO S5: o README não tem o link do vídeo.
- RISCO X6: telefones em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi e são fictícios.

## Maior retorno

1. **Pôr o sha atual no ar e medir a fila na doca, hoje.**
   - Primeiro, confirmar o `/health` com `sha: "8b303db"`. Se o job falhar de novo, reverter para o `force-new-deployment`.
   - Depois, fechar as duas lacunas num commit pequeno, cada uma com um teste: `deve_abrir_fila_separada` também no ramo `complemento`, e ignorar "não tem fila" e "sem fila".
   - Rodar `validar_fluxos.py` contra o CloudFront pelo menos 4 vezes e publicar a tabela por etapa em `evidence/validacao.md`.
   - Com 5e e 5e2 em pelo menos 3/4, **H1 8→9 = +1**.
2. **Link do vídeo de 3 min no README "Para o júri".**
   - Tira o único RISCO de entregável deste repo e é a base do H4 do projeto.
   - **S5 RISCO→OK.**
3. **Avaliação do LLM versionada, com resultado publicado.**
   - Um conjunto pequeno de falas ("tem fila", "não tem fila", "trânsito parado", "doca 2... não, doca 4", "beleza, obrigado"), com a ferramenta e o campo esperados.
   - Um job manual contra o LLM real, com a taxa de acerto publicada.
   - Para um júri de dados/ML, é a prova de que o comportamento do modelo é medido. **H2 9→10 = +1**, junto com as lacunas do item 1 e um deploy por `:sha` bem-sucedido.

## Observações

- O time corrigiu o deploy um minuto depois de a falha ficar visível, e testou a correção na AWS antes do push. É boa disciplina. A falha em si veio de mudar o pipeline sem uma execução de ensaio.
- A partir de 29/11, nada de pipeline nem Terraform. Se o deploy de `8b303db` passar, ele fica como está.
- Em 30/11, só três coisas: o link do vídeo, conferir que o `/health` mostra o último `sha` e uma rodada final de `validar_fluxos.py`. Não mexa na voz no último dia.
- De 01/12 a 12/12 não pode haver commit (X8). A imagem no ar em 30/11 é a que o júri vê.
