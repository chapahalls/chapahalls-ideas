# Judge: rodar-backend, 2026-11-27 23:35

Gatilho: push na main de rodar-backend c9c040c por HenryFacens. Commit avaliado: c9c040c.

**Nota do repo: 16 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d0h para 30/11 23h59 · Variação: 0 (era 16/20 em `f630043`)

Desde a rodada anterior (`f630043`) entraram 2 commits. Os dois respondem aos dois alertas de H1 da rodada passada:
- `38c765a`: nova função `corrigir_tipo_por_estado` (`dominio/ocorrencias.py:131`), chamada em `servicos/tasks.py:252`. Com a rota `em_transito`, uma ocorrência classificada como `fila` passa a ser `atraso`. Entraram 3 testes de domínio e um teste de API (`test_llm_classifica_atraso_como_fila_mas_estado_da_rota_corrige`) em que o LLM fake erra de propósito e o aviso ao recebedor sai mesmo assim. Isso fecha a falha da etapa 3d. **Não** fecha a 5e2, que é o erro inverso: a fila detalhada na doca não vira ocorrência detalhada.
- `c9c040c`: `ecs.tf:28` passa para `"true"`, o `/health` expõe `ligar_recebedor_na_aproximacao` (com teste) e o README ganhou a linha 93 dizendo que a flag está ativa no ambiente da AWS. A mensagem do commit diz que o `tofu apply` foi feito.

**Conferido nesta rodada:**
- `docker compose run --rm test`: **397 passed** em 42 s (eram 392).
- `curl` às 23h33 e às 23h35 (-03) em `https://d3fy4m7zwukr3x.cloudfront.net/health`: 200, `banco_ok: true`, mas ainda **`sha: "f630043"`**, sem a chave `ligar_recebedor_na_aproximacao`. O push foi às 23h32, então a imagem de `c9c040c` ainda não estava no ar. **Não consegui confirmar pela API que a flag está ligada em produção.** Continuam `twilio_configurado: false` e `recebedor_modo: rtc`.

## Alertas

- **RISCO (H1): a correção da demo pública ainda não tem prova no ar.** O `/health` continua em `f630043`. Quando o deploy de `c9c040c` terminar, ele deve mostrar `sha: "c9c040c"` e `ligar_recebedor_na_aproximacao: true`. Se a chave aparecer `false`, a task definition não foi aplicada, e o README (linha 93) estará prometendo algo que a demo não faz. **Precisa de humano:** conferir com `curl` depois da run de `deploy`.
- **RISCO (H1): a 5e2 continua dependendo só do LLM.** A regra nova cobre `fila`→`atraso` na estrada, mas não o caso inverso, que é a fila na doca, com o caminhão `no_destino`, classificada de outro jeito ou sem o aprofundamento. A validação publicada (`evidence/validacao.md`, 32/34 em `bdc14e5`) é anterior às duas correções, e o README (linha 38) ainda diz que "as 2 falhas são a classificação `atraso`×`fila`". Rodar `validar_fluxos.py` de novo é o que mostra quanto subiu.
- **RISCO (S5), sem mudança:** o README ainda não tem o link do vídeo. A linha 44 continua `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **Precisa de humano (fresh clone):** a validação diz que o `.env.example` vem com `LIGAR_RECEBEDOR_NA_APROXIMACAO=false` ("padrão do `.env.example`"), mas a tabela do README (linha 460) diz que o padrão é `true`. Não li o `.env.example` nesta rodada. Se for `false`, quem seguir o README localmente não vê a abertura do pitch.
- **O smoke ainda tem efeito colateral, sem mudança:** cada deploy chama `GET /rotas/1/ocoren` (`ci.yml`), e isso incrementa `Empresa.ultima_sequencia_ocoren` em produção.
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md` continua sobre `7fe3475`, 12 commits atrás):
  - Ele diz que a infra está numa "branch sem PR", só em HTTP. Ela está na main, com HTTPS via CloudFront e deploy pela CI provado.
  - Ele cita 377 testes. Hoje são 397.
  - Ele diz que a voz atual "não tem validação publicada". Tem: 32/34.
  - Ele lista `rodarglobal.github.io/rodar-web` como demo. O README diz que o painel está só na Vercel.
  - A linha do OpenTofu em `decisoes.md` ("ALB em HTTP", "não chegou ao main") está superada.
  - Rodar `/registrar rodar-backend`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | Mantém. No código, os dois motivos que seguravam a nota foram tratados. O ambiente público liga para o recebedor na aproximação (`ecs.tf:28`). O atraso na estrada não depende mais só do LLM, com teste em que o modelo erra e o fluxo segue. Para subir a 8 falta **prova**: o `/health` público ainda roda `f630043` e não mostra a flag, a validação de 32/34 é anterior às correções e foi feita local, não contra o CloudFront, e a 5e2 continua aberta. A telefonia real segue desligada (`twilio_configurado: false`), declarada. |
