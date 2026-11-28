# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 22 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261128-1131.md`](docs/report/judge-20261128-1131.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 2d12h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- Novo: a CI do web deve estar vermelha em `70a2414`. O login da Demo agora vai para `/dashboard/mobile-demo`, mas o smoke e2e ainda espera `/dashboard`.
- O link `rodarglobal.github.io/rodar-mobile` dá 404 (11ª rodada), e o STATUS do mobile o marca como Ok.
- O celular do recebedor no web (`70a2414`) é simulado no navegador. A sala real em `RECEBEDOR_MODO=rtc` continua sem ninguém que a receba, e o painel não mostra `pagina_recebedor`.
- A Routes API do web segue sem cache negativo. Os READMEs se contradizem em dois pontos: web l.239 (API real) e backend (`/mobile-web`). Os números de testes também não batem.
- Falta confirmar no navegador o "Conectar à API".

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 18/20 | Falta o vídeo. O link do recebedor em `rtc` não chega a ninguém, e o `ChamadoCCO` duplicado nunca escala. A 5e falha 1 em 4. O README nega o `/mobile-web` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 14/20 | Smoke e2e quebrado pelo novo destino do login. `ReceiverCallPhone` sem teste. A Routes API não tem cache negativo, e falta o teste de contrato do modo API. A l.239 do README está desatualizada, e o STATUS é de `18f0e2a`. Falta o vídeo | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 12/20 | O link da demo dá 404, e o STATUS o marca como Ok. A voz LiveKit está sem plugin nativo e sem prova em aparelho. O `.idea/` está versionado. Falta o vídeo | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | O mobile o usa só atrás de flag, e o backend não valida o token. Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min sobre URLs públicas: a doca em uma frase, a voz real pelo `/mobile-web`, o recebedor (o real em `/recebedor?ligacao=<id>` ou o simulado com rótulo), o painel em modo API com o escalonamento e a estadia em R$ com o OCOREN. Link no painel e nos READMEs (S5/X7; H4 3→6).
2. CI do web verde: atualizar o `smoke.spec.ts` para `/dashboard/mobile-demo`, pôr um teste do `ReceiverCallPhone` e confirmar no Actions (H2 6→7).
3. Resolver o 404 do mobile (Pages ou `/mobile-web`), ligar o recebedor real ao `pagina_recebedor` no painel, pôr o cache negativo da Routes API e confirmar o "Conectar à API" (S4; H1 6→7).
4. Alinhar os READMEs (web l.239, backend `/mobile-web`, um só número de testes) e pôr o teste de contrato do snapshot no web (H2 7→8).
5. Rodar `/registrar rodar-web` e `/registrar rodar-mobile`, registrar a troca Agora → LiveKit com `/adr`, tirar o `.idea/` do mobile e ligar a proteção da `main` do web.
