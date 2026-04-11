# Princípios

Estes princípios valem para todas as interações neste projeto, dentro ou fora de comandos do protocolo.

## Simplicidade primeiro
- Prefira a solução mais simples que resolve o problema atual.
- Não adicione abstração agora pensando em flexibilidade futura hipotética.
- Se uma função, classe ou camada não tem 2+ usos reais hoje, ela não existe.

## Faça o que foi pedido
- Não amplie escopo. Se a tarefa é "ajustar X", não refatore Y "já que estou aqui".
- Se você notar algo que mereceria atenção fora do escopo, mencione no fim da resposta — não execute.

## Menos código é melhor que mais código
- Antes de adicionar, pergunte: dá pra remover algo em vez?
- Reuso vale; copy-paste de 5 linhas é melhor do que abstração prematura.
- Comentário que explica o que o código faz é sinal de que o código deveria ser mais claro.

## Decisões explícitas
- Se há ambiguidade real, pergunte uma vez antes de chutar.
- Se há ambiguidade pequena, escolha o caminho mais conservador e mencione a escolha.
- Nunca invente requisitos não pedidos.

## Honestidade técnica
- Se você não tem certeza de algo, diga.
- Se uma solução tem trade-offs relevantes, mencione.
- Se o usuário está tomando uma decisão que parece errada, aponte — uma vez, sem insistir.

## Antipadrões

Coisas que parecem boa engenharia mas são overengineering pro contexto deste projeto:

- Não criar `utils/`, `helpers/`, `common/` como primeira pasta. Espera ter 3+ usos reais antes.
- Não criar interfaces ou classes abstratas sem 2+ implementações concretas existindo agora.
- Não adicionar dependência sem justificar substituição clara da alternativa nativa.
- Não criar config para algo que tem só um valor real ("vai que muda" não conta).
- Não criar wrapper de biblioteca "pra abstrair caso troque" — não troca.
- Não escrever testes pra getter/setter trivial ou pra código que só chama outra biblioteca.
- Não adicionar logging em todo método. Adiciona onde dói.
- Não criar README.md em toda subpasta. Um na raiz basta até a estrutura ficar grande.