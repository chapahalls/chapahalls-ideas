# rodar-mobile: decisões

Decisões que valem só para este repositório. Uma linha por decisão, a mais nova no topo. Decisão que muda o plano (fases, critérios, escopo) vai por `/adr` em [`docs/adr/`](../../docs/adr/), e aqui fica só o link.

| Data | Decisão | Por quê | Fonte |
|---|---|---|---|
| 2026-11-28 | Migrar a voz real de `react-native-agora` para `@livekit/react-native` + `livekit-client` | O `rodar-backend` migrou 100% para LiveKit (LiveKit Agents, tokens LiveKit, salas `rodar-rota-{id}`); a integração Agora do app ficou arquiteturalmente incompatível com o contrato do backend. Risco aceito por não ser testável em dispositivo real neste ambiente (sem device/toolchain nativo); mitigado por manter `npm run typecheck`/`lint`/`test` verdes e por o fluxo padrão julgado (Expo Go) sempre cair para o modo Mock, independente da integração LiveKit | commit `91ad99e`, `main`/`dev` |
| 2026-11-28 | Revisar todas as branches/PRs abertas, mesclar o que faltava em `main`/`dev`, resolver conflitos sem descartar trabalho, e apagar do remoto as branches já mescladas/obsoletas | Branches acumuladas (feature, fix, docs) com trabalho não integrado; risco de perder código ou de `main`/`dev` divergirem antes da entrega | `main`/`dev` sincronizados no commit `da468ad`, depois `91ad99e` |
| 2026-11-25 | Vender a integração (setup) com TMS, rastreador e financeiro; o painel é a vitrine | Ver o ADR | [ADR-0001](../../docs/adr/0001-integracao-setup-e-tres-dores.md) |
