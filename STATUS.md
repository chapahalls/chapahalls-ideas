# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261128-0057.md`](docs/report/judge-20261128-0057.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 2d23h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- As duas demos anunciadas estão quebradas:
  - o painel na Vercel ainda chama a API sem banco (bundle `index-B9aLfjQ1.js`, `rodar-backend-five.vercel.app`, `ok: false`);
  - **novo:** o link `rodarglobal.github.io/rodar-mobile` do README do mobile dá 404 (Pages desligada, o workflow falhou em `da468ad`).
- A correção da 4c está no ar (`sha: 8b3f0d4`) e foi medida em 4/4. A fila na doca segue falhando no ar: 5e em 1/4 e 5e2 em 0/4. O falso positivo "beleza, obrigado" continua sem teste.
- A voz do app nativo não conecta ao backend (Agora × LiveKit).
- Higiene que o júri vê: `.idea/` versionado no mobile, "júri" nos testes do backend, `main` do web sem proteção.

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 17/20 | Falta o vídeo. A fila na doca (5e/5e2) falha no ar, e a linha 38 do README só cita a 5e2. "Júri" aparece nos testes e no `infra/README.md`. O STATUS está sobre `7fe3475` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 (no projeto, 14 enquanto o deploy apontar para a API sem banco) | O `VITE_API_BASE_URL` da Vercel aponta para a API sem banco, e a linha 239 do README diz outra coisa. A proteção da `main` não está ligada. Falta o vídeo | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (estimativa sobre `da468ad`; no projeto, 12) | O link da demo dá 404. A voz real não conecta ao backend (Agora × LiveKit). O `.idea/` está versionado. Falta o vídeo. O score.md é de `9d7cc33` e o STATUS de `28e1569` | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | O mobile o usa só atrás de flag (o padrão é mock), e o backend não valida o token. Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real pelo `/mobile-web` contra o CloudFront, o recebedor avisado na aproximação, o escalonamento, a estadia fechando em R$ e o OCOREN gerado. A fila falada fica fora até ser corrigida. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Consertar as demos sem commit:
   - na Vercel, `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy;
   - no mobile, ligar a Pages (Source: GitHub Actions) e rodar de novo o `Demo (GitHub Pages)`, ou trocar o link pelo `/mobile-web`.

   Depois, a regra determinística de `fila` depois da chegada e o descarte de "ok/beleza/obrigado", com testes, seguidos de 4 rodadas no CloudFront (H1 6→7).
3. Religar a voz do app ao LiveKit, ou declarar que o nativo roda em Mock e que a voz real é o `/mobile-web`. Tirar o `.idea/`. Ligar a proteção da `main` do web. Tirar "júri" dos testes e do `infra/README.md` do backend (H2 7→8).
4. READMEs coerentes:
   - no backend, a linha 38 diz "5e e 5e2";
   - no web, a linha 239 diz a verdade sobre o `VITE_API_BASE_URL`.
5. Rodar `/registrar rodar-backend` e `/registrar rodar-mobile`.
