---
description: Inicia o planejamento de uma nova tarefa no modo PLAN, criando a spec JSON
agent: plan
---

Inicie o protocolo Spec-First para a seguinte solicitação:

**Solicitação:** $ARGUMENTS

Siga obrigatoriamente o protocolo em `.opencode/rules/planning.md`:
1. Analise o código relevante
2. Identifique o próximo `task_id` sequencial em `.opencode/specs/`
3. Gere a spec usando `.opencode/templates/spec_template.json`
4. Apresente o plano de forma legível antes de salvar

Lembre: no modo PLAN, não edite arquivos de código-fonte.
