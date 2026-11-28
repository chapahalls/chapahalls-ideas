# Judge: rodar-web, 2026-11-28 10:08

Gatilho: push na main de rodar-web adea4d5 por HenryFacens. Commit avaliado: adea4d5.

**Nota do repo: 15 / 20** (H1+H2)

Comparado com o score de `bac015f` (15/20, 27/11 21:52), entraram 2 commits:

- `05d559e` fix(tour): o cursor do tutorial do `/mobile-web` não salta mais entre passos (CSS/transição, `MobileWebDemoPage.tsx`).
- `adea4d5` fix(api): o backend passou a registrar ligações com `motivo: "atraso"`, e o guard `isCall` (`src/services/api/client.ts`) só aceitava `aproximacao`/`cco_sem_resposta`. A resposta inteira era rejeitada (`invalid_response`) e **o modo API caía** mesmo com o backend respondendo. O commit corrige o contrato ponta a ponta (`BackendCall.motivo`, `isCall`, `CallLog.moment = 'delay'`, adapter e traduções pt-BR/en em `tripView`, `analytics`, `api.calls.moment`). No mesmo commit vêm duas melhorias de UX: os toasts de alerta (`LiveAlerts.tsx`) passam a ter no máximo 3 visíveis, contador "+N", 1 toast por veículo, placa e `pointer-events-none` no contêiner; o aviso de push (`TaskPushNotifications.tsx`) agora lembra o descarte em `localStorage`.

Rodei localmente em `adea4d5`: `npm run typecheck` sem erros, `npm run lint` com 167 arquivos e **0 avisos**, `npm test` **145/145**, `npm run build` ok (o aviso de chunk acima de 500 kB continua). `npm run test:e2e` **não executou neste ambiente** porque o binário do Chromium do Playwright não está instalado no runner (`browserType.launch: Executable doesn't exist`). É falha de ambiente, não do produto, e não conto contra a nota. Também não consegui ler o status da CI no GitHub (`gh` sem token neste runner).

`sh scripts/check-rules.sh ../rodar-web`: **0 FALHA, 2 RISCOS** (S5 vídeo ausente; X6 possíveis CPF/telefone, ver abaixo). X1, X3 e X4 OK. X7/X8 OK. Faltam 2d13h para 30/11 23h59.

## Alertas

