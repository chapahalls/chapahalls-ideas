# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 22 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-1659.md`](docs/report/judge-20261127-1659.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d7h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- A API do backend na Vercel (`rodar-backend-five.vercel.app`) dá 500 em todas as rotas que usam o banco, inclusive o login, e o 500 expõe o erro interno do psycopg. O README declara a limitação, mas o júri não vê nenhum backend funcionando no ar.
- Ainda há links "Demo no ar" com 404: os dois do README do backend (linha 36) e o do app do motorista no web (linha 32). As demos que funcionam são `https://rodar-web-beta.vercel.app/home` e `/mobile-web`.
- A voz do app nativo não conecta ao backend: o app pede o `app_id` da Agora e o backend devolve um token LiveKit.
- As contagens de testes se contradizem: o web diz 554 (318 + 127 + 109), o backend diz 615, e o número conferido é 621 (379 + 144 + 98).

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 14/20 | a URL pública na Vercel dá 500 (não tem banco, e o serverless não segura tarefas de fundo, WS e SSE); os dois links de demo do README dão 404; não há validação ponta a ponta no LiveKit; o STATUS ainda dá o PR #12 como aberto | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 14/20 | o deploy na Vercel funciona e ganhou o seletor de velocidade da Demo, mas o link do app do motorista dá 404; falta o vídeo; o README fala em 127 testes (são 144); o STATUS não registra o seletor | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12, porque a voz não conecta ao backend) | a voz real está quebrada contra o backend (Agora × LiveKit); não há link de demo nem de vídeo; "GPT-Live" ainda aparece na tela; o STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | nenhum outro repo o usa (o login segue MOCK); faltam os links de demo e de vídeo e as seções de dependências e de terceiros | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real, o escalonamento, a estadia fechando e o OCOREN gerado, com o link no painel e nos READMEs. Gravar a Demo em 2x (S5/X7; H4 3→6, H1 +1).
2. Backend num container (Fly, Render ou Railway) ou na Vercel com um Postgres gratuito, e o painel no modo API. Se não der, tirar o badge e a linha "API em produção" do README e não expor `str(e)` no 500 (S4; H1 +1).
3. Trocar os links `rodarglobal.github.io` pela Vercel (`/home` e `/mobile-web`) nos READMEs do backend e do web, e pôr o link da demo no mobile (S4; protege H1).
4. Religar a voz do app ao LiveKit, ou declarar que o app nativo roda no modo Mock (H1 +1, H2 +1).
5. Deixar READMEs, STATUS e locales coerentes (H2):
   - 621 testes (379 + 144 + 98) no web e no backend;
   - nada de "GPT-Live" na tela;
   - `/registrar` no backend, no web e no mobile.
