# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-2048.md`](docs/report/judge-20261127-2048.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d3h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- O CORS da API (`https://d3fy4m7zwukr3x.cloudfront.net`) já libera o painel da Vercel. Mas o painel publicado tem `VITE_API_BASE_URL` apontando para `rodar-backend-five.vercel.app`, que não tem banco (`/rotas` dá 500). O README do web diz que o deploy não tem essa variável.
- A API roda numa conta AWS dev de uma empresa. Ela precisa ficar no ar até 12/12, e alguém precisa garantir isso por escrito.
- Há links ruins e contraditórios: o "app do motorista" do web (linha 32) dá 404; o backend diz que o motorista não tem demo web, mas o `/mobile-web` existe; o topo do README do backend manda para a Vercel sem banco.
- A voz do app nativo não conecta ao backend (Agora × LiveKit), e a voz atual não tem prova ponta a ponta.
- As contagens de testes se contradizem: o web diz 554, o backend diz 615, e o número conferido é 621 (379 + 144 + 98).

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 15/20 | API HTTPS com banco no CloudFront, com o CORS já liberado para a Vercel; o topo do README ainda aponta para a Vercel sem banco; a linha 36 esconde o `/mobile-web`; falta o vídeo; o deploy na AWS é manual; o 500 expõe `str(e)`; não há validação ponta a ponta no LiveKit; o STATUS ainda dá a infra como branch sem PR | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 14/20 (no projeto, 13 enquanto o deploy apontar para a API sem banco) | o `VITE_API_BASE_URL` da Vercel aponta para `rodar-backend-five` (sem banco), e o README diz o contrário; o link do app do motorista dá 404; falta o vídeo; o README fala em 127 testes (são 144) | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12, porque a voz não conecta ao backend) | a voz real está quebrada contra o backend (Agora × LiveKit); não há link de demo nem de vídeo; "GPT-Live" ainda aparece na tela; o STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | nenhum outro repo o usa (o login segue MOCK); faltam os links de demo e de vídeo e as seções de dependências e de terceiros (o Keycloak é de terceiros). Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real contra o CloudFront, o escalonamento, a estadia fechando e o OCOREN gerado, com o link no painel e nos READMEs. Gravar a Demo em 2x (S5/X7; H4 3→6).
2. Trocar o `VITE_API_BASE_URL` do projeto da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy (sem commit; o CORS já está pronto). Depois, testar o "Conectar à API" e o `/mobile-web` ao vivo e refazer o `evidence/validacao.md` com a voz atual (H1 6→7).
3. Corrigir os links: o topo do README do backend no CloudFront, a linha 36 do backend e a linha 32 do web em `/mobile-web`, a linha 239 do web, e o link da demo no mobile (S4; protege H1).
4. Religar a voz do app ao LiveKit, ou declarar que o app nativo roda no modo Mock (H1 +1, H2 +1).
5. Deixar READMEs, STATUS e locales coerentes (H2):
   - 621 testes (379 + 144 + 98) no web e no backend;
   - nada de "GPT-Live" na tela;
   - 500 genérico em `deps.py:32`;
   - `/registrar` no backend, no web e no mobile;
   - garantir a conta AWS no ar até 12/12.
