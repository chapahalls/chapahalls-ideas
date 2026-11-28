# Judge: rodar-mobile, 2026-11-28 01:07

Gatilho: push na main de rodar-mobile 91ad99e por HenryFacens. Commit avaliado: 91ad99e.

**Nota do repo: 12 / 20** (H1+H2)

Faltam 2d22h para 30/11 às 23h59 (UTC−3). Eliminatórios checáveis por repo: 0 FALHAS, 3 RISCOS (demo fora do ar, vídeo ausente, voz real provavelmente quebrada no Dev Build). Nota anterior: 13/20 (commit `9d7cc33`).

## Alertas

- **RISCO S4 (novo, o mais urgente):** o link da demo no README, `https://rodarglobal.github.io/rodar-mobile/`, devolve **404 "Site not found · GitHub Pages"** (conferido 3 vezes nesta execução; `rodarglobal.github.io/rodar-web/` também dá 404). O `check-rules.sh` marcou "OK link de demo HTTPS" porque só confere se o link existe no texto, não se ele abre. O próprio `demo-pages.yml` avisa: "Precisa, uma vez: Settings → Pages → Source: GitHub Actions". Se o júri clicar hoje, cai numa página de erro do GitHub. Se o deploy só estiver em andamento por causa do push de 01:07, alguém precisa confirmar que o link abre.
- **RISCO H1 (voz real provavelmente não funciona):** a migração para LiveKit trocou o `react-native-agora` por `@livekit/react-native` + `@livekit/react-native-webrtc`, mas o `app.config.ts` **não tem o plugin Expo do LiveKit** (`@livekit/react-native-expo-plugin`) nem o `@config-plugins/react-native-webrtc`, e não há pasta `android/` versionada. O README do `@livekit/react-native` exige `LiveKitReactNative.setup(...)` no `MainApplication.onCreate` do Android, "acima de qualquer outra inicialização do RN", e diz que no Expo quem faz isso é o plugin. Sem ele, o `expo prebuild` do Dev Build gera um app sem essa configuração de áudio. O próprio commit admite: "o fluxo real de voz (LiveKit) não pôde ser testado em dispositivo real". Hoje não há nenhuma prova de que o diferencial de acessibilidade (conversa por voz real) funciona neste commit. Isso precisa de um humano com o celular.
- **RISCO S5:** o README não tem o link do vídeo de até 3 min. O lembrete continua na linha 38: `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->`. O `tour.mp4` (1 min) foi "gravado no modo Mock... voz simulada".
- **Troca Agora → LiveKit: declarações em dia.** O README cita o LiveKit em "Dependências e componentes preexistentes" (`@livekit/react-native ^3.2.0`, `@livekit/react-native-webrtc ^150.2.0`, `livekit-client ^2.25.0`), em "O que é simulado" (`LiveKitVoiceSession` com fallback para Mock), nas variáveis (`EXPO_PUBLIC_VOICE_MODE=livekit`), nos endpoints e nas decisões técnicas. Não sobrou nenhum `react-native-agora`, `AgoraVoiceSession` nem `voice.agora*` no código, nos locales ou na documentação. A Agora só aparece como origem histórica (hackathon UNMUTE by Agora), o que é coerente com X1/X2. Também saíram dos locales as strings "GPT-Live" e "agent-server" que o score anterior apontou.
- **STATUS desatualizado:** `repos/rodar-mobile/STATUS.md` (commit `28e1569`, 25/11) dá como **Ok** a "Conversa por voz em tempo real: `AgoraVoiceSession` (`react-native-agora`)". Esse código foi removido neste commit. O STATUS também lista como entregue o "Whisper local (`whisper.rn`, `ggml-small`)", que já não existe: o README diz que o time decidiu não rodar modelo no aparelho, e o áudio é transcrito no servidor. Os números também mudaram: o STATUS fala em 86 testes e o código tem **130**. Falta rodar `/registrar rodar-mobile`.
- **README com número desatualizado:** a linha 34 diz "109 no mobile" e "554 testes". Neste commit são **130** no mobile (a favor do time, mas o júri que contar não vai bater). A linha 452 ainda fala da "tag `v0.1.0-entrega` quando a entrega for fechada", que não existe.

## Saída de `sh scripts/check-rules.sh ../rodar-mobile` (resumo)

- X1 OK (primeiro commit em 22/11/2026 04:22) · X4 OK (público, não fork) · X3 OK (LICENSE) · X6 OK (sem `.env`, sem padrão de credencial) · X7/X8 OK (main em dia com o remote) · Prazo OK (faltam 2d22h).
- S4/S5: execução, dependências, link de demo HTTPS (só a presença), simulado e terceiros OK. **RISCO:** sem link do vídeo de até 3 min.
- Resultado: **0 FALHAS, 1 RISCO.** Esta avaliação acrescenta 2 RISCOS que o script não vê: a demo dá 404 e a voz real não tem o setup nativo.

## Checks da CI (rodados aqui no commit 91ad99e)

