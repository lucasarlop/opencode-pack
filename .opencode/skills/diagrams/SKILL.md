---
name: diagrams
description: Gera diagramas C4 L1/L2 e diagramas de sequência UML com Mermaid. Use ao iniciar um projeto novo, ao criar ADRs com decisões arquiteturais relevantes, ao criar specs de arquitetura, ou quando explicitamente pedido.
license: MIT
compatibility: opencode
---

## O que faço

Gero diagramas de arquitetura em Mermaid e os salvo nos locais corretos do projeto.

## Onde salvar

| Tipo | Local | Quando |
|---|---|---|
| C4 L1 — contexto | `docs/diagrams/c4-context.md` | Projeto novo ou mudança de atores externos |
| C4 L2 — containers | `docs/diagrams/c4-containers.md` | Projeto novo ou mudança de containers |
| Sequência | inline no ADR relacionado em `.opencode/docs/adr/` | Ao criar um ADR que descreve um fluxo |

## C4 L1 — Diagrama de contexto

Mostra o sistema e seus atores externos. Não entra em detalhes internos.

```mermaid
C4Context
  title System Context — <Nome do Sistema>

  Person(user, "Usuário", "Descrição do usuário principal")
  Person_Ext(admin, "Administrador", "Descrição opcional")

  System(sistema, "<Nome>", "O que o sistema faz em uma frase")

  System_Ext(ext1, "<Sistema externo>", "Descrição")

  Rel(user, sistema, "Usa")
  Rel(sistema, ext1, "Consome", "HTTPS/REST")

  UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

**Regras L1:**
- Máximo de 5-6 elementos no total
- Sem detalhes internos (sem bancos, sem serviços internos)
- Foco em quem usa e com o que o sistema se comunica

## C4 L2 — Diagrama de containers

Mostra os containers (apps, bancos, filas) dentro do sistema.

```mermaid
C4Container
  title Container Diagram — <Nome do Sistema>

  Person(user, "Usuário", "Descrição")

  System_Boundary(sistema, "<Nome do Sistema>") {
    Container(api, "API", "Python / FastAPI", "Processa requisições REST")
    Container(worker, "Worker", "Python / Celery", "Processa tarefas assíncronas")
    ContainerDb(db, "Banco de dados", "PostgreSQL", "Armazena dados principais")
    ContainerQueue(queue, "Fila", "Redis", "Gerencia tarefas assíncronas")
  }

  System_Ext(ext, "Serviço externo", "Descrição")

  Rel(user, api, "Usa", "HTTPS")
  Rel(api, db, "Lê/Escreve", "SQL")
  Rel(api, queue, "Enfileira tarefas", "Redis protocol")
  Rel(worker, queue, "Consome", "Redis protocol")
  Rel(worker, ext, "Chama", "HTTPS")

  UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

**Regras L2:**
- Mostrar apenas containers — não classes, não funções
- Cada container: nome, tecnologia, responsabilidade em uma frase
- Incluir bancos, filas, caches como containers separados
- Não detalhar implementação interna

## Diagrama de sequência UML

Usado inline em ADRs para descrever fluxos de chamadas entre componentes.

```mermaid
sequenceDiagram
  autonumber
  actor User as Usuário
  participant API as API (FastAPI)
  participant DB as Banco (PostgreSQL)
  participant Queue as Fila (Redis)

  User->>API: POST /tarefas
  API->>DB: Valida e persiste tarefa
  DB-->>API: tarefa_id
  API->>Queue: Enfileira tarefa_id
  Queue-->>API: ok
  API-->>User: 202 Accepted {tarefa_id}

  Note over Queue,DB: Processamento assíncrono
  Queue->>API: Executa worker
  API->>DB: Atualiza status
```

**Regras de sequência:**
- Usar `autonumber` sempre — facilita referência no texto
- `->>` para chamadas síncronas, `-->>` para respostas
- `--)` para chamadas assíncronas (fire and forget)
- `Note over` para explicar etapas importantes
- Máximo de 10-12 steps por diagrama — quebrar em diagramas menores se necessário
- Participantes com nome legível + tecnologia entre parênteses

## Estrutura dos arquivos gerados

### `docs/diagrams/c4-context.md`
```markdown
# C4 L1 — Contexto do sistema

> Atualizado em: YYYY-MM-DD

\`\`\`mermaid
C4Context
  ...
\`\`\`

## Atores
- **Usuário**: descrição
- **Sistema externo**: descrição e por que existe essa dependência
```

### `docs/diagrams/c4-containers.md`
```markdown
# C4 L2 — Containers

> Atualizado em: YYYY-MM-DD

\`\`\`mermaid
C4Container
  ...
\`\`\`

## Containers
| Container | Tecnologia | Responsabilidade |
|---|---|---|
| API | FastAPI | ... |
| DB | PostgreSQL | ... |
```

### ADR com diagrama de sequência inline
```markdown
# 003 — Título da decisão

## Contexto
...

## Fluxo

\`\`\`mermaid
sequenceDiagram
  ...
\`\`\`

## Decisão
...
```

## Quando atualizar os diagramas

- C4 L1: quando mudar atores externos ou o propósito do sistema
- C4 L2: quando adicionar, remover ou renomear um container
- Sequência: quando o fluxo descrito no ADR mudar — atualizar inline no mesmo ADR
