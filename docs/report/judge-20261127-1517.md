# Judge: RODAR (projeto), 2026-11-27 15:17

Gatilho: push na main de rodar-web 97886f0 por HenryFacens.
Repositórios avaliados: rodar-backend f4a1bbd · rodar-web 97886f0 · rodar-mobile 9d7cc33 · rodar-keycloak de1817a.

**Nota estimada: 22 / 40** (final exige 20) · Trilha: enquadra · Eliminatórios: 0 FALHAS, 2 RISCOS (X7 vídeo, S4 link) · Prazo: faltam 3d8h para 30/11 23h59

A nota passa dos 20 por 2 pontos, e só se o vídeo existir. **Sem o vídeo de 3 min, a submissão fica incompleta (X7) e o projeto é desclassificado.** Com vídeo ruim, H4 fica em 3-4 e o total cai para 19-20.

## Alertas

- **RISCO X7/S5: o vídeo de até 3 min não existe.** Nenhum dos quatro READMEs tem o link; os três de produto ainda guardam o comentário `<!-- Vídeo de 3 min ... antes de 30/11 -->`. Os tours de 1 min em MP4 ajudam, mas não são o entregável. Sem vídeo no painel, a submissão não é completa.
- **RISCO S4: todo link "Demo no ar" dos READMEs dá 404.** Conferido às 15h17: `https://rodarglobal.github.io/rodar-web/` e `https://rodarglobal.github.io/rodar-mobile/` respondem 404, e é para eles que aponta o *Para o júri* do rodar-backend. A demo que funciona está em `https://rodar-web-beta.vercel.app` (`/`, `/dashboard` e `/mobile-web` respondem 200), mas esse endereço não aparece em nenhum README. Um jurado que siga o README de qualquer repo cai numa página de erro do GitHub.
- **H1: a voz do app nativo está quebrada contra o backend atual.** O backend trocou Agora por LiveKit em `774e5c2` (`POST /sessions` agora devolve `livekit_url`, `identity` e `token`, sem `app_id`). O rodar-mobile continua só com `react-native-agora` e lança `'POST /sessions retornou sem app_id ou token da Agora'` (`src/features/voice/api/agoraVoiceSession.ts:138`). O diferencial do pitch, que é o motorista falando com o agente no app, não funciona ponta a ponta hoje. A voz ao vivo só existe pelo LiveKit do rodar-web (`/mobile-web`, com backend configurado).
- **Backend sem URL pública fixa.** Ele sobe por túnel cloudflared numa máquina ligada, e a URL muda a cada reinício. A demo no ar (Vercel) é só o modo Demo, com dados fictícios e voz sintetizada no navegador. Na demo, o júri não vê a IA de voz real nem a estadia contada pelo backend.
- **Números conflitantes entre READMEs.** O backend diz "568 testes: 332 + 127 + 109", o mobile diz "524: 299 + 127 + 98" e o web tem 143. Conferido agora: **backend 332** (pytest com Postgres 16, ruff limpo), **mobile 98** (vitest) e **web 143** (score.md do rodar-web, mesmo commit). O total real é **573**. Um jurado de dados vai notar que nenhum dos números bate.
- **`evidence/validacao.md` (33/33) é anterior à troca para LiveKit.** O backend admite isso ("validação histórica"), mas o README do mobile ainda a apresenta como "validação com a API real".
- **STATUS desatualizado.** `repos/rodar-backend/STATUS.md` (b353d12, 25/11) diz que JWT e papel `cco` estão "desligados por padrão", que o projeto usa Agora ConvoAI e que há 299 testes. Hoje `AUTH_OBRIGATORIA=true` é o padrão, a voz é LiveKit com Gemini Live e são 332 testes. `repos/rodar-mobile/STATUS.md` (28e1569) marca "Conversa por voz em tempo real: **Ok**" via `AgoraVoiceSession`, e isso deixou de ser verdade depois da troca de provedor no backend. `repos/rodar-web/STATUS.md` está atrás do código (ver o score.md dele).
- **Score de repo ausente:** `repos/rodar-backend/score.md` e `repos/rodar-mobile/score.md` dizem "ainda não avaliado". Conferi os dois repos eu mesmo e estimei as notas abaixo. O rodar-keycloak não tem pasta em `repos/`.

