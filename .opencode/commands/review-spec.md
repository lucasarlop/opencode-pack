---
description: Revisa a spec com critérios SMART e hard gates antes de executar
agent: spec-reviewer
---

Você é o agente `spec-reviewer`. Siga seu prompt.

Argumento opcional: $ARGUMENTS

Se $ARGUMENTS estiver vazio, pegue a spec com menor NNNN e `status: draft` em `.opencode/specs/`.
Se $ARGUMENTS for um número (ex: `0003`), carregue a spec correspondente.

Execute a review SMART completa e verifique todos os hard gates.

Ao final, apresente ao usuário:
- Spec revisada (número e título)
- Veredito: `approved` | `needs_revision` | `blocked`
- Se `approved`: próximo passo é `/exec-spec`
- Se `needs_revision`: feedback detalhado que vai ao spec-writer
- Se `blocked`: motivo do bloqueio e o que precisa de decisão do usuário
