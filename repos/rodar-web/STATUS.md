# rodar-web: o que falta, contra o que prometemos

28/11/2026 · commit verificado: `41be659` (main de [rodarglobal/rodar-web](https://github.com/rodarglobal/rodar-web)). Entre `bac015f` e `41be659`, 6 commits novos:
- `05d559e`: o cursor falso do tutorial guiado desmontava e remontava a cada passo, perdendo a transição CSS (teleportava em vez de deslizar); agora fica sempre montado e só esconde depois de 900ms. Reaplicou de passagem o `aria-hidden` no SVG do sino de `TaskPushNotifications` (tinha sido perdido no revert `3a085b4`).
- `adea4d5`: o backend local passou a registrar ligações ao recebedor com `motivo: "atraso"` (aviso de atraso, recurso já existente em `backend/app/servicos/ligacoes.py`); o painel só aceitava `aproximacao`/`cco_sem_resposta` nesse campo e rejeitava a resposta inteira (`ApiError('invalid_response')` → `api_invalid_response`), caindo a conexão com o modo API mesmo com o backend respondendo normalmente. Corrigido ponta a ponta (tipo, guard de resposta, `CallLog.moment` ganhou `'delay'` em vez de cair, errado, no rótulo de escalonamento, traduções próprias pt-BR/en). Junto, duas melhorias de UX pedidas ao observar o painel: os toasts de alerta (`LiveAlerts`) agora limitam a 3 visíveis com contador de excedente, não acumulam mais de um por veículo e nunca bloqueiam clique nos painéis abaixo; o aviso para ativar notificação do navegador (`TaskPushNotifications`) lembra o descarte em `localStorage` (antes voltava a cada troca de tela do Dashboard) e ganhou uma frase explicando que cobre a aba em segundo plano, diferente dos toasts que já aparecem com a aba em foco.
- `042e3d1`: os toasts de alerta (`LiveAlerts`) usavam fundo com alfa (`bg-wait-500/15` etc.) sobre o próprio cabeçalho/badges do painel, deixando o toast visivelmente transparente (print do usuário mostrava "Operador CCO" e o badge "3" do sino atravessando a notificação). Troquei para `color-mix(..., var(--color-ink-900))` (mesmo padrão opaco já usado em `cco.css`/`monitoring.css`), mantendo a borda colorida por prioridade; fundo agora é sólido.
- `15ddd39`: `deriveAlerts` (`src/features/monitoring/model.ts`) podia listar o mesmo `tripId` mais de uma vez na "Fila de alertas" (Task escalada + estadia acima da franquia + posição indisponível geram motivos distintos para a mesma viagem). Agora, depois de ordenar por severidade, mantém só o alerta mais grave por viagem — o caminhão/motorista ocupa uma única linha. Teste novo em `tests/monitoring.test.mjs`.
- `18f0e2a`: no modo API, o mapa desenhava o `trajeto` do backend como segmentos retos entre os pontos enviados (seed do backend documentado como "dados fictícios lineares, não evidência de geometria rodoviária real" — ver `docs/INTEGRACAO-BACKEND.md`). A pedido do usuário, passou a ajustar visualmente esse traçado à via via Google Maps Routes API — uma consulta por rota (origem→destino do próprio `trajeto`), em cache, nunca por tick — sem tocar em distância, ETA, progresso ou posição GPS, que continuam exclusivamente do backend; biblioteca Routes carregada em separado e só no modo API (a Demo continua só com Maps+Marker, sem exigir essa permissão), com fallback silencioso para o `trajeto` original se a chave faltar ou a consulta falhar. `CLAUDE.md` (regra 4) e `docs/INTEGRACAO-BACKEND.md` atualizados para permitir esse ajuste visual.
- `41be659`: README e `docs/ARQUITETURA.md` ainda descreviam o mapa como "sem Routes API, sem biblioteca adicional" — desatualizado depois de `18f0e2a`. Sincronizados: habilitar **Routes API** (com cobrança) junto da Maps JavaScript API, e explicados o comportamento sem a Routes API habilitada (traçado em reta, sem quebrar o painel) e o que o ajuste visual não faz (não recalcula distância/ETA/progresso/GPS).

**Incidente antigo, já corrigido (sem mudança nesta rodada):** um subagente de avaliação comitou e deu push sem autorização numa restilização do aviso de notificações (`830d6a4`), que quebrou o lint (SVG sem `aria-hidden`); revertido em `3a085b4`. Ver `decisoes.md` para o detalhe — não mude o código com base nisso, já está revertido.

**O que prometemos** está em [`ADR-0001`](../../docs/adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../../HACKATHON.md). Para o backend, ver [`rodar-backend-o-que-falta.md`](../rodar-backend/STATUS.md).

**Como conferi:** rodei a suíte completa depois de `05d559e`, diagnostiquei a queda de conexão do modo API comparando o guard de resposta do painel com a resposta real do backend local (`curl http://127.0.0.1:8000/cco/estado`), corrigi, e conferi ao vivo no navegador contra o backend local (login em modo API, banner "Conectado" sem erro, ligações de atraso exibidas como "Agente → recebedor (atraso)") depois de `adea4d5`. Depois de `042e3d1` (fundo opaco do toast), rodei `npm run typecheck`, `npm run lint` e `npm test` de novo (não refiz `build`/e2e, mudança é só CSS/classe num componente já cobrto pelos testes existentes). Em `15ddd39` (dedup da fila de alertas), adicionei teste cobrindo uma viagem com três motivos de alerta simultâneos e reconferi `npm test`/`npm run typecheck`. Em `18f0e2a` (traçado ajustado à via), só reconferi `npm run typecheck`, `npm run lint` e `npm test` (146/146) — **não abri o navegador com uma chave real do Google Maps e um backend rodando** para ver a linha de fato se ajustar à via; a lógica (consulta por rota em cache, fallback para o `trajeto` original sem chave/erro, sem tocar em distância/ETA/GPS) foi conferida por leitura de código e pelos testes já existentes de `getRoadRoute`/`createRoutePath` (`tests/domain.test.mjs`), que cobrem cache, erro e geometria, mas não o `FleetMap.tsx` em si (sem teste de UI para o mapa):

| Check | Resultado |
|---|---|
| `npm test` | **146 passaram**, 0 falharam (145 em `042e3d1` + 1 novo em `15ddd39`; reconferido em `18f0e2a`) |
| `npm run typecheck` | Sem erros (reconferido em `18f0e2a`) |
| `npm run lint` | **Sem erros, 0 avisos** (reconferido em `18f0e2a`) |
| `npm run build` | Ok em `adea4d5`. `OperatorPage` e outros chunks passam de 500 kB, mas são carregados sob demanda (mesmo aviso de sempre) — não reconferido em `042e3d1` |
| `npm run test:e2e` (Playwright) | **1 passou**, 0 falharam em `adea4d5` — login na Demo → painel → troca de idioma → logout — não reconferido em `042e3d1` |

Não reconferi a fundo as entregas de produto anteriores a `e6b1683` (itens 4 e 5 do resumo abaixo, exportação por entrega e tela de integrações): seguem como no relatório de 27/11.

Legenda:
- **Bloqueia:** ameaça a submissão ou o primeiro desempate (H1).
- **Promessa:** está no pitch, no site ou no ADR e não existe.
- **Parcial:** existe, mas menor que o prometido.
- **Contradição:** o site diz algo que o produto não faz.
- **Ok:** entregue.

## Resumo: o que fazer até 30/11 às 23h59

| # | O que falta | Estado | Esforço |
|---|---|---|---|
| 1 | **Publicar o painel** (site + painel + `/mobile-web`) numa URL fixa | **Ok** — ao ar em [rodar-web-beta.vercel.app/home](https://rodar-web-beta.vercel.app/home) (deploy contínuo na Vercel a cada push na `main`, `curl` confirma 200); o GitHub Pages foi removido (workflow, config do repo e `vite.config.ts`) por divergir da config da Vercel (risco de deploy duplicado) e por já estar respondendo 404 | Baixo |
| 2 | **Corrigir o texto do site** que promete o que não existe (seção 4) | **Ok** — as cinco alegações foram reescritas em pt-BR e en (`src/assets/locales/home.ts`, commit `1f52c23`); reconferido hoje, nenhuma frase antiga restou | Baixo |
| 3 | **Links da demo e do vídeo + números de impacto com fonte** no README e na home | **Parcial** — o link morto (`rodarglobal.github.io/rodar-mobile/`, 404) foi trocado por `/mobile-web` na Vercel; os números de impacto no README têm fonte (IER 2025, CNTA 2025, ANTT); falta o vídeo de 3 min do Hack Brasil (o comentário-lembrete ainda está no README, linha 39) e a home não cita os números de impacto, só o README | Baixo |
| 4 | **Exportação da estadia por entrega** para o financeiro | **Pendente, não reconferido hoje** — no relatório de 25/11, o CSV ainda agregava por recebedor/motorista | Médio (depende do backend) |
| 5 | **Tela de integrações** com o estado real de cada conector | **Pendente** — sem rota de integrações em `src/app/router.tsx`/`src/pages`; agora há um plano escrito (`docs/PLANO-CONECTORES-TMS.md`, `docs/PLANO-TESTES-CONECTORES.md`), mas nenhuma tela | Baixo |

Se só der para fazer dois, faça 3 (vídeo) e 4; os itens 1 e 2 já foram concluídos.

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Demo HTTPS publicada (S4) | **Ok** | [rodar-web-beta.vercel.app/home](https://rodar-web-beta.vercel.app/home) responde 200; deploy a cada push na `main` via integração nativa da Vercel (`vercel.json`, `vite.config.ts: base: '/'`); CI (`.github/workflows/ci.yml`) roda lint, typecheck, testes e build a cada push/PR | — |
| GitHub Pages (hospedeiro duplicado) | **Resolvido** | `.github/workflows/demo-pages.yml` buildava com `--base /rodar-web/`, divergindo do `base: '/'` da Vercel; a página já respondia 404. Removido o workflow, desativado `Settings → Pages` (API `DELETE /repos/.../pages`, confirmado 404 "Not Found") e atualizado o README/`vite.config.ts` (commit `69cdfab`, merge `b62e17c`) | — |
| Link morto do app do motorista (S4) | **Resolvido** | `rodarglobal.github.io/rodar-mobile/` (404, GitHub Pages desativado) trocado por `https://rodar-web-beta.vercel.app/mobile-web` (rota real, `src/app/router.tsx`), commit `795a62a` | — |
| Links da demo e do vídeo no README | **Parcial** | README já liga a demo pública, o tour de 1 min e a validação da API; o comentário `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->` (linha 39) mostra que o vídeo ainda não foi incluído | Vídeo de 3 min ainda não gravado/linkado |
| Números de impacto com fonte | **Parcial** | O README cita 11h40, 5h09 e 91% com fonte (IER 2025/SETCESP, CNTA 2025, ANTT). A home (`src/assets/locales/home.ts`) não repete esses números; a calculadora usa só os valores que o visitante digita | Levar os números com fonte também para a home, se for esse o objetivo original |
| A demo pública mostra a IA de voz real | **Parcial, não reconferido hoje** | `/mobile-web` simula a voz com a síntese do navegador. A voz real via LiveKit existe como opção ("Testar ao vivo") desde o commit `a72aed8`, não reconferida nesta rodada | Confirmar se a opção de voz ao vivo funciona na URL pública |
| Qualidade (CI, testes, tipos) | **Ok** | Rodado hoje: 146 testes (novo: dedup da fila de alertas em `15ddd39`), typecheck sem erros, **lint com 0 avisos** (era 53), build não reconferido hoje (sem mudança de dependências), e smoke e2e com Playwright na CI (ver topo) | — |

**Atenção:** a demo publicada roda no modo Demo (dados fictícios). O vídeo do Hack Brasil precisa mostrar o modo API e a voz real, senão o júri vê só a simulação.

## 2. Integração: o que vendemos (ADR-0001)

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Dashboard como vitrine da operação | **Ok** | Monitoramento, dispatch, viagem com linha do tempo e transcrição, Análises, Operador (`src/pages`) | — |
| Mostrar o que está integrado e o que é roadmap | **Promessa** | Sem rota de integrações em `src/app/router.tsx`/`src/pages`. Agora existe um plano escrito (`docs/PLANO-CONECTORES-TMS.md`, `docs/PLANO-TESTES-CONECTORES.md`), mas nenhuma tela | Decidido em 25/11 (ADR-0001); o plano chegou, a tela não |
| TMS/ERP, rastreador e telefonia do cliente | **Promessa** | A home agora é explícita: TMS/ERP e telefonia "exigem implementação específica" (não é recurso padrão disponível) | O backend não tem esses conectores (ver o relatório do backend) |

## 3. As três dores no painel

| Dor | O que o painel entrega | Estado | O que falta e por quê |
|---|---|---|---|
| **Dono / CCO** | KPIs, fila de alertas por severidade, frota no mapa, linha do tempo com transcrição, ranking de recebedores | **Ok** | — |
| **Financeiro**: estadia devida | Total e por recebedor (`/api/metrics`, ranking) e CSV por recebedor e por motorista (`features/analytics`) | **Parcial** | Não há exportação **por entrega** (horário de chegada, de descarga, toneladas, valor). O backend não expõe essa lista |
| **Financeiro**: estadia cobrada | Só na Demo (marca fictícia em ~15% das entregas) | **Promessa** | `docs/INTEGRACAO-BACKEND.md`: "Série temporal e estadia cobrada: indisponíveis no modo API". O backend não registra cobrança |
| **Caminhoneiro** | `/mobile-web` mostra o roteiro do app com voz simulada | **Parcial** | A acessibilidade real (voz, sem tocar na tela) está no `rodar-mobile` |

## 4. Contradições do site público com o produto — corrigidas

Texto em `src/assets/locales/home.ts`. As cinco alegações abaixo foram reescritas no commit `1f52c23` (25/11); reconferi hoje em pt-BR e en e nenhuma frase antiga restou.

| Alegação antiga | Texto atual do produto | Estado |
|---|---|---|
| "a espera conta, com horário, local e **ligação gravada**" | O site diz que a chamada registra a transcrição, **não o áudio** (decisão de LGPD) | **Ok** |
| "O AI liga para o recebimento **30 minutos antes** da chegada" | A home não promete um valor fixo: "o gatilho e a antecedência seguem a configuração da rota". README distingue Demo (8 km) de API (ETA configurado, 15 min por padrão) | **Ok** |
| "com o **comprovante pronto para cobrar**" / "Estadia que vira receita" | FAQ e passos da home dizem que o painel "não gera comprovante de cobrança automaticamente" | **Ok** |
| "As ligações ao recebedor saem pelos **números e canais que você já usa**" | Home: "as chamadas dependem do provedor configurado; o uso dos seus números e canais precisa ser validado no setup" | **Ok** |
| "Rotas, entregas e notas chegam **por integração ou importação**" | Home: "hoje, as rotas são cadastradas no painel. Integração ou importação de TMS/ERP exige implementação específica" | **Ok** |

## 5. Outros pontos

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Login e autorização reais | **Parcial** | SSO MOCK (declarado). O JWT vai em todas as chamadas, mas o backend só exige o papel `cco` com `AUTH_OBRIGATORIA=true` | Simplificação da demo |
| NF-e e CT-e | **Parcial (declarado)** | Metadados MOCK do backend (`mock:true`) | Upload real de documentos ficou fora por decisão |
| Acessibilidade do painel | **Ok, sem auditoria** | 235 atributos `aria-*`, `prefers-reduced-motion` no login, contraste documentado em `docs/DESIGN.md` | Nenhuma auditoria automatizada (axe, Lighthouse) foi rodada |
| Documentação desatualizada | **Resolvido** | Os caminhos absolutos `/home/henry/Documents/...` em `docs/ARQUITETURA.md`, `docs/INTEGRACAO-BACKEND.md` e `CLAUDE.md` foram trocados por referência portátil ao repositório `rodarglobal/rodar-backend` (pasta `backend/`), commit `795a62a` | — |
| Painel não mostra nem abre o link da ligação ao recebedor (`pagina_recebedor`) | **Promessa, achado nesta rodada (diagnóstico, sem commit)** | `grep` em `src/` por `pagina_recebedor`/`ligar-recebedor`/`/ligacoes/atual/recebedor`: nenhuma referência. A ligação ao operador (CCO) tem o caminho completo (`/operador`, botão "Abrir operador" no toast crítico de `LiveAlerts.tsx`); a ligação ao recebedor não tem equivalente | Sem essa tela, toda ligação ao recebedor em `RECEBEDOR_MODO=rtc` (ver [`rodar-backend/STATUS.md`](../rodar-backend/STATUS.md), seção 4) termina `nao_atendida` — ninguém no painel consegue entrar na sala |

---

## O que já está entregue e não precisa ser refeito

- Site público com história 3D, calculadora e FAQ; login; painel completo (monitoramento, dispatch, cadastro de viagem, viagem com linha do tempo e transcrição, Análises com CSV, Operador com Agora RTC).
- Modo API (REST + SSE, com reconciliação) e modo Demo (motor local, 63 entregas fictícias), com o que é MOCK identificado na tela e no README.
- `/mobile-web`: demonstração pública do app do motorista, sem login.
- i18n pt-BR e en, páginas sob demanda, tokens de cor da marca, 146 testes (`node:test`) + 1 smoke e2e (Playwright) e CI com 0 avisos de lint.
- As cinco alegações do site corrigidas (seção 4) e o painel publicado num único hospedeiro fixo (Vercel), sem o risco de deploy duplicado que havia com o GitHub Pages.
- Notificação push só pede permissão após um gesto do CCO (antes pedia sozinha ao carregar a página) e lembra o descarte em `localStorage` (não volta a cada troca de tela); vocabulário do canal do evento unificado em português (`painel`/`ligacao`), com o `payload.channel` do modo API devolvido depois de uma regressão pega pelo `/judge`; caminhos absolutos removidos da documentação.
- Modo API aceita ligação ao recebedor com `motivo: "atraso"` (rótulo próprio "aviso de atraso", distinto de aproximação/escalonamento); toasts de alerta (`LiveAlerts`) limitados a 3 visíveis por vez com contador de excedente e sem acumular mais de um por veículo.
- Fila de alertas nunca repete a mesma viagem (uma linha por caminhão/motorista, com o motivo mais grave). No modo API, o traçado do mapa pode se ajustar visualmente à via (Google Maps Routes API, uma consulta em cache por rota, nunca por tick) sem alterar distância, ETA, progresso ou GPS, que continuam só do backend.

## Correções no nosso discurso (deck e documentos)

- "512 testes": a soma usada no README (572) é **318 no backend + 145 no web + 109 no mobile**; o web já está em **145 testes** (rodei agora), o backend/mobile não foram reconferidos nesta rodada — não repetir o número antigo sem atualizar os três.
- O dashboard é a **vitrine**: o pitch não deve parar nele (ADR-0001).
- A demo publicada roda no modo Demo (dados fictícios); diga isso no vídeo e no README, e mostre o modo API com voz real no vídeo de 3 min que ainda falta gravar.
