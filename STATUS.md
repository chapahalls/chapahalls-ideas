# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-2134.md`](docs/report/judge-20261127-2134.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d2h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- O painel publicado ainda chama a API sem banco. Conferido nos 21 chunks do deploy às 21h34: a única URL de API é `rodar-backend-five.vercel.app`. Ela vem da variável da Vercel, e a linha 239 do README do web diz que essa variável não existe.
- A migração da AWS é manual (`migrar.sh`). Ninguém confirmou que o OCOREN responde no CloudFront com a coluna nova.
- A API roda numa conta AWS dev de uma empresa. Ela precisa ficar no ar até 12/12, e alguém precisa garantir isso por escrito.
- A voz do app nativo não conecta ao backend (Agora × LiveKit), e a voz atual não tem prova ponta a ponta.
- No backend, a linha 36 do README ainda esconde o `/mobile-web`. O link 404 do web foi corrigido.
- Os três READMEs dão contagens de testes diferentes (625, 572 e 524). O número conferido é 632 (389 + 145 + 98).

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 16/20 | Falta o vídeo. A linha 36 esconde o `/mobile-web`. O deploy na AWS é manual, e a migração em task separada pode deixar o OCOREN quebrado no ar. A voz no LiveKit não tem validação ponta a ponta. O STATUS ainda dá a infra como branch sem PR | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 (no projeto, 14 enquanto o deploy apontar para a API sem banco) | O `VITE_API_BASE_URL` da Vercel aponta para `rodar-backend-five` (sem banco), e a linha 239 do README nega isso. Falta o vídeo. O README dá 572 testes (são 632) e diz "1 s = 1 min" (no código, 2 s = 1 min). O STATUS não registra o e2e | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12, porque a voz não conecta ao backend) | A voz real está quebrada contra o backend (Agora × LiveKit). Não há link de demo nem de vídeo. "GPT-Live" ainda aparece na tela. O STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | Nenhum outro repo o usa (o login segue MOCK). Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real contra o CloudFront, o escalonamento, a estadia fechando e o OCOREN gerado. Pôr o link no painel e nos READMEs. Gravar a Demo em 2x (S5/X7; H4 3→6).
2. Trocar o `VITE_API_BASE_URL` da Vercel para `https://d3fy4m7zwukr3x.cloudfront.net` e fazer o redeploy (sem commit). Rodar `migrar.sh` e testar ao vivo o "Conectar à API", o `/mobile-web` e um OCOREN. Refazer o `evidence/validacao.md` com a voz atual (H1 6→7).
3. Religar a voz do app ao LiveKit, ou declarar que o app nativo roda no modo Mock e linkar o `/mobile-web` como demo do mobile (H2 7→8 se religar; protege H1).
4. Corrigir os READMEs: no backend, a linha 36 aponta para o `/mobile-web`; no web, a linha 239 trata do `VITE_API_BASE_URL` e o relógio fica em 2 s = 1 min; nos três, 632 testes (389 + 145 + 98) (S4; protege H1).
5. Deixar o resto coerente (H2):
   - nada de "GPT-Live" nem "agent-server" na tela do app;
   - `/registrar` no backend, no web e no mobile;
   - garantir a conta AWS no ar até 12/12.
