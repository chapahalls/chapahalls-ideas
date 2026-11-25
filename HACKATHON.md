# Hack Brasil 2026: regras e pontuação

> Fonte: [regulamento](https://hackbrasil.com/regulamento) (última atualização **18/11/2026**), [site](https://hackbrasil.com) e [mentores](https://hackbrasil.com/mentores), lidos em 25/11/2026. Se houver conflito com o FAQ ou outra comunicação, vale o regulamento (item 1.6).
> Este arquivo é a referência que o agente `judge` usa para pontuar e checar conformidade. Se o regulamento mudar, atualize aqui e a data acima. Dúvidas sobre regras: oi@hackbrasil.com.

## Nossa inscrição

- **Trilha:** Logística & automação.
- **Time:** Jeferson, Henry, Lucas e Eduardo. São 4, o máximo permitido (item 4.1). A composição pode mudar até 30/11 pelo painel (hackbrasil.com/painel).
- **Repositórios entregues:** [rodar-backend](https://github.com/rodarglobal/rodar-backend), [rodar-web](https://github.com/rodarglobal/rodar-web), [rodar-mobile](https://github.com/rodarglobal/rodar-mobile). O primeiro commit de cada um é de 22/11/2026, depois da abertura (item 6.1).
- **Este repositório (`rodar-ideas`)** guarda pesquisa e decisões, não é código do produto. Não entra na submissão.

## Cronograma (horário de Brasília)

| Quando | O quê |
|---|---|
| 04/11 19h-21h | Abertura (online). Repositórios só valem se forem criados **depois das 21h** |
| 23 e 27/11 | Livestreams opcionais |
| até 30/11 | Anúncio do júri |
| **30/11 23h59** | **Fim das submissões.** O júri avalia o último commit enviado ao GitHub até esse horário |
| 01/12 → 12/12 | **Repositórios congelados.** Nenhum commit (item 8.4). Pode-se preparar slides e ensaio e manter a demo no ar, sem mudar o código |
| 02/12 | Anúncio dos finalistas |
| **04/12 23h59** | Finalista confirma presença |
| **12/12** | Final presencial em São Paulo: o time termina o projeto no local e apresenta. Vencedores anunciados no mesmo dia |
| até 15/12 | Repositórios precisam continuar públicos (item 6.7) |

## Pontuação

Quatro critérios **com o mesmo peso**, nota de **0 a 10** cada. Nota do jurado = soma (0-40). Nota do projeto = média dos jurados (itens 9.1 e 9.2).

| # | Critério | O que o júri olha |
|---|---|---|
| **H1** | Execução técnica | se o produto **funciona e está completo** |
| **H2** | Implementação técnica | arquitetura, qualidade do código, escolha e uso das tecnologias, APIs e ferramentas (qualquer ferramenta tem o mesmo peso, item 6.3) |
| **H3** | Impacto do projeto | o efeito sobre **o problema e o público da trilha** (item 5.2) |
| **H4** | Qualidade da comunicação | o **vídeo** na fase online; a **apresentação ao júri** na final |

- **Nota mínima para a final:** 20/40, ou seja, média 5 por critério (item 9.4).
- **Finalistas:** os 5 melhores de cada trilha que atingem a nota mínima. Vagas que sobram vão para outras trilhas (item 8.1).
- **A final zera tudo:** o júri dá notas novas no dia 12/12, e a fase online não conta (item 9.3).
- **Desempate:** H1 execução → H3 impacto → maioria do júri (item 9.5).

Leitura prática: H1 é o primeiro desempate, e o júri **não é obrigado a instalar nem executar** nada (item 7.4). Quem não vê a demo no ar ou o produto funcionando no vídeo não dá nota alta em H1. H3 é o segundo desempate e é medido **contra a trilha**: impacto em logística, não em saúde ou segurança do motorista.

## Enquadramento na trilha (condição, não nota)

> "Logística & automação. Projetos que movem bens, informação ou trabalho de forma mais eficiente. Exemplos: conectores e integrações entre sistemas, automação de fluxos de trabalho, robótica, roteirização, estoque e cadeia de suprimentos."

O problema e o público precisam estar **dentro** da trilha. Citar o tema não basta (item 5.4). Se o júri achar que o projeto não se enquadra, pode avaliá-lo em outra trilha ou torná-lo **inelegível** (item 5.5).

## Eliminatórios (desclassificam)

| # | Regra | Item |
|---|---|---|
| **X1** | Repositórios **públicos no GitHub**, criados **depois de 04/11 21h**, com todos os commits depois disso. Repositório anterior, fork ou histórico importado desclassifica | 6.1 |
| **X2** | Nenhum código anterior ao evento que não fosse **público**, nem mesmo código privado do próprio time. Código aberto (starter kit, boilerplate, biblioteca) pode ser copiado **sem o histórico**, num commit cuja mensagem cite a origem | 6.2 |
| **X3** | Licença que impeça o júri de **ler, executar e testar** desclassifica. Licença open source é recomendada | 6.6 |
| **X4** | Repositórios públicos e acessíveis até **15/12** | 6.7 |
| **X5** | Temas proibidos: conteúdo adulto, drogas, armas, ódio, malware, apostas, pirâmide | 6.8 |
| **X6** | A demo não pode expor **dados pessoais reais** de terceiros | 6.9 |
| **X7** | Submissão completa até **30/11 23h59** (ver Entregáveis) | 7.1 |
| **X8** | **Nenhum commit** de 01/12 a 12/12 (período congelado) | 8.4 |
| **X9** | Time de 1 a 4 pessoas físicas com 18+, cada uma em um só time. Na final, **todos presentes** (falta só com justificativa aceita) | 3, 4.1, 8.5 |
| **X10** | Enquadramento na trilha (ver acima) | 5.4, 5.5 |

## Entregáveis (painel do time, até 30/11 23h59)

| # | Entregável | Detalhe |
|---|---|---|
| **S1** | Nome, frase de apresentação e descrição | no painel |
| **S2** | Trilha | uma só: Logística & automação |
| **S3** | Link de **cada** repositório no GitHub | os três |
| **S4** | Link da **demo funcionando** (HTTPS) | precisa ficar **no ar durante a avaliação**. Se cair, o júri avalia só pelo vídeo e pelo código (item 7.3) |
| **S5** | Link de um **vídeo de até 3 min**, acessível sem login, mostrando o produto funcionando | PT ou EN, o idioma não influencia a nota |
| **S6** | Aceite do regulamento e da autorização de dados (item 13.1) | sem isso, a submissão não é enviada |

Não são exigidos: slides na fase online (só na final), licença específica, nenhuma tecnologia de patrocinador.

## Júri

Anunciado até 30/11. Os já listados no site vêm de dados/ML (Apple, C6 Bank), produto e growth (Firecrawl, Strattum), Palantir, Capivarafy e estudantes de economia e ciência de dados (Harvard, WPI). **Não há ninguém de logística.** O vídeo precisa explicar o caminhão parado na doca do zero, em uma frase, antes de mostrar o produto.

## Mentores úteis para nós

Pedido no Discord, canal `#pedir-mentoria`. Nenhum mentor é de logística. Os mais próximos do que precisamos:

- **Agentes e backend:** Luiz Real (Arkana), Leandro Leite (Itaú), Marcos Guimarães (Time do Futuro), Patrick Passos Agostinho (Renor: memória e contexto para agentes; de MVP a produto), Rodrigo Lemela Duarte (superint.ai: infraestrutura).
- **Recorte de MVP e pitch:** Juliana Monteiro Assunção (Rank), Eduardo Wakim Neto.
- **Front, UI e Claude Code:** Samuel Rizzon (Git City), Alexandre Schrammel (Playlist).

A página mostra 10 de 14 mentores (página 1 de 2).

## Prêmios (resumo)

Final, classificação geral entre todas as trilhas: US$ 3 mil / 2 mil / 1 mil (Convex), créditos Firecrawl, Cognition e Resend, Nvoip Pro com número virtual, consultoria Capivarafy (PIPE/FINEP), Globalfy, WorkOS, AbacatePay, Jumpstart (vistos), Tech Fellow e C6 Bank. Detalhes no item 10 do regulamento.

**Prêmio de participação relevante para o produto:** 3 meses de **Nvoip Pro** para cada participante de time com rascunho aprovado no painel (conta nova). [Hipótese a confirmar] Isso pode dar o número de telefone que falta para a ligação real ao recebedor (hoje desligada, conforme o README do backend).

## Notas que mudam decisões

- **Ferramentas são livres** (item 6.3): Agora é escolha nossa, não requisito. Ela conta em H2 como qualquer outra tecnologia.
- **IA é permitida e recomendada** (item 6.4).
- **A propriedade intelectual é do time** (item 11.1), mas não há confidencialidade: o júri e os parceiros podem desenvolver algo parecido (item 11.4).
- **Continuidade do UNMUTE:** o código do UNMUTE foi escrito em 21 e 22/11, dentro do período do Hack Brasil, e os repositórios foram criados em 22/11 com todo o histórico. Isso atende 6.1 e 6.2. Não copie para eles nada escrito antes de 04/11 que não fosse público.
- **Último commit antes de 30/11 23h59** é o que o júri vê. Depois disso, mais nada até a final.
