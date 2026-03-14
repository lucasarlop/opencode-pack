# Documentação do opencode-pack

> Protocolo Spec-First para projetos com [OpenCode](https://opencode.ai)

---

## O que é o opencode-pack

Um bootstrap que impõe disciplina de planejamento em agentes de codificação. Toda tarefa passa por um plano aprovado antes de qualquer linha de código ser escrita.

O pack fornece:
- Um protocolo de planejamento (`planning.md`) carregado automaticamente como instrução de sistema
- Um template de especificação (`spec_template.json`) que o agente deve preencher
- Comandos (`/new-spec`, `/spec-review`, `/execute`) que guiam o fluxo de trabalho
- Skills sob demanda (TDD, Docker/Python, diagramas, revisão de specs)

---

## Arquitetura do pack

```mermaid
graph LR
  subgraph "Arquivos do pack"
    A[AGENTS.md] -->|contexto do projeto| AG[Agente]
    P[planning.md] -->|instrução de sistema| AG
    T[spec_template.json] -->|estrutura da spec| AG
  end

  subgraph "Comandos"
    NS["/new-spec"] -->|modo plan| AG
    SR["/spec-review"] -->|modo plan| AG
    EX["/execute"] -->|modo build| AG
  end

  subgraph "Skills sob demanda"
    TDD[tdd]
    PD[python-docker]
    DG[diagrams]
    SRS[spec-review]
    NT[notify]
  end

  AG -->|cria/edita| SPEC[".opencode/specs/NNNN.json"]
  AG -->|consulta| ADR[".opencode/docs/adr/"]
  AG -->|gera| CODE[Código-fonte]
  AG -->|executa| NOTIFY["notify.sh"]
```

---

## Fluxo completo do protocolo Spec-First

```mermaid
flowchart TD
  START([Usuário solicita tarefa]) --> NS["/new-spec descrição"]
  NS --> PLAN["Modo PLAN<br/>Agente analisa código,<br/>cria spec JSON,<br/>apresenta plano"]

  PLAN --> REVIEW{"Usuário revisa"}
  REVIEW -->|"/spec-review"| CHECK["Agente avalia<br/>contra checklist"]
  CHECK --> VERDICT{Veredicto}
  VERDICT -->|APROVADO| APPROVE
  VERDICT -->|REQUER AJUSTES| ADJUST["Usuário indica<br/>quais ajustes aceita"]
  ADJUST --> FIX["Agente corrige<br/>o JSON existente"]
  FIX --> REVIEW

  REVIEW -->|"Aprovado.<br/>Pode executar."| APPROVE([Aprovação explícita])
  APPROVE --> EXEC["/execute"]
  EXEC --> BUILD["Modo BUILD<br/>Executa steps em ordem,<br/>verifica cada um"]

  BUILD --> FAIL{Step falhou?}
  FAIL -->|Sim| STOP["Para e informa.<br/>Não improvisa."]
  FAIL -->|Não| NEXT{Mais steps?}
  NEXT -->|Sim| BUILD
  NEXT -->|Não| DONE["Atualiza spec:<br/>status → completed"]
  DONE --> NOTIF["notify.sh<br/>(automático)"]
  NOTIF --> FIM([Notificação enviada])
```

---

## Diagrama de sequência

```mermaid
sequenceDiagram
  autonumber
  actor Dev as Desenvolvedor
  participant OC as OpenCode
  participant Agent as Agente
  participant FS as Sistema de arquivos

  Note over Dev,FS: Fase 1 — PLAN

  Dev->>OC: /new-spec Implementar autenticação JWT
  OC->>Agent: Injeta prompt com instruções de planning.md
  Agent->>FS: Lê código relevante do projeto
  Agent->>FS: Lê .opencode/specs/ (identifica próximo task_id)
  Agent->>FS: Cria .opencode/specs/0003_autenticacao_jwt.json
  Agent-->>Dev: Apresenta plano legível + caminho do arquivo

  Note over Dev,FS: Fase 2 — Revisão

  Dev->>OC: /spec-review
  OC->>Agent: Injeta prompt com checklist de spec-review
  Agent->>FS: Lê a spec mais recente com status "planned"
  Agent-->>Dev: Avaliação: APROVADO ou REQUER AJUSTES

  alt REQUER AJUSTES
    Dev-->>Agent: Indica quais ajustes aceita
    Agent->>FS: Corrige o JSON da spec existente
    Agent-->>Dev: Apresenta mudanças e aguarda nova aprovação
  end

  Dev-->>Agent: "Aprovado. Pode executar."

  Note over Dev,FS: Fase 3 — BUILD

  Dev->>OC: /execute
  OC->>Agent: Inicia modo BUILD

  loop Para cada step da spec
    Agent->>FS: Executa ação (create/edit/run)
    Agent->>Agent: Verifica critério do step
    Agent-->>Dev: Reporta resultado do step
  end

  Agent->>FS: Atualiza spec: status → "completed"
  Agent->>FS: Executa notify.sh (automático)
  FS-->>Dev: Notificação desktop / Telegram
```

---

## Estrutura de uma spec

```mermaid
graph TD
  SPEC["spec JSON"] --> META["meta<br/>task_id, status, author"]
  SPEC --> OBJ["objective<br/>title, primary_goal,<br/>definition_of_done"]
  SPEC --> ENV["environment<br/>required_files, dependencies,<br/>constraints, docker, python"]
  SPEC --> TEST["testing<br/>tdd_required, scope,<br/>test_files, framework"]
  SPEC --> PLAN["execution_plan<br/>step_id, name, reasoning,<br/>action, verification,<br/>rollback, dependencies"]
  SPEC --> OUT["outcome<br/>summary, generated_artifacts,<br/>encountered_errors, adr_created"]

  style META fill:#E6F1FB,stroke:#185FA5
  style OBJ fill:#E1F5EE,stroke:#0F6E56
  style ENV fill:#FAEEDA,stroke:#854F0B
  style TEST fill:#EEEDFE,stroke:#534AB7
  style PLAN fill:#FAECE7,stroke:#993C1D
  style OUT fill:#F1EFE8,stroke:#5F5E5A
```

---

## Ciclo de vida de uma spec

```mermaid
stateDiagram-v2
  [*] --> planned: /new-spec cria o arquivo

  planned --> planned: /spec-review → REQUER AJUSTES → corrige

  planned --> in_progress: /execute (após aprovação)

  in_progress --> failed: step falha → agente para

  in_progress --> completed: todos os steps OK

  failed --> planned: nova spec ou ajuste

  completed --> [*]: notify.sh → notificação enviada
```

---

## Comandos disponíveis

| Comando | Agente | O que faz |
|---|---|---|
| `/new-spec <descrição>` | `plan` | Inicia o modo PLAN e cria a spec JSON |
| `/spec-review` | `plan` | Revisa a spec mais recente contra o checklist |
| `/execute` | `build` | Executa a spec aprovada e notifica ao concluir |

---

## Skills disponíveis

| Skill | Quando usar |
|---|---|
| `tdd` | Lógica de negócio isolada, funções puras, parsers, validações, ETL transforms |
| `python-docker` | Criar ou ajustar Dockerfile, docker-compose, ambientes Python |
| `diagrams` | Gerar diagramas C4 L1/L2 ou sequência com Mermaid |
| `spec-review` | Validar uma spec antes de aprovar execução |
| `notify` | Referência de configuração das notificações automáticas |

---

## Estrutura de diretórios do pack

```mermaid
graph TD
  ROOT["projeto/"] --> AGENTS["AGENTS.md<br/><i>contexto global</i>"]
  ROOT --> OCJSON["opencode.json<br/><i>carrega rules, specs, docs</i>"]
  ROOT --> INSTALL["install.sh"]
  ROOT --> DOCS["docs/"]
  ROOT --> OC[".opencode/"]

  DOCS --> DIAG["diagrams/<br/><i>C4 commitados</i>"]
  DOCS --> WG["workflow-guide.md"]

  OC --> RULES["rules/<br/>planning.md"]
  OC --> TEMPLATES["templates/<br/>spec_template.json"]
  OC --> COMMANDS["commands/<br/>new-spec.md<br/>execute.md<br/>spec-review.md<br/>notify.sh"]
  OC --> SKILLS["skills/<br/>tdd/ python-docker/<br/>diagrams/ spec-review/<br/>notify/"]
  OC --> SPECS["specs/<br/><i>.gitignore</i>"]
  OC --> OCDOCS["docs/adr/<br/><i>commitado</i>"]

  style SPECS fill:#FCEBEB,stroke:#A32D2D
  style OCDOCS fill:#E1F5EE,stroke:#0F6E56
  style DIAG fill:#E1F5EE,stroke:#0F6E56
```

---

## Regras fundamentais

1. **Nunca codifique sem spec aprovada.** Sem exceções.
2. No modo PLAN, a única permissão de escrita é criar e editar o arquivo de spec.
3. Cada step deve ter `reasoning` preenchido — justificativa técnica real, não genérica.
4. O `definition_of_done` deve ser verificável — evite critérios vagos.
5. Se um step falhar no BUILD, o agente para e informa — não improvisa.
6. Notificação é automática ao concluir o `/execute`.

---

## Notificações

O `/execute` chama `notify.sh` automaticamente ao concluir. Prioridade:

1. **Telegram** — se `TELEGRAM_BOT_TOKEN` e `TELEGRAM_CHAT_ID` estiverem no `.env`
2. **notify-send** — notificação desktop Linux
3. **Terminal** — fallback se nenhum dos anteriores estiver disponível

---

## Quando criar um ADR

Crie um ADR em `.opencode/docs/adr/NNN_<decisao>.md` quando:
- Escolher entre duas ou mais abordagens arquiteturais
- Adicionar uma dependência significativa
- Mudar um padrão existente do projeto
- A decisão tiver impacto duradouro e não for óbvia
