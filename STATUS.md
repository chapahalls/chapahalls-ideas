# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261127-2016.md`](docs/report/judge-20261127-2016.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 3d3h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- A API agora está no ar com banco (`https://d3fy4m7zwukr3x.cloudfront.net`, login e `/rotas` funcionam), mas o painel publicado roda no modo Demo e o CORS da API só libera o Pages, que dá 404. O júri não vê o produto falando com a API real.
- A API roda numa conta AWS dev de uma empresa. Ela precisa ficar no ar até 12/12, e alguém precisa garantir isso por escrito.
- Ainda há links ruins: o "app do motorista" do web (linha 32) dá 404, e o topo do README do backend manda para a Vercel sem banco.
- A voz do app nativo não conecta ao backend (Agora × LiveKit), e a voz atual não tem prova ponta a ponta.
- As contagens de testes se contradizem: o web diz 554, o backend diz 615, e o número conferido é 621 (379 + 144 + 98).

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 15/20 | API HTTPS com banco no CloudFront (AWS ECS + RDS via OpenTofu), mas o CORS não libera o painel da Vercel; o topo do README ainda aponta para a Vercel sem banco; falta o vídeo; o deploy na AWS é manual; o 500 expõe `str(e)`; não há validação ponta a ponta no LiveKit; o STATUS ainda dá a infra como branch sem PR | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 14/20 | o deploy na Vercel funciona, mas só no modo Demo; o link do app do motorista dá 404; falta o vídeo; o README fala em 127 testes (são 144); o STATUS não registra o seletor de velocidade | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 13/20 (no projeto, 12, porque a voz não conecta ao backend) | a voz real está quebrada contra o backend (Agora × LiveKit); não há link de demo nem de vídeo; "GPT-Live" ainda aparece na tela; o STATUS cita o Whisper local, que já foi removido | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | nenhum outro repo o usa (o login segue MOCK); faltam os links de demo e de vídeo e as seções de dependências e de terceiros | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min com a voz real contra o CloudFront, o escalonamento, a estadia fechando e o OCOREN gerado, com o link no painel e nos READMEs. Gravar a Demo em 2x (S5/X7; H4 3→6).
2. Ligar o painel publicado à API publicada: incluir a origem da Vercel em `CORS_ORIGENS` e publicar um deploy com `VITE_API_BASE_URL` no CloudFront. Depois, refazer o `evidence/validacao.md` com a voz atual (H1 6→7).
3. Corrigir os links: o topo do README do backend no CloudFront, o "app do motorista" do web em `/mobile-web` e o link da demo no mobile. Tirar a Vercel sem banco da frente (S4; protege H1).
4. Religar a voz do app ao LiveKit, ou declarar que o app nativo roda no modo Mock (H1 +1, H2 +1).
5. Deixar READMEs, STATUS e locales coerentes (H2):
   - 621 testes (379 + 144 + 98) no web e no backend;
   - nada de "GPT-Live" na tela;
   - 500 genérico em `deps.py:32`;
   - `/registrar` no backend, no web e no mobile;
   - garantir a conta AWS no ar até 12/12.
