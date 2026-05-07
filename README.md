# opencode-pack

Bootstrap mínimo para projetos com [OpenCode](https://opencode.ai). Versão atual: **3.0.0**.

Implementa o protocolo **Spec-First**: toda tarefa grande começa com uma spec aprovada — ou múltiplas specs ordenadas quando a quebra ajuda revisão e execução — antes de qualquer código. Specs também definem a estratégia de testes/validação antes da execução. Tarefas pequenas seguem direto, sem cerimônia.

Você fala com um único agente, o `orchestrator`, que classifica a tarefa em **fluxo simples** ou **fluxo completo** e delega aos agentes especializados. Não há comandos slash para o pipeline de specs — é tudo orquestrado via conversa.

## Instalação

> ✅ Esta é a versão atual, publicada na branch `main`.

```bash
git clone https://github.com/lucasarlop/opencode-pack.git /tmp/opencode-pack
cd meu-projeto
bash /tmp/opencode-pack/install.sh
```

O install é **interativo** na primeira vez em cada máquina. Ele pergunta:

1. Se quer configurar Telegram para notificações.
2. O preset de stack do projeto (`python` / `node` / `generic`).

A resposta do Telegram é salva em `~/.config/opencode-pack/config` e reutilizada nas próximas instalações. A resposta do preset é perguntada em cada projeto.

**Flags:**
- `--non-interactive` — usa defaults, não pergunta nada
- `--force` — sobrescreve arquivos existentes
- `--dry-run` — mostra o que faria
- `--preset=python|node|generic` — pula a pergunta de preset

Presets: `python`, `node`, `generic` (default).

## Comandos

O pipeline de specs (`spec-writer` → `spec-reviewer` → `spec-executor` → `code-reviewer`) é acionado pelo `orchestrator` em linguagem natural — não existem comandos slash para isso.

**Bypass** (não afetam o fluxo, não alteram arquivos nem specs)
| Comando | O que faz |
|---|---|
| `/btw <pergunta>` | Pergunta lateral curta. |
| `/teach <tema>` | Explicação didática isolada. |

## Fluxo

Ponto de entrada único: o usuário fala com `orchestrator`, que classifica a tarefa.

- **Fluxo simples** — correção pontual, ≤ 3 arquivos, descrição cabe em 1 frase. Spec compacta inline com estratégia de testes/validação (sem arquivo em disco) → `spec-executor` → `code-reviewer`.
- **Fluxo completo** — múltiplos módulos, > 5 arquivos prováveis, requisitos ambíguos, migrations/infra. Pipeline: `spec-writer` → `spec-reviewer` → `spec-executor` → `code-reviewer`. Pode gerar uma spec única ou múltiplas specs encadeadas, ordenadas por `sequence`/`depends_on`, por exemplo `0006-01-planejar.md` e `0006-02-executar.md`. Roda do início ao fim sem intervenção, exceto em `blocked`, estouro de change budget ou `redo` do code-reviewer.

Cada spec passa pelos estados `draft` → `approved` → `executing` → `done` → `reviewed` (com `needs_revision`, `blocked` ou `failed` como ramificações). Quando houver múltiplas specs, cada parte segue esses estados na ordem definida. Ciclo de revisão limitado a **2 iterações** entre `spec-writer` e `spec-reviewer`.

### Estratégia de testes

Toda spec deve declarar como a mudança será testada ou validada. Use TDD quando houver lógica isolável, bug reproduzível, transformação de dados, parser/validador ou regra clara. Para glue code, config, texto/documentação ou UI simples sem lógica relevante, aceite validação posterior/checklist. O `spec-reviewer` bloqueia mudança de comportamento sem estratégia adequada, o `spec-executor` cria/ajusta testes ou executa o checklist definido, e o `code-reviewer` revisa a qualidade dos testes/verificações.

Exemplo de fluxo completo:

```
1. Usuário ao orchestrator:
   "Adicionar endpoint de login com JWT e rate limiting"
   → orchestrator classifica como completo
   → delega ao spec-writer, que cria .opencode/specs/0001-adicionar-endpoint-de-login.md (draft)
     ou, se fizer sentido, múltiplas specs como 0001-01-modelar-login.md e 0001-02-adicionar-rate-limit.md

2. orchestrator delega ao spec-reviewer
   → avalia (hard gates + SMART, incluindo estratégia de testes)
   → veredito: approved

3. orchestrator delega ao spec-executor
   → executa a 0001, registra budget_usado e outcome (done)

4. orchestrator delega ao code-reviewer
   → revisa o diff
   → veredito: approved (ou redo, com 1 retrabalho máximo) → reviewed
```

## Agentes customizados

O pack define cinco agentes em `opencode.json`:

- **orchestrator** — primary. Classifica a tarefa e delega. Sem write/edit/bash.
- **spec-writer** — planeja. Só escreve em `.opencode/specs/`. Sem bash.
- **spec-reviewer** — revisa specs (hard gates + SMART, incluindo estratégia de testes, threshold ≥ 3). Não edita nada.
- **spec-executor** — executa specs `approved`. Write/edit/bash liberados. Registra `budget_usado` e outcome.
- **code-reviewer** — revisa código e testes/verificações após `done`. Veredito `approved` ou `redo` (1 retrabalho máximo).

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
     │   ├── btw.md
     │   └── teach.md
     ├── agents/
     │   ├── orchestrator.md
     │   ├── spec-writer.md
     │   ├── spec-reviewer.md
     │   ├── spec-executor.md
     │   └── code-reviewer.md
     └── skills/
         ├── python/           --preset=python
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
