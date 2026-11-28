# Judge: rodar-web, 2026-11-27 21:32

Gatilho: push na main de rodar-web 2368b3c por HenryFacens. Commit avaliado: 2368b3c.

**Nota do repo: 15 / 20** (H1+H2)

Trilha: avaliado no projeto · Eliminatórios do repo: 0 FALHAS, 1 RISCO · Prazo: faltam 3d2h para 30/11 23h59

## Alertas

- **RISCO S5 (vídeo), o único que sobrou do score anterior:** o README continua sem o link do vídeo de até 3 min. Na seção "Para o júri", o comentário `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->` segue no lugar da linha. Os tours de 1 min ajudam, mas não substituem o S5.
- **Resolvido o RISCO S4 do score anterior:** o link do app do motorista agora aponta para `https://rodar-web-beta.vercel.app/mobile-web`. Conferi às 21h32: `/home`, `/login`, `/dashboard` e `/mobile-web` respondem 200.
- **X6 (só registro, sem mudança):** o check-rules aponta `docs/RODAR-telas/.../04-trip-dispatch-cadastro/index.html:79` e o `+5511999999999` em `src/assets/locales/dispatch.ts`. São placeholders de formato (CPF zerado e exemplo E.164). Classifiquei como OK.
- **README contradiz o código:** a seção "O que é simulado" ainda diz "cada segundo real avança um minuto da operação", mas `src/lib/config.ts` define `SIM_MINUTES_PER_SECOND = 0.5` (2 s = 1 min em 1x). Isso não elimina, mas é o tipo de detalhe que um jurado de dados percebe se cronometrar a Demo.
- **STATUS desatualizado** (`repos/rodar-web/STATUS.md`, verificado em `e6b1683`): nenhum item marcado como **Ok** falta no código. O STATUS é que ficou para trás: ainda fala em 144 testes e 53 avisos de lint (hoje são 145 testes e 0 avisos) e não registra o e2e na CI, o pedido de permissão de push após um gesto nem a unificação `painel`/`ligacao`. O `docs/rodar-web-o-que-falta.md` do próprio repo também segue com "127 testes".

## O que mudou desde e6b1683 (5 commits)

- `795a62a`: o README corrige o link 404, a contagem de testes (145 no web, 572 no total), os caminhos `/home/henry` (não restou nenhum em `docs/`) e justifica Agora RTC (fallback do operador) e LiveKit (teste de voz ao vivo).
- `ea06a9c`: o Biome passa de 53 avisos para 0 (conferi: "No fixes applied").
- `1eb2088`: `payload.channel` passa a usar `painel`/`ligacao`, igual ao contrato do backend. Os testes e as chaves de i18n foram atualizados juntos.
- `470b018`: a permissão de notificação só é pedida depois do clique em "Ativar". Antes, era pedida ao montar a página, o que os navegadores bloqueiam.
- `2368b3c`: `tests-e2e/smoke.spec.ts` (Playwright) faz login na Demo, confere a fila de alertas, troca o idioma e faz logout. O teste roda na CI depois do build. Também entrou um teste para `setSpeed`.

Rodei localmente em 2368b3c: `npm test` deu **145/145**, o typecheck e o lint (0 avisos) passaram, e o smoke do Playwright passou (1 teste, 2,1 s).

## Pontuação

