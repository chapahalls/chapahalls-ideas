# Judge: rodar, 2026-11-21 13:22

**Nota estimada: 3,65 / 5** · Eliminatórios: 2 RISCOS (E2, E3)

## Alertas
- **RISCO E2 (Uso funcional da Agora demonstrado):** O diferencial central proposto (rede mesh/DTN offline `A → B → C` via Google Nearby Connections + STT/TTS local) roda **fora** da Agora. Se o time gastar a maior parte das 24h construindo multi-hop Android e o modo online com Agora ficar raso ou secundário nos 2 minutos de vídeo, a nota de C2 despenca e há risco no eliminatório E2. A Agora precisa brilhar na primeira metade da demo (voz fluida, barge-in, tool calling/roteamento e entrega na central).
- **RISCO E3 (Prazo 22/11 12:00):** Escopo combina app Android (React Native/nativo), Agora RTC/Conversational AI, STT/LLM/TTS offline no aparelho, Google Nearby Connections multi-hop (`A → B → C`) e painel web da central. Alto risco de não fechar o vertical slice completo em ~24h se não travar o escopo no P0 imediatamente.

## Pontuação
| # | Critério | Peso | Nota | Justificativa |
|---|---|---|---|---|
| C1 | Voz e interação | 25 | 4 | O diálogo e o demo path cobrem conversa fluida via Agora, interrupção (*"Corta isso — avisa a central..."*) e recuperação de falha na queda de internet com transição ordenada de microfone; falta apenas definir latência medida e fechar se o fallback offline será comando local ou LLM. |
| C2 | Execução + Agora | 25 | 3 | Agora RTC + Conversational AI estão no caminho principal do modo online, mas metade da arquitetura (STT/TTS local + Nearby Connections `A → B → C`) não usa SDKs da Agora e ainda depende de validar compatibilidade de SDKs no Android. |
| C3 | Relevância do problema e impacto | 20 | 4 | Público principal bem recortado (caminhoneiro vinculado a transportadora com CCO usando Android) e dor real (zonas de sombra em rodovias + risco de digitar dirigindo), com postura ética madura sobre fadiga e emergência. |
| C4 | Inovação e diferenciação | 15 | 4 | Unificar entrada única por voz (Trabalho/Pessoal/Estrada) com degradação graciosa para voz local e store-and-forward oportunista entre caminhões (`A → B → C`) cria um diferencial forte onde apps puramente online falham. |
| C5 | Validação e potencial de evolução | 10 | 3 | Limitações conhecidas (microssono, entrega DTN não garantida, regulação Anatel para rádio PX 27 MHz) são muito honestas e técnicas, mas falta um protocolo concreto de validação com usuários/testadores externos e métricas-alvo durante o hackathon. |
| C6 | Clareza da apresentação | 5 | 4 | O roteiro ponta a ponta conta uma história clara e fácil de visualizar pela banca, mas condensar conversa Agora + barge-in + queda de rede + salto `A → B → C` + painel da central em 2 minutos exigirá corte cirúrgico. |
| | **Total** | 100 | **3,65** | Σ(nota×peso)/100 = (4×25 + 3×25 + 4×20 + 4×15 + 3×10 + 4×5) / 100 = 365 / 100 |

## Eliminatórios
| # | Regra | Status | Nota |
|---|---|---|---|
| E1 | Equipe 3-5 presentes | N/A ainda | Confirmar lista final de integrantes inscritos e presentes. |
| E2 | Uso funcional da Agora demonstrado | RISCO | Agora é usada no modo online, mas a parte offline/mesh não passa pela Agora; garantir que a Agora seja o coração visível da experiência de voz e não coadjuvante do Nearby Connections. |
| E3 | Entrega até 22/11 12:00 BRT | RISCO | Empilhar Agora + LLM/STT offline + Nearby Connections multi-hop em 3 celulares Android + Central Web em <24h é ambicioso; seguir estritamente o corte P0 do `RODAR-CONTEXT.md`. |
| E4 | Repositório público na entrega | OK | Repositório `chapahalls/chapahalls-ideas` já é público. |
| E5 | Componentes preexistentes declarados | RISCO | Declarar explicitamente no `README.md` final quaisquer modelos locais (`whisper.cpp`, `llama.cpp`), SDKs e templates utilizados. |
| E6 | Licenças e ativos autorizados | OK | Apenas SDKs oficiais e modelos abertos previstos. |
| E7 | Sem credenciais ou dados pessoais | OK | Payload de exemplo usa dados fictícios e pseudônimos. |
| E8 | Simulações identificadas | OK | Documento já prevê declarar coordenadas fictícias e eventual nó simulado caso não haja 3 celulares físicos na demo. |

## Maior retorno
1. **Amarrar a Agora também na ponta final da recuperação (`C → Central → Motorista`) e detalhar os produtos Agora no fluxo (ex.: Conversational AI Engine + Signaling/RTM ou RTC na Central):** C2 3→4 = **+0,25** (e elimina o risco de a banca achar que o projeto é sobre Bluetooth/Nearby e não sobre Agora).
2. **Simplificar o modo voz offline no P0 para STT/TTS nativo do Android com classificador leve de intenção (sem `llama.cpp` no caminho crítico) e garantir latência Agora `< 1,5 s` com barge-in + transição online→offline testada ao vivo:** C1 4→5 = **+0,25**.
3. **Definir protocolo de validação durante o hackathon com N testadores e métricas objetivas (latência online, tempo de handoff offline, tempo de salto `A → B → C`, taxa de acerto do orquestrador):** C5 3→4 = **+0,10**.

## Observações
- Excelente maturidade na seção de segurança e responsabilidade (não prometer prevenção de microssono por conversa com IA e não posicionar mesh oportunista como substituto de 190/193). Isso protege o time contra questionamentos duros da banca.
- Há forte sinergia com a ideia `parceiro-de-estrada` (PR #1): ambas compartilham o domínio (caminhoneiros) e as 3 frentes (Trabalho/Corporativo, Pessoal, Estrada/Comunidade). Vale decidir em equipe se o MVP une a riqueza de produtos Agora do `parceiro-de-estrada` com o salto oportunista `A → B → C` (P0 enxuto) do `RODAR`.
