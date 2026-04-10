# opencode-pack

Bootstrap mínimo para projetos com [OpenCode](https://opencode.ai).

Implementa o protocolo **Spec-First**: toda tarefa grande começa com uma spec aprovada antes de qualquer código. Tarefas pequenas seguem direto, sem cerimônia.

## Instalação

> ⚠️ **Em validação.** Esta versão vive na branch `v2-rewrite`.

```bash
git clone -b v2-rewrite https://github.com/lucasarlop/opencode-pack.git /tmp/opencode-pack
cd meu-projeto
bash /tmp/opencode-pack/install.sh
```

O install é **interativo** na primeira vez em cada máquina. Ele pergunta:

1. Se você quer integrar com um vault de notas (e o caminho).
2. Se quer configurar Telegram para `/notify`.
3. O preset de stack do projeto (`python` / `node` / `generic`).
4. O slug deste projeto no vault (se vault ativado).

As respostas 1 e 2 são salvas em `~/.config/opencode-pack/config` e reusadas nas próximas instalações. As respostas 3 e 4 são perguntadas a cada projeto.

**Flags:**
- `--non-interactive` — usa defaults, não pergunta nada
- `--force` — sobrescreve arquivos existentes
- `--dry-run` — mostra o que faria
- `--preset=python|node|generic` — pula a pergunta de preset
- `--vault-slug=SLUG` — pula a pergunta de slug

Presets: `python`, `node`, `generic` (default).

Flags:
- `--dry-run` — mostra o que faria, não escreve.
- `--force` — sobrescreve sem perguntar.

## Comandos

**Spec**
| Comando | O que faz |
|---|---|
| `/new-spec <descrição>` | Cria spec em `.opencode/specs/NNNN-slug.md`. Não executa. |
| `/exec-spec [NNNN]` | Executa spec aprovada. Sem argumento: menor NNNN em `draft`. |

**Vault (opcional)**
| Comando | O que faz |
|---|---|
| `/vault-link <slug>` | Cria `.vault-link` no projeto atual (configurado no install, mas pode rodar depois). |
| `/vault-sync` | `git pull --rebase && git push` no vault. Rode manualmente no início/fim da sessão. |

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
   → spec-executor pega a 0001, executa, registra outcome
   → se .vault-link existir, loga no estado.md do vault

3. /notify Login implementado
```

## Agentes customizados

O pack define dois agentes em `opencode.json`:

- **spec-writer** — planeja. Só escreve em `.opencode/specs/`. Sem bash.
- **spec-executor** — executa. Escrita livre, bash liberado, registra tempo e outcome.

Fora dos comandos, os agentes padrão do OpenCode seguem funcionando normalmente.

## Vault sync (opcional)

Integração com um vault pessoal de notas. Configurada no install na primeira vez; depois disso é transparente.

Fluxo típico por sessão:
```bash
/vault-sync            # puxa mudanças antes de começar
# ... trabalha, /new-spec, /exec-spec (que loga no vault) ...
/vault-sync            # empurra tudo ao terminar
```

O `spec-executor` escreve localmente em `<VAULT_ROOT>/10-duon/<slug>/estado.md` na seção `## Log do agente`. A sincronização git é sempre manual, por design — evita conflitos no meio de uma execução.

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
    │   └── vault-sync.md
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

## Publicando a branch v2-rewrite

Passo a passo para subir esta reescrita como branch separada no repo existente:

```bash
# Dentro do repo opencode-pack (onde main tem a v1)
cd ~/repos/opencode-pack

# Crie a branch a partir do estado atual da main
git checkout -b v2-rewrite

# Remova os arquivos antigos da v1 que foram substituídos
# (ajuste conforme o que realmente existe)
rm -rf .opencode AGENTS.md opencode.json install.sh

# Copie os arquivos da v2 (descompactados deste zip) pra dentro do repo
cp -r /caminho/para/opencode-pack-v2/* .
cp -r /caminho/para/opencode-pack-v2/.opencode .
cp /caminho/para/opencode-pack-v2/.gitignore .

# Commita e publica
git add -A
git commit -m "feat: v2 rewrite — spec-writer/executor, vault sync, presets"
git push -u origin v2-rewrite
```

Enquanto `v2-rewrite` estiver sendo validado, `main` continua servindo a v1. Depois de validado em projetos reais, merge para `main` e tag `v2.0.0`.


OPENCODE_PACK_BRANCH=v2-rewrite bash <(curl -s https://raw.githubusercontent.com/lucasarlop/opencode-pack/v2-rewrite/bootstrap.sh)
<!-- bash <(curl -s https://raw.githubusercontent.com/lucasarlop/opencode-pack/main/bootstrap.sh)
 -->