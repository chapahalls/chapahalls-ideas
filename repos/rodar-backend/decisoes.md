# rodar-backend: decisões

Decisões que valem só para este repositório. Uma linha por decisão, a mais nova no topo. Decisão que muda o plano (fases, critérios, escopo) vai por `/adr` em [`docs/adr/`](../../docs/adr/), e aqui fica só o link.

| Data | Decisão | Por quê | Fonte |
|---|---|---|---|
| 2026-11-27 | Infra do backend sai do CDK/CloudFormation improvisado e vai pra OpenTofu dedicado (não CDK, não GCP), na conta AWS dev da Rumo (`140147589257`). RDS antigo decomissionado (snapshot final + stack deletada) e recriado 100% pelo OpenTofu; ECS Fargate num cluster próprio (`rumolog-cluster-dev`, não compartilha com `sginfra-cluster-dev`); ALB público em HTTP (sem TLS ainda) pra api, porque o front real (`rodar-web`/`rodar-mobile`) é GitHub Pages, não Vercel | A Vercel hospeda só o backend hoje, e o próprio README admite que é o host errado (serverless, sem tarefa de fundo, sem WebSocket, SSE limitado). Decisão ainda não chegou ao main: está na branch `infra/setup-opentofu-aws`, sem PR aberto | commit `5f0a4a9` em `infra/setup-opentofu-aws` (rodar-backend) |
| 2026-11-25 | Vender a integração (setup) com TMS, rastreador e financeiro; o painel é a vitrine | Ver o ADR | [ADR-0001](../../docs/adr/0001-integracao-setup-e-tres-dores.md) |
