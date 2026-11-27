# OCOREN: estrutura para implementação no rodar-backend

Pesquisa de 27/11/2026, revisada com o manual OCOREN 5.0 da Intelipost (PDF enviado pelo time). Responde ao item "conector OCOREN" do judge (H3 7→8) e à promessa do [ADR-0001](adr/0001-integracao-setup-e-tres-dores.md) e do `PLAN.md` ("TMS via EDI OCOREN (Proceda): ocorrências de chegada, espera e descarga").

## 1. Mercado: o quanto a 5.0 é sólida e quantas versões existem

- **3.1 e 5.0 convivem. A versão é combinada com cada embarcador, não é uma regra do mercado.**
  - **Intelipost:** aceita 3.1 ou 5.0, conforme alinhado com o embarcador, e **ignora arquivo de outra versão**. Um erro de versão falha em silêncio.
  - **TOTVS GFE:** pergunta a versão (3.1 ou 5.0) na exportação e detecta sozinho na importação. A 5.0 entrou por patch (boletim TR8627).
  - **Brudam:** importa 3.0, 3.0A, 3.1, 5 e "customizado".
- **A 3.1 é a mais documentada e a mais suportada:** manual PROCEDA de 2000, parsers open source, TOTVS e Senior.
- **A 5.0 é suportada pelos TMS grandes,** mas quase nenhuma biblioteca independente a implementa. A especificação é da TIVIT, de 2008, e a Intelipost publica só 000/540/541/542.
- **Existem variantes por embarcador,** por exemplo "Proceda Schneider OCOREN 3.1", e campos "obrigatórios dependendo do parceiro" (romaneio e números SAP no 542 da 5.0).

**Sobre "cada empresa usa uma versão, então precisamos de adapters por versão": em parte.** O que varia entre empresas é, nesta ordem:

1. o **De-Para de códigos** (cada embarcador cadastra os seus);
2. os **campos condicionais exigidos** (romaneio, SAP, conhecimento);
3. a **versão** (na prática 3.1 ou 5.0; 3.0/3.0A são raras);
4. o **transporte** (SFTP, e-mail, VAN, upload no portal);
5. a **codificação** (Windows-1252 e CRLF).

Um adapter em código por versão é a abstração errada. Cada variante viraria um fork. O certo é:

- **Um motor só** de largura fixa, que lê a **especificação do layout como dado** (tabela de registros e campos).
- **Um perfil por parceiro**, que escolhe a especificação e define De-Para, campos extras, transporte e codificação.
- Variante "customizada" = cópia da especificação com ajustes, sem código novo. É o mesmo princípio do "mapeamento declarativo" do `PLANO-CONECTORES-TMS.md`.

## 2. Por que a 5.0 é a melhor versão para o RODAR

O registro 542 da 5.0 tem **campos próprios para a prova da estadia**, que a 3.1 não tem:

| Campo 542 (5.0) | Pos. (base 1) | Origem no RODAR |
|---|---|---|
| 19-20 data e hora da chegada no destino | 165 · 173 | evento `chegada` (geocerca + rastreador) |
| 21-22 data e hora do início da descarga | 177 · 185 | início da descarga (hoje não registrado separadamente: ver seção 5) |
| 23-24 data e hora do término da descarga | 189 · 197 | evento `descarga` |
| 25-26 data e hora da saída do destino | 201 · 209 | saída da geocerca do destino |

- Na 3.1, a espera só cabe no texto livre, como frase que o TMS não lê.
- Na 5.0, **uma linha 001 (entrega realizada) com os campos 19-26 preenchidos** entrega ao embarcador os horários que provam a estadia, em campos que o TMS dele já importa.
- **Limite:** o 542 da 5.0 **não tem texto livre nem valor em R$**.
  - A cobrança da estadia não é papel do OCOREN.
  - Ela vai no CONEMB/DOCCOB (conhecimento complementar e fatura).
  - O OCOREN dá a prova dos horários; o valor sai do backend (`dominio/estadia.py`) para o financeiro.

**Decisão proposta:** o motor nasce com duas especificações. A **5.0 é o padrão do demo**; a **3.1 vem como segunda especificação**, para provar a flexibilidade. Com o motor pronto, a segunda especificação custa uma tabela.

## 3. Especificações

Regras comuns (manual Intelipost 5.0, manual PROCEDA 3.1):

