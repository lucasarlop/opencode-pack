---
description: Executa a implementação da última spec aprovada em .opencode/specs/
agent: build
---

**Configuração do projeto:** use apenas `.opencode/` e `AGENTS.md`; não leia nem liste `.claude/`, `.Claude/`, `.cursor/`, etc.

Usando a última spec, realize a implementação. Siga o protocolo em `.opencode/rules/planning.md`:

1. Leia os arquivos em `.opencode/specs/` e identifique a spec mais recente com status `planned`
2. Confirme que o usuário já aprovou a execução (se não houve aprovação explícita, pergunte antes de prosseguir)
3. Execute os steps do `execution_plan` em ordem, respeitando `dependencies`
4. Ao concluir cada step, verifique o critério em `verification`
5. Se um step falhar, **pare e informe** — não improvise soluções fora do escopo da spec
6. Ao finalizar, atualize `outcome.summary`, `generated_artifacts` e `status: "completed"`
7. Notifique o usuário executando `.opencode/commands/notify.sh "<título da spec>"`

$ARGUMENTS

⚠️ Não modifique arquivos fora do escopo da spec.
Se encontrar necessidade de mudanças não previstas, pare e proponha uma nova spec.
