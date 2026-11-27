# Judge: rodar-web, 2026-11-27 15:14

Gatilho: push na main de rodar-web 97886f0 por HenryFacens. Commit avaliado: 97886f0.

**Nota do repo: 13 / 20** (H1+H2)

Trilha: avaliado no projeto · Eliminatórios do repo: 0 FALHAS, 3 RISCOS · Prazo: faltam 3d8h para 30/11 23h59

## Alertas

- **RISCO S4 (demo): o link "Demo no ar" do README está morto.** `https://rodarglobal.github.io/rodar-web/` responde **404 "Site not found · GitHub Pages"** (conferido às 15h14). O link do app do motorista, `https://rodarglobal.github.io/rodar-mobile/`, também dá 404. A demo que funciona está em **https://rodar-web-beta.vercel.app** (campo *homepage* do repo): `/`, `/login`, `/dashboard` e `/mobile-web` respondem 200 e os assets carregam. Mas esse endereço não aparece em nenhum lugar do README. Um jurado que segue o README cai numa página de erro do GitHub, e é aí que se perde o H1.
- **RISCO S5 (vídeo):** o README ainda não tem o link do vídeo de até 3 min (linha 38: `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`). O tour de 1 min 9 s em MP4 no repositório não substitui o vídeo.
- **RISCO de deploy duplicado:** `vite.config.ts` usa `base: '/'` para a Vercel, e o workflow `demo-pages.yml` continua publicando com `--base /rodar-web/`. As implantações no ambiente `github-pages` saíram em 27/11 (a de 914cd47 falhou uma vez), e mesmo assim o site do Pages não responde. Escolham um dos dois hospedeiros e apaguem o outro.
- **STATUS desatualizado** (`repos/rodar-web/STATUS.md`, verificado em `dd68e2d` no dia 25/11). Aqui o erro é o inverso do habitual: o STATUS está **atrás** do código.
  - "Demo HTTPS: Bloqueia, não há deploy": já existe um deploy na Vercel. O problema agora é o link, não a falta de deploy.
  - A seção 4 ("Contradições do site") foi corrigida em `src/assets/locales/home.ts`. A home diz "Hoje, as rotas são cadastradas no painel" e "O cálculo não gera comprovante de cobrança", e não fala mais em "ligação gravada".
  - "127 testes": hoje são **143** (o README também diz 127).
  - Nenhum item marcado **Ok** no STATUS falta no código.
- **Pendência de segurança, só informativa:** `X6 OK`. Os achados do check-rules são placeholders fictícios (`000.000.000-00` no mockup e `+5511999999999` como exemplo de E.164), e a Demo usa e-mails `.test`.

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | O escopo do painel está completo: monitoramento, dispatch com cadastro em 4 etapas, viagem com linha do tempo e transcrição, Análises com CSV, Operador e `/mobile-web`. Há dois modos (Demo e API REST+SSE), e as falhas são tratadas (o client usa `ApiError` com `timeout`/`network_error`/`invalid_response`, e o README promete "Tentar novamente" sem fallback silencioso). Lint, typecheck, 143/143 testes e build passaram localmente, e o CI está verde em 97886f0. O que segura a nota em 6 é que o link de demo do README dá 404, a demo pública só mostra dados fictícios e a voz real (LiveKit) exige backend configurado. Com o link certo, a nota vira 7. Não abri a UI num navegador: a navegação no deploy precisa de humano. |
| H2 | Implementação técnica | 7 | TypeScript strict, features isoladas que só expõem o `index.ts`, contrato validado com *guards* em `services/api/client.ts` (timeout com `AbortController`, validação de id e de URL, SSE com fechamento seguro), reconciliação REST/SSE em `services/operations/runtime.ts`, páginas com `React.lazy` (o pacote cai de 2,3 MB para cerca de 330 kB), i18n em pt-BR e en, e o CI roda lint, typecheck, test e build. Faltam teste de UI ou e2e (os 143 testes são de modelo e serviço, em `node:test`). Há 53 avisos de lint, dois SDKs de voz convivem (`agora-rtc-sdk-ng` no Operador e `livekit-client` no app) sem justificativa no README, e a documentação está velha (`docs/INTEGRACAO-BACKEND.md` aponta `/home/henry/Documents/rodar-backend/backend`). |
| H3 | Impacto | avaliado no projeto | Sem nota aqui. O README já traz os números com fonte (IER 2025: 11h40 em CD; CNTA 2025: 91% sem estadia) e o cálculo de R$ 525 por entrega. |
| H4 | Comunicação | avaliado no projeto | Sem nota aqui. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **13/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h, sem histórico anterior | OK | Criado em 2026-11-22T04:25Z, com o primeiro commit às 01:22 (UTC−3) do mesmo dia. Ressalva em *Observações* (commit de 15 mil linhas 4 h depois). |
| X2 | Nenhum código privado anterior ao evento | OK | O README declara a origem no UNMUTE by Agora (21 e 22/11), depois de 04/11. |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | `private: false`, não é fork |
| X6 | Sem dado pessoal real | OK | CPF e telefone são placeholders. A frota, os recebedores e os motoristas da Demo são fictícios, com e-mails `.test` |
| — | Segredo no git | OK | Não há `.env` versionado, e o `.env.example` só tem os nomes das variáveis. O README explica que a chave `VITE_` do Maps é pública e precisa de restrição por referrer |
| — | Mocks declarados no README | OK | A seção "O que é simulado" cobre SSO, GPS, ligações, histórico com seed 42, cobrança e formulários |
| — | Terceiros declarados | OK | OSRM/OpenStreetMap, modelos 3D de terceiros (fora do git), Google Maps, Agora e LiveKit |
| S4 | Link de demo HTTPS no README | **RISCO** | O link aponta para o GitHub Pages, que dá 404. A Vercel funciona, mas não está no README |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente |

