# Judge: rodar-web, 2026-11-28 10:50

Gatilho: push na main de rodar-web 18f0e2a por HenryFacens. Commit avaliado: 18f0e2a.

**Nota do repo: 15 / 20** (H1+H2)

Desde o score de `adea4d5` (15/20, 28/11 10:08) entraram 3 commits:

- `042e3d1` fix(alertas): o fundo do toast deixou de ter alfa e agora é opaco (`color-mix` com `ink-900`, em `LiveAlerts.tsx`). É só CSS.
- `15ddd39` fix(alertas): `deriveAlerts` (`src/features/monitoring/model.ts`) deixa uma linha por viagem na fila, a do alerta mais grave. Veio com teste novo em `tests/monitoring.test.mjs`, e o teste antigo foi ajustado para usar viagens distintas.
- `18f0e2a` fix(mapa): no modo API, `FleetMap.tsx` ajusta visualmente o traçado do backend à via pela Routes API do Google. A consulta vai de origem a destino do próprio `trajeto`, com cache por geometria. Distância, ETA, progresso e GPS continuam vindo do backend. A regra 4 do `CLAUDE.md` e o `docs/INTEGRACAO-BACKEND.md` foram atualizados junto, então a mudança de contrato ficou documentada. Não há teste.

Rodei localmente em `18f0e2a`, depois de `npm ci`. `npm run typecheck` não deu erros. `npm run lint` checou 167 arquivos sem nenhum aviso. `npm test` passou **146/146**, um a mais que antes. `npm run build` passou, com o aviso de chunk acima de 500 kB de sempre. Não rodei o e2e, porque o runner não tem o Chromium do Playwright. Agora, `/home`, `/dashboard` e `/mobile-web` em `rodar-web-beta.vercel.app` respondem 200.

`sh scripts/check-rules.sh ../rodar-web`: **0 FALHA, 2 RISCOS**. São o S5, sem link do vídeo, e o X6, com possíveis CPF e telefone (ver abaixo). X1, X3 e X4 estão OK, assim como X7/X8. Faltam 2d13h para 30/11 23h59.

## Alertas

