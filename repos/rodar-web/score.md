# Judge: rodar-web, 2026-11-27 21:52

**Nota do repo: 15 / 20** (H1+H2)

Gatilho: push na main de rodar-web, commit avaliado `bac015f`. Comparado com o score de `e6b1683` (14/20, 16:58): 5 commits que executaram as 3 recomendações de "Maior retorno" daquele relatório (`795a62a`, `ea06a9c`, `1eb2088`, `470b018`, `2368b3c`), seguidos de um incidente e duas correções — ver "O que mudou" abaixo.

`sh scripts/check-rules.sh ../rodar-web`: **1 FALHA, 2 RISCOS**. A FALHA (X4, "remote não é GitHub") é falso positivo do script: o remote local usa o alias SSH `git@github.com-pessoal:...`, que não casa com a regex `github\.com[:/]`, mas é o mesmo repositório. Confirmado na API: `GET /repos/rodarglobal/rodar-web` → `full_name: rodarglobal/rodar-web`, `private: false`, `fork: false`, criado em `2026-11-22T04:25:12Z` (depois da abertura). **X4 tratado como OK**, não contei como FALHA.

## O que mudou desde e6b1683

- `795a62a`, `ea06a9c`, `1eb2088`, `470b018`, `2368b3c`: as 3 correções de maior retorno do score anterior (link morto do README, zerar lint, smoke e2e + teste de `setSpeed` + unificar vocabulário de canal) mais uma extra (push só pede permissão após gesto do CCO). Ver `decisoes.md` para o detalhe de cada commit.
- **Incidente, já revertido:** um commit seguinte (`830d6a4`, fora do pedido de quem o gerou) restilizou o aviso de notificações e quebrou o lint (`<svg>` sem título, `lint/a11y/noSvgWithoutTitle`); como o lint é o primeiro passo do `ci.yml`, a CI ficou vermelha e typecheck/testes/build/e2e deixaram de rodar nesse commit. Foi revertido em `3a085b4`; a CI volta a ficar verde a partir daí. Não conto isso contra a nota porque não chegou a ficar a versão final da `main`.
- `bac015f`: corrige uma regressão real que o `1eb2088` introduziu (ver *Alertas*) — devolve `payload.channel` no adaptador do modo API, com teste de regressão novo em `tests/operations.test.mjs`.

Rodei localmente em `bac015f`: `npm run typecheck` sem erros, `npm run lint` **0 avisos**, `npm test -- --run` **145/145**, `npm run build` ok, `npm run test:e2e` **1/1**.

## Alertas

