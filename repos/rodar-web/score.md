# Judge: rodar-web, 2026-11-28 11:29

Gatilho: push na main de rodar-web 70a2414 por HenryFacens. Commit avaliado: 70a2414.

**Nota do repo: 14 / 20** (H1+H2)

Desde o score de `18f0e2a` (15/20, 28/11 10:50) entraram 2 commits:

- `41be659` docs(mapa): o README e o `docs/ARQUITETURA.md` agora descrevem o ajuste visual à via pela Routes API. Isso atende a observação do score anterior sobre declarar a Routes API como terceiro. É só documentação.
- `70a2414` (a mensagem não segue o formato convencional): **na Demo, o login agora leva direto a `/dashboard/mobile-demo`**, e o modo API continua indo para `/dashboard`. O commit cria a feature `src/features/receiver-call` com `ReceiverCallPhone`, um celular simulado do recebedor que mostra a ligação de escalonamento com a transcrição do `CallLog`/`buildCall`. No modo integrado, ele abre sozinho quando sai a ligação de escalonamento. No tour público, abre aos 60 min. Há também um botão "Simular ligação ao recebedor" na fila do celular. Tem traduções em pt-BR e en. Não tem teste.

Rodei localmente em `70a2414`, depois de `npm ci`. `npm run typecheck` não deu erros. `npm run lint` checou 169 arquivos sem nenhum aviso. `npm test` passou **146/146**, sem teste novo. `npm run build` passou, com o aviso de chunk acima de 500 kB de sempre. Não rodei o e2e, porque o runner não tem o Chromium do Playwright, e a API do GitHub não respondeu sobre os check runs. Agora, `/home`, `/login`, `/dashboard` e `/mobile-web` em `rodar-web-beta.vercel.app` respondem 200.

`sh scripts/check-rules.sh ../rodar-web`: **0 FALHA, 3 RISCOS**. São o X4, porque a API do GitHub não respondeu (limite ou rede); o S5, sem link do vídeo; e o X6, com possíveis CPF e telefone, que são placeholders (ver abaixo). X1, X3 e X7/X8 estão OK. Faltam 2d12h para 30/11 23h59.

## Alertas

