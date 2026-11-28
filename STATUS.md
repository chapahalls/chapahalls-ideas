# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261128-0900.md`](docs/report/judge-20261128-0900.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 2d14h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- As duas demos anunciadas continuam quebradas (sexta rodada seguida):
  - o painel na Vercel ainda chama a API sem banco (bundle `index-B9aLfjQ1.js`, `rodar-backend-five.vercel.app`, `ok: false`);
  - o link `rodarglobal.github.io/rodar-mobile` do README do mobile dá 404.
- O deploy por `:sha` falhou em `d8af042`, e o `8b303db` é a segunda tentativa. O `/health` ainda mostra `62076bd`. Confiram o job `deploy`. Se falhar de novo, voltem ao `force-new-deployment`.
- A fila na doca (`62076bd`) está no ar, mas sem medição. Faltam o atraso fechado e a negação "não tem fila".
- A voz LiveKit do mobile está sem o plugin Expo e sem teste em aparelho.
- Os totais de testes não batem entre os READMEs: 661 no backend, 554 e "33 de 33" no mobile. A contagem real é perto de 700, e a validação dá 32 de 34 etapas.

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 17/20 | Falta o vídeo. O deploy por `:sha` ainda não teve sucesso, e a AWS está em `62076bd`. A fila na doca não foi medida. O STATUS ainda é de `4d01768` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 (no projeto, 14 enquanto o deploy apontar para a API sem banco) | O `VITE_API_BASE_URL` da Vercel aponta para a API sem banco. A proteção da `main` não está ligada. Falta o vídeo | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 12/20 | O link da demo dá 404. A voz LiveKit está sem plugin nativo e sem prova em aparelho. O `.idea/` está versionado. O README tem números velhos. Falta o vídeo. O STATUS ainda é de `28e1569` | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | O mobile o usa só atrás de flag, e o backend não valida o token. Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min: a voz real pelo `/mobile-web` contra o CloudFront, o recebedor avisado na aproximação, o escalonamento, a estadia em R$ e o OCOREN. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Consertar as demos sem commit: `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy na Vercel, e a Pages do mobile ligada. Confirmar `8b303db` no `/health`. Depois, cobrir o atraso fechado e a negação da fila e medir a 5e/5e2 de 4 a 8 vezes no CloudFront (H1 6→7).
3. Um só total de testes e "32 de 34" (ou a medição nova) nos três READMEs, e o `/mobile-web` citado como demo do motorista no backend (H2 7→8, junto com o item 4).
4. Voz nativa: os plugins LiveKit/WebRTC e um teste no celular, ou a declaração de que o nativo roda em Mock. Tirar o `.idea/` e ligar a proteção da `main` do web.
5. Rodar `/registrar rodar-backend` e `/registrar rodar-mobile`, e registrar a troca Agora → LiveKit com `/adr`.