| # | Critério | Nota (0-10) | Justificativa |
|---|---|---|---|
| H1 | Execução técnica | 7 | A demo HTTPS está no ar com deploy contínuo, e todos os links de demo do README respondem 200. O escopo do painel está completo: monitoramento, dispatch, viagem com linha do tempo e transcrição, Análises com CSV, Operador e `/mobile-web`. Os modos Demo e API (REST+SSE) funcionam, e o retry é explícito. Agora há um e2e provando que login → painel → logout funciona num navegador real, e o push não quebra mais em silêncio. Não sobe para 8 por três motivos: o deploy é só a Demo com dados fictícios, a voz real depende de um backend configurado que o júri não vê na URL pública, e faltam o vídeo, a tela de integrações e o CSV por entrega. A navegação no deploy *precisa de humano*. |
| H2 | Implementação técnica | 8 | TypeScript strict, features isoladas que só expõem `index.ts`, contrato validado por *guards*, reconciliação REST/SSE, `React.lazy` e i18n. A CI roda lint (0 avisos), typecheck, 145 testes, build e e2e Playwright. O vocabulário de canal agora é o mesmo do backend, e o README justifica por que há dois SDKs de voz. Esta rodada fechou quatro dos cinco pontos que seguravam o 7. Não chega a 9 porque o e2e é um único smoke, que não assume um alerta nem abre uma viagem, porque não há teste de componente de UI e porque a asserção "Nenhum alerta aberto" depende de o relógio da Demo não ter gerado alertas no primeiro segundo (frágil se a velocidade padrão mudar). |
| H3 | Impacto | avaliado no projeto | Sem nota aqui. O README traz IER 2025, CNTA 2025 e ANTT com fonte, e uma estimativa de R$ 525 por entrega. |
| H4 | Comunicação | avaliado no projeto | Sem nota aqui. O vídeo de 3 min ainda não está no README. |
| | **Total do repo** | **15/20** | +1 sobre o score de e6b1683 (H2 7→8) |

## Eliminatórios

| # | Regra | Status | Nota |
|---|---|---|---|
| X1 | Repo público, criado depois de 04/11 21h | OK | Primeiro commit em 22/11/2026 |
| X2 | Nenhum código privado anterior ao evento | OK | O README declara a origem no UNMUTE by Agora (21 e 22/11) e diz que todo o histórico está no repo |
| X3 | Licença | OK | MIT |
| X4 | Público até 15/12 | OK | Público e não é fork |
| X6 | Sem dado pessoal real | OK | CPF e telefone são placeholders, e os e-mails da Demo são `.test` |
| — | Segredo no git | OK | Não há `.env` versionado, e o `.env.example` só tem nomes de variáveis. O README avisa que a chave `VITE_` do Maps é pública e precisa de restrição |
| — | Mocks declarados no README | OK | Seção "O que é simulado" (com o desvio do relógio citado em *Alertas*) |
| — | Terceiros declarados | OK | OSRM/OpenStreetMap, modelos 3D (fora do git), Google Maps, Agora, LiveKit, Vercel, Playwright |
| S4 | Links de demo HTTPS no README | OK | Vercel `/home` e `/mobile-web` respondem 200 |
| S5 | Link do vídeo de até 3 min no README | **RISCO** | Ausente |

## Maior retorno

1. **Linkar no README o vídeo de 3 min, mostrando o modo API com voz real** (alerta escalando, assumido no painel, estadia fechando em R$). Isso fecha o S5 e mostra ao júri que o painel não é só simulação: **H1 7→8 = +1**, além do H4 do projeto.
2. **Ampliar o smoke para o caminho que vende o produto:** avançar o relógio da Demo (2x) até criar uma Task, clicar em **Assumir**, abrir `/dashboard/trips/:id` e conferir a estadia. Trocar a asserção "Nenhum alerta aberto" por uma que não dependa do tempo, e rodar o mesmo spec contra a URL da Vercel depois do deploy. Assim o "nada quebra na mão do júri" passa a ter prova: **H2 8→9 = +1** (H1 protegido).
3. **Uma tela simples de Integrações** (TMS/ERP, rastreador, telefonia, financeiro, com o estado real de cada um: "ativo", "MOCK" ou "roadmap"), já planejada em `docs/PLANO-CONECTORES-TMS.md`. Junto, corrigir o "cada segundo real avança um minuto" no README. É o que o ADR-0001 diz que vendemos e o que hoje falta no escopo do painel: **H1 completude + H3 do projeto, cerca de +1**.

## Observações

- O commit `470b018` tem o e-mail corporativo de um integrante no autor. Isso é metadado do git, não dado exposto na demo, e não entra no X6.
- O build ainda avisa sobre chunks acima de 500 kB, que vêm do three.js e são carregados sob demanda. Não afeta a nota.
- O CSV de Análises continua agregado por recebedor/motorista, sem uma linha por entrega. Depende do backend e pesa no H3 do projeto, não aqui.
- O `retries: 1` da CI no Playwright esconde uma falha intermitente. Se o smoke passar só na segunda tentativa, isso é sinal da fragilidade citada no H2.