- **RISCO S5 (vídeo):** o README continua sem o vídeo de até 3 min. A linha 39 ainda é `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. É o único item de submissão pendente neste repo. Se ficar de fora, pesa no projeto inteiro (S5/X7).
- **`18f0e2a` volta a consultar a Routes API quando a consulta falha.** Em `getRoadRoute` (`src/lib/googleMaps.ts`), um erro tira a entrada do `routeCache`. O `catch` de `visualRoute` (`FleetMap.tsx`) também tira a viagem de `snapping`, e nada guarda a falha. Assim, a próxima chamada de `visualRoute` dispara outra `computeRoutes`. Essa chamada vem de `updateTrucks`, que roda a cada atualização de dados, e do laço `requestAnimationFrame` quando há progresso ou `dirty`. Se a chave do Google não tiver a Routes API habilitada, ou se a cota acabar, o painel em modo API passa a disparar requisições e `console.warn` em sequência. Isso contradiz a regra "nunca por tick" que o próprio commit escreveu no `CLAUDE.md`. O conserto tem uma linha: guardar a falha, por exemplo com `mapRes.snapped.set(trip.id, base)` no `catch`. A demo pública roda em modo Demo e não aciona esse caminho, mas o vídeo vai gravar o modo API.
- **O modo API ainda não tem teste de contrato.** O score anterior pediu isso pela segunda vez. Nenhum teste chama `isCall` nem `projectSnapshot` com um fixture do backend que traga `motivo: "atraso"` (busquei em `tests/`). O teste novo de `15ddd39` é bom, mas cobre o modelo de alertas, não o guard de resposta.
- **Traçado e marcador podem divergir no modo API (visual).** O caminhão é desenhado no GPS do backend (`trip.position`), mas `splitRoute` corta a linha ajustada à via usando a fração `progress` do backend. Os dois sistemas são diferentes, e o trecho percorrido pode terminar longe do ícone. Não é bug de dado. Mesmo assim, vale conferir antes de gravar o vídeo.
- **X6 (só registro):** `docs/RODAR-telas/.../04-trip-dispatch-cadastro/index.html:79` é um mockup com CPF zerado. `src/assets/locales/dispatch.ts:62,216,292,446` usa `+5511999999999` como exemplo de E.164. São placeholders: **OK**.
- **STATUS desatualizado (leve):** o `STATUS.md` do time para em `042e3d1` e não fala de `15ddd39` nem de `18f0e2a`. Diz "145 testes", e agora são 146. Nada marcado **Ok** falta no código. Cabe ao time rodar `/registrar rodar-web`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | A demo pública está no ar (3 rotas em 200), e typecheck, lint, 146 testes e build passam. A fila de alertas com uma linha por caminhão e o traçado ajustado à via deixam o painel mais legível para um jurado que nunca viu uma doca. Não sobe a 9 por quatro motivos. Falta o vídeo. A demo pública roda só em modo Demo. A voz real depende de um backend que o júri não vai configurar. E o modo API ganhou um novo ponto de falha que não degrada bem (a nova consulta a cada atualização). |
| H2 | Implementação técnica | 7 | As camadas continuam bem separadas. O ajuste à via ficou isolado na apresentação: o dado do backend não é alterado, a biblioteca é carregada à parte só no modo API e a documentação de contrato foi atualizada junto. `15ddd39` trouxe teste de regressão. Não sobe a 8 porque o caminho API↔web segue sem teste de contrato, pedido em dois scores seguidos, e porque `18f0e2a` entrou sem teste e com um defeito de cache negativo que um teste simples teria pegado. |
| H3 | Impacto | avaliado no projeto | Sem nota. Os números do README têm fonte (IER 2025, CNTA 2025, ANTT). |
| H4 | Comunicação | avaliado no projeto | Sem nota. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **15/20** | Igual ao anterior. Há ganho de UX e um teste a mais, mas também um risco novo no modo API. |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h | OK | Primeiro commit em 22/11/2026 |
| X2 | Nenhum código privado anterior ao evento | OK | O README declara a origem no UNMUTE by Agora (21 e 22/11) |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público, não é fork |
| X6 | Sem dado pessoal real | OK | CPF zerado e telefones de exemplo, todos placeholders |
| — | Segredo no git | OK | Nenhum `.env` nem credencial versionados. O log de erro do Google redige a chave |
| — | Mocks declarados no README | OK | Seção "O que é simulado" |
| — | Terceiros declarados | OK | Google Maps já declarado. Vale citar a Routes API, agora usada no modo API |
| S4 | Link de demo HTTPS no README | OK | `rodar-web-beta.vercel.app` (`/home`, `/dashboard` e `/mobile-web` em 200) |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente: a linha 39 ainda é o comentário-lembrete |

## Maior retorno

1. **Gravar o vídeo de até 3 min e pôr o link no README**, no lugar da linha 39. O vídeo deve mostrar o modo API com voz real, um aviso de atraso chegando e o mapa com o traçado na via. Isso fecha o único RISCO de submissão e é o que falta para o júri ver além da Demo. **H1 8→9 = +1.**
2. **Teste de contrato do modo API mais o cache negativo da Routes API.** Em `tests/`, um fixture real de `/cco/estado` com os motivos `aproximacao`, `cco_sem_resposta` e `atraso` e com `dados.canal`, passando por `isCall` e `projectSnapshot`. No `FleetMap`, guardar a falha da consulta de rota. **H2 7→8 = +1.**
3. **Tornar o job de CI obrigatório na `main`.** Um commit vermelho em 30/11 vira a versão que o júri avalia, sem chance de correção depois de 01/12 (X8). Isso protege H1 e H2 de perder ponto.

## Observações

- O ritmo de 3 commits de polimento em 40 minutos, a 2,5 dias do prazo, é bom para a demo. Cada mudança em `FleetMap`, porém, mexe na tela que mais aparece no vídeo. Vale congelar o mapa depois da gravação.
- O README poderia citar o ajuste à via pela Routes API na seção de terceiros e explicar que o traçado é só visual. Isso não muda a nota.
- Entre 01/12 e 12/12, nenhum commit neste repo (X8). Tudo o que está acima precisa entrar até 30/11 23h59.
