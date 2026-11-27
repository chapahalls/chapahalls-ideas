# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 22 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-1530.md`](docs/report/judge-20261127-1530.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d8h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- Os links "Demo no ar" dos READMEs dão 404. A demo que funciona é `https://rodar-web-beta.vercel.app`.
- A voz do app nativo não conecta ao backend: o app pede `app_id` da Agora e o backend devolve token LiveKit.
- O backend tem três commits iniciais com o mesmo horário, o que um jurado pode ler como histórico importado (X1). Expliquem isso no README.

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 14/20 | sem URL pública fixa (só túnel); o link da demo no README dá 404; a validação ponta a ponta é anterior ao LiveKit | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 13/20 | o link "Demo no ar" dá 404 (a Vercel funciona, mas não está no README); falta o vídeo; o README chama a validação histórica de "api real" | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12: a voz não conecta ao backend) | a voz real está quebrada contra o backend (Agora × LiveKit); sem link de demo nem de vídeo; "GPT-Live" ainda aparece na tela | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | nenhum outro repo o usa (o login segue MOCK); faltam links de demo e vídeo e as seções de dependências e terceiros | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real e a estadia fechando, com o link no painel e nos READMEs (S5/X7; H4 3→6, H1 +1).
2. Trocar os links `rodarglobal.github.io` pela Vercel nos READMEs e pôr o link no mobile (S4; H1 +1).
3. Religar a voz do app ao LiveKit ou declarar que o app nativo roda no modo Mock (H1 +1, H2 +1).
4. Backend numa URL fixa, com o painel no modo API, para o júri ver dados reais (H1).
5. READMEs e locales coerentes (H2 e X1):
   - 573 testes;
   - validação marcada como "histórica";
   - uma frase sobre os commits de 22/11;
   - nada de "GPT-Live" na tela.
