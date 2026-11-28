# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-2356.md`](docs/report/judge-20261127-2356.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d0h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- O painel publicado ainda chama a API sem banco. O bundle das 23h56 é o mesmo das 23h06 e só conhece `rodar-backend-five.vercel.app` (`banco_ok: false`). Falta trocar a variável na Vercel e fazer o redeploy.
- Na validação contra a AWS pública, a 4c (doca e previsão do recebedor) falha em 3 de 4 rodadas, e a 5e2 (fila detalhada) em 4 de 4.
- A voz do app nativo não conecta ao backend (Agora × LiveKit).
- O código e o README do backend citam o "júri" e o "score.md" em comentários. Troquem pela razão de domínio.
- A `main` do web não tem proteção de branch. Os READMEs dão 625 testes, mas o número conferido é 640 (397 + 145 + 98).
- **Fechado nesta rodada, no ar:** o `/health` público mostra `sha: "c9c040c"` com `ligar_recebedor_na_aproximacao: true`, e a validação de voz foi feita contra o CloudFront, com a 3d passando 4/4.

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 17/20 | Falta o vídeo. A 4c e a 5e2 falham na maioria das rodadas. Há menções ao "júri" no código. A linha 36 do README esconde o `/mobile-web`, e a linha 40 diz 625 testes. O STATUS está sobre `7fe3475` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 (no projeto, 14 enquanto o deploy apontar para a API sem banco) | O `VITE_API_BASE_URL` da Vercel aponta para a API sem banco, e a linha 239 do README diz que o deploy não usa a variável. A proteção da `main` não está ligada. Falta o vídeo | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12, porque a voz não conecta ao backend) | A voz real está quebrada contra o backend (Agora × LiveKit). Não há link de demo nem de vídeo. "GPT-Live" ainda aparece na tela. O STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | Nenhum outro repo o usa (o login segue MOCK). Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real contra o CloudFront, o recebedor avisado na aproximação, o escalonamento, a estadia fechando em R$ e o OCOREN gerado. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy, sem commit. Testar ao vivo o "Conectar à API", o `/mobile-web` e um OCOREN (H1 6→7).
3. Normalizar doca e previsão em `registrar_resposta_recebedor` (4c) e o aprofundamento da fila (5e2), com teste. Depois, rodar a validação de novo contra o CloudFront (protege H1 antes do vídeo).
4. Religar a voz do app ao LiveKit, ou declarar que o app nativo roda em Mock e linkar o `/mobile-web` como demo do mobile. Ligar a proteção da `main` do web. Trocar os comentários sobre o "júri" no backend (H2 7→8).
5. Deixar os READMEs e os STATUS coerentes:
   - no backend, a linha 36 aponta para o `/mobile-web` e a linha 40 usa 640 testes;
   - no web, a linha 239 diz a verdade sobre o `VITE_API_BASE_URL`;
   - nada de "GPT-Live" nem "agent-server" na tela do app;
   - rodar `/registrar` no backend e no mobile.