## Maior retorno

1. **Trocar no README o link "Demo no ar" para `https://rodar-web-beta.vercel.app`** (ou reativar o Pages) e corrigir o link morto do app do motorista. Se ficarem com a Vercel, apaguem o `demo-pages.yml`. Isso acaba com o 404 na mão do júri e com o risco em S4: **H1 6→7 = +1**. Custa 5 minutos e é o item mais urgente.
2. **Pôr no README o link do vídeo de 3 min, mostrando o modo API com voz real** (backend no ar, alerta assumido no painel, estadia fechando). O júri passa a ver o painel ligado ao produto real, e não só à simulação: **H1 7→8 = +1**. Isso também fecha o S5, que entra no X7 se faltar no painel.
3. **Um smoke test e2e (Playwright) no CI** que abra `/login`, entre com SSO, chegue a `/dashboard` e assuma um alerta na Demo, mais zerar os 53 avisos de lint e atualizar a documentação velha (caminho `/home/henry`, 127→143 testes). Com isso o CI prova que a tela funciona, e não só o modelo: **H2 7→8 = +1**.

## Observações

- **Histórico (X1/X2, para o time ter a resposta pronta):** o `Initial commit` tem 54 arquivos e 1.759 linhas, e o `69afff2` (05:31 do dia 22/11) soma 15.482 linhas em 96 arquivos, 4 h depois da criação do repo. O README explica que o código vem do UNMUTE by Agora (21 e 22/11), que é posterior a 04/11, então não viola o 6.2. Um jurado atento pode perguntar se é "histórico importado". A resposta curta é: "escrito no fim de semana de 21 e 22/11, depois da abertura".
- **Dois SDKs de voz no front:** o Agora RTC atende o fallback do operador (`OperatorPage.tsx`) e o LiveKit faz a voz ao vivo do app (`services/livekit`). Uma frase no README sobre o porquê dos dois evita que o H2 leia isso como indecisão.
- **`docs/PLANO-CONECTORES-TMS.md` se declara "planejamento, nada implementado".** Está correto e honesto, mas o que o ADR-0001 vende (a integração) ainda não aparece em nenhuma tela do painel. Isso conta no H3 do projeto, não aqui.
- O CSV das Análises continua agregado por recebedor e por motorista, sem linha por entrega para o financeiro. Isso depende do backend.
- O aviso de chunk acima de 500 kB no build vem do three.js, que é carregado sob demanda. Não afeta a nota.
