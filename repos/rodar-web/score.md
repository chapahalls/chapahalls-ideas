# Judge: rodar-web, 2026-11-27 15:40

Gatilho: push na main de rodar-web b62e17c por HenryFacens. Commit avaliado: b62e17c.

**Nota do repo: 14 / 20** (H1+H2)

Trilha: avaliado no projeto · Eliminatórios do repo: 0 FALHAS, 3 RISCOS · Prazo: faltam 3d8h para 30/11 23h59

## Alertas

- **RISCO S4 (link morto no README): o link do "app do motorista no navegador" ainda dá 404.** O README, na linha 32, aponta para `https://rodarglobal.github.io/rodar-mobile/`, que responde **404 "Site not found · GitHub Pages"** (conferido às 15h40). O link principal foi corrigido: `https://rodar-web-beta.vercel.app/home` responde 200, e `/dashboard`, `/mobile-web` e o bundle `/assets/index-*.js` também respondem 200. Só que o segundo link da mesma linha leva o jurado a uma página de erro. Como `/mobile-web` já está no ar na Vercel, ele pode substituir o link morto.
- **RISCO S5 (vídeo):** o README continua sem o link do vídeo de até 3 min (linha 39: `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`). O tour em MP4 de 1 min 9 s, gravado no modo Demo, não substitui o vídeo da submissão.
- **RISCO X6 (só para registro, sem dado real):** o check-rules aponta o mockup `docs/RODAR-telas/.../04-trip-dispatch-cadastro/index.html:79` e o `+5511999999999` em `src/assets/locales/dispatch.ts`. São placeholders: um CPF zerado e um exemplo do formato E.164 numa mensagem de validação. A Demo usa e-mails `.test`. Classifiquei como OK na tabela.
- **Resolvido desde o score anterior (97886f0):** o deploy duplicado. O `demo-pages.yml` foi apagado, a Vercel ficou como único hospedeiro (`vite.config.ts` com `base: '/'`) e o link "Demo no ar" agora funciona.
- **STATUS desatualizado** (`repos/rodar-web/STATUS.md`, verificado em `dd68e2d` no dia 25/11). Continua **atrás** do código:
  - "Demo HTTPS publicada (S4): Bloqueia, não há deploy": o deploy existe, está na Vercel, responde 200 e é publicado a cada push na main.
  - "Links da demo e do vídeo no README: Bloqueia": a demo já está no README. Falta só o vídeo.
  - "Números de impacto com fonte: Promessa": o README já cita o IER 2025 (11h40 em CD, 5h09) com link.
  - A seção 4 ("Contradições do site") já foi corrigida na home.
  - "127 testes": hoje são **144**. O README também ainda diz "127 no web".
  - Nenhum item marcado **Ok** no STATUS falta no código.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | A demo pública está no ar em HTTPS (`rodar-web-beta.vercel.app`, com `/home`, `/dashboard` e `/mobile-web` respondendo 200) e é publicada a cada push. O escopo do painel está completo: monitoramento, dispatch, viagem com linha do tempo e transcrição, Análises com CSV, Operador e `/mobile-web`. Há os modos Demo e API REST+SSE, e as falhas são tratadas (`ApiError` com timeout, rede e resposta inválida; "Tentar novamente" sem fallback silencioso). Neste push entrou o escalonamento push → painel → ligação na Demo (`ESCALATION_LEVELS` em `services/mock/engine.ts`), alinhado ao backend, com notificação real do navegador (`TaskPushNotifications.tsx`). Localmente, os **144 de 144 testes**, o typecheck e o build passaram. Não chega a 8 por três motivos: o deploy é só o modo Demo, com dados fictícios e sem API real; um dos dois links de demo do README dá 404; e a voz real (LiveKit) exige um backend configurado. Não naveguei a UI num navegador: a navegação no deploy *precisa de humano*. |
