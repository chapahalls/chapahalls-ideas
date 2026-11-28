# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261128-1010.md`](docs/report/judge-20261128-1010.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 2d13h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- O link `rodarglobal.github.io/rodar-mobile` do README do mobile dá 404 (nona rodada). O painel na Vercel foi resolvido: ele agora chama o CloudFront, que responde com banco e com CORS correto.
- Falta confirmar no navegador que o "Conectar à API" do painel carrega a frota real e aceita uma ação do CCO. Só os endpoints foram testados, com `curl`.
- Os READMEs se contradizem:
  - web l.239 diz que o deploy não chama API real;
  - web diz "33 de 33", e o backend diz "34/34";
  - o backend diz que o motorista não tem demo web;
  - os totais de testes são 661, 554 e 145.
- A voz LiveKit do mobile está sem o plugin Expo e sem teste em aparelho. A correção do contrato `atraso` no web veio sem teste de regressão.

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 18/20 | Falta o vídeo. Faltam testes para o atraso fechado e para a negação da fila. A 5e falha 1 em 4 (declarado). O README nega o `/mobile-web` e ainda cita a Vercel sem banco | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 | Falta o vídeo. Falta o teste de contrato do modo API (2 regressões seguidas). A l.239 do README está desatualizada. A proteção da `main` está desligada. O STATUS ainda é de `bac015f` | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 12/20 | O link da demo dá 404, e o STATUS o marca como Ok. A voz LiveKit está sem plugin nativo e sem prova em aparelho. O `.idea/` está versionado. O README tem números velhos. Falta o vídeo | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | O mobile o usa só atrás de flag, e o backend não valida o token. Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min, todo sobre URLs públicas: a doca em uma frase, a voz real pelo `/mobile-web`, o painel da Vercel em modo API recebendo o atraso e o escalonamento, e a estadia em R$ com o OCOREN. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Resolver o 404 do mobile sem commit, ligando a Pages, ou trocar o link pelo `/mobile-web`. Confirmar o "Conectar à API" no navegador (S4; H1 6→7).
3. Alinhar os READMEs: um só total de testes e etapas, a web l.239 com o CloudFront, e o backend citando o `/mobile-web` (H2 7→8, junto com o item 4).
4. Teste de contrato do snapshot no web (`atraso` no `isCall`/`projectSnapshot`). Voz nativa: os plugins LiveKit/WebRTC e um teste no celular, ou a declaração de que roda em Mock. Tirar o `.idea/` e ligar a proteção da `main` do web.
5. Rodar `/registrar rodar-web` e `/registrar rodar-mobile` (o STATUS do mobile marca o link em 404 como Ok), e registrar a troca Agora → LiveKit com `/adr`.
