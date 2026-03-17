---
description: Inicia o planejamento de uma nova tarefa no modo PLAN, criando obrigatoriamente o arquivo de spec JSON
agent: plan
---

**Configuração do projeto:** use apenas `.opencode/` e `AGENTS.md`. Não leia nem liste `.claude/`, `.Claude/`, `.cursor/` ou outros diretórios de ferramenta.

Inicie o protocolo Spec-First para a seguinte solicitação:

**Solicitação:** $ARGUMENTS

Siga obrigatoriamente o protocolo em `.opencode/rules/planning.md`:
1. Analise o código relevante
2. Identifique o próximo `task_id` sequencial em `.opencode/specs/`
3. **Crie o arquivo** `.opencode/specs/NNNN_<nome>.json` usando `.opencode/templates/spec_template.json`
   ⛔ NUNCA crie em qualquer diretório diferente de `.opencode/specs/` — apenas esse caminho é usado para as specs.
4. Após salvar o arquivo, apresente o plano de forma legível informando o caminho do arquivo criado

⚠️ OBRIGATÓRIO: O arquivo JSON deve ser criado antes de apresentar o plano.
Apresentar o plano em texto sem criar o arquivo é uma violação do protocolo. Não faça isso.

Lembre: no modo PLAN, não edite arquivos de código-fonte.