## Nota por repositório

| Repo | Commit | H1 | H2 | Total /20 | Fonte |
|---|---|---|---|---|---|
| rodar-backend | f4a1bbd | 6 | 8 | **14** | conferido agora: 332 testes passaram, ruff limpo. Portas e adaptadores, JWT obrigatório por padrão, papel `cco`, dono da rota e LiveKit Agents com Gemini Live. Não tem deploy público, e a validação ponta a ponta é anterior ao LiveKit |
| rodar-web | 97886f0 | 6 | 7 | **13** | `repos/rodar-web/score.md`, de 15h14 do mesmo commit |
| rodar-mobile | 9d7cc33 | 4 | 6 | **10** | conferido agora: 98 testes passaram. O modo Mock é completo, mas a voz real está quebrada contra o backend atual. Não há demo própria (o link do Pages dá 404) e o README fala de pilha antiga |
| rodar-keycloak | de1817a | 4 | 6 | **10** | o CI sobe um Keycloak real e faz login PKCE, e há ADR. Mas nada o usa: web, mobile e backend seguem com o SSO MOCK (`/auth/sso`). Roda só local |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | Existe uma demo HTTPS de verdade no ar (`rodar-web-beta.vercel.app`): site, painel e `/mobile-web` respondem 200, com o caminho feliz completo no modo Demo. O backend implementa o fluxo inteiro (aproximação → Task → estadia → escalonamento → recebedor → descarga) e tem 332 testes verdes. O que segura a nota em 5: os READMEs levam a 404, a demo pública é toda simulada, o backend só existe por túnel e a voz do app nativo não conecta ao backend atual. *Precisa de humano:* navegar na demo e ver se o vídeo mostra a voz real. Com o link certo, a nota provável é 6; com vídeo mostrando voz real e estadia fechando, 7 |
| H2 | Implementação técnica | 7 | Backend com portas e adaptadores (`app/portas.py`, `app/integracoes/`), testes com fakes, JWT HS256 com segredo mínimo, autorização por papel e por rota, e limite de ligações. Front com TypeScript strict, features isoladas, contrato validado e SSE reconciliado. São 573 testes conferidos, há CI nos quatro repos e o Keycloak tem smoke test real no CI. O que tira ponto: a troca de provedor de voz 4 dias antes do prazo deixou o mobile incompatível, há três SDKs de voz no projeto (Agora no mobile e no Operador, LiveKit no backend e no web), o Keycloak não está ligado a nada e as contagens se contradizem |
| H3 | Impacto | 7 | O problema está em uma frase, dentro da trilha: o caminhão parado na doca e a informação entre motorista, recebedor e CCO. O README traz fonte brasileira (IER 2025: 5h09 de média e 11h40 em CD na Grande SP; CNTA 2025: 91% sem estadia) e benefício em R$ (R$ 525 por entrega; cerca de R$ 113 mil por mês numa frota de 50, estimativa declarada). Não chega a 8 porque não há piloto nem usuário real, e o que o ADR-0001 diz vender (integração com TMS, rastreador e ERP) é só plano (`docs/PLANO-CONECTORES-TMS.md`) |
| H4 | Comunicação | 3 | *Precisa de humano.* O vídeo de 3 min não existe. O que se vê hoje são dois tours mudos de 1 min no modo Mock e READMEs bons, com glossário para quem não é de logística. Nota provável com um vídeo que explique a doca em uma frase, mostre voz real e feche com o R$ da estadia: 6-7 |
| | **Total** | **22/40** | Passa dos 20 por pouco. A nota depende inteira do vídeo |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repos públicos, criados depois de 04/11 21h | OK | 1º commit em 22/11 (backend, web e mobile) e em 26/11 (keycloak). Nenhum é fork |
| X2 | Sem código privado anterior | OK (ressalva) | Origem declarada: UNMUTE by Agora, 21 e 22/11, depois da abertura. No web há um commit de 15 mil linhas 4 h depois da criação. Tenham a resposta pronta: "escrito em 21 e 22/11" |
| X3 | Licença | OK | MIT nos quatro |
| X4 | Públicos até 15/12 | OK | Não arquivar nem tornar privado antes de 15/12 |
| X5 | Temas proibidos | OK | — |
| X6 | Sem dado pessoal real | OK | Os telefones apontados pelo check-rules são placeholders fictícios (padrão `9000000x` e `+5511999999999`), os e-mails são `.test` e o SVG do keycloak é falso positivo. Nenhum `.env` está versionado |
| X7 | Submissão completa até 30/11 23h59 | **RISCO** | Falta o vídeo (S5), e o link de demo dos READMEs está errado (S4) |
| X8 | Nenhum commit de 01/12 a 12/12 | OK até agora | Atenção à CI do judge e a merges automáticos: nada pode ir para a main de nenhum repo de código entre 01 e 12/12 |
| X9 | Time de 1 a 4, todos na final | precisa de humano | Os quatro (Jeferson, Henry, Lucas e Eduardo) aparecem nos commits. Conferir no painel e garantir que os quatro estejam presentes em 12/12 |
| X10 | Enquadramento | OK | O pitch fala de doca, estadia e fluxo de informação. "Mãos no volante" no mobile deve continuar como acessibilidade e não virar discurso de segurança no vídeo |