- Todos os registros com o mesmo tamanho (250 na 5.0, 120 na 3.1).
- A: alinhado à esquerda, completado com espaços. N: alinhado à direita, com zeros à esquerda. Decimais implícitos (N 13,2 ocupa 15 posições).
- Campo vazio: zeros se N, espaços se A.
- M = obrigatório, C = condicional. Respeitar o número de ocorrências de cada registro.
- Na 3.1, maiúsculas. Valor maior que o campo é **erro**, nunca truncamento.

### 3.1 OCOREN 5.0 (250 posições), conforme o manual da Intelipost

| Reg. | Ocorre | Campo | Fmt | Pos. | St. | Origem / nota |
|---|---|---|---|---|---|---|
| 000 | 1 por arquivo | identificador `000` | N3 | 001 | M | |
| | | remetente (caixa postal) | A35 | 004 | M | transportadora |
| | | destinatário (caixa postal) | A35 | 039 | M | embarcador |
| | | data DDMMAA | N6 | 074 | M | |
| | | hora HHMM | N4 | 080 | M | |
| | | identificação do intercâmbio | A12 | 084 | M | sugestão `OCO50DDMM999` |
| | | filler | A155 | 096 | C | espaços |
| 540 | até 200 por 000 | identificador `540` · identificação do documento | N3 · A14 | 001 · 004 | M | sugestão `OCORR50DDMM999` |
| | | filler | A233 | 018 | C | |
| 541 | 1 por 540 | identificador `541` · CNPJ da transportadora | N3 · N14 | 001 · 004 | M | `Empresa.cnpj` |
| | | razão social | A50 | 018 | C | |
| | | filler | A183 | 068 | C | |
| 542 | até 9.999 por 541 | identificador `542` | N3 | 001 | M | |
| | | CNPJ do emissor da NF (embarcador) | N14 | 004 | M | chave NF-e |
| | | série da NF | A3 | 018 | C | chave NF-e |
| | | número da NF | N9 | 021 | M | chave NF-e (9 dígitos cabem) |
| | | código da ocorrência | N3 | 030 | M | De-Para (seção 4) |
| | | data DDMMAAAA · hora HHMM | N8 · N4 | 033 · 041 | M · C | horário do evento, America/Sao_Paulo |
| | | código de observação | N2 | 045 | C | 01 recusa total, 02 recusa parcial, 03 entrega por acordo, 04/05 devolução com NF do destinatário |
| | | romaneio/ordem de coleta | A20 | 047 | C | NOTFIS reg. 505 campo 23; exigido por alguns parceiros |
| | | identificação do embarque #1, #2, #3 (SAP etc.) | A20 ×3 | 067 · 087 · 107 | C | NOTFIS reg. 505 campos 24-26 |
| | | filial · série · número do conhecimento | A10 · A5 · A12 | 127 · 137 · 142 | C | CT-e (mock) |
| | | tipo de entrega | A1 | 154 | C | 1 primeira entrega · 2/3/4 reentrega (embarcador, destinatário, transportador) |
| | | código da empresa · filial emissora da NF | A5 · A5 | 155 · 160 | C | |
| | | **chegada no destino** data · hora | N8 · N4 | 165 · 173 | C | evento `chegada` |
| | | **início da descarga** data · hora | N8 · N4 | 177 · 185 | C | seção 5 |
| | | **término da descarga** data · hora | N8 · N4 | 189 · 197 | C | evento `descarga` |
| | | **saída do destino** data · hora | N8 · N4 | 201 · 209 | C | saída da geocerca |
| | | CNPJ · série · número da NF de devolução | N14 · A3 · N9 | 213 · 227 · 230 | C | não usado |
| | | filler | A12 | 239 | C | |
| 543-545, 549 | — | complementos e totalizador | — | — | — | **não publicados pela Intelipost**. O validador de referência (manual TIVIT 2008) diz que existem e que o 549 traz contagens. Confirmar antes de enviar a outro parceiro |

Códigos de ocorrência 5.0 (3 dígitos): 000-105, sem o 038 (ausente tanto na tabela da Intelipost quanto no validador), e 201-213 (datas e dados de transbordo).

### 3.2 OCOREN 3.1 (120 posições)

Posições confirmadas por duas fontes: `edi-proceda`, e TOTVS (código na posição 29, observação na 43, texto na 45). Base 1:

