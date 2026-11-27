# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 22 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-1650.md`](docs/report/judge-20261127-1650.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d7h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- A API do backend na Vercel (`rodar-backend-five.vercel.app`) dá 500 em todas as rotas com banco, inclusive o login. O `/health` agora mostra `banco_ok: false` e o README declara a limitação, mas o júri continua sem backend funcionando no ar. O 500 expõe o erro interno do psycopg no corpo.
- Ainda há links "Demo no ar" com 404: os dois do README do backend (linha 36) e o do app do motorista no web (linha 32). A demo que funciona é `https://rodar-web-beta.vercel.app/home`, e o `/mobile-web` também está no ar.
- A voz do app nativo não conecta ao backend: o app pede `app_id` da Agora e o backend devolve token LiveKit.
- O README do backend diz "615 testes (379 + 127 + 109)". O número conferido é 621 (379 + 144 + 98).

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 14/20 | a URL pública na Vercel dá 500 (sem banco; serverless não segura tarefas de fundo, WS e SSE); os dois links de demo do README dão 404; não há validação ponta a ponta no LiveKit; o STATUS ainda dá o PR #12 como aberto | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 14/20 | o deploy na Vercel funciona, mas o link do app do motorista dá 404; falta o vídeo; o README fala em 127 testes | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12: a voz não conecta ao backend) | a voz real está quebrada contra o backend (Agora × LiveKit); sem link de demo nem de vídeo; "GPT-Live" ainda aparece na tela; o STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | nenhum outro repo o usa (o login segue MOCK); faltam links de demo e vídeo e as seções de dependências e terceiros | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real, o escalonamento, a estadia fechando e o OCOREN gerado, com o link no painel e nos READMEs (S5/X7; H4 3→6, H1 +1).
2. Backend num container (Fly, Render ou Railway) com Postgres gerenciado e o painel no modo API. Se não der, tirar o badge e a linha "API em produção" do README e não expor `str(e)` no 500 (S4; H1 +1).
3. Trocar os links `rodarglobal.github.io` pela Vercel (`/home` e `/mobile-web`) nos READMEs do backend e do web e pôr o link no mobile (S4; protege H1).
4. Religar a voz do app ao LiveKit ou declarar que o app nativo roda no modo Mock (H1 +1, H2 +1).
5. READMEs, STATUS e locales coerentes (H2):
   - 621 testes (379 + 144 + 98);
   - nada de "GPT-Live" na tela;
   - `/registrar` no backend e no mobile.
