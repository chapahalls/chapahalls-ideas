# Judge: rodar-backend, 2026-11-28 08:42

Gatilho: push na main de rodar-backend 62076bd por HenryFacens. Commit avaliado: 62076bd.

**Nota do repo: 17 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 2d15h para 30/11 23h59 · Variação: 0 (era 17/20 em `4d01768`)

Desde a rodada anterior (`4d01768`) entraram 2 commits:
- **`7dcc0c8` (docs):** a linha 38 do README e o topo de `evidence/validacao.md` agora dizem "5e e 5e2". O alerta de inconsistência da rodada anterior está **resolvido**.
- **`62076bd` (fix, 7 arquivos, +97/−2):** implementa o item 1 do *Maior retorno* anterior.
  - `dominio/ocorrencias.py` ganhou `indica_fila_na_doca()` e `deve_abrir_fila_separada()`. Em `servicos/tasks.py::detalhar_ocorrencia`, com um `atraso` aberto, a rota em `no_destino` e uma fala com "fila" ou "caminhões na frente", o sistema abre uma ocorrência `fila` nova em vez de anexar o detalhe ao atraso. É a mesma técnica determinística por estado da 3d, aplicada na direção contrária.
  - `resposta_livre_ocorrencia` só anexa a fala se ela casar com o padrão do primeiro campo que falta ou trouxer um número, uma hora ou duração, ou um sim/não literal. "ok", "beleza", "obrigado" e "tô chegando" agora são descartados, com um teste para cada.
  - Entrou um teste de API com LLM fake que reproduz o cenário de produção: atraso na estrada, depois a chegada, depois "tem fila" chamando `detalhar_ocorrencia`. Resultado esperado: tipos `["atraso","fila"]` e o atraso fechado.

**Conferido nesta rodada:**
- Li o diff inteiro de `4d01768..62076bd` e o contexto de `detalhar_ocorrencia` e `registrar_ocorrencia`.
- Rodei a suíte com `docker compose run --rm --build test pytest -q`: **423 passaram** em 46 s. Bate com o README (423 no backend, 659 no total).
- Às 08h42 (-03), `curl` em `https://d3fy4m7zwukr3x.cloudfront.net/health` devolveu `ok: true`, `banco_ok: true`, `sha: "7dcc0c8"`, `llm_upstream: true` e `recebedor_modo: rtc`. **A correção `62076bd` ainda não está no ar**: o deploy da CI deste push deve estar em andamento. Por isso também **não há medição contra a AWS** da correção da 5e/5e2.

## Alertas

- **RISCO (H1): a correção da 5e/5e2 não foi medida no ambiente real.**
  - Ela foi provada só com LLM fake. A última medição publicada (`8b3f0d4`) ainda mostra 5e em 1/4 e 5e2 em 0/4.
  - Até haver rodadas de `validar_fluxos.py` contra o CloudFront com `sha: 62076bd` no `/health`, o jurado que disser "tem fila aqui na doca" corre o mesmo risco de antes.
  - A correção ataca a causa diagnosticada (reaproveitar o atraso aberto). O fallback de "ferramenta sem efeito" (5e2) só age quando o LLM não chama nenhuma ferramenta, conforme `decisoes.md`, e esse caso continua sem cobertura.