| H2 | Implementação técnica | 7 | TypeScript strict, features isoladas que só expõem o `index.ts`, contrato validado com *guards* no client, reconciliação REST/SSE, `React.lazy`, i18n em pt-BR e en, e CI (lint, typecheck, test e build) mais deploy contínuo, agora com um hospedeiro só. A notificação push está bem defendida: checa `typeof Notification`, só dispara para eventos novos e tem `try/catch` para navegadores que bloqueiam. Continua sem teste de UI ou e2e: os 144 testes são de modelo e serviço, em `node:test`. Restam 53 avisos de lint, dois SDKs de voz sem justificativa (Agora RTC no Operador, LiveKit no app) e documentação velha (`/home/henry/Documents/...` em `docs/ARQUITETURA.md:84` e `docs/INTEGRACAO-BACKEND.md:104`; "127 no web" no README). Detalhe de domínio: o evento da Demo usa `channel: 'panel'`/`'call'`, enquanto o tipo da Task usa `'painel'`/`'ligacao'`, com dois vocabulários para a mesma escala. |
| H3 | Impacto | avaliado no projeto | Sem nota aqui. O README traz IER 2025 e CNTA 2025 com fonte e o cálculo de R$ 525 por entrega. |
| H4 | Comunicação | avaliado no projeto | Sem nota aqui. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **14/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h, sem histórico anterior | OK | Primeiro commit em 22/11/2026. Ver a ressalva sobre o commit grande em *Observações* |
| X2 | Nenhum código privado anterior ao evento | OK | O README declara a origem no UNMUTE by Agora (21 e 22/11), depois da abertura |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Repositório público e não é fork |
| X6 | Sem dado pessoal real | OK | CPF e telefone são placeholders; frota, recebedores e motoristas são fictícios, com e-mails `.test` |
| — | Segredo no git | OK | Não há `.env` versionado; o `.env.example` só tem os nomes das variáveis; o deploy roda sem `VITE_API_BASE_URL` |
| — | Mocks declarados no README | OK | A seção "O que é simulado" e a nova seção "CI/CD e deploy" dizem que o deploy é o modo Demo e não chama API real |
| — | Terceiros declarados | OK | OSRM/OpenStreetMap, modelos 3D, Google Maps, Agora, LiveKit e Vercel |
| S4 | Links de demo HTTPS no README | **RISCO** | O link da Vercel funciona, mas o "app do motorista no navegador" (github.io/rodar-mobile) dá 404 |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente |

## Maior retorno

1. **Trocar no README o link morto `rodarglobal.github.io/rodar-mobile/` por `https://rodar-web-beta.vercel.app/mobile-web`**, ou pelo deploy real do mobile se ele existir. Assim nenhum link do README cai em 404 na mão do júri. Custa 2 minutos. Não muda a nota sozinho, mas evita perder o 7 de H1 se o jurado clicar justo nesse link: **H1 protege 7**.
2. **Pôr no README o link do vídeo de 3 min, mostrando o modo API com voz real** (backend no ar, alerta escalando push → painel → ligação, assumido no painel, estadia fechando). O júri passa a ver o painel ligado ao produto real, e não só à simulação: **H1 7→8 = +1**. Também fecha o S5, que pesa no X7 se faltar no painel.
3. **Um smoke test e2e (Playwright) no CI** que entre por `/login`, chegue a `/dashboard` e assuma um alerta na Demo, junto com zerar os 53 avisos de lint, unificar `panel`/`painel` e `call`/`ligacao` e limpar a documentação velha (`/home/henry`, 127→144): **H2 7→8 = +1**.

## Observações

- **Histórico (X1/X2):** o `69afff2` soma cerca de 15 mil linhas 4 h depois da criação do repo. O README explica que o código vem do UNMUTE by Agora (21 e 22/11). Resposta pronta para o júri: "escrito no fim de semana de 21 e 22/11, depois da abertura".
- A notificação push pede permissão logo ao carregar o painel (`Notification.requestPermission()` sem gesto do usuário). Alguns navegadores ignoram ou penalizam esse pedido. Para a demo, é melhor pedir ao clicar.
- O deploy da Vercel mostra só a Demo. Na apresentação, digam que os dados são fictícios, como o README já faz.
- O aviso de chunk acima de 500 kB no build vem do three.js, que é carregado sob demanda. Não afeta a nota.
- O CSV das Análises continua agregado por recebedor e por motorista, sem linha por entrega. Isso depende do backend e conta no H3 do projeto.