| H2 | Implementação técnica | 9 | Mantém. A divergência entre a IaC e o padrão documentado foi corrigida, e a flag ficou observável no `/health`, com teste. A correção da classificação é determinística, fica no domínio e tem testes para os casos positivo e negativo e para os tipos que não mudam. São 397 testes com Postgres real, sobre camadas `dominio/`, `servicos/`, `portas.py`, o motor EDI por layout, a outbox idempotente, IaC em OpenTofu e deploy pela CI provado. O que impede o 10: o GET com efeito colateral no smoke, a imagem `:latest` mutável e a classificação de ocorrências sem conjunto de avaliação versionado. A regra nova cobre só um sentido do erro. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **16/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026 |
| X2 | Sem código anterior não público | OK, precisa de humano | Declarado no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork. Há compromisso por escrito de manter a infra até 15/12 |
| X6 | Sem dado pessoal real | OK | `+5519900000002`, `+5511900000001` e os números de `test_auth.py` seguem o padrão sequencial `9000000xx`. Os e-mails são `.test`, e o seed e a NF-e estão declarados como fictícios |
| Segredo no git | — | OK | Nenhum `.env`, `tfstate` ou `tfvars` real versionado. As credenciais da CI ficam só nos secrets do Actions |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" está completa. A ressalva da rodada passada (flag desligada sem aviso) foi resolvida no código e no README. Falta a confirmação no ar |
| Link da demo | README | OK | Painel na Vercel. A API no CloudFront responde 200 com banco |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS. Deram OK: X1 (primeiro commit em 22/11), X4 (público, não fork), X3 (LICENSE), X7/X8 (main em dia) e prazo (3d0h). Em S4/S5, deram OK as instruções, as dependências, o link HTTPS da demo e a declaração do que é simulado e de terceiros. Em X6, sem `.env` e sem credenciais.
- RISCO S5: o README não tem o link do vídeo de até 3 min.
- RISCO X6: há telefones versionados em `.env.example`, `settings.py`, `seed.py` e `test_auth.py`. Conferi: são fictícios.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S5, S6, o `/health` depois do deploy de `c9c040c` e o valor da flag no `.env.example`.

## Maior retorno

1. **Validar de novo, agora contra a demo pública.** Depois que o `/health` mostrar `sha: "c9c040c"` e `ligar_recebedor_na_aproximacao: true`, rodar `scripts/validar_fluxos.py` contra `https://d3fy4m7zwukr3x.cloudfront.net` e publicar o resultado em `evidence/validacao.md` com o `sha`. Atualizar também a frase da linha 38 do README sobre "as 2 falhas". É a prova que falta para "demo pública no ar, falhas tratadas". **H1 7→8 = +1.**
2. **Fechar a 5e2 do mesmo jeito que a 3d.** Com a rota `no_destino` ou `aproximando` e uma fala de fila ou portaria, forçar `fila` e o roteiro de aprofundamento, com um teste em que o LLM fake erra. Junto, um pequeno conjunto versionado de falas ambíguas que rode na CI. **Protege o 8 de H1 e conta para H2 9→10.**
3. **Link do vídeo no README (linha 44), trocar o smoke do OCOREN por uma checagem sem efeito colateral e fixar a imagem por `:<sha>`.** Tira o RISCO S5, que pesa no H4 do projeto, e remove os dois últimos defeitos de H2. Rodar também `/registrar rodar-backend`, porque o STATUS está 12 commits atrás. **S5 RISCO→OK; H2 9→10 = +1, junto com o item 2.**

## Observações

- Faltam 3 dias para o prazo, então commits ainda são permitidos até 30/11 23h59. Depois, nada até 12/12: a imagem que estiver no ar em 30/11 é a que o júri vê.
- Este time responde aos alertas em poucos minutos e com teste, o que é bom sinal para a final, em que o projeto é terminado no local. Cuidado só com comentários no código que citam "score.md" e "risco do júri" (`ocorrencias.py:125`, `main.py:88`, `test_health.py:35`). Para um jurado que lê o código, isso parece código escrito para a banca, não para o produto. Vale reescrever esses comentários com a razão de domínio antes de 30/11.
- A honestidade do `evidence/validacao.md` (mostrar 32/34 e explicar as falhas) continua sendo um ponto forte para um júri de dados e ML. Mantenha esse tom quando publicar a nova rodada.
