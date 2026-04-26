# Changelog

## 2.0.1 — Unreleased

### Removido

- Removida a integração com o fluxo de notas pessoais (Obsidian/vault).
- Removidos comandos `/vault-link` e `/vault-sync`.
- Removidas opções de instalação relacionadas a `vault` (`--vault-slug` e perguntas de configuração).
- Atualizados os fluxos de `/exec-spec` e documentação para execução sem sync automático de vault.

## 2.0.0 — 2026-04-10

Reescrita completa. Incompatível com v1.x.

### Mudanças principais
- Protocolo Spec-First agora só ativa dentro de `/new-spec` e `/exec-spec`. Fora dos comandos, conversa e tarefas funcionam sem cerimônia.
- `/new-spec` e `/exec-spec` rodam em agentes customizados (`spec-writer` e `spec-executor`) definidos no `opencode.json`. Separação por ferramentas, não por modo.
- Spec agora é markdown com frontmatter (era JSON).
- `AGENTS.md` enxugado para só contexto de projeto. Sem regras de protocolo, sem stack.
- Presets de stack no install: `--preset=python|node|generic`. Default: `generic`.
- Vault sync opcional via arquivo `.vault-link` na raiz do projeto.
- 4 timestamps de tempo em cada spec: `created_at`, `exec_started_at`, `exec_finished_at`, `completed_at` + `duration_minutes` calculado.

### Removido
- Skill `diagrams`.
- Skill `spec-review` (absorvida no fluxo do `spec-writer`).
- ADRs (`.opencode/docs/adr/`).
- Pasta `docs/diagrams/`.
- Comando `/spec-review`.

### Adicionado
- Agentes customizados em `.opencode/agents/`.
- Install interativo: pergunta vault e telegram na primeira vez por máquina, salva em `~/.config/opencode-pack/config`.
- Comando `/vault-link` — cria `.vault-link` no projeto atual (também pode ser feito durante o install).
- Comando `/vault-sync` — sincroniza vault com git remoto (manual).
- Regra `vault-sync.md` lendo config de máquina.
- Flags `--preset`, `--vault-slug`, `--non-interactive`, `--dry-run` no install.
