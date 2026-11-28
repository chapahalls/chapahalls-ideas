# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-2234.md`](docs/report/judge-20261127-2234.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d1h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- O painel publicado ainda chama a API sem banco. Conferido no bundle às 22h35: a única URL de API é `rodar-backend-five.vercel.app`. Falta trocar a variável na Vercel e fazer o redeploy.
- Nenhuma run do `deploy` do backend tem prova de verde: o `/health` no CloudFront ainda não mostra o `sha` de bdc14e5.
- A API roda numa conta AWS dev de uma empresa. Ela precisa ficar no ar até 12/12, e alguém precisa garantir isso por escrito.
- A voz do app nativo não conecta ao backend (Agora × LiveKit), e a voz atual não tem prova ponta a ponta.
- A `main` do web não tem proteção de branch (a CI voltou a passar no lint em `05d559e`).
- Os READMEs dão contagens de testes diferentes (625 e 572). O número conferido é 634 (391 + 145 + 98).

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 16/20 | Falta o vídeo. O sha de bdc14e5 não aparece no `/health`, então nenhum deploy pela CI está provado. O smoke depende da ordem de `GET /rotas` e pode dar 409 falso. A linha 36 esconde o `/mobile-web`. A voz no LiveKit não tem validação ponta a ponta. O STATUS está sobre `7fe3475` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 (no projeto, 14 enquanto o deploy apontar para a API sem banco) | O `VITE_API_BASE_URL` da Vercel aponta para a API sem banco, e a linha 239 do README diz que o deploy não usa a variável. A proteção da `main` não está ligada. Falta o vídeo. O README dá 572 testes | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12, porque a voz não conecta ao backend) | A voz real está quebrada contra o backend (Agora × LiveKit). Não há link de demo nem de vídeo. "GPT-Live" ainda aparece na tela. O STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | Nenhum outro repo o usa (o login segue MOCK). Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real contra o CloudFront, o escalonamento, a estadia fechando e o OCOREN gerado. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy (sem commit). Confirmar o sha do último commit no `/health` e testar ao vivo o "Conectar à API", o `/mobile-web` e um OCOREN (H1 6→7).
3. Religar a voz do app ao LiveKit, ou declarar que o app nativo roda no modo Mock e linkar o `/mobile-web` como demo do mobile. Ligar a proteção da `main` do web com o job de CI obrigatório (H2 7→8).
4. Tornar o smoke do deploy determinístico (`order_by(Rota.id)` em `GET /rotas` ou filtrar uma rota com NF-e), para que a última run antes do congelamento saia verde (protege H1 e H2).
5. Deixar os READMEs e os STATUS coerentes:
   - no backend, a linha 36 aponta para o `/mobile-web` e a linha 40 usa 634 testes;
   - no web, a linha 239 diz a verdade sobre o `VITE_API_BASE_URL`, e o README usa 634 testes;
   - nada de "GPT-Live" nem "agent-server" na tela do app;
   - `/registrar` no backend e no mobile.
