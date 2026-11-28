# Judge: rodar-backend, 2026-11-28 00:55

Gatilho: push na main de rodar-backend 4d01768 por HenryFacens. Commit avaliado: 4d01768.

**Nota do repo: 17 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 2d23h para 30/11 23h59 · Variação: 0 (era 17/20 em `8b3f0d4`)

Desde a rodada anterior (`8b3f0d4`) entrou 1 commit, `4d01768` (7 arquivos, +151/−18). Ele não muda comportamento:
- **Código:** a mudança é só em comentários e docstrings (`main.py`, `rotas.py`, `ocorrencias.py`, `settings.py`, `conversa.py`). Conferi o diff linha a linha, e nenhuma instrução executável mudou.
- **README:** a linha 40 agora diz 413 testes no backend e 649 no total. A linha 38 cita a validação sobre `8b3f0d4`. A linha 93 deixou de citar o júri simulado.
- **`evidence/validacao.md`:** tem uma rodada nova, com 4 execuções de `validar_fluxos.py` contra o CloudFront (LLM e LiveKit reais) sobre `8b3f0d4`. A rodada anterior foi para o *Registro histórico*.

**Conferido nesta rodada:**
- Li o diff inteiro de `8b3f0d4..4d01768`.
- `curl` às 00h55 (-03) em `https://d3fy4m7zwukr3x.cloudfront.net/health` devolveu `ok: true`, `banco_ok: true`, `sha: "8b3f0d4"`, `llm_upstream: true`, `ligar_recebedor_na_aproximacao: true` e `recebedor_modo: rtc`. **A correção de 4c/5e2 está no ar.** O commit `4d01768` só muda documentação, então ainda não estar no ar não afeta nada.
- Não rodei a suíte de novo porque o diff de código é só comentário. Os 413 testes que passaram em `8b3f0d4` (rodada anterior) continuam valendo.
- Comparei a tabela nova de rodadas com a de `c9c040c`:

| Etapa | Antes (`c9c040c`) | Agora (`8b3f0d4`) |
|---|---|---|
| 3d | 4/4 | 3/3 (a rodada 2 não registrou) |
| **4c** | 1/4 | **4/4**, conferido no banco (`doca="4"`) |
| **5e** | 2/4 | **1/4** |
| 5e2 | 0/4 | 0/4 |

## Alertas

- **RISCO (H1): a demo pública ainda falha na etapa de ocorrência na doca (5e e 5e2) em 3 a 4 de cada 4 execuções.**
  - Um jurado que diz "tem fila aqui na portaria" ao agente tende a ver a ocorrência ser engolida pela de atraso. Ou vê a Task do CCO preenchida com "não sei".
  - O diagnóstico publicado é bom e honesto. O LLM reaproveita a ocorrência `atraso` aberta na 3d, e no outro caso chama uma ferramenta sem efeito. Mas diagnóstico não é correção.
  - A queda de 5e de 2/4 para 1/4 é compatível com ruído em 4 amostras. Ela não prova regressão, mas também não mostra melhora.
- **Inconsistência no README (H1, credibilidade):** a linha 38 diz que "a falha que sobra" é a **5e2**. A tabela da própria evidência mostra a **5e** falhando em 3 de 4 rodadas. Um jurado de dados/ML que abrir o link vai notar a diferença. Corrija para "5e e 5e2 (ocorrência de fila na doca)".
- **RISCO (S5), sem mudança:** o link do vídeo continua ausente. A linha 44 ainda é `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **Sem mudança: o falso positivo da 5e2.**
  - `resposta_livre_ocorrencia` continua gravando qualquer fala que não seja pergunta no primeiro campo que falta. Com uma ocorrência de fila aberta, "beleza, obrigado" vira `quantos = "beleza, obrigado"`.
  - Não há teste para esse caso.
  - O próprio commit admite que uma heurística mais agressiva contamina os dados. A mais estrita também contamina, só que em outro caso.
- **Sem mudança: 4c com correção do recebedor.** `extrair_doca_previsao` usa `re.search`, que pega a **primeira** `doca N` da transcrição. "Doca 4... não, doca 6" fica 4.
- **As menções ao júri simulado saíram de `backend/app`, mas ficaram em outros arquivos.**
  - Testes: `tests/dominio/test_ocorrencias.py:40`, `tests/api/test_lacunas_rastreabilidade.py:123`, `tests/api/test_api_edi.py:68`, `tests/api/test_publicacao_rota.py:34`, `tests/api/test_health.py:4` e `:35`.
  - Documentação: `infra/README.md:82`, `:87` e `docs/edi/ocoren-integracao.md:3`.
  - Pesa menos que no código de produção, mas o jurado que abre os testes encontra "alerta do júri, score.md".
- **Sem mudança: o smoke do deploy tem efeito colateral.** `GET /rotas/1/ocoren` incrementa `Empresa.ultima_sequencia_ocoren` em produção a cada deploy.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` ainda descreve `7fe3475`.
  - Ele diz que a infra está numa "branch sem PR". Ela está na main, com HTTPS via CloudFront.
  - Ele cita 377 testes. São 413.
  - Ele diz que "o caminho de voz atual não tem validação publicada". Agora tem duas validações.
  - Ele diz que o painel está no GitHub Pages. O README diz que está só na Vercel desde 27/11.
  - `decisoes.md` não registra a decisão "corrigir na borda das ferramentas, sem mexer no prompt", nem a recusa ao fallback agressivo da 5e2.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | Mantém. **Ganho real e provado: 4c passou de 1/4 para 4/4** contra a AWS pública, com LLM real e conferência no banco. A demo está no ar com o `sha` da correção. A ocorrência na doca (5e/5e2) segue instável, então "nada quebra na mão do júri" (9) ainda não vale. O README também subnotifica a falha da 5e. |
