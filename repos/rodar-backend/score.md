# Judge: rodar-backend, 2026-11-27 15:22

Gatilho: push na main de rodar-backend f4a1bbd por HenryFacens. Commit avaliado: f4a1bbd.

**Nota do repo: 14 / 20** (H1+H2) · Eliminatórios: 0 FALHAS, 3 RISCOS · Prazo: faltam 3d8h para 30/11 23h59

## Alertas

- **RISCO (S5):** o README não tem o link do vídeo de até 3 min. A linha 40 ainda é um comentário: `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **RISCO (S4/H1):** o backend não tem deploy fixo. Ele roda via `docker compose` mais um quick tunnel do cloudflared, cuja URL "muda se o túnel reiniciar" (README, linha 102). Os links "Demo no ar" apontam para o GitHub Pages do web e do mobile. Este repo não publica nenhuma URL própria estável, e o `CORS_ORIGENS` padrão só tem localhost. Se a máquina do túnel desligar durante a avaliação, tudo o que depende do backend cai (voz ao vivo, fluxo real). **Precisa de humano** para confirmar se a demo do Pages chama este backend e se ele fica no ar até 12/12.
- **RISCO (X1/X2, leitura do júri):** o README diz que o projeto "começou como AvisAI no hackathon UNMUTE by Agora (21–22/11/2026)" e mantém as tags `v1.0-entrega` a `v1.3-entrega` dessa entrega. Os três primeiros commits têm o mesmo horário (`2026-11-22 02:42:12 -0300`), o que parece histórico montado de uma vez. As datas estão depois de 04/11 21h, então a regra 6.1 é cumprida. Mesmo assim, um jurado pode ler "histórico importado". Basta uma frase no README dizendo que nenhum código anterior a 04/11 entrou e que o trabalho de 21/11 foi commitado a partir de 22/11.
- **STATUS desatualizado:** `repos/rodar-backend/STATUS.md` (25/11, `b353d12`) marca como **Ok** "Conversa por voz... Agora ConvoAI (ASR ARES, TTS MiniMax)" e cita como adaptadores reais `agora_rest.py` e `tokens.py`. Esses arquivos não existem mais: a voz agora é LiveKit Agents com Gemini Live (`app/voice_agent.py`, `integracoes/livekit.py`, commit `774e5c2`). Ele também está desatualizado no sentido favorável, em quatro pontos:
  - auth agora é `auth_obrigatoria = True` por padrão;
  - os números de impacto já estão no README ("Por que importa");
  - o link da demo já está no README;
  - os testes passaram de 299 para 332.
- **Evidência velha:** `evidence/validacao.md` (33/33, 22/11) é anterior à troca para LiveKit e foi feita "LLM upstream: não (contingência)". O próprio README a chama de "histórica". Não há prova ponta a ponta do caminho de voz atual.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | O fluxo inteiro está implementado e coberto. Rota publicada → retirada por voz → aproximação → aviso ao recebedor → chegada com dupla prova de GPS → Task → escalonamento → estadia → descarga, com contingência sem LLM. **Rodei: 332 testes passaram (36,8 s, Postgres 16) e o `ruff check` passou limpo.** Não chega a 7-8 por três motivos. Primeiro, o backend não tem demo pública estável (só túnel). Segundo, a única validação ponta a ponta é da era Agora e em contingência. Terceiro, o recebedor atende por página web (`RECEBEDOR_MODO=rtc`), não por telefone. |
| H2 | Implementação técnica | 8 | Camadas limpas: `dominio/` com regras puras, `servicos/`, `portas.py` (Protocols) e `integracoes/`, com fakes nos testes. Há migrações Alembic, outbox idempotente (`POST /events`, 409 na repetição), SSE e WS, JWT com papel `cco` e dono da rota, e limite de ligações. A CI roda ruff + pytest contra Postgres real. A estadia por "hora ou fração" cita o §5º. Não chega a 9 por estes pontos: o worker de voz (`voice_agent.py`) não tem teste; as leituras (`GET`, SSE, WS) e o gateway `/v1/voice/*` estão abertos sem segredo (o README admite isso); o rate limit fica em memória; e há restos (`.idea/` versionado, nomes `avisai`). |
| H3 | Impacto | avaliado no projeto | Não pontuado aqui. O README já traz 11h40/5h09 (IER 2025) e 91% sem estadia (CNTA 2025), com fonte, e o cálculo de R$ 525 por entrega. |
| H4 | Comunicação | avaliado no projeto | Não pontuado aqui. Falta o link do vídeo no README. |
| | **Total** | **14/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h, sem fork | OK (RISCO de leitura) | Primeiro commit em 22/11 02:42 (UTC−3). Ver o alerta sobre UNMUTE e os horários idênticos |
| X2 | Sem código anterior não público | OK, precisa de humano | Origem declarada como 21–22/11, depois da abertura. Não há como verificar código anterior a 04/11 |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público hoje. Manter até 15/12 |
| X6 | Sem dado pessoal real | OK | Seed fictício e declarado: e-mails `.test`, telefones `+55119000000xx` e `+5519900000002`, placa `ABC1D23`. As ocorrências do check-rules são esses números de mentira |
| Segredo no git | — | OK | Nenhum `.env` versionado. As chaves estão só documentadas por nome |
| Mocks e terceiros | Declarados no README | OK | Seção "Simulado / pré-existente": GPS, rastreador, SSO, documentos, RTC × SIP, LiveKit, OpenAI, Nominatim, Twilio, cloudflared |
| Link da demo | README | OK, com ressalva | Aponta para o Pages do web e do mobile, não para uma URL do backend |
| Link do vídeo | README | RISCO | Ausente |

Saída resumida do `scripts/check-rules.sh ../rodar-backend`:
- 0 FALHAS e 2 RISCOS.
- X1, X3, X4, X6 (credenciais), X7/X8 e o prazo deram OK.
- RISCO 1: o README não tem link do vídeo.
- RISCO 2: há telefones no seed, no settings, no teste e no `.env.example`. Conferi: são fictícios.

## Maior retorno

1. **Deploy fixo do backend com HTTPS** (Fly, Render, Railway ou VM com domínio e túnel nomeado), com `PUBLIC_URL` e `CORS_ORIGENS` apontando para o Pages, no ar até 12/12, e a URL no "Para o júri": H1 6→7 = **+1** (e protege S4 no projeto).
2. **Nova validação ponta a ponta no stack LiveKit atual**, com o LLM real: rodar `scripts/validar_fluxos.py` e substituir `evidence/validacao.md`, citando data e commit. É a prova de que o caminho de voz que o vídeo mostra funciona hoje: H1 +1 se somada ao item 1 (6→7 vira 7→8).
3. **Teste mínimo do `voice_agent.py`** (mapeamento de ferramentas e `_metadata`/`_instrucoes` com fakes) e **segredo compartilhado de volta no `/v1/voice/*`**: H2 8→9 = **+1**. Junto, pôr a linha do vídeo no README, que vale no projeto (S5/H4) e não aqui.

## Observações

- O júri não é de logística. O README já tem glossário (CCO, doca, estadia, franquia) e "Em uma frase", o que é bom. Mas ele tem cerca de 460 linhas e a parte "Para o júri" fica soterrada pelo contrato de API. Vale considerar mover o contrato para `backend/docs/`.
- O README do backend diz "568 testes: 332 no backend, 127 no web, 109 no mobile". Confirmei só os 332.
- O README chama a integração com TMS, rastreador e ERP de fora do escopo ("Integração real com Sascar, Omnilink etc. fica fora"). Está coerente com o que existe. O pitch não deve dizer "integramos".
- A entrega no UNMUTE by Agora reaproveitada no Hack Brasil não aparece no `HACKATHON.md` e não afeta a nota. Se houver dúvida sobre submissão dupla, a pergunta vai para oi@hackbrasil.com.
- Faltam 3d8h. Depois de 30/11 23h59, nenhum commit neste repo até 12/12 (X8).
