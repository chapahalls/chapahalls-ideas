# Judge: rodar-mobile, 2026-11-27 15:28

Gatilho: push na main de rodar-mobile 9d7cc33 por HenryFacens. Commit avaliado: 9d7cc33.

**Nota do repo: 13 / 20** (H1+H2)

Faltam 3d8h para 30/11 às 23h59 (UTC−3). Eliminatórios checáveis por repo: 0 FALHAS, 2 RISCOS (links de demo e de vídeo).

## Alertas

- **RISCO S4/S5:** o README não tem link da demo no ar nem do vídeo de até 3 min. O lugar já está marcado no README: `<!-- Demo publicada e vídeo de 3 min do Hack Brasil: incluir as duas linhas aqui antes de 30/11. -->`. Se a demo cair, o júri avalia pelo vídeo e pelo código (item 7.3). Hoje não há nenhum dos dois neste repo.
- **RISCO H1 (o maior deste repo):** o júri nunca vê a voz real. O `tour.mp4` do README foi "gravado no modo Mock... GPS, recebedor e voz são simulados". A voz Agora e a wake word só rodam no Dev Build com backend por túnel `trycloudflare.com`, e não há APK publicado. Sem isso no vídeo, o diferencial de acessibilidade fica só no texto do README.
- **Texto antigo na tela do app:** `src/assets/locales/pt-BR.json` (linhas 229, 263, 474 e 475) ainda mostra "Sessão GPT-Live ativa" e "agent-server indisponível". Aparece na interface e, portanto, no vídeo. O README foi corrigido, mas a interface não.
- **STATUS desatualizado:** `repos/rodar-mobile/STATUS.md` (commit `28e1569`) dá como entregue a "Voz sem internet: Whisper local (`whisper.rn`, `ggml-small`)", e em "Já entregue" lista "Whisper local para fala sem rede". Esse código não existe mais: não há `whisper` em `src/` nem no `package.json`, e o README diz "Sem rede: nenhum modelo de voz roda no celular". Agora o app grava WAV (`speechSegmenter.ts`) e o servidor transcreve via `POST /rotas/{id}/falas-offline`.
- **STATUS desatualizado (a favor):** o STATUS fala em 86 testes, mas hoje são **98**. Ele cita "endpoints não validam o token" e o README agora descreve JWT do `/auth/sso` em toda escrita, com 403 na rota de outro motorista. Ele pede tirar `agent-server` e "GPT-Live" do README, e isso já foi feito. Falta rodar `/registrar rodar-mobile`.
- **Promessa no README:** a linha "tag `v0.1.0-entrega` quando a entrega for fechada" fala de uma tag que não existe. O júri avalia o último commit até 30/11.

## Saída de `sh scripts/check-rules.sh ../rodar-mobile` (resumo)

- X1 OK (primeiro commit 22/11/2026) · X4 OK (público, não fork) · X3 OK (LICENSE MIT) · X6 OK (sem `.env`, sem credenciais) · X7/X8 OK (main em dia).
- S4/S5: o README tem execução, dependências, o que é simulado e os terceiros. **RISCO:** sem link da demo no ar. **RISCO:** sem link do vídeo de até 3 min.
- Resultado: **0 FALHAS, 2 RISCOS.**

## Checks da CI (rodados aqui no commit 9d7cc33)

| Check | Resultado |
|---|---|
| `npm test` (Vitest) | **98 passaram**, 15 arquivos, 2,6 s |
| `npm run typecheck` | sem erros |
| `npm run lint` | 0 erros, 46 avisos |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 6 | No escopo do app, está completo: login, viagem, retirada por voz, mapa, aviso do recebedor a 8 km, check-in, fila com franquia de 5 h e estadia (R$ 140 na captura), documentos, mensagens e fila offline. Há fallback para Mock quando faltam o módulo nativo, o backend ou a permissão de microfone (`agoraVoiceSession.ts`). O júri não vê nada disso rodando: não há demo nem APK, e o tour é "gravado no modo Mock" com voz simulada. Pela rubrica, "caminho feliz ponta a ponta, vídeo mostra" vale 5-6. Para 7-8 falta algo público e a voz real comprovada. |
| H2 | Implementação técnica | 7 | Camadas claras (`pages → features → services`, só o `index.ts` é público, `agentBus` sem import circular). A integração Agora não é trivial: `aplicarAudioIA` com AEC/AINS, barge-in, renovação de token e parser de stream. A outbox SQLite é FIFO e idempotente, com 409 tratado. Tem i18n e CI com lint, typecheck e testes (98). Contra: `useTrip.ts` tem 1489 linhas e `useVoice.ts` 749, os testes cobrem regras e clientes, mas nenhum hook nem tela, há 46 avisos de lint e nenhum teste de ponta a ponta em aparelho. |
| H3 | Impacto | — | Avaliado no projeto. |
| H4 | Comunicação | — | Avaliado no projeto. |
| | **Total** | **13/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026, 30 commits. O README declara a origem no UNMUTE by Agora (21 e 22/11) e diz que o repo e o histórico começam em 22/11. Isso é coerente com X1/X2 |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Hoje é público. Manter assim até 15/12 |
| X6 | Sem dados pessoais reais | OK | Telefones de exemplo `+55 00 0000-0000` (`route.mock.ts`). Nomes e placas declarados como fictícios |
| — | Segredo no git | OK | Nenhum `.env`, `.keystore`, `google-services.json` ou `.apk` versionado. Só o `.env.example` |
| — | Mocks e terceiros declarados no README | OK | Seções "O que é simulado" e "Dependências e componentes preexistentes" |
| S4/S5 | Links da demo e do vídeo no README | **RISCO** | Ausentes. O comentário de lembrete ainda está no README |

## Maior retorno

1. **Gravar a voz real no celular para o vídeo**: a wake word "Ei AvisAI", a Agora respondendo, um aviso falado com a conversa fechada e o check-in por voz. Colocar o link no README. H1 6→7 = +1. Também é o que dá prova à acessibilidade em H3 e H4, no projeto.
2. **Pôr no README os links da demo (o `/mobile-web` do rodar-web ou outra URL HTTPS fixa) e do vídeo**, e publicar o APK de preview (`eas.json` já tem o perfil `preview`) como Release. Isso fecha os 2 RISCOS de S4/S5, e o app deixa de existir só em vídeo: H1 +1 (com o item 1, 6→8 no máximo, se o backend tiver URL fixa).
3. **Quebrar `useTrip.ts` (1489 linhas) em hooks menores**, com 2 ou 3 testes de hook (chegada → estadia → descarga), e zerar os avisos de lint. H2 7→8 = +1. Junto, trocar "GPT-Live" e "agent-server" nos locales: custa 5 minutos e evita que o júri veja nome da arquitetura antiga na tela.

Tudo isso só até 30/11 às 23h59. De 01/12 a 12/12 o repo fica congelado (X8): nenhum commit.

## Observações

- O `node_modules/` foi instalado localmente para rodar os checks. Está no `.gitignore` e não afeta o repo.
- "524 testes" no README (299 + 127 + 98): confirmei só os **98** deste repo.
- O workflow `judge.yml` usa o secret `IDEAS_DISPATCH_TOKEN` e não expõe nenhum valor. Não conta na rubrica.
- O pacote ainda se chama `avisai-mobile` e o APK `avisai-dev-debug.apk`. O README explica o histórico, então não pesa na nota.
- Nada de voz, GPS ou wake word foi testado em aparelho nesta avaliação: precisa de humano.
