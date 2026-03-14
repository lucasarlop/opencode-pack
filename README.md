# opencode-pack

Bootstrap para projetos com [OpenCode](https://opencode.ai) + Claude Code.

Implementa o protocolo **Spec-First** — toda tarefa começa com um plano aprovado antes de qualquer linha de código ser escrita.

---

## O que está incluído

```
opencode-pack/
├── AGENTS.md                        # Contexto global — lido pelo agente em toda sessão
├── opencode.json                    # Carrega rules, specs e docs automaticamente
├── .gitignore                       # Entradas para Python, Docker, .env e specs
├── install.sh                       # Script de instalação
└── .opencode/
    ├── rules/
    │   └── planning.md              # Protocolo Spec-First completo
    ├── templates/
    │   └── spec_template.json       # Template de spec v2.1
    ├── commands/
    │   ├── new-spec.md              # /new-spec — inicia planejamento
    │   ├── execute.md               # /execute — executa spec aprovada + notifica
    │   ├── spec-review.md           # /spec-review — valida spec antes de executar
    │   └── notify.sh                # Script: notify-send + Telegram (chamado pelo /execute)
    └── skills/
        ├── tdd/                     # Protocolo TDD com pytest
        ├── python-docker/           # Boas práticas Python + Docker
        ├── diagrams/                # C4 L1/L2 e sequência com Mermaid
        ├── spec-review/             # Checklist de revisão de specs
        └── notify/                  # Documentação da notificação automática
```

Após a instalação, o `install.sh` também cria:
- `.opencode/specs/` — specs de trabalho (no `.gitignore`)
- `.opencode/docs/adr/` — ADRs commitados
- `docs/diagrams/` — diagramas C4 commitados

---

## Instalação

```bash
# Clone o pack
git clone https://github.com/lucasarlop/opencode-pack.git

# Entre no seu projeto
cd meu-projeto

# Instale o pack
bash /caminho/para/opencode-pack/install.sh

# Ou com --force para sobrescrever sem perguntar
bash /caminho/para/opencode-pack/install.sh --force
```

---

## Primeiros passos após instalar

```bash
# 1. Abra o OpenCode no projeto
opencode

# 2. Enriqueça o AGENTS.md com contexto real do projeto
/init

# 3. Crie sua primeira spec
/new-spec Implementar autenticação JWT

# 4. Revise antes de executar
/spec-review

# 5. Aprove e execute (notifica automaticamente ao concluir)
/execute
```

---

## Protocolo Spec-First

Todo trabalho segue três fases:

**1. PLAN** — o agente analisa, cria a spec em `.opencode/specs/NNNN_nome.json` e apresenta o plano. Nenhum código é modificado nesta fase.

**2. Revisão** — você lê, ajusta se necessário, e aprova explicitamente.

**3. BUILD** — o agente executa passo a passo, verifica cada step e registra o resultado no `outcome` da spec.

Para mais detalhes sobre o fluxo de trabalho, veja `docs/workflow-guide.md`.

---

## Skills disponíveis

As skills são carregadas sob demanda pelo agente. Você pode invocá-las diretamente:

| Skill | Quando usar |
|---|---|
| `tdd` | Lógica de negócio isolada, funções puras, ETL transforms |
| `python-docker` | Criar ou ajustar Dockerfile, docker-compose, ambientes |
| `diagrams` | Gerar C4 L1/L2 ou diagramas de sequência com Mermaid |
| `spec-review` | Validar uma spec antes de aprovar execução |
| `notify` | Referência de configuração das notificações |

---

## Notificações (automáticas)

Ao concluir o `/execute`, o agente notifica automaticamente via `notify.sh`.

Por padrão, usa `notify-send` (Linux desktop). Para receber via Telegram, adicione ao `.env`:

```env
TELEGRAM_BOT_TOKEN=seu_token
TELEGRAM_CHAT_ID=seu_chat_id
```

Para obter o token: crie um bot via [@BotFather](https://t.me/BotFather).
Para obter o chat_id: envie uma mensagem ao bot e acesse:
`https://api.telegram.org/bot<TOKEN>/getUpdates`

---

## O que commitar vs ignorar

| Path | Git |
|---|---|
| `AGENTS.md` | ✅ commita |
| `opencode.json` | ✅ commita |
| `.opencode/rules/` | ✅ commita |
| `.opencode/templates/` | ✅ commita |
| `.opencode/commands/` | ✅ commita |
| `.opencode/skills/` | ✅ commita |
| `.opencode/docs/adr/` | ✅ commita |
| `docs/diagrams/` | ✅ commita |
| `.opencode/specs/` | ❌ `.gitignore` |
| `.env` | ❌ `.gitignore` |

---

## Adaptando para um novo projeto

O `AGENTS.md` vem com placeholders marcados com `<!-- /init: ... -->`. Após rodar `/init` dentro do OpenCode, o agente preenche automaticamente com base no código do projeto:

- Stack e versões
- Comandos de build, run e test
- Estrutura de diretórios
- Convenções específicas encontradas

O que **não muda** entre projetos (já preenchido no template):
- Protocolo Spec-First
- Regras de TDD
- Regras de Docker/Python
- Seção "O que NÃO fazer"

---

## Versionamento

O pack segue [Semantic Versioning](https://semver.org/lang/pt-BR/):

| Tipo | Quando |
|---|---|
| `MAJOR` (x.0.0) | Mudança que quebra compatibilidade — renomear arquivos, mudar estrutura de diretórios |
| `MINOR` (1.x.0) | Nova funcionalidade sem quebrar nada — nova skill, novo comando |
| `PATCH` (1.0.x) | Correção ou melhoria pequena — ajuste em regra, fix no `notify.sh` |

A versão instalada em cada projeto fica registrada em `.opencode/.pack-version`.
Para verificar: `cat .opencode/.pack-version`

Para atualizar um projeto existente para uma nova versão do pack:

```bash
bash /caminho/para/opencode-pack/install.sh --force
```

---

## Criando o repositório

```bash
cd opencode-pack

git init
git add .
git commit -m "feat: opencode bootstrap pack v1.0.0"

# GitHub CLI
gh repo create opencode-pack --public --source=. --push

# ou manual
git remote add origin https://github.com/lucasarlop/opencode-pack.git
git branch -M main
git push -u origin main
```

Para instalar em qualquer projeto a partir do repo:

```bash
# Clone e instale
git clone https://github.com/lucasarlop/opencode-pack.git /tmp/opencode-pack
bash /tmp/opencode-pack/install.sh

# Ou one-liner (após o repo estar público)
bash <(curl -s https://raw.githubusercontent.com/lucasarlop/opencode-pack/main/install.sh)
```
