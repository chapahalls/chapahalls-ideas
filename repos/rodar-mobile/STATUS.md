# rodar-mobile: o que falta, contra o que prometemos

28/11/2026 · commit verificado: `bafa041` (local, não enviado ainda para o remoto de [rodarglobal/rodar-mobile](https://github.com/rodarglobal/rodar-mobile); base `abe0ce7`).

**O que prometemos** está em [`ADR-0001`](../../docs/adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../../HACKATHON.md). Relatórios dos outros repos: [`rodar-backend`](../rodar-backend/STATUS.md) e [`rodar-web`](../rodar-web/STATUS.md).

O app é onde mora o **diferencial de acessibilidade**: o motorista fala, não digita, e não toca na tela dirigindo. Por isso este relatório pesa mais a seção 2.

**Como conferi:**
- Revisei todas as branches/PRs abertas do repositório (mescladas ou descartadas conforme o conteúdo), sincronizei `main`↔`dev` e apaguei as branches obsoletas do remoto.
- Migrei a voz real de **Agora para LiveKit** (o `rodar-backend` migrou 100% para LiveKit; a integração `react-native-agora` do app ficou incompatível com o contrato atual) e conferi o contrato HTTP/voz contra o backend (`schemas.py`, `agentes.py`, `compat.py`, `main.py`).
- Li o código (`src/features/voice`, `src/services`, `src/pages`) e o README.
- Rodei os checks do CI localmente:

| Check | Resultado |
|---|---|
| `npm test` (Vitest) | **133 passaram** em 19 arquivos |
| `npm run typecheck` | Sem erros |
| `npm run lint` | Sem erros, **0 avisos** |

Não reconferi os números de teste do backend e do web nesta passada (ficaram como estavam no README do mobile: 318 e 127); o total do README do mobile foi corrigido para **575** (318 + 127 + 130).

**O que não testei:** o app num celular ou em Dev Build real. A migração para LiveKit (`@livekit/react-native`), a wake word, o GPS real e a gravação da fala sem rede não puderam ser exercitados num dispositivo — só por tipo, lint e teste unitário (mocks). Também não testei o login via Keycloak (OIDC+PKCE) nem o modo direção visualmente.

Legenda:
- **Bloqueia:** ameaça a submissão ou o primeiro desempate (H1).
- **Promessa:** está no pitch ou no ADR e não existe.
- **Parcial:** existe, mas menor que o prometido.
- **Ok:** entregue no código (não testei em aparelho).

## Resumo: o que fazer até 30/11 às 23h59

| # | O que falta | Por que importa | Esforço |
|---|---|---|---|
| 1 | **Gravar o vídeo de 3 min do Hack Brasil** e colar o link no README (linha com o comentário `<!-- Vídeo de 3 min... -->`): voz pelo LiveKit, wake word e um aviso com a conversa fechada | O júri não instala nada. A demo web ([rodarglobal.github.io/rodar-mobile](https://rodarglobal.github.io/rodar-mobile/)) e o tour (`docs/assets/readme/tour.mp4`) já existem, mas são do modo Mock; falta o vídeo com o app real e a voz LiveKit | Médio (precisa do backend no ar e de um Dev Build/APK) |
| 2 | **Testar a migração para LiveKit num Dev Build real** | A sessão de voz (`LiveKitVoiceSession`, `@livekit/react-native`) só foi validada por tipo/lint/teste unitário com mocks; nunca rodou contra um `Room` LiveKit de verdade, num dispositivo | Médio–Alto (precisa de APK/Dev Build + backend com LiveKit configurado) |
| 3 | **Criar a tag `v0.1.0-entrega`** quando a entrega for fechada (README linha final) | O Hack Brasil avalia o último commit até 30/11 23h59; a tag é só decorativa, mas o README promete criá-la | Baixo |
| 4 | **Um teste rápido de voz em cabine real** (ruído do motor, rádio, sotaque) | É a promessa central de acessibilidade, e nunca foi testada fora da mesa | Médio |
| 5 | **Prova da espera para o próprio motorista** (compartilhar o resumo da estadia) | O `RODAR-CONTEXT.md` diz que "a prova é dele também"; hoje ele vê o tempo, mas não leva nada consigo | Baixo a médio |

Se só der para fazer dois, faça 1 e 2 — o vídeo e um teste real da voz LiveKit são o maior risco restante (ver "Bloqueia" abaixo).

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Ver o app sem instalar | **Ok** | O app real do motorista está publicado em [rodarglobal.github.io/rodar-mobile](https://rodarglobal.github.io/rodar-mobile/) (modo Mock, `scripts/web-demo/build.sh`, workflow `demo-pages.yml` a cada push na `main`), mais o tour gravado (`docs/assets/readme/tour.gif`/`tour.mp4`) | A voz real (LiveKit) ainda não roda no navegador; a demo publicada é só o modo simulado |
| APK para download | **Promessa (opcional)** | O README ensina a gerar `build/avisai-dev-debug.apk`, mas não há APK publicado (o `.apk` está no `.gitignore`) | Não priorizado; o júri não é obrigado a instalar |
| Links da demo e do vídeo no README | **Parcial** | Demo web e tour (1 min) já estão linkados no topo do README; falta só o vídeo de 3 min do Hack Brasil (comentário `<!-- Vídeo de 3 min... -->` ainda no README) | Vídeo com o app real (voz LiveKit, wake word) ainda não gravado |
| Conexão com o backend | **Parcial** | Feita pela URL de um túnel `trycloudflare.com` colada no app, que muda a cada reinício do backend | Não há backend publicado com URL fixa (ver o relatório do backend) |
| Qualidade (CI, testes, tipos) | **Ok** | Conferido acima (130 testes, typecheck e lint sem erros/avisos) | — |

## 2. Acessibilidade: o diferencial

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Conversa por voz em tempo real | **Parcial** | `LiveKitVoiceSession` (`@livekit/react-native` + `livekit-client`, migrado de Agora porque o backend passou a usar LiveKit): entra na sala via `Room.connect`, mapeia `lk.agent.state` para o estado visual, usa `ActiveSpeakersChanged`/`audioLevel` para volume, barge-in tratado pelo próprio agente, Mudo e Encerrar | Reescrita nesta sessão só por tipo/lint/teste unitário; **nunca rodou contra um `Room` LiveKit real num dispositivo** |
| Começar sem tocar na tela | **Parcial** | Wake word "Ei AvisAI" (`services/wakeWord.ts`). Só no Android e no Dev Build; usa o reconhecimento do Google **com internet** (o modo offline foi desligado porque devolvia texto vazio no Galaxy A17); **pausa com o app em segundo plano** | Limite do reconhecimento de fala do Android |
| Não tocar na tela dirigindo | **Ok** | Comandos por voz abrem telas, documentos, Waze e recados. Telas de leitura **só abrem com o caminhão parado** | — |
| Avisos sem conversa aberta | **Ok** | `aviso_motorista` pelo `/ws`, lido com `expo-speech` (voz local) | — |
| Voz sem internet | **Parcial** | O time tirou o Whisper local do app: sem rede, cada fala é **gravada em WAV** (`offlineVoiceRecorder.ts`, pasta `falas_offline/`) e sobe para o backend transcrever quando a rede volta (`POST /rotas/{id}/falas-offline`, apagada ao confirmar); comandos simples continuam resolvidos localmente (`voiceCommands.ts`) | Nenhuma transcrição acontece no aparelho enquanto está offline; o motorista só é entendido depois que a fala sincroniza |
| Funciona em cabine barulhenta e com sotaques | **Promessa (não testada)** | Há filtro de sinal (commit `be2cd95`), mas nenhuma evidência de teste com ruído real ou com motoristas | Exige teste de campo (planejado para 01–12/12) |
| Motoristas de 50 anos ou mais conseguem usar | **Promessa (não testada)** | Nenhum teste com usuários; nenhuma métrica de conclusão por voz × toque | É validação, não código |
| Privacidade: só transcrição | **Ok** | `VOICE_PRIVACY` (`recordAudio: false`), com o selo "Somente transcrição" na tela | — |
| iOS | **Parcial** | Há config de iOS no `app.config.ts`, mas o build e a wake word documentados são só de Android | O time testou em Android; a maioria dos caminhoneiros usa Android [hipótese] |

## 3. Dor do caminhoneiro (espera e prova)

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Ver o tempo parado, a franquia e a estadia | **Ok** | Tela da fila no recebedor e textos `Tempo parado` / `Estadia` / `Franquia` (`locales/pt-BR.json`) | — |
| Saber quando vai descarregar | **Parcial** | Mostra a doca confirmada e o tempo parado. **Não mostra a posição na fila** | O recebedor não informa a fila (o README declara) |
| "A prova é dele também" | **Promessa** | Não há como o motorista compartilhar ou salvar o resumo da espera (horário de chegada, de descarga, valor) | A prova foi pensada para a transportadora; o lado do motorista não foi priorizado |
| Chegada confirmada por voz | **Ok** | Fluxo via backend (`POST /rotas/{id}/chegada`), com a voz validando | — |
| GPS real, também em segundo plano | **Ok** | `deviceGps.ts` usa `expo-location` com serviço em primeiro plano e permissão de localização em segundo plano. Ligando "GPS Real do Celular" (Ajustes), cada posição nova agora também atualiza o mapa de verdade (`useTrip.applyDeviceGpsPosition`, câmera segue o caminhão no Google Maps), em vez de só alimentar a detecção de velocidade. O simulador acelerado continua disponível para a demo | — |
| Usar o Waze sem perder o RODAR | **Parcial** | "Abre o Waze" leva o RODAR para segundo plano: o GPS segue, mas a **wake word pausa**. Não confirmei se o `/ws` continua no Android em segundo plano [hipótese] | Limites do Android para apps em segundo plano |

## 4. Integração, portos e o resto

| Promessa | Estado | Por que falta |
|---|---|---|
| Integração com TMS, rastreador e ERP (ADR-0001) | **Não se aplica ao app** | É papel do backend (ver o relatório dele). O app consome só a API do RODAR |
| Agendamento portuário por voz | **Promessa (roadmap)** | Depende de integração com a APS e o Carga Online |
| Autorização real nos endpoints | **Ok** (não reconferido no backend) | README: "com `AUTH_OBRIGATORIA=true` (padrão do backend), toda escrita exige o JWT do `/auth/sso` e o motorista só age na rota atribuída a ele (403 na rota de outro)". Mudou desde a última conferência (antes não validava) | Login continua sem senha; leituras seguem abertas |

## 5. README desatualizado

Os itens "`agent-server`"/"GPT-Live" já foram corrigidos em commits anteriores (não aparecem mais no README). Nesta sessão, todo o conteúdo técnico sobre Agora (RTC, variáveis de ambiente, tabela de rotas, dependências, decisões técnicas, `docs/ARQUITETURA.md`, `docs/DESIGN.md`) foi atualizado para LiveKit — preservando só a menção histórica ao hackathon "UNMUTE by Agora" (nome do evento, não da stack atual).

| Trecho | Problema | Correção |
|---|---|---|
| "`v0.1.0` (tag `v0.1.0-entrega` quando a entrega for fechada)" | A tag ainda não existe. O Hack Brasil avalia o último commit até 30/11 | Criar a tag antes de 30/11 ou tirar a frase |
| Nome do pacote `avisai-mobile` e APK `avisai-dev-debug.apk` | AvisAI é o nome do agente, mas o produto é RODAR | Opcional; o histórico do README já explica |
| Capturas/tour do README (`docs/assets/readme/*`) | Ainda são do fluxo Mock de antes desta sessão (modo direção foi incluído em sessão anterior; a migração LiveKit não muda a UI visível no Mock) | Baixo risco — regerar com `scripts/readme-captures/capture.sh` (precisa de Playwright + ffmpeg, indisponível neste sandbox) se a UI mudar de novo |

---

## O que já está entregue e não precisa ser refeito

- Voz real migrada de Agora para **LiveKit** (`@livekit/react-native` + `livekit-client`), com barge-in (tratado pelo agente), Mudo e Encerrar; wake word; comandos por voz que abrem telas, documentos, Waze e recados; avisos falados com a conversa fechada.
- Leitura só com o caminhão parado; leitura de documentos em voz alta; selo e política de só transcrição (`lk.transcription` é recebido e descartado, nunca mostrado).
- GPS do aparelho em segundo plano; simulador para a demo; mapa Google ou SVG; modo direção com esfera do AvisAI arrastável. Com "GPS Real do Celular" ligado, o mapa agora segue a posição de verdade (câmera no Google Maps; limites do SVG incluem a posição fora do trecho mock) em vez de só alimentar a detecção de velocidade.
- A esfera flutuante, ao ser arrastada e solta, encosta na lateral mais próxima da tela (esquerda ou direita) em vez de ficar solta no meio, com uma animação suave até lá (commit `bafa041`).
- Novo comando de voz "sair do modo direção" (e "exit driving mode" em inglês): libera a tela do modo direção na hora, sem esperar o caminhão parar de verdade, e ignora a velocidade por 2 min para não travar de novo no segundo seguinte (`useDrivingMode.exitDrivingModeManually`, `voiceCommands.ts`, commit `bafa041`).
- Login via SSO mock ou Keycloak real (OIDC + PKCE, `EXPO_PUBLIC_AUTH_MODE=keycloak`), com Organizations.
- Fila offline (outbox SQLite, idempotente, FIFO); sem Whisper local — a fala sem rede agora é **gravada em WAV e enviada ao backend** quando a rede volta.
- Contrato de rota cancelada; demo pública no GitHub Pages; CI do judge (`rodar-ideas`) disparado a cada push na `main`.
- Documentos com resposta só a partir dos campos (NF-e/CT-e MOCK declarados).
- Todas as branches/PRs do repositório revisadas; `main` e `dev` sincronizados; branches obsoletas apagadas do remoto.
- 133 testes, typecheck e lint (0 avisos) — todos verdes após a migração para LiveKit e as mudanças de GPS/esfera/modo direção desta sessão (3 testes novos: `snapToEdge`, saída manual do modo direção, comando de voz "sair do modo direção").
- Em voz real (LiveKit), falar com o AvisAI (esfera, cabeçalho, botões "falar com o AvisAI", wake word, aviso que pede resposta) não abre mais o Painel de frases prontas (Modal cheio) — só liga o microfone; a resposta aparece no balão ao lado da esfera (`useVoice.isDirectVoice`, hook `useTalkToAvisai`, commit `abe0ce7`). No modo Mock o Painel com as frases prontas continua abrindo do mesmo jeito, por não haver microfone real ouvindo.

## Correções no nosso discurso (deck e documentos)

- "575 testes": número do mobile **corrigido** nesta sessão (130, não mais 109); backend (318) e web (127) **não foram reconferidos** agora.
- "Voz pela Agora": **desatualizado**. O backend migrou para LiveKit; o app também. Dizer "voz pelo LiveKit Agents".
- "Sem tocar no celular": verdade **depois** que a conversa começa ou com a wake word. A wake word precisa de internet, só existe no Android e pausa em segundo plano.
- "Funciona sem internet": a **fala é gravada** sem rede e transcrita pelo backend quando a rede volta (não há mais Whisper local no aparelho); o raciocínio do agente nunca funcionou offline.
- "Acessível para o motorista de 50+": é a hipótese central e **ainda não foi testada com ninguém**. Diga "projetado para" até ter o teste.
- A migração para LiveKit **não foi testada em dispositivo real** (sem device/toolchain nativo neste ambiente); só por tipo, lint e teste unitário com mocks.
