# Judge: rodar-backend, 2026-11-27 16:47

Gatilho: push na main de rodar-backend f45b6cc por HenryFacens. Commit avaliado: f45b6cc.

**Nota do repo: 14 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 3 RISCOS · Prazo: faltam 3d7h para 30/11 23h59

Desde a rodada anterior (`7fe3475`) entrou só o PR #12 (`f3cc6ac`): `/health` agora checa o banco, há 2 testes novos e o README ficou honesto sobre a Vercel e os commits de 22/11. O texto melhorou, mas o deploy não mudou. Por isso a nota fica igual.

## Alertas

- **RISCO alto (S4/H1): a URL pública do backend continua sem banco.** Testei em 27/11, às 16h47, em [rodar-backend-five.vercel.app](https://rodar-backend-five.vercel.app):
  - `/health` responde `{"ok":false,"banco_ok":false,...}`. Agora ele diz a verdade, o que é bom.
  - `/docs` e `/livekit/config` respondem 200.
  - `/rotas` e `/cco/estado` devolvem 500. `POST /auth/sso` também devolve 500, então **ninguém faz login**.
  - O README agora avisa isso em "Já em produção (temporário)" e diz que é "intencional pelo custo". Ser honesto evita a acusação de enganar o júri, mas não faz a demo funcionar. Para um júri que não instala nada (7.4), o backend no ar não roda nenhum fluxo.
- **RISCO (vazamento de erro):** `POST /auth/sso` devolve no corpo `psycopg.OperationalError: failed to resolve host 'db' ...` com link do SQLAlchemy. A causa é `api/deps.py:32` (`HTTPException(500, str(e))`). Um jurado de dados/ML que clicar em "Try it out" no Swagger vê o detalhe interno.
- **RISCO (S5):** o README ainda não tem o link do vídeo. A linha 44 continua sendo o comentário `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **RISCO de leitura (X1/X2) resolvido no texto:** o README agora diz que "nenhum código anterior a 04/11/2026 21h entrou" e explica por que os três primeiros commits têm o mesmo segundo. Era a mudança pedida na rodada anterior. Fica só como algo que um humano pode precisar confirmar.
- **Evidência velha:** `evidence/validacao.md` (33/33) é da era Agora e foi feita com o LLM em contingência. O README já declara isso. O caminho de voz atual (LiveKit com Gemini Live) continua sem prova ponta a ponta.
- **STATUS levemente desatualizado** (`repos/rodar-backend/STATUS.md`, sobre `7fe3475`): ele cita o PR #12 como "aberto", mas o PR já foi mergeado em `f45b6cc`. Diz também que o README cita 332 testes, e agora ele cita 379. **Rodei 379, e todos passaram.** Os itens que ele marca como Ok batem com o código.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | **Rodei: 379 testes passaram (44 s, Postgres 16) e o `ruff check` passou limpo.** O escopo está completo para o caminho feliz: rota, voz, aproximação, chegada, estadia pela Lei 11.442, escalonamento com ligação de verdade no 3º canal e OCOREN 5.0/3.1. Isso valeria 7. Mas a única URL pública do backend ainda devolve 500 em tudo que usa o banco, inclusive o login, e o próprio README manda "rodar localmente para ver o fluxo completo". Também faltam a prova ponta a ponta da voz atual e a ligação telefônica ao recebedor (`recebedor_modo: rtc`, confirmado no `/health` ao vivo). |
| H2 | Implementação técnica | 8 | A base é boa. `dominio/`, `servicos/` e `portas.py` têm fakes. O motor EDI trata o layout como dado. Há outbox idempotente, JWT com papel `cco`, Alembic e CI com ruff, pytest e Postgres real. A correção do `/health` é limpa (`db.banco_ok`, `SELECT 1`) e vem com teste do caso de banco fora. Não sobe para 9 porque continuam: (1) o `voice_agent.py` sem teste (`grep voice_agent tests/` vazio); (2) o 500 expondo `str(e)` (`deps.py:32`); (3) a Vercel como host de um app com SSE, WebSocket e tarefas de fundo, sem `vercel.json` versionado; (4) a `_SEQUENCIA` do OCOREN em memória (`servicos/edi.py:51`); (5) resíduos como `.idea/` e os nomes `avisai`. |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. O README traz 11h40 e 5h09 (IER 2025), 91% sem estadia (CNTA 2025) e R$ 525 por entrega, com fonte. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. O link do vídeo ainda falta no README. |
| | **Total** | **14/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026, repositório criado em 2026-11-22T03:57Z, não é fork. O README agora explica a origem no UNMUTE e os commits no mesmo segundo |
| X2 | Sem código anterior não público | OK, precisa de humano | A declaração está no README. Não dá para verificar daqui código privado anterior a 04/11 |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público hoje. Manter até 15/12 |
| X6 | Sem dado pessoal real | OK | Os telefones apontados (`+5519900000002`, `+55119000000xx`) são placeholders com sufixo sequencial, os e-mails são `.test`, e os CNPJs e NF-e do seed estão declarados como fictícios |
| Segredo no git | — | OK | Nenhum `.env` versionado e nenhum padrão de credencial. A URL do LiveKit Cloud em `/livekit/config` é pública por design |
| Mocks e terceiros | Declarados no README | OK | A seção "Simulado / pré-existente" cobre o login sem senha, o GPS, os documentos fiscais, o EDI sem parceiro, a Vercel temporária e o resto |
| Link da demo | README | **RISCO** | Os links do Pages (painel e app) existem. O link da API na Vercel leva a 500 no login, embora agora venha com aviso |
| Link do vídeo | README | RISCO | Ausente (linha 44) |

Saída resumida do `sh scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS.
- X1, X3, X4, X6 (credenciais), X7/X8 e prazo (3d7h) deram OK. S4/S5 passaram, exceto o vídeo.
- RISCO 1: o README não tem link do vídeo de até 3 min.
- RISCO 2: há telefones em `.env.example:42`, `settings.py:36`, `seed.py:36/105` e `test_auth.py:12`. Conferi: são fictícios.

Checagens humanas pendentes: X2, X9, X10, S1, S3, S4 (a demo do projeto inteiro no ar), S5 e S6.

## Maior retorno

1. **Pôr o banco no deploy ou trocar de host.** O mínimo, de custo zero, é configurar na Vercel uma `DATABASE_URL` de um Postgres gratuito (Neon ou Supabase), rodar `alembic upgrade head` e o seed, e apontar `CORS_ORIGENS` para o Pages. Com isso, login, rotas e painel funcionam pela URL pública. O certo é um container em Fly, Render ou Railway, por causa das tarefas de fundo, do SSE e do WebSocket. **H1 6→7 = +1.** Também protege S4 no projeto. O argumento de custo do README não se sustenta para o banco, porque há plano gratuito.
2. **Validação ponta a ponta no stack LiveKit atual**, contra a URL pública e com o LLM real. Basta rodar `scripts/validar_fluxos.py`, substituir `evidence/validacao.md` com data e commit, e incluir um passo do OCOREN. **H1 7→8 = +1**, somado ao item 1.
3. **Teste mínimo do `voice_agent.py`** com fakes e um 500 genérico em `deps.py:32` (logar `str(e)` e devolver "erro interno"). Somar a isso a config do deploy versionada e a remoção de `.idea/`. **H2 8→9 = +1.** Junto, pôr a linha do vídeo no README, que conta no projeto (S5/H4) e não aqui.

## Observações

- O README melhorou em honestidade: a seção sobre a Vercel, a ressalva da validação histórica e a frase sobre código anterior a 04/11. Isso não muda a nota, mas tira munição de um jurado cético.
- A frase "intencional pelo custo" pode soar como "não deu tempo" para um júri de produto. Se o banco for ligado, convém apagá-la.
- O README tem cerca de 500 linhas. O contrato de API poderia ir para `backend/docs/` e deixar o "Para o júri" no topo.
- A entrega anterior no UNMUTE by Agora não aparece no `HACKATHON.md` e não afeta a nota. Se houver dúvida sobre submissão dupla, a pergunta vai para oi@hackbrasil.com.