- **O e2e da CI deve quebrar com `70a2414` (verificado por leitura).** `tests-e2e/smoke.spec.ts` entra na Demo e verifica `await expect(page).toHaveURL(/\/dashboard$/)` e depois o heading "Fila de alertas". O modo padrão é `demo` (`src/services/operations/index.ts:14`, `mode: 'demo'`), e o `LoginPage` não navega por conta própria. Quem redireciona é o `LoginRoute`, que agora usa `APP_ROUTES.mobileDemo` (`/dashboard/mobile-demo`) na Demo. Assim, a URL não casa com `/dashboard$`, e o passo "E2E (Playwright, Demo sem backend)" de `.github/workflows/ci.yml` fica vermelho, mesmo com `retries: 1`. Se a `main` estiver assim em 30/11 23h59, o júri avalia um commit com a CI vermelha, e isso não tem conserto depois de 01/12 (X8). O conserto é atualizar o smoke: esperar `/dashboard/mobile-demo` depois do login e então navegar para `/dashboard` antes de checar a fila. Confira o resultado do job no GitHub Actions.
- **RISCO S5 (vídeo):** o README continua sem o vídeo de até 3 min. A linha 39 ainda é `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. É o único item de submissão pendente neste repo e pesa no projeto inteiro (S5/X7).
- **RISCO X4 (checagem):** o script não conseguiu consultar a API do GitHub, mas o `/login` e o resto da demo respondem, e o score anterior confirmou que o repo é público e não é fork. Tudo indica que é falha da checagem, não do repo.
- **O cache negativo da Routes API continua aberto.** Em `src/features/fleet/components/FleetMap.tsx:123`, o `.catch(() => { mapRes.snapping.delete(trip.id); })` não guarda a falha. A próxima atualização volta a chamar `computeRoutes`, o que contradiz a regra "nunca por tick" que agora também está no README (`41be659`). O conserto continua sendo uma linha (`mapRes.snapped.set(trip.id, base)` no `catch`). Só afeta o modo API, que é o modo do vídeo.
- **O modo API continua sem teste de contrato (terceiro score seguido).** Nenhum teste em `tests/` passa um fixture de `/cco/estado` por `isCall` e `projectSnapshot`. `ReceiverCallPhone` e o redirecionamento por modo também entraram sem teste.
- **A ligação ao recebedor é encenação, e o painel precisa dizer isso.** `ReceiverCallPhone` mostra uma transcrição montada no navegador (`buildCall` com `Math.random`), com a tag "Simulação" só no caso do botão. No modo integrado, a ligação "real" de escalonamento também vem do motor da Demo. O item "Ligações" de "O que é simulado" no README cobre isso de forma genérica. Isso não fecha o item do `STATUS.md` "Painel não mostra nem abre o link da ligação ao recebedor (`pagina_recebedor`)": em `RECEBEDOR_MODO=rtc`, ninguém no painel entra na sala. No vídeo, não apresente esse celular como ligação real.
- **X6 (só registro):** `docs/RODAR-telas/.../04-trip-dispatch-cadastro/index.html:79` é um mockup com CPF zerado. `src/assets/locales/dispatch.ts:62,216,292,446` usa `+5511999999999` como exemplo de E.164. São placeholders: **OK**.
- **STATUS desatualizado:** o `STATUS.md` do time para em `18f0e2a`. Não cita `41be659` nem `70a2414`, nem a mudança no destino do login. Também diz que o e2e "passou", o que deve deixar de valer em `70a2414`. Nada marcado **Ok** falta no código. Cabe ao time rodar `/registrar rodar-web`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | A demo pública está no ar (4 rotas em 200), e typecheck, lint, 146 testes e build passam. A mudança é boa para um jurado que não instala nada: na Demo, o login já abre o celular do motorista ao lado do painel. Agora também dá para **ver** o terceiro ator, o recebedor, recebendo a ligação com transcrição, em um clique. Antes, esse elo da história (motorista → recebedor → CCO) era invisível na demo. Não sobe a 9 por vários motivos. Falta o vídeo. A ligação ao recebedor é simulada no navegador. A voz real depende de um backend que o júri não vai configurar. O modo API segue com o defeito de cache da Routes API. E a `main` deve estar com a CI vermelha. |
| H2 | Implementação técnica | 6 | As camadas continuam bem separadas. `receiver-call` é uma feature própria, reaproveita `buildCall` e `CallLog` em vez de duplicar a transcrição, limpa os timers e tem `role="dialog"`/`aria-label`. Cai de 7 para 6 porque `70a2414` mudou o destino do login sem atualizar o smoke e2e que testa exatamente isso: a CI, que era um ponto forte do repo, deve estar vermelha na HEAD. Além disso, a feature nova não tem teste, e os dois pedidos do score anterior (teste de contrato do modo API e cache negativo da Routes API) continuam abertos. Volta a 7 quando a CI estiver verde. |
| H3 | Impacto | avaliado no projeto | Sem nota. O celular do recebedor deixa a dor da informação entre motorista, recebedor e CCO mais concreta na demo. Os números do README têm fonte (IER 2025, CNTA 2025, ANTT). |
| H4 | Comunicação | avaliado no projeto | Sem nota. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **14/20** | Cai 1 em relação ao anterior. A demo ficou mais clara, mas a CI deve ter quebrado e não há teste novo. |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h | OK | Primeiro commit em 22/11/2026 04:22 |
| X2 | Nenhum código privado anterior ao evento | OK | O README declara a origem no UNMUTE by Agora (21 e 22/11) |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | RISCO (checagem) | A API do GitHub não respondeu. Público e sem fork no score anterior. A demo responde |
| X6 | Sem dado pessoal real | OK | CPF zerado e telefones de exemplo, todos placeholders. Nomes e placa (`RST-4B21`) do celular do recebedor são fictícios |
| — | Segredo no git | OK | Nenhum `.env` nem credencial versionados |
| — | Mocks declarados no README | OK | Seção "O que é simulado". Vale citar à parte o celular simulado do recebedor |
| — | Terceiros declarados | OK | Google Maps, Routes API (agora no README, `41be659`), OSRM/OSM, LiveKit, Agora |
| S4 | Link de demo HTTPS no README | OK | `rodar-web-beta.vercel.app` (`/home`, `/login`, `/dashboard` e `/mobile-web` em 200) |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente: a linha 39 ainda é o comentário-lembrete |

## Maior retorno

1. **Pôr a CI de volta no verde agora.** Em `tests-e2e/smoke.spec.ts`, troque a espera por `/\/dashboard\/mobile-demo$/` depois do login e navegue para `/dashboard` antes de checar "Fila de alertas". De quebra, o smoke passa a cobrir o novo destino. Depois, confirme o job verde no Actions. **H2 6→7 = +1**, além de proteger H1 em 30/11.
2. **Gravar o vídeo de até 3 min e pôr o link no README**, no lugar da linha 39. Mostre o modo API com voz real e um aviso de atraso, e use o celular do recebedor como ilustração, rotulado como simulação. Isso fecha o RISCO S5. **H1 8→9 = +1.**
3. **Teste de contrato do modo API mais o cache negativo da Routes API.** Crie um fixture de `/cco/estado` com os motivos `aproximacao`, `cco_sem_resposta` e `atraso` e com `dados.canal`, passando por `isCall` e `projectSnapshot`. Em `FleetMap.tsx:123`, guarde a falha no `catch`. **H2 7→8 = +1** (depois do item 1).

## Observações

- A mensagem de `70a2414` não segue o formato convencional do `/commit` (`feat(demo): ...`). Isso não muda a nota, mas o roadmap gerado depende dos trailers.
- Dois commits de produto a cada hora, a 2,5 dias do prazo, mexendo no login e na tela que mais vai aparecer no vídeo. Vale congelar `MobileWebDemoPage` e `FleetMap` assim que o vídeo for gravado e fazer o último push com a CI verde, com folga antes das 23h59 de 30/11.
- Com o celular do recebedor aberto pelo `useEffect` de escalonamento, ele pode abrir assim que a página monta, se já houver uma ligação de escalonamento no estado compartilhado. Vale conferir antes de gravar.
- Entre 01/12 e 12/12, nenhum commit neste repo (X8). Tudo o que está acima precisa entrar até 30/11 23h59.
