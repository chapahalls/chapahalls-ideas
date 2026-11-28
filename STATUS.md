# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261128-0931.md`](docs/report/judge-20261128-0931.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 2d14h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- As duas demos anunciadas continuam quebradas (oitava rodada seguida):
  - o painel na Vercel ainda chama a API sem banco (chunk `operations-Bi56NYIX.js`, `rodar-backend-five.vercel.app`, `ok: false`);
  - o link `rodarglobal.github.io/rodar-mobile` do README do mobile dá 404.
- O backend está resolvido e o README dele agora bate com a evidência ("3 de 4 rodadas em 34/34"). Mas ainda diz que o motorista não tem demo web, e o `/mobile-web` responde.
- A voz LiveKit do mobile está sem o plugin Expo e sem teste em aparelho.
- Os totais de testes não batem entre os READMEs: 661 no backend, 554 e "33 de 33" no mobile. A contagem real é perto de 700.

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 18/20 | Falta o vídeo. Faltam testes para o atraso fechado e para a negação da fila. A 5e falha 1 em 4 (declarado). O README nega o `/mobile-web`. O STATUS ainda é de `4d01768` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 (no projeto, 14 enquanto o deploy apontar para a API sem banco) | O `VITE_API_BASE_URL` da Vercel aponta para a API sem banco. A proteção da `main` não está ligada. Falta o vídeo | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 12/20 | O link da demo dá 404. A voz LiveKit está sem plugin nativo e sem prova em aparelho. O `.idea/` está versionado. O README tem números velhos. Falta o vídeo. O STATUS ainda é de `28e1569` | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | O mobile o usa só atrás de flag, e o backend não valida o token. Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min: a voz real pelo `/mobile-web` contra o CloudFront, o recebedor avisado na aproximação, o escalonamento, a estadia em R$ e o OCOREN. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Consertar as demos sem commit: `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy na Vercel, e a Pages do mobile ligada (ou o link trocado pelo `/mobile-web`) (S4; H1 6→7).
3. Coerência dos READMEs: um só total de testes e o `/mobile-web` citado como demo do motorista no backend (H2 7→8, junto com o item 4).
4. Voz nativa: os plugins LiveKit/WebRTC e um teste no celular, ou a declaração de que o nativo roda em Mock. Tirar o `.idea/` e ligar a proteção da `main` do web.
5. Rodar `/registrar rodar-backend` e `/registrar rodar-mobile`, e registrar a troca Agora → LiveKit com `/adr`.
