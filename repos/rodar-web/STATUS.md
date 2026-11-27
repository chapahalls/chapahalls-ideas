# rodar-web: o que falta, contra o que prometemos

27/11/2026 · commit verificado: `b62e17c` (main de [rodarglobal/rodar-web](https://github.com/rodarglobal/rodar-web)).

**O que prometemos** está em [`ADR-0001`](../../docs/adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../../HACKATHON.md). Para o backend, ver [`rodar-backend-o-que-falta.md`](../rodar-backend/STATUS.md).

**Como conferi:** este repositório já tinha uma reavaliação própria em `docs/rodar-web-o-que-falta.md` (commit-base `1f52c23`, 25/11), que usei como ponto de partida; a partir daí conferi o que mudou até `b62e17c` (`git log --oneline dd68e2d..b62e17c`, 28 commits):
- Deploy e CI: li `vite.config.ts`, `vercel.json`, `.github/workflows/ci.yml` e o histórico de execuções (`gh run list`); testei as duas URLs por `curl`.
- Textos públicos: reconferi `src/assets/locales/home.ts` (pt-BR e en) contra as cinco alegações da seção 4 — nenhuma segue com a redação antiga.
- README: conferi os links da demo, do vídeo e os números de impacto com suas fontes.
- Não reconferi a fundo as entregas de produto dos commits `a72aed8` (app do motorista com voz LiveKit) e `4e4f1e6` (viagem cancelada, busca de endereço, plano de conectores TMS) nem a exportação por entrega (item 4) ou a tela de integrações (item 5): seguem como no relatório de 25/11.
- Rodei os checks do CI localmente, hoje:

| Check | Resultado |
|---|---|
| `npm test` | **144 passaram**, 0 falharam |
| `npm run typecheck` | Sem erros |
| `npm run lint` | Sem erros, 53 avisos |
| `npm run build` | Ok. `OperatorPage` e outros chunks passam de 500 kB, mas são carregados sob demanda |

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
| 3 | **Links da demo e do vídeo + números de impacto com fonte** no README e na home | **Parcial** — a URL pública agora existe e os números de impacto no README têm fonte (IER 2025, CNTA 2025, ANTT); falta o vídeo de 3 min do Hack Brasil (o comentário-lembrete ainda está no README, linha 39) e a home não cita os números de impacto, só o README | Baixo |
| 4 | **Exportação da estadia por entrega** para o financeiro | **Pendente, não reconferido hoje** — no relatório de 25/11, o CSV ainda agregava por recebedor/motorista | Médio (depende do backend) |
| 5 | **Tela de integrações** com o estado real de cada conector | **Pendente** — sem rota de integrações em `src/app/router.tsx`/`src/pages`; agora há um plano escrito (`docs/PLANO-CONECTORES-TMS.md`, `docs/PLANO-TESTES-CONECTORES.md`), mas nenhuma tela | Baixo |

Se só der para fazer dois, faça 3 (vídeo) e 4; os itens 1 e 2 já foram concluídos.

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Demo HTTPS publicada (S4) | **Ok** | [rodar-web-beta.vercel.app/home](https://rodar-web-beta.vercel.app/home) responde 200; deploy a cada push na `main` via integração nativa da Vercel (`vercel.json`, `vite.config.ts: base: '/'`); CI (`.github/workflows/ci.yml`) roda lint, typecheck, testes e build a cada push/PR | — |
| GitHub Pages (hospedeiro duplicado) | **Resolvido** | `.github/workflows/demo-pages.yml` buildava com `--base /rodar-web/`, divergindo do `base: '/'` da Vercel; a página já respondia 404. Removido o workflow, desativado `Settings → Pages` (API `DELETE /repos/.../pages`, confirmado 404 "Not Found") e atualizado o README/`vite.config.ts` (commit `69cdfab`, merge `b62e17c`) | — |
| Links da demo e do vídeo no README | **Parcial** | README já liga a demo pública, o tour de 1 min e a validação da API; o comentário `<!-- Vídeo de 3 min do Hack Brasil: incluir a linha aqui antes de 30/11. -->` (linha 39) mostra que o vídeo ainda não foi incluído | Vídeo de 3 min ainda não gravado/linkado |
| Números de impacto com fonte | **Parcial** | O README cita 11h40, 5h09 e 91% com fonte (IER 2025/SETCESP, CNTA 2025, ANTT). A home (`src/assets/locales/home.ts`) não repete esses números; a calculadora usa só os valores que o visitante digita | Levar os números com fonte também para a home, se for esse o objetivo original |
| A demo pública mostra a IA de voz real | **Parcial, não reconferido hoje** | `/mobile-web` simula a voz com a síntese do navegador. A voz real via LiveKit existe como opção ("Testar ao vivo") desde o commit `a72aed8`, não reconferida nesta rodada | Confirmar se a opção de voz ao vivo funciona na URL pública |
| Qualidade (CI, testes, tipos) | **Ok** | Rodado hoje: 144 testes, typecheck e lint sem erros, build ok (ver topo) | — |

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
| Documentação desatualizada | **Parcial** | `docs/INTEGRACAO-BACKEND.md` aponta o backend em `/home/henry/Documents/rodar-backend/backend`, "fora deste repositório"; hoje ele está em `rodarglobal/rodar-backend` | Escrito antes da criação do repositório |

---

## O que já está entregue e não precisa ser refeito

- Site público com história 3D, calculadora e FAQ; login; painel completo (monitoramento, dispatch, cadastro de viagem, viagem com linha do tempo e transcrição, Análises com CSV, Operador com Agora RTC).
- Modo API (REST + SSE, com reconciliação) e modo Demo (motor local, 63 entregas fictícias), com o que é MOCK identificado na tela e no README.
- `/mobile-web`: demonstração pública do app do motorista, sem login.
- i18n pt-BR e en, páginas sob demanda, tokens de cor da marca, 144 testes e CI.
- As cinco alegações do site corrigidas (seção 4) e o painel publicado num único hospedeiro fixo (Vercel), sem o risco de deploy duplicado que havia com o GitHub Pages.

## Correções no nosso discurso (deck e documentos)

- "512 testes": a soma usada no README (554) é **318 no backend + 127 no web + 109 no mobile**; hoje o web já está em **144 testes** (rodei agora), o backend/mobile não foram reconferidos nesta rodada — não repetir o número antigo sem atualizar os três.
- O dashboard é a **vitrine**: o pitch não deve parar nele (ADR-0001).
- A demo publicada roda no modo Demo (dados fictícios); diga isso no vídeo e no README, e mostre o modo API com voz real no vídeo de 3 min que ainda falta gravar.
