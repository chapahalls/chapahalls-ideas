# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261128-0020.md`](docs/report/judge-20261128-0020.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 2d23h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- O painel publicado ainda chama a API sem banco. O bundle continua `index-B9aLfjQ1.js`. Falta trocar o `VITE_API_BASE_URL` na Vercel e fazer o redeploy.
- A correção da 4c e da 5e2 (`8b3f0d4`) ainda não está no ar (o `/health` mostra `eec39ea`) e só foi provada com LLM fake. Ela também abre um falso positivo: um "beleza, obrigado" vira detalhe da ocorrência.
- A voz do app nativo não conecta ao backend (Agora × LiveKit).
- O código e o README do backend citam o "júri" em comentários. A `main` do web não tem proteção de branch. Os READMEs dão 625 testes, mas o número conferido é 656 (413 + 145 + 98).

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 17/20 | Falta o vídeo. A correção da 4c e da 5e2 não está no ar nem medida, e tem um falso positivo na 5e2. Há menções ao "júri" no código. As linhas 36 e 40 do README estão desatualizadas. O STATUS está sobre `7fe3475` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 (no projeto, 14 enquanto o deploy apontar para a API sem banco) | O `VITE_API_BASE_URL` da Vercel aponta para a API sem banco, e a linha 239 do README diz que o deploy não usa a variável. A proteção da `main` não está ligada. Falta o vídeo | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12, porque a voz não conecta ao backend) | A voz real está quebrada contra o backend (Agora × LiveKit). Não há link de demo nem de vídeo. "GPT-Live" ainda aparece na tela. O STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | Nenhum outro repo o usa (o login segue MOCK). Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real contra o CloudFront, o recebedor avisado na aproximação, o escalonamento, a estadia fechando em R$ e o OCOREN gerado. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy, sem commit. Fechar o falso positivo da 5e2 (descartar "ok", "beleza", "obrigado"), com teste. Com o `/health` no commit novo, rodar `validar_fluxos.py` contra o CloudFront em 4 rodadas e publicar (H1 6→7).
3. Religar a voz do app ao LiveKit, ou declarar que o app nativo roda em Mock e linkar o `/mobile-web` como demo do mobile. Ligar a proteção da `main` do web. Trocar os comentários sobre o "júri" no backend (H2 7→8).
4. Deixar os READMEs coerentes:
   - no backend, a linha 36 aponta para o `/mobile-web` e a linha 40 usa 656 testes;
   - no web, a linha 239 diz a verdade sobre o `VITE_API_BASE_URL`;
   - nada de "GPT-Live" nem "agent-server" na tela do app.
5. Rodar `/registrar rodar-backend` e `/registrar rodar-mobile` (os STATUS estão sobre `7fe3475` e `28e1569`).