| Check | Resultado |
|---|---|
| `npm test` (Vitest) | **130 passaram**, 19 arquivos, 3,2 s |
| `npm run typecheck` | sem erros |
| `npm run lint` | 0 erros, **0 avisos** (eram 46) |

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 5 | O escopo do app continua completo no modo Mock: login, viagem, retirada por voz simulada, mapa, aviso a 8 km, check-in, fila com franquia e estadia (R$ 140 na captura), documentos e fila offline, com fallback para Mock quando falta módulo nativo, backend ou microfone (`livekitVoiceSession.ts`, linhas 116-126). Cai de 6 para 5 por três motivos. A demo linkada no README dá 404. O vídeo do repo é Mock, com voz simulada. E a voz real foi reescrita a 2 dias do prazo sem teste em aparelho e sem o plugin nativo que o LiveKit exige no Android. Pela rubrica, "caminho feliz ponta a ponta, vídeo mostra" vale 5-6. Hoje só o tour Mock mostra isso. |
| H2 | Implementação técnica | 7 | Melhorou em qualidade: 130 testes (eram 98), incluindo `livekitRealtime.test.ts` (mapeamento de `lk.agent.state`, privacidade da transcrição, health), lint sem nenhum aviso e o contrato `VoiceSession`/`voiceFactory` mantido. A troca de provedor coube num commit só, o que mostra que a camada de voz está bem isolada. A sessão LiveKit é limpa: `registerGlobals` uma vez, `AudioSession` aberta e fechada, `lk.transcription` descartado por `VOICE_PRIVACY` e encerramento idempotente. Não sobe para 8 por três motivos. Falta o setup nativo do LiveKit (é uma integração mal usada até prova em contrário). `useTrip.ts` cresceu para 1510 linhas e `useVoice.ts` para 764. Os testes continuam sem cobrir hooks e telas. |
| H3 | Impacto | — | Avaliado no projeto. |
| H4 | Comunicação | — | Avaliado no projeto. |
| | **Total** | **12/20** | |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h, sem fork | OK | Primeiro commit em 22/11/2026. A origem no UNMUTE by Agora (21 e 22/11) está declarada no README |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Hoje é público. Manter assim até 15/12 |
| X6 | Sem dados pessoais reais | OK | O diff do commit não traz telefones, e-mails nem CPF. Os perfis são declarados como fictícios |
| — | Segredo no git | OK | Nenhum `.env` versionado. O `.env.example` só tem os nomes das variáveis |
| — | Mocks e terceiros declarados no README | OK | O LiveKit já aparece em "Dependências" e em "O que é simulado". A Agora só aparece como histórico |
| S4 | Link da demo no README | **RISCO** | O link existe, mas devolve 404 ("Site not found") |
| S5 | Link do vídeo no README | **RISCO** | Ausente. O lembrete está na linha 38 |

## Maior retorno

1. **Pôr a demo no ar de verdade.** Ativar Settings → Pages → Source: GitHub Actions nos dois repos, rodar de novo o `Demo (GitHub Pages)` por `workflow_dispatch` (não precisa de commit) e confirmar que `rodarglobal.github.io/rodar-mobile/` abre no celular. Isso fecha o RISCO S4: H1 5→6 = +1.
2. **Fazer a voz LiveKit funcionar no celular e gravar a prova.** Adicionar `@livekit/react-native-expo-plugin` e `@config-plugins/react-native-webrtc` ao `plugins` do `app.config.ts`, gerar o Dev Build, testar uma conversa de ponta a ponta (wake word "Ei AvisAI", o agente respondendo, check-in por voz) e pôr esse trecho no vídeo de 3 min, com o link na linha 38 do README. Se isso falhar até 29/11, voltar para o modo que funciona e declarar a voz real como "em teste". H1 6→7 = +1. É também a prova de acessibilidade de que H3 e H4 dependem no projeto.
3. **Alinhar os números e as promessas do README:** 130 testes no mobile (e não 109), remover a frase da tag `v0.1.0-entrega` e rodar `/registrar rodar-mobile` para o STATUS deixar de citar Agora e Whisper. Não muda a nota sozinho, mas evita que o júri perca a confiança ao conferir. Se sobrar tempo, quebrar `useTrip.ts` e escrever 2 ou 3 testes de hook: H2 7→8 = +1.

Tudo isso até 30/11 às 23h59. De 01/12 a 12/12 o repo fica congelado (X8): nenhum commit.

## Observações

- O `node_modules/` foi instalado aqui (`npm ci --ignore-scripts`) só para rodar os checks. Está no `.gitignore` e não afeta o repo.
- O commit chegou à main pelo `dev` (`da468ad`, `a221970`). O histórico tem merge commits, e não squash, então os trailers do roadmap estão preservados.
- Não testei a disponibilidade do GitHub Pages pelo `gh` (sem token nesta CI). O 404 veio de `curl` com o corpo "Site not found · GitHub Pages".
- O README fala em "cancelamento de ruído da cabine prontos" no LiveKit. No LiveKit, o cancelamento de ruído depende do plugin do agente no backend. Este repo não tem como provar isso, e a afirmação não pesa na nota.
- Voz, wake word e GPS não foram testados em aparelho nesta avaliação: precisa de humano.
