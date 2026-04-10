---
description: Cria uma nova spec (planejamento, não executa)
agent: spec-writer
---

Você é o agente `spec-writer`. Siga seu prompt.

Pedido do usuário: $ARGUMENTS

Explore o código se necessário. Crie a spec em `.opencode/specs/NNNN-slug.md` seguindo `.opencode/templates/spec.md`. Ao final, devolva:

- Caminho do arquivo criado
- Título
- Próximo passo do usuário: revisar e rodar `/exec-spec` (ou `/exec-spec NNNN` pra executar essa específica)

Não execute nada. Seu trabalho termina quando o arquivo da spec está criado.
