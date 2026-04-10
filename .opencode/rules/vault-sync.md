# Vault Sync

Integração opcional com vault pessoal de notas.

## Pré-requisitos

A integração só é ativada quando **ambos** existem:

1. `~/.config/opencode-pack/config` com `USE_VAULT=true` e `VAULT_ROOT=<caminho>`.
2. `.vault-link` na raiz do projeto com o slug do projeto no vault.

Se algum estiver faltando, esta regra é ignorada silenciosamente.

## Resolvendo o caminho da nota

```
VAULT_ROOT = valor lido de ~/.config/opencode-pack/config
slug       = primeira linha de .vault-link
nota       = <VAULT_ROOT>/10-duon/<slug>/estado.md
```

## Quando ler

No início de sessões de trabalho em código deste projeto, o agente lê `estado.md` e considera como contexto:
- `## Estado atual`
- `## Próxima ação`
- `## Bloqueios`
- `## Não fazer`

Não leia `tecnico.md` automaticamente. Não leia notas de outros projetos.

## Quando escrever

Apenas o `spec-executor` escreve no vault, apenas em `## Log do agente` do `estado.md` do projeto atual, append-only, uma linha por execução.

## Sync com remoto é manual

O executor escreve localmente. `git push` é responsabilidade do usuário via `/vault-sync`.
