# Changelog

## [3.0.0] — 2026-05-05

### Breaking changes
- Adicionado agente `orchestrator` como ponto de entrada único
- Adicionado agente `spec-reviewer` com review SMART + hard gates
- Comando `/spec-review` renomeado para `/review-spec`
- Template de spec agora inclui campo obrigatório `Change budget`
- Campo `Resultado` do executor agora inclui `budget_usado`

### Adicionado
- `orchestrator`: classifica tarefa como fluxo simples ou completo
- `spec-reviewer`: review SMART (notas 0-5, threshold ≥ 3) + 7 hard gates + veredito tri-estado
- Ciclo de revisão limitado a 2 iterações entre spec-writer e spec-reviewer
- Comando `/review-spec` — delega ao spec-reviewer
- Comando `/btw` — pergunta lateral curta sem afetar fluxo
- Comando `/teach` — explicação didática isolada
- Change budget no template e no executor (checkpoints por step)
- Testes por escopo no executor (apenas módulo alterado, suite completa só no step final)
- Checkpoints obrigatórios após cada step do executor (aguarda `ok` do usuário)
- Princípio de comunicação direta no orchestrator (sem preâmbulos, sem repetição do pedido)

### Alterado
- `spec-executor`: checkpoints por step, budget tracking, testes por escopo
- `opencode.json`: 4 agentes registrados com permissões explícitas
- `spec-writer`: orientado a preencher change budget no template

## [2.1.0] — anterior

Versão anterior do protocolo Spec-First com spec-writer e spec-executor.