| H2 | Implementação técnica | 9 | Mantém. A avaliação contra o ambiente real foi feita com 4 rodadas, tabela por etapa, causa raiz com IDs de rota e a rejeição justificada de uma heurística que contaminaria os dados. É o tipo de rigor que um júri de ML valoriza. Os comentários de produção agora explicam o domínio. Continuam impedindo o 10: falso positivo da 5e2 sem teste, regex da 4c com a primeira doca, menções ao júri nos testes e no `infra/README.md`, GET com efeito colateral no smoke e nenhum conjunto de avaliação de LLM versionado na CI. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **17/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork. O README assume o compromisso escrito de manter a infra no ar até 15/12 |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx` e são fictícios. A evidência nova não traz nome nem telefone real |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. A evidência nova não expõe chave |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa. `recebedor_modo: rtc` e `twilio_configurado: false` estão declarados |
| Link da demo | README | OK | O painel está na Vercel. A API no CloudFront responde 200 com banco |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- **0 FALHAS e 2 RISCOS.**
- Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE) e X7/X8 (main em dia). Em S4/S5, deram OK as instruções de execução, as dependências, a demo HTTPS e a declaração do que é simulado e de terceiros. Em X6, não há `.env` nem credenciais.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: telefones versionados em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi e são fictícios.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S5 e S6.

## Maior retorno

1. **Estabilizar a ocorrência na doca (5e/5e2) com a mesma técnica da 3d.**
   - Depois da chegada (`status_rota` em geocerca de destino ou `na_doca`), se a fala tem "fila" ou "caminhões na frente" e só há ocorrência `atraso` aberta, **abra uma `fila` nova na borda** de `detalhar_ocorrencia` em vez de anexar ao atraso. É a regra determinística por estado que já funcionou na 3d.
   - Para o falso positivo, só anexe a fala se o `_DETECTA` do primeiro faltante casar, ou se ela tiver número, hora ou sim/não. Descarte "ok", "beleza", "obrigado" e "tô chegando", com um teste para cada.
   - Meça de novo 4 vezes contra o CloudFront. Se 5e e 5e2 chegarem a 3/4 ou mais, o caminho inteiro fica estável. **H1 8→9 = +1.**
2. **Link do vídeo no README (linha 44) e linha 38 honesta** ("as falhas que sobram: 5e e 5e2, ocorrência de fila na doca").
   - O vídeo tira o RISCO S5. É entregável obrigatório e é a base do H4 do projeto.
   - A frase corrigida protege a credibilidade da evidência, que é o melhor argumento de H1 e H2 do repo.
   - **S5 RISCO→OK; protege H1 8.**
3. **Limpeza final de H2 em um commit só:**
   - Tirar "júri" e "score.md" dos 6 testes, do `infra/README.md` e de `docs/edi/`.
   - Fazer a 4c preferir a última `doca N` (`re.findall(...)[-1]`).
   - Deixar o smoke do deploy sem efeito colateral (um `HEAD` ou parâmetro `dry_run` no OCOREN).
   - Publicar a imagem por `:<sha>`.
   - Depois, `/registrar rodar-backend`.
   - **H2 9→10 = +1.**

## Observações

- O time está fazendo o certo: medir no ambiente real, publicar as falhas e recusar uma heurística que piora os dados. Isso vale mais para este júri (dados/ML, produto) do que 34/34 com LLM fake. Vale mostrar a tabela de rodadas no pitch com a frase "o modelo decide, o sistema garante".
- Com 4 amostras, 1/4 contra 2/4 na 5e é ruído. Se o time quiser afirmar melhora ou piora, precisa de pelo menos 8 a 10 rodadas por versão.
- Ordem sugerida até o prazo: item 1 em 28/11 e itens 2 e 3 em 29/11. Em 30/11, só o link do vídeo, a conferência de que `/health` mostra o último `sha` e um `validar_fluxos.py` final. Nada de mexer na voz no último dia: uma regressão ali custa mais H1 do que qualquer ganho de H2.
- De 01/12 a 12/12 não pode haver commit (X8). A imagem no ar em 30/11 é a que o júri vê, e a infra precisa continuar de pé até 15/12.
