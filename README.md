# opencode-pack

Bootstrap mínimo para projetos com [OpenCode](https://opencode.ai).

Implementa o protocolo **Spec-First**: toda tarefa grande começa com uma spec aprovada antes de qualquer código. Tarefas pequenas seguem direto, sem cerimônia.

Você fala com um único agente, o `orchestrator`, que classifica a tarefa em **fluxo simples** ou **fluxo completo** e delega aos agentes especializados.

## Instalação

> ✅ Esta é a versão atual, publicada na branch `main`.

```bash
git clone https://github.com/lucasarlop/opencode-pack.git /tmp/opencode-pack
cd meu-projeto
bash /tmp/opencode-pack/install.sh
```

O install é **interativo** na primeira vez em cada máquina. Ele pergunta:

1. Se quer configurar Telegram para `/notify`.
2. O preset de stack do projeto (`python` / `node` / `generic`).

A resposta do Telegram é salva em `~/.config/opencode-pack/config` e reutilizada nas próximas instalações. A resposta do preset é perguntada em cada projeto.

**Flags:**
- `--non-interactive` — usa defaults, não pergunta nada
- `--force` — sobrescreve arquivos existentes
- `--dry-run` — mostra o que faria
- `--preset=python|node|generic` — pula a pergunta de preset

Presets: `python`, `node`, `generic` (default).

## Comandos

**Spec**
| Comando | O que faz |
|---|---|
| `/new-spec <descrição>` | `spec-writer` cria spec em `.opencode/specs/NNNN-slug.md`. Não executa. |
| `/review-spec [NNNN]` | `spec-reviewer` revisa a spec (SMART + hard gates) e devolve `approved` / `needs_revision` / `blocked`. Sem argumento: menor NNNN em `draft`. |
| `/exec-spec [NNNN]` | `spec-executor` executa spec aprovada. Sem argumento: menor NNNN em `approved`. |

**Bypass** (não afetam o fluxo, não alteram arquivos nem specs)
| Comando | O que faz |
|---|---|
| `/btw <pergunta>` | Pergunta lateral curta. |
| `/teach <tema>` | Explicação didática isolada. |

**Utilitários**
| Comando | O que faz |
|---|---|
| `/notify <mensagem>` | Notifica via Telegram ou `notify-send`. |

## Fluxo

Ponto de entrada único: o usuário fala com `orchestrator`, que classifica a tarefa.

- **Fluxo simples** — correção pontual, ≤ 3 arquivos, descrição cabe em 1 frase. Spec compacta inline (sem arquivo em disco) → `spec-executor` → `code-reviewer`.
- **Fluxo completo** — múltiplos módulos, > 5 arquivos prováveis, requisitos ambíguos, migrations/infra. Pipeline: `spec-writer` → `spec-reviewer` → `spec-executor` → `code-reviewer`. Roda do início ao fim sem intervenção, exceto em `blocked`, estouro de change budget ou `redo` do code-reviewer.

Cada spec passa pelos estados `draft` → `approved` → `executing` → `done` → `reviewed` (com `needs_revision`, `blocked` ou `failed` como ramificações). Ciclo de revisão limitado a **2 iterações** entre `spec-writer` e `spec-reviewer`.

Exemplo de fluxo completo:

```
1. "Adicionar endpoint de login com JWT e rate limiting"
   → orchestrator classifica como completo
   → spec-writer cria .opencode/specs/0001-adicionar-endpoint-de-login.md (draft)

2. spec-reviewer avalia (SMART + 7 hard gates)
   → veredito: approved

3. spec-executor executa a 0001
   → registra budget_usado e outcome (done)

4. code-reviewer revisa o diff
   → veredito: approved (ou redo, com 1 retrabalho máximo)

5. /notify Login implementado
```

## Agentes customizados

O pack define cinco agentes em `opencode.json`:

- **orchestrator** — primary. Classifica a tarefa e delega. Sem write/edit/bash.
- **spec-writer** — planeja. Só escreve em `.opencode/specs/`. Sem bash.
- **spec-reviewer** — revisa specs (SMART + 7 hard gates, threshold ≥ 3). Não edita nada.
- **spec-executor** — executa specs `approved`. Write/edit/bash liberados. Registra `budget_usado` e outcome.
- **code-reviewer** — revisa código após `done`. Veredito `approved` ou `redo` (1 retrabalho máximo).

Fora dos comandos, os agentes padrão do OpenCode seguem funcionando normalmente.

## Estrutura

```
opencode-pack/
 ├── AGENTS.md                 só contexto do projeto
 ├── opencode.json             define agentes customizados
 ├── install.sh                com presets
 ├── VERSION
 ├── CHANGELOG.md
 └── .opencode/
     ├── rules/
     │   └── principles.md
     ├── templates/
     │   └── spec.md           markdown com frontmatter
     ├── commands/
     │   ├── new-spec.md
     │   ├── review-spec.md
     │   ├── exec-spec.md
     │   ├── btw.md
     │   ├── teach.md
     │   └── notify.md
     ├── agents/
     │   ├── orchestrator.md
     │   ├── spec-writer.md
     │   ├── spec-reviewer.md
     │   ├── spec-executor.md
     │   └── code-reviewer.md
     └── skills/
         ├── python/           --preset=python
         │   ├── tdd/
         │   └── docker/
         └── utils/
             └── notify/
 ```

## Versionamento

[Semantic Versioning](https://semver.org/). Ver `CHANGELOG.md`.

## Publicando a versão atual

Passo a passo para publicar atualizações na `main`:

```bash
# Dentro do repo opencode-pack
cd ~/repos/opencode-pack

# Mantenha-se na branch main (ou traga as últimas mudanças)
git checkout main
git pull origin main

# Commita e publica
git add -A
git commit -m "feat: atualiza opencode-pack"
git push origin main
```

Instale usando a `main` (ou especifique `OPENCODE_PACK_BRANCH` para outra branch):

```bash
bash <(curl -s https://raw.githubusercontent.com/lucasarlop/opencode-pack/main/bootstrap.sh)
```
