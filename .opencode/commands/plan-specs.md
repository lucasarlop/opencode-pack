---
description: "Cria um conjunto de specs para uma feature ou tarefa complexa, cada uma com 4-5 steps e duração ~5min."
agent: plan
---

**Configuração do projeto:** use apenas `.opencode/` e `AGENTS.md`. Não leia nem liste `.claude/`, `.Claude/`, `.cursor/` ou outros diretórios de ferramenta.

Crie um conjunto de specs para a seguinte feature ou tarefa:

**Feature/Tarefa:** $ARGUMENTS

## Princípios

- Cada spec deve ser atômica: executável de forma independente ou com dependências explícitas entre specs.
- 4 a 5 steps por spec, com duração estimada de ~5 minutos cada.
- Se um step parecer longo demais, quebre em outra spec.

## Fluxo obrigatório

### 1. Análise de contexto

Leia os arquivos relevantes do projeto para entender o estado atual e as dependências da feature em `$ARGUMENTS`.

### 2. Decomposição

Divida a feature em unidades de trabalho. Para cada unidade, avalie:
- É independente ou depende de outra unidade? (defina `dependencies` entre specs quando necessário)
- Cabe em 4-5 steps de ~5min?
- Tem critério de verificação claro?

### 3. Numeração sequencial

Liste `.opencode/specs/` para identificar o próximo `task_id`. Se o último for `0005`, as novas specs serão `0006`, `0007`, etc.

### 4. Criação de todas as specs

Crie todos os arquivos JSON em `.opencode/specs/` usando o template em `.opencode/templates/spec_template.json`.

Requisitos de qualidade para cada spec:
- `reasoning` específico em cada step — não genérico
- `definition_of_done` verificável
- `tdd_required` declarado explicitamente
- `rollback` em steps que modificam arquivos críticos
- `dependencies` entre specs usando `task_id` quando aplicável

### 5. Apresentação

Após criar todos os arquivos, apresente:
- Lista de specs com título, arquivo criado e número de steps
- Ordem de execução recomendada
- Dependências entre specs (se houver)
- Estimativa total de tempo

Aguarde aprovação explícita antes de avançar para `/execute`.

## Restrições

- Não modifique código-fonte neste modo.
- Specs criadas apenas em `.opencode/specs/NNNN_<nome>.json`.
