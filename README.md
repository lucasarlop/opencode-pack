# opencode-pack

Bootstrap mínimo para projetos com [OpenCode](https://opencode.ai).

Implementa o protocolo **Spec-First**: toda tarefa grande começa com uma spec aprovada antes de qualquer código. Tarefas pequenas seguem direto, sem cerimônia.

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
| `/new-spec <descrição>` | Cria spec em `.opencode/specs/NNNN-slug.md`. Não executa. |
| `/exec-spec [NNNN]` | Executa spec aprovada. Sem argumento: menor NNNN em `draft`. |

**Utilitários**
| Comando | O que faz |
|---|---|
| `/notify <mensagem>` | Notifica via Telegram ou `notify-send`. |

## Fluxo

```
1. /new-spec Adicionar endpoint de login
   → spec-writer cria .opencode/specs/0001-adicionar-endpoint-de-login.md
   → você lê, edita se quiser

2. /exec-spec
   → spec-executor pega a 0001, executa e registra outcome

3. /notify Login implementado
```

## Agentes customizados

O pack define dois agentes em `opencode.json`:

- **spec-writer** — planeja. Só escreve em `.opencode/specs/`. Sem bash.
- **spec-executor** — executa. Escrita livre, bash liberado, registra tempo e outcome.

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
     │   ├── exec-spec.md
     │   └── notify.md
     ├── agents/
     │   ├── spec-writer.md
     │   └── spec-executor.md
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