- **Lacuna na correção nova: atraso já fechado.** `deve_abrir_fila_separada` só roda no ramo `elif`, ou seja, quando há ocorrência **aberta**. Se o atraso da estrada já foi completamente detalhado e o LLM chama `detalhar_ocorrencia` com "tem fila" na doca, o código cai no ramo `complemento` e soma o detalhe ao atraso fechado. O resultado é o mesmo sintoma da 5e, por outro caminho. Não há teste para esse caso.
- **Falso positivo por negação:** `_FILA_NA_DOCA = r"\bfila\b|..."` casa com "não tem fila, só atrasei mesmo". Com o atraso aberto e o caminhão no destino, essa fala abre uma ocorrência de fila que não existe e fecha o atraso. É raro na demo, mas vale um teste.
- **Regressão de higiene:** o teste novo `tests/dominio/test_contingencia.py:284` cita `score.md` de novo. Continuam com menção ao júri simulado: `test_ocorrencias.py:40`, `test_lacunas_rastreabilidade.py:123`, `test_api_edi.py:68`, `test_publicacao_rota.py:34`, `test_health.py:4` e `:35`, além de `infra/README.md:82` e `:87`.
- **RISCO (S5), sem mudança:** o README ainda não tem o link do vídeo de até 3 min.
- **Sem mudança:**
  - A 4c usa `re.search` em `contingencia.py:338`. Com isso, pega a **primeira** `doca N`, e "doca 4... não, doca 6" fica 4.
  - O smoke do deploy chama `GET /rotas/1/ocoren`, que incrementa `ultima_sequencia_ocoren` em produção.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` descreve `4d01768`.
  - Ele cita 413 testes. São 423.
  - O item 1 do resumo diz que o falso positivo "beleza, obrigado" não tem teste e que o reaproveitamento do atraso não tem correção. Os dois entraram em `62076bd`.
  - `decisoes.md` não registra a decisão "fila depois da chegada é ocorrência nova, por estado da rota".
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | Mantém. A demo pública responde com banco e LLM, e as etapas 3d e 4c foram provadas 4/4 contra a AWS. A falha que sobrava (5e/5e2) ganhou uma correção com a causa certa, mas **sem prova no ambiente real**: o `/health` ainda mostra `7dcc0c8`. O 9 exige rodadas contra o CloudFront com 5e e 5e2 em pelo menos 3/4. |
| H2 | Implementação técnica | 9 | Mantém. A correção é pequena, fica na borda da ferramenta, reusa a regra por estado da 3d, testa no domínio e na API, e fecha o falso positivo com um teste por fala. Rodei 423 testes e todos passaram. O 10 continua barrado por: atraso fechado não coberto, negação no regex, a primeira `doca N` na 4c, um GET com efeito colateral no smoke, menções a `score.md` nos testes (uma delas nova) e nenhum conjunto de avaliação do LLM versionado na CI. |
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
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa |
| Link da demo | README | OK | A API no CloudFront responde 200 com banco. O painel está na Vercel |
| Link do vídeo | README | RISCO | Ausente |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- **0 FALHAS e 2 RISCOS.**
- Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE) e X7/X8 (main em dia). Em S4/S5, deram OK as instruções, as dependências, a demo HTTPS e a declaração do que é simulado e de terceiros. Em X6, não há `.env` nem credenciais.
- RISCO S5: o README não tem o link do vídeo.
- RISCO X6: telefones em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi e são fictícios.

## Maior retorno

1. **Medir `62076bd` no ar e fechar as duas lacunas antes da medição.**
   - Espere o `/health` mostrar `sha: 62076bd` (ou o commit seguinte).
   - Antes, ponha `deve_abrir_fila_separada` também no ramo `complemento`, para o caso do atraso fechado. Ignore "não tem fila" e "sem fila" com uma negação simples antes de `fila`. Escreva um teste para cada caso.
   - Depois, rode `validar_fluxos.py` contra o CloudFront pelo menos 4 vezes e publique a tabela por etapa em `evidence/validacao.md`.
   - Com 5e e 5e2 em pelo menos 3/4, o caminho inteiro fica estável na mão do júri. **H1 8→9 = +1.**
2. **Link do vídeo de 3 min no README "Para o júri".**
   - Tira o único RISCO de entregável deste repo.
   - É a base do H4 do projeto.
   - **S5 RISCO→OK.**
3. **Limpeza final de H2 em um commit, até 29/11:**
   - Tirar "júri" e "score.md" dos 7 pontos dos testes e do `infra/README.md`.
   - Fazer a 4c pegar a última `doca N` (`re.findall(...)[-1]`).
   - Deixar o smoke do deploy sem efeito colateral no OCOREN.
   - Depois, `/registrar rodar-backend`.
   - **H2 9→10 = +1.**

## Observações

- O time executou o *Maior retorno* da rodada anterior em menos de 8 horas, com causa raiz, teste e sem mexer no prompt. É o padrão certo, e a frase "o modelo decide, o sistema garante" vale como argumento no pitch para um júri de dados/ML.
- Com 4 amostras por etapa, diferenças de 1/4 são ruído. Para afirmar que a 5e "ficou estável", 8 rodadas dão mais segurança.
- Em 30/11, só o link do vídeo, a conferência de que o `/health` mostra o último `sha` e uma rodada final de `validar_fluxos.py`. Não mexa na voz no último dia.
- De 01/12 a 12/12 não pode haver commit (X8). A imagem no ar em 30/11 é a que o júri vê.
