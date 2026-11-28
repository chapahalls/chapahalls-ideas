# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-2154.md`](docs/report/judge-20261127-2154.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d2h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- O painel publicado ainda chama a API sem banco. Conferido no bundle às 21h55: a única URL de API é `rodar-backend-five.vercel.app`. O CORS do CloudFront já aceita a Vercel; falta trocar a variável e fazer o redeploy.
- A CI da main do rodar-web continua vermelha desde `830d6a4` (lint em `TaskPushNotifications.tsx:54`). A correção leva uma linha.
- O deploy da AWS agora roda pela CI do backend (`25dcce7`), mas ninguém confirmou que a primeira run ficou verde nem que o OCOREN responde com login no CloudFront.
- A API roda numa conta AWS dev de uma empresa. Ela precisa ficar no ar até 12/12, e alguém precisa garantir isso por escrito.
- A voz do app nativo não conecta ao backend (Agora × LiveKit), e a voz atual não tem prova ponta a ponta.
- Os três READMEs dão contagens de testes diferentes (625, 572 e 524). O número conferido é 632 (389 + 145 + 98).

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 16/20 | Falta o vídeo. A primeira run do `deploy` não foi confirmada, e o smoke aceita `/health` com `ok: false`. A linha 36 esconde o `/mobile-web`. A voz no LiveKit não tem validação ponta a ponta. O STATUS está desatualizado | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 14/20 (no projeto, 13 enquanto o deploy apontar para a API sem banco) | A CI está vermelha (lint, `TaskPushNotifications.tsx:54`), e a proteção da `main` não está ligada. O `VITE_API_BASE_URL` da Vercel aponta para a API sem banco, e a linha 239 do README nega isso. Falta o vídeo. O README dá 572 testes e "1 s = 1 min". O STATUS diz que o lint está com 0 avisos | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12, porque a voz não conecta ao backend) | A voz real está quebrada contra o backend (Agora × LiveKit). Não há link de demo nem de vídeo. "GPT-Live" ainda aparece na tela. O STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | Nenhum outro repo o usa (o login segue MOCK). Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real contra o CloudFront, o escalonamento, a estadia fechando e o OCOREN gerado. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy (sem commit). Confirmar a run verde do `deploy` do backend e testar ao vivo o "Conectar à API", o `/mobile-web` e um OCOREN (H1 6→7).
3. CI do web verde: `aria-hidden="true"` no `<svg>` de `TaskPushNotifications.tsx` e proteção da `main` com o job obrigatório (o web volta a 15/20; parte do H2 7→8).
4. Religar a voz do app ao LiveKit, ou declarar que o app nativo roda no modo Mock e linkar o `/mobile-web` como demo do mobile (com o item 3, H2 7→8; protege H1).
5. Deixar os READMEs e os STATUS coerentes:
   - no backend, a linha 36 aponta para o `/mobile-web` e a linha 40 usa 632 testes;
   - no web, a linha 239 diz a verdade sobre o `VITE_API_BASE_URL` e o relógio fica em 2 s = 1 min;
   - nos três, 632 testes;
   - nada de "GPT-Live" na tela do app;
   - `/registrar` nos três repos.
