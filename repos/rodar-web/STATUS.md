# rodar-web: o que falta, contra o que prometemos

25/11/2026 · commit verificado: `dd68e2d` (main de [rodarglobal/rodar-web](https://github.com/rodarglobal/rodar-web)).

**O que prometemos** está em [`ADR-0001`](../../docs/adr/0001-integracao-setup-e-tres-dores.md), [`ideas/rodar.md`](../../ideas/rodar.md), [`ideas/demora-em-docas/descoberta.md`](../../ideas/demora-em-docas/descoberta.md), [`RODAR-CONTEXT.md`](../../RODAR-CONTEXT.md), no deck e nas regras de [`HACKATHON.md`](../../HACKATHON.md). Para o backend, ver [`rodar-backend-o-que-falta.md`](../rodar-backend/STATUS.md).

**Como conferi:**
- Li o código e a documentação do repositório (`docs/INTEGRACAO-BACKEND.md`, `docs/REGRAS-DE-NEGOCIO.md`, `docs/DESIGN.md`).
- Conferi o texto do site público (`src/assets/locales/home.ts`).
- Rodei os checks do CI localmente:

| Check | Resultado |
|---|---|
| `npm test` | **127 passaram**, 0 falharam |
| `npm run typecheck` | Sem erros |
| `npm run lint` | Sem erros, 49 avisos |
| `npm run build` | Ok. O pacote do three.js passa de 500 kB, mas é carregado sob demanda |

Legenda:
- **Bloqueia:** ameaça a submissão ou o primeiro desempate (H1).
- **Promessa:** está no pitch, no site ou no ADR e não existe.
- **Parcial:** existe, mas menor que o prometido.
- **Contradição:** o site diz algo que o produto não faz.
- **Ok:** entregue.

## Resumo: o que fazer até 30/11 às 23h59

| # | O que falta | Por que importa | Esforço |
|---|---|---|---|
| 1 | **Publicar o painel** (site + painel + `/mobile-web`) numa URL fixa | Requisito da submissão (S4) e primeiro desempate. O modo Demo roda sem backend, então um deploy estático já fica no ar o tempo todo | Baixo |
| 2 | **Corrigir o texto do site** que promete o que não existe (seção 4) | "Ligação gravada" contradiz a decisão de LGPD; integração com TMS/ERP, telefonia própria e "comprovante pronto para cobrar" ainda não existem | Baixo |
| 3 | **Links da demo e do vídeo + números de impacto com fonte** no README e na home | O júri avalia pelo que vê sem instalar (item 7.4), e o impacto (H3) é o segundo desempate | Baixo |
| 4 | **Exportação da estadia por entrega** para o financeiro | O CSV atual agrega por recebedor; o financeiro precisa linha por entrega, com horários e valor | Médio (depende do backend) |
| 5 | **Tela de integrações** com o estado real de cada conector | Torna visível o que o ADR-0001 vende, sem prometer o que não roda | Baixo |

Se só der para fazer três, faça 1, 2 e 3.

---

## 1. Submissão e nota (Hack Brasil)

| Item | Estado | Evidência | Por que falta |
|---|---|---|---|
| Demo HTTPS publicada (S4) | **Bloqueia** | Não há deploy: o CI (`.github/workflows/ci.yml`) só faz lint, typecheck, testes e build, e não há config de hospedagem | Até agora o painel só rodou local (`npm run dev`) |
| Links da demo e do vídeo no README | **Bloqueia** | README, linha 36: `<!-- Demo publicada e vídeo de 3 min do Hack Brasil: incluir ... antes de 30/11 -->` | Ainda não existem |
| Números de impacto com fonte | **Promessa** | Nem o README nem a home citam 11h40, 5h09, 91% sem estadia ou portos. A calculadora da home usa valores padrão (20 caminhões, 1,5 entrega por dia) sem fonte | A pesquisa ficou no `rodar-ideas` |
| A demo pública mostra a IA de voz real | **Parcial** | `/mobile-web` simula a voz com a síntese do navegador, sem a Agora. A voz real só existe no app (`rodar-mobile`) com o backend no ar | A Demo foi feita para rodar sem chave nem servidor |
| Qualidade (CI, testes, tipos) | **Ok** | Conferido acima | — |

**Atenção:** um deploy só do modo Demo mostra telas com dados fictícios. O vídeo precisa mostrar o modo API e a voz real, senão o júri vê só uma simulação.

## 2. Integração: o que vendemos (ADR-0001)

| Promessa | Estado | Evidência | Por que falta |
|---|---|---|---|
| Dashboard como vitrine da operação | **Ok** | Monitoramento, dispatch, viagem com linha do tempo e transcrição, Análises, Operador (`src/pages`) | — |
| Mostrar o que está integrado e o que é roadmap | **Promessa** | Não há tela de integrações nem de estado de conectores | Decidido em 25/11 (ADR-0001), depois do código |
| TMS/ERP, rastreador e telefonia do cliente | **Promessa** | Só existem na home (seção "Funciona como plug-in") | O backend não tem esses conectores (ver o relatório do backend) |

## 3. As três dores no painel

| Dor | O que o painel entrega | Estado | O que falta e por quê |
|---|---|---|---|
| **Dono / CCO** | KPIs, fila de alertas por severidade, frota no mapa, linha do tempo com transcrição, ranking de recebedores | **Ok** | — |
| **Financeiro**: estadia devida | Total e por recebedor (`/api/metrics`, ranking) e CSV por recebedor e por motorista (`features/analytics`) | **Parcial** | Não há exportação **por entrega** (horário de chegada, de descarga, toneladas, valor). O backend não expõe essa lista |
| **Financeiro**: estadia cobrada | Só na Demo (marca fictícia em ~15% das entregas) | **Promessa** | `docs/INTEGRACAO-BACKEND.md`: "Série temporal e estadia cobrada: indisponíveis no modo API". O backend não registra cobrança |
| **Caminhoneiro** | `/mobile-web` mostra o roteiro do app com voz simulada | **Parcial** | A acessibilidade real (voz, sem tocar na tela) está no `rodar-mobile` |

## 4. Contradições do site público com o produto

Texto em `src/assets/locales/home.ts`. São o tipo de coisa que o júri pega se abrir o site e depois o código.

| O site diz | O produto faz | Correção sugerida |
|---|---|---|
| "a espera conta, com horário, local e **ligação gravada**" | O backend **não grava áudio**, só a transcrição (decisão de LGPD) | "com horário, local e a transcrição da ligação" |
| "O AI liga para o recebimento **30 minutos antes** da chegada" | O padrão do backend é **15 min** de ETA (`Rota.aproximacao_min = 15`), e o README do web fala em "**8 km** do destino" | Escolher um valor e usar o mesmo nos três lugares |
| "com o **comprovante pronto para cobrar**" / "Estadia que vira receita" | Não há comprovante nem exportação por entrega | "estadia calculada e registrada por entrega" até existir o comprovante |
| "As ligações ao recebedor saem pelos **números e canais que você já usa**" | A ligação telefônica está desligada; a demo usa uma página web (Agora RTC) | Marcar como "no setup" ou "em breve" |
| "Rotas, entregas e notas chegam **por integração ou importação**" | Não há importação nem integração com TMS/ERP; as rotas são cadastradas no painel | "Cadastro no painel hoje; integração com o seu TMS no setup" |

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
- i18n pt-BR e en, páginas sob demanda, tokens de cor da marca, 127 testes e CI.

## Correções no nosso discurso (deck e documentos)

- "512 testes": conferi **127 no web** e **299 no backend**; os 86 do mobile não rodei.
- O dashboard é a **vitrine**: o pitch não deve parar nele (ADR-0001).
- Se a demo publicada for o modo Demo, diga no vídeo e no README que os dados são fictícios e mostre o modo API com voz real no vídeo.
