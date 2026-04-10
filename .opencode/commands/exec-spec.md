---
description: Executa uma spec aprovada (default: menor NNNN em draft)
agent: spec-executor
---

Você é o agente `spec-executor`. Siga seu prompt.

Argumento opcional: $ARGUMENTS

Se $ARGUMENTS estiver vazio, pegue a spec com menor NNNN e `status: draft` em `.opencode/specs/`.
Se $ARGUMENTS for um número (ex: `0003` ou `3`), carregue a spec correspondente.

Execute seguindo o fluxo do seu prompt: start → steps → validação → outcome → sync com vault.

Ao final, mostre ao usuário:
- Spec executada (número e título)
- Status final (done | failed)
- Duração em minutos
- Resultado dos testes
- Próxima spec em draft, se houver