- **Regressão real, já corrigida em `bac015f`:** o commit `1eb2088` (unifica vocabulário `panel`/`call` → `painel`/`ligacao`) tinha removido, em `src/services/operations/adapter.ts`, o campo que levava `event.dados.canal` (nome do backend) para `event.payload.channel` (nome que o resto do código lê). Em modo API isso quebrava a notificação push do navegador (`TaskPushNotifications.tsx` filtra por `payload.channel === 'push'`) e o rótulo de canal na linha do tempo da viagem; não afetava a Demo pública (que já emite `channel` direto em `engine.ts`). `bac015f` devolve o campo e adiciona um teste que falha sem a correção (confirmei rodando o teste contra o adapter sem o fix). Fechado; sem ação pendente.
- **RISCO S5 (vídeo):** README ainda sem o vídeo de até 3 min do Hack Brasil (linha 39, mesmo comentário-lembrete). Fora do controle só deste repo.
- **X6 (só registro, igual ao score anterior):** `docs/RODAR-telas/.../04-trip-dispatch-cadastro/index.html:79` tem um mockup estático com CPF zerado (`000.000.000-00`) e um celular de exemplo (`(19) 9 9650-3307`, DDD de Campinas, coerente com a região fictícia da Demo); `src/assets/locales/dispatch.ts` tem `+5511999999999` como exemplo de formato E.164 numa mensagem de validação. Mantenho como OK (placeholders de mockup/validação, não dado de terceiro).
- **STATUS.md do time bate com o código** (verificado em `bac015f`): nenhum item marcado **Ok** falta no repositório. O incidente `830d6a4`/revert `3a085b4` e a correção `bac015f` já estão registrados em `decisoes.md`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | A demo pública segue no ar (`/home`, `/dashboard`, `/mobile-web` respondem 200). O link morto do app do motorista foi trocado por `/mobile-web` na Vercel. A CI real no GitHub está verde no commit avaliado, e agora inclui um smoke e2e Playwright (login na Demo → painel → troca de idioma → logout) contra o app servido de verdade — a "prova" que faltava para subir de 7. Não chega a 9: falta o vídeo, a demo pública continua só em modo Demo (a voz real depende de um backend que o júri não vai configurar), e a `main` não tem proteção de branch/status obrigatório (o commit `830d6a4` provou isso ao quebrar o lint e ainda chegar à `main` antes do revert). |
| H2 | Implementação técnica | 7 | Dos 5 itens que o relatório anterior listou, todos foram resolvidos de forma verificável: lint zerado (supressões linha a linha, com justificativa), `setSpeed` ganhou teste, os dois SDKs de voz (Agora RTC, LiveKit) têm uma frase explicando os papéis no README, caminhos absolutos saíram da documentação, e o e2e novo roda na CI real. Não sobe para 8 por dois motivos ligados: (1) a unificação de vocabulário introduziu, no mesmo pacote, uma regressão real em código não coberto por teste até então — já corrigida, mas mostra que "mais teste" só cobre o motor da Demo, não o adaptador da API; (2) a ausência de proteção de branch deixou um commit fora do pedido original quebrar a CI na `main` por alguns minutos antes do revert. |
| H3 | Impacto | avaliado no projeto | Sem nota aqui. O README cita IER 2025, CNTA 2025 e ANTT com fonte. |
| H4 | Comunicação | avaliado no projeto | Sem nota aqui. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **15/20** | +1 sobre o score de `e6b1683` (H2 7→8) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h | OK | Primeiro commit em 22/11/2026 01:22 |
| X2 | Nenhum código privado anterior ao evento | OK | README declara a origem no UNMUTE by Agora (21–22/11) |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | `FALHA` do script é falso positivo (alias SSH); confirmado via API do GitHub: público, não é fork |
| X6 | Sem dado pessoal real | OK | CPF zerado, telefones de exemplo/mockup, e-mails `.test` na Demo |
| — | Segredo no git | OK | Nenhum `.env` versionado |
| — | Mocks declarados no README | OK | Seção "O que é simulado" |
| — | Terceiros declarados | OK | OSRM/OpenStreetMap, modelos 3D, Google Maps, Agora, LiveKit, Vercel |
| S4 | Links de demo HTTPS no README | OK | `/home`, `/dashboard`, `/mobile-web` respondem 200; o link morto anterior foi substituído |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente (linha 39 ainda é o comentário-lembrete) |

## Maior retorno

1. **Ligar a proteção da `main`** (status check obrigatório = job de CI) para que um commit que quebra o lint não chegue à `main` de novo, mesmo que revertido minutos depois. Baixo esforço, reforça o H1 8 e o H2 7 contra regressão futura.
2. **Gravar e linkar o vídeo de até 3 min no README**, mostrando o modo API com voz real (o seletor de velocidade da Demo ajuda a cronometrar). Resolve o único S5/S4 pendente deste repo: fecha o alerta e aproxima H1 de 9.
3. **Mais um teste cobrindo o adaptador do modo API** com um fixture de evento com `dados.canal` (além do que `bac015f` já adicionou), e um e2e opcional em modo API: a regressão desta rodada só foi pega depois do push porque a suíte nova cobria a Demo, não o adaptador tocado. **H2 7→8.**

## Observações

- A permissão de notificação (push do navegador) só é pedida após um clique do CCO (`470b018`): correção de UX genuína, reduz o anti-padrão apontado antes.
- A suíte de lint não "desliga regras": as supressões novas (`biome-ignore`) são linha a linha, com justificativa, e uma delas (`LiveCall.tsx`, chave de array na janela deslizante do transcript) corrige um bug real de key instável.
- `docs/rodar-web-o-que-falta.md`, dentro do próprio repositório, ainda registra "127 testes" — é um relatório histórico, datado de 25/11, não linkado pelo README. Não contei como inconsistência de H2.
- O aviso de chunk acima de 500 kB (three.js, `OperatorPage`) continua vindo do carregamento sob demanda; não afeta a nota.
