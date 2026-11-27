# rodar-mobile: o que falta, contra o que prometemos

25/11/2026 · commit verificado: `28e1569` (main de [rodarglobal/rodar-mobile](https://github.com/rodarglobal/rodar-mobile)).

**O que prometemos** está em [`ADR-0001`](adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../HACKATHON.md). Relatórios dos outros repos: [`rodar-backend`](rodar-backend-o-que-falta.md) e [`rodar-web`](rodar-web-o-que-falta.md).

O app é onde mora o **diferencial de acessibilidade**: o motorista fala, não digita, e não toca na tela dirigindo. Por isso este relatório pesa mais a seção 2.

**Como conferi:**
- Li o código (`src/features/voice`, `src/services`, `src/pages`) e o README.
- Rodei os checks do CI localmente:

| Check | Resultado |
|---|---|
| `npm test` (Vitest) | **86 passaram** em 14 arquivos |
| `npm run typecheck` | Sem erros |
| `npm run lint` | Sem erros, 47 avisos |

Com os relatórios do backend (299) e do web (127), o total de **512 testes** citado no README está **confirmado**.

**O que não testei:** o app num celular. Voz real, wake word, GPS e Whisper offline exigem o Dev Build no aparelho.

Legenda:
- **Bloqueia:** ameaça a submissão ou o primeiro desempate (H1).
- **Promessa:** está no pitch ou no ADR e não existe.
- **Parcial:** existe, mas menor que o prometido.
- **Ok:** entregue no código (não testei em aparelho).

## Resumo: o que fazer até 30/11 às 23h59

| # | O que falta | Por que importa | Esforço |
|---|---|---|---|
| 1 | **Gravar no vídeo o app real**: voz pela Agora, wake word e um aviso com a conversa fechada | O júri não instala nada. A acessibilidade só aparece se o vídeo mostrar o motorista falando, sem tocar na tela | Médio (precisa do backend no ar) |
| 2 | **Links da demo e do vídeo** no README | Mesmo comentário pendente dos outros repos (linha 28) | Baixo |
| 3 | **Corrigir o README desatualizado** (`agent-server`, "GPT-Live", tag de entrega) | O júri lê o código e o README; referências à arquitetura antiga confundem | Baixo |
| 4 | **Um teste rápido de voz em cabine real** (ruído do motor, rádio, sotaque) | É a promessa central de acessibilidade, e nunca foi testada fora da mesa | Médio |
| 5 | **Prova da espera para o próprio motorista** (compartilhar o resumo da estadia) | O `RODAR-CONTEXT.md` diz que "a prova é dele também"; hoje ele vê o tempo, mas não leva nada consigo | Baixo a médio |

Se só der para fazer três, faça 1, 2 e 3.

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Ver o app sem instalar | **Parcial** | O júri não instala nada (item 7.4). A voz real exige o Dev Build (APK) mais o backend; o Expo Go só roda o modo mock. A versão pública é o `/mobile-web` do `rodar-web`, com voz simulada | Um app nativo com voz em tempo real não roda no navegador |
| APK para download | **Promessa (opcional)** | O README ensina a gerar `build/avisai-dev-debug.apk`, mas não há APK publicado (o `.apk` está no `.gitignore`) | Não priorizado; o júri não é obrigado a instalar |
| Links da demo e do vídeo no README | **Bloqueia** | README, linha 28: `<!-- Demo publicada e vídeo de 3 min do Hack Brasil: incluir ... antes de 30/11 -->` | Ainda não existem |
| Conexão com o backend | **Parcial** | Feita pela URL de um túnel `trycloudflare.com` colada no app, que muda a cada reinício do backend | Não há backend publicado com URL fixa (ver o relatório do backend) |
| Qualidade (CI, testes, tipos) | **Ok** | Conferido acima | — |

## 2. Acessibilidade: o diferencial

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Conversa por voz em tempo real | **Ok** | `AgoraVoiceSession` (`react-native-agora`), cenário de áudio para IA da Agora, AEC/AINS, barge-in, Mudo e Encerrar | — |
| Começar sem tocar na tela | **Parcial** | Wake word "Ei AvisAI" (`services/wakeWord.ts`). Só no Android e no Dev Build; usa o reconhecimento do Google **com internet** (o modo offline foi desligado porque devolvia texto vazio no Galaxy A17); **pausa com o app em segundo plano** | Limite do reconhecimento de fala do Android |
| Não tocar na tela dirigindo | **Ok** | Comandos por voz abrem telas, documentos, Waze e recados. Telas de leitura **só abrem com o caminhão parado** | — |
| Avisos sem conversa aberta | **Ok** | `aviso_motorista` pelo `/ws`, lido com `expo-speech` (voz local) | — |
| Voz sem internet | **Parcial** | Whisper local (`whisper.rn`, modelo `ggml-small`) para reconhecer a fala sem rede. O modelo (centenas de MB) é **baixado do Hugging Face no primeiro uso** e precisa de internet uma vez. O LLM continua na nuvem; offline, os comandos são resolvidos localmente (`voiceCommands.ts`) | Um LLM inteiro no aparelho não cabe no MVP |
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
| GPS real, também em segundo plano | **Ok** | `deviceGps.ts` usa `expo-location` com serviço em primeiro plano e permissão de localização em segundo plano. O simulador acelerado continua disponível para a demo | — |
| Usar o Waze sem perder o RODAR | **Parcial** | "Abre o Waze" leva o RODAR para segundo plano: o GPS segue, mas a **wake word pausa**. Não confirmei se o `/ws` continua no Android em segundo plano [hipótese] | Limites do Android para apps em segundo plano |

## 4. Integração, portos e o resto

| Promessa | Estado | Por que falta |
|---|---|---|
| Integração com TMS, rastreador e ERP (ADR-0001) | **Não se aplica ao app** | É papel do backend (ver o relatório dele). O app consome só a API do RODAR |
| Agendamento portuário por voz | **Promessa (roadmap)** | Depende de integração com a APS e o Carga Online |
| Autorização real nos endpoints | **Parcial** | O próprio README diz: "os endpoints operacionais ainda não validam o token MOCK como autorização" |

## 5. README desatualizado

| Trecho | Problema | Correção |
|---|---|---|
| "integrada ao Conversational AI Engine via `agent-server`" | O `agent-server` em Node era o plano inicial; o backend real é FastAPI | "via `rodar-backend` (FastAPI)" |
| "agente GPT-Live configurado no backend" | O backend usa LLM compatível com OpenAI + ASR ARES + TTS MiniMax | Citar a pilha real |
| "`v0.1.0` (tag `v0.1.0-entrega` quando a entrega for fechada)" | A tag não existe. O Hack Brasil avalia o último commit até 30/11 | Criar a tag antes de 30/11 ou tirar a frase |
| Nome do pacote `avisai-mobile` e APK `avisai-dev-debug.apk` | AvisAI é o nome do agente, mas o produto é RODAR | Opcional; o histórico do README já explica |

---

## O que já está entregue e não precisa ser refeito

- Voz real pela Agora, com barge-in, Mudo e Encerrar; wake word; comandos por voz que abrem telas, documentos, Waze e recados; avisos falados com a conversa fechada.
- Leitura só com o caminhão parado; selo e política de só transcrição.
- GPS do aparelho em segundo plano; simulador para a demo; mapa Google ou SVG.
- Fila offline (outbox SQLite, idempotente, FIFO); Whisper local para fala sem rede.
- Documentos com resposta só a partir dos campos (NF-e/CT-e MOCK declarados).
- 86 testes, typecheck e CI.

## Correções no nosso discurso (deck e documentos)

- "512 testes": **confirmado** (299 + 127 + 86).
- "Sem tocar no celular": verdade **depois** que a conversa começa ou com a wake word. A wake word precisa de internet, só existe no Android e pausa em segundo plano.
- "Funciona sem internet": a **fala** é reconhecida offline depois do download do modelo; o raciocínio do agente não.
- "Acessível para o motorista de 50+": é a hipótese central e **ainda não foi testada com ninguém**. Diga "projetado para" até ter o teste.
