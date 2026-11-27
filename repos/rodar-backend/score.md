# Judge: rodar-backend, 2026-11-27 15:59

Gatilho: push na main de rodar-backend 7fe3475 por HenryFacens. Commit avaliado: 7fe3475.

**Nota do repo: 14 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 3 RISCOS · Prazo: faltam 3d8h para 30/11 23h59

## Alertas

- **RISCO alto (S4/H1): a "API em produção" está quebrada.** O README novo anuncia [rodar-backend-five.vercel.app](https://rodar-backend-five.vercel.app/docs) como produção, mas o deploy da Vercel não tem banco. Testei em 27/11, às 15h59:
  - `/docs`, `/openapi.json`, `/health` e `/livekit/config` respondem 200.
  - Todas as rotas que tocam o banco devolvem **500**: `GET /rotas`, `/rotas/1`, `/tasks`, `/motoristas`, `/usuarios`, `/cco/estado`, `/api/metrics`, `/api/route` e `POST /auth/sso`.
  - A mensagem de erro é `psycopg.OperationalError: failed to resolve host 'db'`. Ou seja, `DATABASE_URL` não foi configurada na Vercel e vale o padrão do docker compose (`settings.py:79`).
  - Sem `/auth/sso` ninguém faz login, então nenhum fluxo funciona por essa URL.

  Um jurado que clicar em "Try it out" no Swagger vê 500 com detalhe interno do banco. Isso é pior do que não ter link.
- **RISCO (arquitetura do deploy):** mesmo com banco, a Vercel é serverless. As tarefas de fundo (`container.py:37`, `asyncio.create_task`: escalonamento, estadia, ligações) morrem quando a resposta termina. O WebSocket não roda lá, e o SSE (`/cco/stream`) tem limite de duração. O fluxo de "só chama a central quando precisa" depende dessas tarefas. Não há `vercel.json` no repo: a config está só no painel da Vercel, sem rastro no código. Para a demo, uma VM ou um container (Fly, Render, Railway) com Postgres gerenciado é o caminho mais seguro.
- **RISCO (S5):** o README ainda não tem o link do vídeo de até 3 min. A linha 44 continua sendo um comentário: `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **RISCO (X1/X2, leitura do júri), mantido da rodada anterior:** a origem no UNMUTE by Agora (21–22/11) e os três primeiros commits no mesmo segundo podem ser lidos como "histórico importado". A regra 6.1 é cumprida (22/11, depois de 04/11 21h). Falta uma frase no README dizendo que nenhum código anterior a 04/11 entrou.
- **`/health` mente:** ele responde `"ok": true` com o banco fora. Por isso o deploy parece saudável e ninguém do time percebeu.
- **STATUS desatualizado** (`repos/rodar-backend/STATUS.md`, de 25/11, `b353d12`):
  - Marca como **Ok** "Conversa por voz… Agora ConvoAI" e cita `agora_rest.py` e `tokens.py`. Esses arquivos não existem. A voz agora é LiveKit Agents com Gemini Live.
  - Diz que a demo "depende de um túnel". Agora existe deploy na Vercel, mas ele está quebrado (ver acima).
  - Nos pontos abaixo, ele está desatualizado a favor do time:
    - **OCOREN** aparece como "Promessa" e agora existe (`conectores/edi/`, `335c827`).
    - O **3º canal do escalonamento** aparecia como "só um rótulo" e agora liga para a central (`c3085e3`).
    - Auth agora é obrigatória por padrão.
    - Os números de impacto já estão no README.
  - Ele cita 299 testes e o README cita 332. **Rodei 377.**
- **Evidência velha:** `evidence/validacao.md` (33/33, 22/11) é da era Agora, em contingência, e o README a chama de "histórica". O caminho de voz atual (LiveKit) não tem prova ponta a ponta.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | O escopo aumentou desde a última rodada (`f4a1bbd`, 14/20). Entrou o conector **OCOREN 5.0/3.1**, com geração e validação de arquivo e perfil por parceiro. É o primeiro conector de mercado, e o ADR-0001 vendia exatamente isso. O 3º canal do escalonamento agora faz uma ligação de verdade, com teste. **Rodei: 377 testes passaram (40 s, Postgres 16) e o `ruff check` passou limpo.** Isso puxaria para 7. Mas a única URL pública do backend devolve 500 em todo endpoint com banco, inclusive o login. Para um júri que não instala nada (7.4), o backend "no ar" hoje não funciona. Também continuam sem prova ponta a ponta da voz atual, e o recebedor atende por página web (`RECEBEDOR_MODO=rtc`), não por telefone. |
| H2 | Implementação técnica | 8 | O motor de EDI é bom design. Uma única peça de largura fixa lê o layout como dado (`motor.py`), e `validar_layout` impede buraco ou sobreposição de campos. O que varia por parceiro fica no perfil (`ParceiroEdi`), não no código. Ele não trunca valores: levanta erro. Há migração Alembic, papel `cco` em todas as rotas EDI e testes de layout, motor, geração e API. A base continua sólida: `dominio/`, `servicos/` e `portas.py` com fakes, mais outbox idempotente, JWT e CI com ruff, pytest e Postgres real. Não chega a 9 por cinco motivos: (1) o `voice_agent.py` segue sem teste; (2) o `/health` não checa o banco; (3) os erros 500 expõem o detalhe do SQLAlchemy ao cliente; (4) a Vercel é uma escolha inadequada para um app com SSE, WS e tarefas de fundo, e a config não está versionada; (5) a sequência do OCOREN fica em memória (`_SEQUENCIA`) e reinicia a cada cold start. Sobram ainda restos de outras versões: `.idea/` e os nomes `avisai`. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. O README traz 11h40/5h09 (IER 2025) e 91% sem estadia (CNTA 2025). O OCOREN dá base concreta para o discurso de "integração". |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. Falta o link do vídeo no README. |
| | **Total** | **14/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK (RISCO de leitura) | Primeiro commit em 22/11/2026. Ver o alerta sobre o UNMUTE |
| X2 | Sem código anterior não público | OK, precisa de humano | `hfoletto/edi-proceda` (MIT) foi declarado como referência de posição de campo, não copiado. Não há como verificar código anterior a 04/11 |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público hoje. Manter até 15/12 |
| X6 | Sem dado pessoal real | OK | Os telefones apontados pelo check-rules (`+55119000000xx`, `+5519900000002`) são placeholders. Os e-mails são `.test`. Os CNPJs e as chaves de NF-e do seed são declarados como fictícios (o DV é válido, mas o número não existe) |
| Segredo no git | — | OK | Nenhum `.env` versionado. A URL do LiveKit Cloud aparece em `/livekit/config`, que é pública por design, não é segredo |
| Mocks e terceiros | Declarados no README | OK | Seção "Simulado / pré-existente", agora com o EDI OCOREN (sem parceiro real e sem SFTP), a Vercel e o restante |
| Link da demo | README | **RISCO** | O link do Pages (web e mobile) existe. O link novo da "API em produção" leva a 500 |
| Link do vídeo | README | RISCO | Ausente |

Saída resumida do `scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS.
- X1, X3, X4, X6 (credenciais), X7/X8 e o prazo (3d8h) deram OK. S4/S5 passaram, exceto o vídeo.
- RISCO 1: o README não tem link do vídeo.
- RISCO 2: há telefones em `.env.example:42`, `settings.py:36`, `seed.py:36/105` e `test_auth.py:12`. Conferi: são fictícios.

Checagens humanas pendentes: X9, X10, S1, S3, S4, S5, S6 e X2.

## Maior retorno

1. **Ligar o banco ao deploy ou trocar de host.** O mínimo é configurar na Vercel uma `DATABASE_URL` de Postgres gerenciado (Neon, Supabase), rodar `alembic upgrade head` e o seed, e fazer o `/health` checar o banco. O certo é um container em Fly, Render ou Railway, porque as tarefas de fundo, o WS e o SSE não sobrevivem no serverless. Por fim, `CORS_ORIGENS` e `PUBLIC_URL` devem apontar para o Pages, e o deploy deve ficar no ar até 12/12. **H1 6→7 = +1.** Também protege S4 no projeto, e enquanto isso não acontece o link atual tira pontos.
2. **Nova validação ponta a ponta no stack LiveKit atual**, com o LLM real e contra a URL pública: rodar `scripts/validar_fluxos.py`, substituir `evidence/validacao.md` com data e commit, e incluir um passo do OCOREN. **H1 7→8 = +1**, somado ao item 1.
3. **Teste mínimo do `voice_agent.py`** com fakes, mais erros 500 genéricos (sem expor o SQLAlchemy) e a config do deploy versionada. **H2 8→9 = +1.** Junto, pôr a linha do vídeo no README, que vale no projeto (S5/H4) e não aqui.

## Observações

- O README fala em "568 testes: 332 no backend…", mas o backend hoje tem **377**. Vale corrigir o número para cima.
- O OCOREN só sai por download manual (sem SFTP nem fila) e sem homologação com parceiro, e o README e o `docs/edi/ocoren-integracao.md` declaram isso com honestidade. No pitch, cabe "geramos OCOREN no padrão de mercado". Não cabe "integramos com TOTVS ou Intelipost".
- O README segue longo (cerca de 490 linhas). A parte "Para o júri" está boa, mas o contrato de API poderia ir para `backend/docs/`.
- A entrega anterior no UNMUTE by Agora não aparece no `HACKATHON.md` e não afeta a nota. Se houver dúvida sobre submissão dupla, a pergunta vai para oi@hackbrasil.com.