- **RISCO S5 (vídeo):** o README continua sem o vídeo de até 3 min do Hack Brasil. A linha 39 ainda é o comentário-lembrete `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. É o único item de submissão pendente neste repo, e um esquecimento aqui pesa no projeto inteiro (S5/X7).
- **Quebra de contrato com o backend, corrigida em `adea4d5`, de novo sem teste:** é a segunda rodada seguida em que uma mudança de contrato API↔web derruba o modo API e só aparece depois, em uso. Na anterior foi `payload.channel`, que `bac015f` corrigiu com teste de regressão. Desta vez é o enum `motivo`, e o commit **não adiciona teste**: nenhum arquivo de `tests/` mudou, e nada falharia se `isCall` voltasse a rejeitar `'atraso'`. O guard estrito é a escolha certa (falha cedo e visível), mas sem um teste de contrato ele vira um ponto de quebra a cada evolução do backend. Isso pode acontecer na véspera do prazo.
- **X6 (só registro, igual ao score anterior):** `docs/RODAR-telas/.../04-trip-dispatch-cadastro/index.html:79` é um mockup estático com CPF zerado (`000.000.000-00`) e celular de exemplo. `src/assets/locales/dispatch.ts:62,216,292,446` usa `+5511999999999` como exemplo do formato E.164 em mensagens de validação. São placeholders, não dados de terceiros: **OK**.
- **STATUS.md do time desatualizado (leve):** o STATUS registra até `bac015f` e não menciona a correção do motivo `atraso` nem as mudanças de toasts e push. Nada marcado **Ok** falta no código. Cabe ao time rodar `/registrar rodar-web`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 8 | A demo pública está no ar: `/home`, `/dashboard` e `/mobile-web` respondem 200 agora. Typecheck, lint, 145 testes e build passam. `adea4d5` conserta uma falha que derrubaria o modo API assim que o backend registrasse um aviso de atraso, e os toasts deixam de empilhar sobre o painel e bloquear cliques. Essa é exatamente a "falha tratada" que o júri vê na mão dele. Não sobe a 9 por três motivos. Falta o vídeo. A demo pública segue só em modo Demo, e a voz real depende de um backend que o júri não vai configurar. E a falha de contrato desta rodada mostra que o modo API ainda quebra quando o backend evolui. |
| H2 | Implementação técnica | 7 | Camadas bem separadas: guard de resposta tipado em `client.ts`, adapter `projectSnapshot` e tipos de domínio em `ops.ts`. A correção atravessa todas elas de forma coerente, e as chaves i18n novas existem nos dois idiomas. Lint zerado e e2e na CI continuam. Não sobe a 8 porque o padrão de regressão se repete: o score anterior pediu teste do adapter do modo API, e o commit que muda o contrato do adapter e do guard veio sem teste. A suíte de `node:test` cobre bem o motor da Demo, mas o caminho que fala com o backend real segue quase descoberto. |
| H3 | Impacto | avaliado no projeto | Sem nota aqui. O README cita IER 2025, CNTA 2025 e ANTT com fonte. O aviso de atraso ao recebedor reforça o fluxo de informação motorista→recebedor→CCO, que é o centro da trilha. |
| H4 | Comunicação | avaliado no projeto | Sem nota aqui. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **15/20** | Igual ao score de `bac015f`. Há ganho real de robustez em H1, mas não o bastante para 9. H2 fica em 7 pela ausência do teste que o score anterior pediu. |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h | OK | Primeiro commit em 22/11/2026 |
| X2 | Nenhum código privado anterior ao evento | OK | O README declara a origem no UNMUTE by Agora (21 e 22/11) |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público, não é fork (check-rules) |
| X6 | Sem dado pessoal real | OK | CPF zerado, telefones de exemplo e de mockup, e-mails `.test` na Demo |
| — | Segredo no git | OK | Nenhum `.env` nem credencial versionados |
| — | Mocks declarados no README | OK | Seção "O que é simulado" |
| — | Terceiros declarados | OK | OSRM/OpenStreetMap, modelos 3D, Google Maps, Agora, LiveKit, Vercel |
| S4 | Links de demo HTTPS no README | OK | `rodar-web-beta.vercel.app` `/home`, `/dashboard` e `/mobile-web` respondem 200 |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente: a linha 39 ainda é o comentário-lembrete |

## Maior retorno

1. **Gravar e linkar no README o vídeo de até 3 min** (substituir a linha 39), mostrando o modo API com voz real e um aviso de atraso chegando ao painel. Fecha o único RISCO de submissão do repo e é o que falta para H1 chegar a 9, já que o júri não vai rodar o modo API. **H1 8→9 = +1.**
2. **Teste de contrato do modo API** em `tests/`: um fixture de snapshot real do backend, com ligações `aproximacao`, `cco_sem_resposta` e `atraso` e eventos com `dados.canal`, passando por `isCall`/guards e `projectSnapshot`, com asserção de `moment` e `payload.channel`. Duas regressões seguidas no mesmo ponto pedem isso, e o teste protege a demo nas 60h finais, quando o backend ainda deve mudar. **H2 7→8 = +1.**
3. **Proteger a `main` com o job de CI como status obrigatório** (pendente desde o score anterior). A partir de 01/12 não dá mais para corrigir nada, então um commit vermelho na `main` em 30/11 vira a versão que o júri avalia. Isso evita perder ponto em H1 e H2.

## Observações

- O guard `isCall` rejeitar a resposta inteira diante de um valor de enum desconhecido é uma escolha consciente de validação estrita. Ela é boa para H2, mas frágil enquanto backend e web evoluem em paralelo. Uma alternativa pragmática até o congelamento é aceitar um `motivo` desconhecido como `escalation` e registrar um aviso no console, em vez de derrubar a conexão. Fica como sugestão, sem efeito na nota.
- O e2e com Playwright não rodou neste runner porque falta o navegador. No relatório anterior ele passava, e o `ci.yml` do repo instala o Chromium. Vale confirmar no GitHub que o job ficou verde em `adea4d5`.
- `05d559e` (cursor do tour) é polimento de UX da demo pública. Ajuda na primeira impressão do júri, mas não muda a rubrica.
- Entre 01/12 e 12/12 nenhum commit neste repo (X8). Tudo acima precisa entrar até 30/11 23h59.
