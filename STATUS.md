# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261128-1052.md`](docs/report/judge-20261128-1052.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 2d13h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- O link `rodarglobal.github.io/rodar-mobile` do README do mobile dá 404 (décima rodada), e o STATUS do mobile o marca como Ok.
- Novo: o aviso ao recebedor (`RECEBEDOR_MODO=rtc`) cria um link de sala que ninguém recebe e que o painel não mostra. Ao vivo, a ligação termina `nao_atendida`. A página `/recebedor` está no ar e pode ser aberta à mão no vídeo.
- Novo: a Routes API do web (`18f0e2a`) não guarda a falha da consulta e a repete a cada atualização do mapa no modo API.
- Os READMEs se contradizem:
  - web l.239 diz que não há API real, e a l.295 diz que não há Routes API;
  - o backend diz que o motorista não tem demo web;
  - os números de testes e etapas não batem.
- Falta confirmar no navegador o "Conectar à API".

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 18/20 | Falta o vídeo. O link do recebedor em `rtc` não chega a ninguém, e o `ChamadoCCO` duplicado nunca escala. Faltam testes do atraso fechado e da negação da fila. A 5e falha 1 em 4. O README nega o `/mobile-web` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 | Falta o vídeo. Falta o botão "Abrir recebedor". A Routes API não tem cache negativo. Falta o teste de contrato do modo API. As l.239 e l.295 do README estão desatualizadas. A `main` está sem proteção. O STATUS é de `042e3d1` | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 12/20 | O link da demo dá 404, e o STATUS o marca como Ok. A voz LiveKit está sem plugin nativo e sem prova em aparelho. O `.idea/` está versionado. Falta o vídeo | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | O mobile o usa só atrás de flag, e o backend não valida o token. Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min sobre URLs públicas: a doca em uma frase, a voz real pelo `/mobile-web`, o recebedor atendendo em `/recebedor?ligacao=<id>`, o painel em modo API com o atraso e o escalonamento, e a estadia em R$ com o OCOREN. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Resolver o 404 do mobile (ligar a Pages ou usar o `/mobile-web`). Pôr o botão "Abrir recebedor" no web e o cache negativo da Routes API. Confirmar o "Conectar à API" no navegador (S4; H1 6→7).
3. Alinhar os READMEs: web l.239 e l.295, backend com o `/mobile-web`, um só número de testes e etapas (H2 7→8, junto com o item 4).
4. Teste de contrato do snapshot no web. Decidir o `ChamadoCCO` duplicado. Plugins LiveKit/WebRTC testados no celular, ou declarar o Mock. Tirar o `.idea/` e ligar a proteção da `main` do web.
5. Rodar `/registrar rodar-web` e `/registrar rodar-mobile`, registrar a troca Agora → LiveKit com `/adr` e fazer push (ou tirar a referência) do `rodar-backend@eb1977e`.
