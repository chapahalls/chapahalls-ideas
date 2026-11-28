# Judge: rodar-web, 2026-11-27 21:41

Gatilho: push na main de rodar-web 830d6a4 por HenryFacens. Commit avaliado: 830d6a4.

**Nota do repo: 14 / 20** (H1+H2)

Trilha: avaliado no projeto · Eliminatórios do repo: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d2h para 30/11 23h59

## Alertas

- **CI vermelha na main (novo, regressão de H2):** `830d6a4` reprova no `npm run lint`. O Biome acusa 1 erro, `lint/a11y/noSvgWithoutTitle` em `src/features/tasks/components/TaskPushNotifications.tsx:54`, por causa do ícone de sino sem título. Como o lint é o primeiro passo do `.github/workflows/ci.yml`, typecheck, testes, build e e2e **não rodam na CI** para este commit. Um jurado que abra o repo vê o X vermelho no último commit. A correção leva uma linha: `aria-hidden="true"` no `<svg>`, já que o `<span>` pai é decorativo e o texto está no `<p>`.
- **RISCO S5 (vídeo):** o README continua sem o link do vídeo de até 3 min. A linha 39 ainda tem o comentário `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`.
- **RISCO X6 (só registro):** os pontos que o check-rules aponta (`docs/RODAR-telas/.../04-trip-dispatch-cadastro/index.html:79` e `+5511999999999` em `src/assets/locales/dispatch.ts`) são placeholders de formato. Classifiquei como OK.
- **README contradiz o código (segue igual):** a linha 307 diz "cada segundo real avança um minuto da operação", mas `src/lib/config.ts:16` define `SIM_MINUTES_PER_SECOND = 0.5`.
- **STATUS desatualizado:** `repos/rodar-web/STATUS.md` (verificado em `2368b3c`) registra "lint com 0 avisos" como **Ok**. Em `830d6a4` isso deixou de valer: há 1 erro.

## O que mudou desde 2368b3c (1 commit)

- `830d6a4`: o aviso "ativar notificações" ganhou borda âmbar, anel, sino com `animate-ping`, `role="status"` e mais espaço. A mudança visual é razoável, mas quebrou o lint. O `animate-ping` também não respeita `prefers-reduced-motion`; `motion-safe:animate-ping` resolveria.

Rodei localmente em 830d6a4: `npm test` deu **145/145**, typecheck ok, build ok e o smoke do Playwright passou (1 teste, 2,2 s). O card maior no canto inferior esquerdo não bloqueia o logout nem a troca de idioma. **O `npm run lint` falha, com 1 erro.** A demo na Vercel responde 200 em `/home`, `/login`, `/dashboard` e `/mobile-web`. O deploy da Vercel não depende da CI, então a demo continua no ar.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | Sem mudança. A demo HTTPS está no ar e os links do README respondem 200. O escopo do painel está completo: monitoramento, dispatch, viagem com linha do tempo e transcrição, Análises com CSV, Operador e `/mobile-web`. Os modos Demo e API (REST+SSE) funcionam e o retry é explícito. Não chega a 8 porque o deploy só mostra a Demo fictícia, a voz real não aparece na URL pública e faltam o vídeo, a tela de integrações e o CSV por entrega. A navegação no deploy *precisa de humano*. |
| H2 | Implementação técnica | 7 | A arquitetura continua a mesma: TypeScript strict, features isoladas, guards de contrato, reconciliação REST/SSE, i18n e 145 testes mais o e2e. O 8 anterior, porém, se apoiava em "CI verde com 0 avisos", e o último commit foi para a main com a CI reprovando no primeiro passo. Isso mostra que a CI não está bloqueando merge, porque falta proteção de branch ou status obrigatório. Volta a 8 assim que a CI ficar verde. |
| H3 | Impacto | avaliado no projeto | Sem nota aqui. |
| H4 | Comunicação | avaliado no projeto | Sem nota aqui. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **14/20** | -1 sobre o score de 2368b3c (H2 8→7) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h | OK | Primeiro commit em 22/11/2026 |
| X2 | Nenhum código privado anterior ao evento | OK | A origem no UNMUTE by Agora (21 e 22/11) está declarada |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork |
| X6 | Sem dado pessoal real | OK (RISCO do script conferido) | CPF zerado e telefone E.164 de exemplo; os e-mails da Demo são `.test` |
| — | Segredo no git | OK | Não há `.env` versionado, e o `.env.example` só tem nomes de variáveis |
| — | Mocks declarados no README | OK | Seção "O que é simulado" (com o desvio do relógio citado em *Alertas*) |
| — | Terceiros declarados | OK | OSRM/OpenStreetMap, modelos 3D, Google Maps, Agora, LiveKit, Vercel, Playwright |
| S4 | Links de demo HTTPS no README | OK | Vercel `/home` e `/mobile-web` respondem 200 |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente |

## Maior retorno

1. **Deixar a CI verde de novo:** `aria-hidden="true"` no `<svg>` do `TaskPushNotifications.tsx` e, de quebra, `motion-safe:animate-ping`. Depois, ligar a proteção da `main` com o job de CI obrigatório, para que isso não se repita até 30/11. **H2 7→8 = +1**. São 5 minutos, e é o melhor retorno por esforço de toda a lista.
2. **Linkar no README o vídeo de 3 min mostrando o modo API com voz real** (alerta escalando, assumido no painel, estadia fechando em R$). Isso fecha o S5 e prova que o painel não é só simulação: **H1 7→8 = +1**, além do H4 do projeto.
3. **Ampliar o smoke para o caminho que vende o produto:** relógio em 2x até surgir uma Task, **Assumir**, abrir `/dashboard/trips/:id` e conferir a estadia, com uma asserção que não dependa do tempo. Rodar o mesmo spec contra a URL da Vercel depois do deploy. **H2 8→9 = +1**, com o H1 protegido.

## Observações

- A tela de Integrações (ADR-0001) e a correção do "cada segundo real avança um minuto" no README seguem pendentes desde o score anterior. Pesam na completude (H1) e no H3 do projeto.
- O build ainda avisa sobre chunks acima de 500 kB (three.js), que são carregados sob demanda. Não afeta a nota.
- O `retries: 1` do Playwright na CI pode esconder uma intermitência. Hoje o smoke passou de primeira, localmente.
