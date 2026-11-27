# Judge: rodar-web, 2026-11-27 16:58

Gatilho: push na main de rodar-web e6b1683 por HenryFacens. Commit avaliado: e6b1683.

**Nota do repo: 14 / 20** (H1+H2)

Trilha: avaliado no projeto · Eliminatórios do repo: 0 FALHAS, 2 RISCOS · Prazo: faltam 3d7h para 30/11 23h59

## Alertas

- **RISCO S4 (link morto no README), igual ao score anterior:** na linha 32, o link "app do motorista no navegador" aponta para `https://rodarglobal.github.io/rodar-mobile/`, que responde **404** (conferido às 16h58). Os demais links funcionam: `rodar-web-beta.vercel.app/home`, `/dashboard` e `/mobile-web` respondem 200. Como o `/mobile-web` já está na Vercel, ele substitui o link morto em 2 minutos.
- **RISCO S5 (vídeo):** o README continua sem o link do vídeo de até 3 min. A linha 39 ainda tem o comentário `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. Faltam 3 dias e 7 horas.
- **X6 (só registro):** o check-rules aponta o mockup `docs/RODAR-telas/.../04-trip-dispatch-cadastro/index.html:79` e o `+5511999999999` em `src/assets/locales/dispatch.ts`. São placeholders: um CPF zerado e o exemplo do formato E.164 numa mensagem de validação. Classifiquei como OK.
- **O que mudou desde b62e17c (3 commits, 47 linhas):** só a velocidade da Demo. O relógio simulado passou de 1 s = 1 min para 2 s = 1 min, e os Controles da demo ganharam o seletor 0.5x/1x/2x (`DemoControls.tsx`, `setSpeed` com validação contra `SIMULATION_SPEED_OPTIONS`, textos em pt-BR e en, `docs/DESIGN.md` atualizado). O ritmo fica mais legível para quem grava o vídeo e para o jurado que abre a demo. O `setSpeed` não tem teste: os testes continuam 144.
- **STATUS desatualizado** (`repos/rodar-web/STATUS.md`, verificado em `b62e17c`): não falta no código nenhum item marcado como **Ok**. O STATUS só não registra o controle de velocidade da Demo. O README e o STATUS ainda dizem "127 no web", mas são **144**.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | A demo está no ar em HTTPS (`/home`, `/dashboard` e `/mobile-web` respondem 200), com deploy contínuo na Vercel. O escopo do painel está completo: monitoramento, dispatch, viagem com linha do tempo e transcrição, Análises com CSV, Operador e `/mobile-web`. Há os modos Demo e API REST+SSE, e as falhas são tratadas com retry explícito. O escalonamento push → painel → ligação aparece na Demo. Neste push, o relógio da simulação ficou mais lento e ganhou o seletor 0.5x/1x/2x, o que ajuda o júri a acompanhar o que acontece. Localmente, os 144 de 144 testes, o typecheck e o build passaram. Não sobe para 8 por três motivos: o deploy é só a Demo com dados fictícios, um dos links de demo do README dá 404 e a voz real depende de backend configurado. A navegação no deploy *precisa de humano*. |
| H2 | Implementação técnica | 7 | TypeScript strict, features isoladas, contrato validado por *guards*, reconciliação REST/SSE, `React.lazy`, i18n e CI (lint, typecheck, test, build) mais deploy contínuo. A mudança nova segue o padrão: constante em `lib/config.ts`, setter validado no store, no-op no runtime da API e `aria-pressed` no grupo de botões. O que segura a nota no 7: nenhum teste de UI ou e2e (os 144 são de modelo e serviço), o `setSpeed` sem teste, 53 avisos de lint, dois SDKs de voz sem justificativa (Agora RTC e LiveKit), `/home/henry/Documents/...` em `docs/ARQUITETURA.md:84` e `docs/INTEGRACAO-BACKEND.md:104`, e dois vocabulários para a escala (`panel`/`call` contra `painel`/`ligacao`). |
| H3 | Impacto | avaliado no projeto | Sem nota aqui. O README cita IER 2025 e CNTA 2025 com fonte. |
| H4 | Comunicação | avaliado no projeto | Sem nota aqui. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **14/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h | OK | Primeiro commit em 22/11/2026 |
| X2 | Nenhum código privado anterior ao evento | OK | O README declara a origem no UNMUTE by Agora (21 e 22/11) |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork |
| X6 | Sem dado pessoal real | OK | CPF e telefone são placeholders, os e-mails da Demo são `.test` |
| — | Segredo no git | OK | Não há `.env` versionado. O `.env.example` só tem nomes de variáveis |
| — | Mocks declarados no README | OK | Seção "O que é simulado" |
| — | Terceiros declarados | OK | OSRM/OpenStreetMap, modelos 3D, Google Maps, Agora, LiveKit, Vercel |
| S4 | Links de demo HTTPS no README | **RISCO** | O link da Vercel funciona. O github.io/rodar-mobile dá 404 |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente |

## Maior retorno

1. **Trocar `rodarglobal.github.io/rodar-mobile/` por `https://rodar-web-beta.vercel.app/mobile-web` no README.** Custa 2 minutos e tira o único 404 que o júri pode encontrar: **H1 protege 7**.
2. **Linkar no README o vídeo de 3 min, mostrando o modo API com voz real** (alerta escalando, assumido no painel, estadia fechando). O seletor de velocidade novo ajuda a gravar a Demo num ritmo legível. Isso fecha o S5 e mostra o painel ligado ao produto real: **H1 7→8 = +1**.
3. **Smoke e2e (Playwright) no CI** cobrindo `/login` → `/dashboard` → assumir um alerta, mais um teste para `setSpeed`, zerar os avisos de lint, unificar `panel`/`painel` e limpar as referências a `/home/henry` e o "127": **H2 7→8 = +1**.

## Observações

- O push novo só mexe no modo Demo, que está bem isolado: o runtime da API recebe `speed: 1` e um `setSpeed` que não faz nada.
- Na velocidade 1x, a Demo agora anda na metade do ritmo anterior. Isso dá mais tempo para ler, mas se a ideia for mostrar uma chegada e uma estadia inteiras em 3 minutos de vídeo, gravem em 2x.
- Continua valendo: a notificação push pede permissão logo ao carregar a página, sem gesto do usuário, e o CSV de Análises é agregado, sem uma linha por entrega (depende do backend e entra no H3 do projeto).
- O aviso de chunk acima de 500 kB vem do three.js, que é carregado sob demanda. Não afeta a nota.
