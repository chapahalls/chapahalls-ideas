# Status do projeto

_Gerado pelo `/judge projeto` (CI). Não editar à mão; corrija o `repos/<repo>/STATUS.md` e deixe o judge refazer este._

**Nota do projeto: 23 / 40** (final exige 20) · último relatório: [`docs/report/judge-20261128-0110.md`](docs/report/judge-20261128-0110.md) · prazo: 30/11/2026 23h59 (UTC-3) · faltam 2d22h

**Alertas:**
- O vídeo de 3 min não existe (X7/S5). Sem ele, o projeto é desclassificado.
- As duas demos anunciadas continuam quebradas (terceira rodada seguida):
  - o painel na Vercel ainda chama a API sem banco (bundle `index-B9aLfjQ1.js`, `rodar-backend-five.vercel.app`, `ok: false`);
  - o link `rodarglobal.github.io/rodar-mobile` do README do mobile dá 404.
- **Novo:** o mobile migrou a voz para LiveKit (`91ad99e`) e agora fala o protocolo do backend, mas está sem o plugin Expo do LiveKit/WebRTC e sem teste em aparelho.
- A fila na doca segue falhando no ar (5e em 1/4, 5e2 em 0/4). O falso positivo "beleza, obrigado" continua sem teste.
- Os números não batem entre os READMEs: o mobile diz "33 de 33" e "554 testes", o backend diz 649, e o real é 32-33/34 e 413 + 145 + 130.

| Repositório | Nota do repo | O que bloqueia | Detalhe |
|---|---|---|---|
| rodar-backend | 17/20 | Falta o vídeo. A fila na doca (5e/5e2) falha no ar, e a linha 38 do README só cita a 5e2. "Júri" aparece nos testes e no `infra/README.md` | [STATUS](repos/rodar-backend/STATUS.md) · [decisões](repos/rodar-backend/decisoes.md) · [nota](repos/rodar-backend/score.md) |
| rodar-web | 15/20 (no projeto, 14 enquanto o deploy apontar para a API sem banco) | O `VITE_API_BASE_URL` da Vercel aponta para a API sem banco. A proteção da `main` não está ligada. Falta o vídeo. O score.md é de `bac015f`, e o `05d559e` só mexe no tour | [STATUS](repos/rodar-web/STATUS.md) · [decisões](repos/rodar-web/decisoes.md) · [nota](repos/rodar-web/score.md) |
| rodar-mobile | 12/20 | O link da demo dá 404. A voz LiveKit está sem plugin nativo e sem prova em aparelho. O `.idea/` está versionado. O README tem números velhos ("33 de 33", "554 testes"). Falta o vídeo. O STATUS ainda é de `28e1569` (cita Agora e Whisper) | [STATUS](repos/rodar-mobile/STATUS.md) · [decisões](repos/rodar-mobile/decisoes.md) · [nota](repos/rodar-mobile/score.md) |
| rodar-keycloak | 10/20 (estimativa do judge projeto) | O mobile o usa só atrás de flag (o padrão é mock), e o backend não valida o token. Faltam os links de demo e de vídeo e as seções de dependências e de terceiros. Recomendação: não submeter | [repo](https://github.com/rodarglobal/rodar-keycloak) |

## Falta para o projeto inteiro

1. Vídeo de até 3 min: voz real pelo `/mobile-web` contra o CloudFront, recebedor avisado na aproximação, escalonamento, estadia em R$ e OCOREN. Sem a fila falada nem o app nativo sem teste. Pôr o link no painel e nos READMEs (S5/X7; H4 3→6).
2. Consertar as demos sem commit:
   - na Vercel, `VITE_API_BASE_URL=https://d3fy4m7zwukr3x.cloudfront.net` e redeploy;
   - no mobile, ligar a Pages e rodar de novo o `Demo (GitHub Pages)`, ou trocar o link pelo `/mobile-web`.

   Depois, a regra determinística de `fila` depois da chegada e o descarte de "ok/beleza/obrigado", com testes e 4 rodadas no CloudFront (H1 6→7).
3. Voz nativa: adicionar os plugins `@livekit/react-native-expo-plugin` e `@config-plugins/react-native-webrtc` e testar no celular, ou declarar no README que o nativo roda em Mock. Tirar o `.idea/`, ligar a proteção da `main` do web e tirar "júri" dos testes do backend (H2 7→8).
4. Um só número nos três READMEs: 413 + 145 + 130 testes, e a validação como "32-33 de 34; falham 5e e 5e2".
5. Rodar `/registrar rodar-mobile` e registrar a troca Agora → LiveKit com `/adr`.
