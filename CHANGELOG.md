# Changelog

Todas as mudanças relevantes do opencode-pack são documentadas aqui.
Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).
Versionamento segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

---

## [1.0.0] — 2026-03-13

### Adicionado
- `AGENTS.md` base com placeholders para `/init`
- `opencode.json` com `instructions` apontando para `planning.md`
- `.opencode/rules/planning.md` — protocolo Spec-First v2.0
- `.opencode/templates/spec_template.json` — template v2.1 com campos `tdd`, `docker` e `python`
- `.opencode/commands/new-spec.md` — comando `/new-spec`
- `.opencode/commands/spec-review.md` — comando `/spec-review`
- `.opencode/commands/notify.md` + `notify.sh` — notificações via `notify-send` e Telegram
- `.opencode/skills/tdd/` — protocolo Red→Green→Refactor com pytest
- `.opencode/skills/python-docker/` — boas práticas Python + Docker
- `.opencode/skills/diagrams/` — C4 L1/L2 e sequência com Mermaid
- `.opencode/skills/spec-review/` — checklist de revisão de specs
- `.opencode/skills/notify/` — documentação da skill de notificação
- `install.sh` — instalação com merge de `.gitignore` e criação de diretórios
- `.gitignore` — entradas para Python, Docker, `.env` e `.opencode/specs/`
- `VERSION` — controle de versão do pack
- `README.md` — documentação completa

---

<!-- 
Guia de versionamento:
  MAJOR (x.0.0) — mudança que quebra compatibilidade (ex: renomear arquivos, mudar estrutura de diretórios)
  MINOR (1.x.0) — nova funcionalidade sem quebrar nada (ex: nova skill, novo comando)
  PATCH (1.0.x) — correção ou melhoria pequena (ex: ajuste em regra, fix no notify.sh)
-->