| Reg. | Campo | Fmt | Pos. |
|---|---|---|---|
| 000 | remetente · destinatário · data DDMMAA · hora HHMM · intercâmbio · filler | A35 · A35 · N6 · N4 · A12 · A25 | 004 · 039 · 074 · 080 · 084 · 096 |
| 340 | identificação do documento · filler | A14 · A103 | 004 · 018 |
| 341 | CNPJ · razão social · filler | N14 · A40 · A63 | 004 · 018 · 058 |
| 342 | CNPJ emissor NF · série · número · código · data+hora DDMMAAAAHHMM · observação · texto livre · filler | N14 · A3 · N8 · N2 · N12 · N2 · A70 · A6 | 004 · 018 · 021 · 029 · 031 · 043 · 045 · 115 |
| 343 | redespacho (condicional) | — | não gerar |

Na 3.1 o número da NF tem 8 dígitos (acima disso é erro), o código tem 2 dígitos, e a espera vai no texto livre.

## 4. De-Para padrão (editável por parceiro)

| Evento RODAR | 5.0 | 3.1 | Observação |
|---|---|---|---|
| `retirada` | 000 | 00 | processo de transporte iniciado |
| `aproximacao` + `aviso_recebedor` | 098 | 98 | chegada na cidade/filial de destino |
| `descarga` | **001** + campos 19-26 | 01 + texto `ESPERA 11H40 EXCED 7H` | a linha principal: prova da estadia |
| `nao_recebe_hoje` | 091 ou 005 | 91 ou 05 | entrega programada ou falta de espaço |
| `ligacao_nao_atendida` (recebedor) | 046 | 46 | responsável de recebimento ausente |
| fila na doca (opcional) | 044 | 44 | excesso de veículos |
| `ocorrencia` com tipo | 058 quebra · 027 roubo · 076 via interditada · 078/079 avaria | idem com 2 dígitos | |
| `rota_cancelada` antes da retirada | 053 | 53 | mercadoria não embarcada |
| `chegada` sozinha | sem linha na 5.0 (vai nos campos 19-20 do 001) | 99 + texto, se o parceiro quiser | não existe código padrão "aguardando descarga" |

## 5. Dados que faltam no backend

| Onde | Campo | Por quê |
|---|---|---|
| `Empresa` | `cnpj`, `razao_social` | 000, 541/341 (hoje só tem `nome`) |
| `Rota` | `nfe_chave` (44, DV módulo 11) | 542: CNPJ, série e número saem da chave. `nota_fiscal` (`DEMO-AVISAI-002`) não serve |
| `Rota` | `embarcador_nome`, `embarcador_cnpj`, `romaneio` | destinatário do arquivo e campo 9 do 542 |
| `Rota`/`Estadia` | `descarga_inicio_em`, `saida_destino_em` | campos 21-22 e 25-26. Hoje só existem chegada e fim da descarga. Sem eles os campos ficam zerados (condicionais, o que é válido) |
| nova `ParceiroEdi` | `empresa_id`, `nome`, `layout` (`ocoren-5.0`/`ocoren-3.1`/variante), `caixa_remetente`, `caixa_destinatario`, `depara` JSON, `campos_extras` JSON, `codificacao`, `fim_de_linha`, `transporte` (`download` agora) | o perfil por parceiro da seção 1 |

Seed com CNPJs e chaves fictícios, com DV válido (X6).

## 6. Estrutura de código

```text
backend/app/conectores/edi/
├── motor.py         Campo(nome, pos, tam, tipo A|N, decimais, status M|C); Registro(id, tamanho, campos, ocorre)
│                    formatar(registro, valores) -> str  ·  ler(linha, layout) -> dict
│                    valida tamanho, tipo, M/C, ordem e ocorrências; normaliza acento e caixa conforme o layout
├── layouts/
│   ├── ocoren_50.py   especificação da seção 3.1 (só dados)
│   └── ocoren_31.py   especificação da seção 3.2 (só dados)
├── codigos.py       tabelas de ocorrência 5.0 (000-105, 201-213) e 3.1 (00-99), observações, DEPARA_PADRAO
├── nfe.py           ChaveNFe.parse -> cnpj, serie, numero; DV módulo 11
├── ocoren.py        gerar(parceiro, transportadora, ocorrencias, agora, seq) -> bytes   (puro: sem banco nem relógio)
└── fonte.py         ocorrencias_da_rota(rota_id, parceiro) -> list[OcorrenciaEdi]  (eventos + estadia do backend)
backend/app/api/edi.py
   GET  /rotas/{id}/ocoren?parceiro=     papel cco · arquivo cp1252, OCOREN_<cnpj>_<DDMMHHMM>.txt · 409 sem NF-e/CNPJ
   GET  /edi/parceiros · POST /edi/parceiros · PATCH /edi/parceiros/{id}   papel cco
   POST /edi/validar                     recebe um arquivo e devolve erros por linha/campo (ajuda na homologação)
backend/tests/conectores/edi/
   test_motor.py      tamanho fixo, A/N, M/C, campo grande → erro, ocorrências máximas
   test_layouts.py    soma dos campos = tamanho do registro (250/120), sem buraco nem sobreposição
   test_ocoren.py     arquivos de referência fictícios 5.0 e 3.1 byte a byte; ida e volta gerar → ler
   test_api_edi.py    rota demo: descarga com espera de 11h40 → 542 com 001 e campos 19-24 preenchidos
```