## Submissão

| # | Item | Status |
|---|---|---|
| S1 | Nome, frase e descrição no painel | precisa de humano |
| S2 | Trilha Logística & automação | OK (declarada nos READMEs). Confirmar no painel |
| S3 | Link de cada repositório | precisa de humano. Incluir também o **rodar-keycloak**, se ele for parte da entrega (o HACKATHON.md lista três) |
| S4 | Demo HTTPS no ar | **RISCO**. `rodar-web-beta.vercel.app` funciona; os links dos READMEs (Pages) dão 404. Use a Vercel no painel e nos READMEs |
| S5 | Vídeo de até 3 min, sem login | **FALTA** (precisa de humano) |
| S6 | Aceite do regulamento | precisa de humano |

## Maior retorno

1. **Gravar e publicar o vídeo de 3 min** (YouTube não listado ou Drive aberto) e pôr o link nos quatro READMEs e no painel. Roteiro: a doca em uma frase para quem não é de logística, depois o 11h40 da Grande SP, a voz real (LiveKit, pelo caminho que funciona hoje), o recebedor avisado, a Task no painel, a estadia fechando em R$ e os R$ 525 por entrega no fim. Isso tira o risco de X7: **H4 3→6 = +3**, e mostrar a voz real puxa **H1 5→6 = +1**.
2. **Trocar todo link `rodarglobal.github.io/...` pela Vercel** nos READMEs do backend, web e mobile (e no keycloak, que não tem link), e apagar o `demo-pages.yml` ou fazer o Pages voltar a responder. Custa 10 minutos e evita que o jurado chegue num 404: **H1 +1** (ou deixa de perder 1). Unificar a contagem de testes (573 = 332 + 143 + 98) nos mesmos READMEs vale para **H2**, porque o júri de dados confere número.
3. **Religar a voz do app ao backend:** portar `agoraVoiceSession` para o LiveKit (o backend já entrega `livekit_url`, `identity` e `token` em `POST /sessions` e em `GET /token`). Se não der até 30/11, declarar no README do mobile que a voz ao vivo da entrega é a do `/mobile-web` e que o app nativo está no modo Mock. É o diferencial de acessibilidade que está desligado: **H1 +1, H2 7→8 = +1**. Junto, publicar o backend numa URL fixa (Render, Fly ou Railway) com o painel da Vercel no modo API, para o júri ver a estadia real e não só a simulação.

## Observações

- O Keycloak tem boa engenharia (Organizations por transportadora, PKCE, CI com login real), mas não está ligado a nenhum outro repo. No vídeo e nos slides, chamem de "identidade pronta para o setup", não de "login do produto".
- O backend usa Gemini Live pelo LiveKit Inference. O CLAUDE.md e o ADR-0001 ainda citam a Agora como pilha de voz. Para a final, registrem a troca num ADR (`/adr`); isso não muda a nota online.
- Os repos estão congelados de 01/12 a 12/12. Depois do prazo, só slides, roteiro, ensaio e manter a Vercel (e o backend, se for publicado) no ar.
- A final zera as notas. Na apresentação de 12/12, a voz ao vivo com um recebedor atendendo é o que diferencia o projeto, e precisa funcionar no app.