- O teste de layout (a soma dos campos fecha em 250/120) pega erro de digitação na especificação, que é o erro mais provável.
- `gerar` tem o mesmo formato da porta `DestinoEventos.montar` do plano de conectores: o núcleo de conectores reaproveita depois, sem reescrever.
- SFTP, fila e outbox ficam para o núcleo de conectores. Até 30/11 o envio é download manual.

**Esforço até 30/11:** motor com as duas especificações e testes, M (cerca de 1 dia). Perfil de parceiro com API, P/M. Botão no painel, P.

## 7. Demo e README

- **Vídeo:** viagem com espera de 11h40, depois o botão "Baixar OCOREN 5.0". O arquivo aberto mostra a linha 542 com 001 e os horários de chegada e fim da descarga. Em seguida, trocar o parceiro para 3.1 e baixar de novo, para mostrar a flexibilidade.
- **README (E5/E8, X2):**
  - Layouts baseados nos manuais PROCEDA 3.1 e OCOREN 5.0 (Intelipost).
  - `hfoletto/edi-proceda` (MIT) usado só como referência de posições.
  - **Simulado:** sem SFTP (download), CNPJs e NF-e fictícios, De-Para não homologado.
  - Dizer "gera OCOREN 3.1 e 5.0", nunca "integrado ao TOTVS/Intelipost".

## 8. Em aberto

- Registros 543, 544, 545 e 549 da 5.0: falta o manual TIVIT. Sem o 549, um leitor que exige o totalizador pode recusar o arquivo; a Intelipost não o documenta.
- Formato oficial da identificação do intercâmbio e do documento: os manuais trazem só sugestões.
- Código para "chegou, aguardando descarga": combinar com um embarcador real.
- 3.0/3.0A e variantes: só quando um cliente pedir. O motor já comporta.

## Fontes

- Manual OCOREN 5.0, Base de Conhecimento Intelipost (PDF enviado pelo time, 6 páginas).
- [Intelipost: como a transportadora disponibiliza os arquivos PROCEDA EDI](https://ajuda.intelipost.com.br/pt-BR/articles/5527436-como-a-transportadora-pode-disponibilizar-os-arquivos-proceda-edi), conforme resumo de busca.
- [TOTVS: boletim de implementação do layout 5.0 no GFE](https://tdn.totvs.com/download/attachments/173083753/GFE_BT_EDI_Ocorren_Implementacao_Layout_5_0_TR8627.pdf?version=1&modificationDate=1416916939000&api=v2) e [TOTVS: exportações e importações de EDI](https://centraldeatendimento.totvs.com/hc/pt-br/articles/360053237474-Log%C3%ADstica-Linha-Protheus-GFE-Exporta%C3%A7%C3%B5es-e-Importa%C3%A7%C3%B5es-de-EDI-no-SIGAGFE), conforme resumo de busca.
- [TOTVS: tipo e motivo de ocorrência](https://centraldeatendimento.totvs.com/hc/pt-br/articles/4404198105751) e [TOTVS: importação de OCOREN](https://centraldeatendimento.totvs.com/hc/pt-br/articles/360025639914): posição do código (29 na 3.1, 30 na 5.0).
- [Brudam: EDI para transportadora](https://brudam.com.br/edi-para-transportadora/): 3.0, 3.0A, 3.1, 5 e customizado.
- [hfoletto/edi-proceda](https://github.com/hfoletto/edi-proceda): posições e tabelas da 3.1 (MIT). [GabrielPertile/edi-proceda](https://github.com/GabrielPertile/edi-proceda): OCOREN 3.1/5.0 ainda "planejado". [VALIDADOREDI](https://github.com/emoraesconsultoria-coder/VALIDADOREDI): regras gerais da 3.1 e 5.0, registros 543-549.
- [Proceda Schneider OCOREN 3.1](http://www.cibras.com.br/left-edi/LEFT-EDI-PROCEDA-OCOREN.pdf): exemplo de variante por embarcador (só o título, o PDF não abriu).
