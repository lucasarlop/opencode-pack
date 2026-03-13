# AGENTS.md

## 1. Protocolo operacional — Spec-First (obrigatório)

**CRÍTICO:** Todo trabalho de modificação segue o protocolo Spec-First.
Regras detalhadas estão em `.opencode/rules/planning.md`.

1. **Modo PLAN**: Analise o pedido → crie a spec em `.opencode/specs/NNNN_<nome>.json` usando `.opencode/templates/spec_template.json` → apresente ao usuário. **Nunca edite código nesta fase.**
2. **Revisão**: Aguarde aprovação explícita antes de avançar.
3. **Modo BUILD**: Execute passo a passo → verifique cada step → atualize o `outcome` da spec ao concluir.

---

## 2. Visão geral do projeto
<!-- /init: preencher com stack, entry point, módulos principais, propósito -->

---

## 3. Ambiente e infraestrutura

### Python
- Versão: <!-- /init: ex. 3.11 -->
- Gerenciador de pacotes: <!-- /init: pip / poetry / uv -->
- Virtualenv: sempre usar `.venv` local ao projeto
- Formatação: ruff (padrão) — rodar antes de commitar
- Testes: pytest — obrigatório para lógica de negócio isolada

### Docker
- Sempre verificar se existe `docker-compose.yml` ou `compose.yaml` antes de rodar serviços
- Preferir `docker compose up -d` para subir dependências locais
- Nunca hardcodar portas ou credenciais — usar `.env` (nunca commitado)
- Verificar saúde dos containers com `docker compose ps` após subir

### Comandos principais
<!-- /init: preencher com comandos reais do projeto -->
- Instalar deps: `<!-- ex: uv sync / pip install -r requirements.txt -->`
- Rodar local: `<!-- ex: uvicorn app.main:app --reload / python -m app -->`
- Testes: `<!-- ex: pytest / pytest -v --cov=app -->`
- Build Docker: `<!-- ex: docker build -t nome:tag . -->`
- Subir ambiente: `<!-- ex: docker compose up -d -->`

---

## 4. O que NÃO fazer
- Não modificar arquivos fora do escopo da spec aprovada
- Não introduzir dependências sem aprovação explícita
- Não hardcodar credenciais, URLs de produção ou secrets
- Não reformatar arquivos sem necessidade
- Não commitar `.env`, `.venv`, `__pycache__`, ou arquivos de build
- Não alterar `docker-compose.yml` sem mencionar explicitamente no plano

---

## 5. TDD — quando aplicar
Consulte a skill `tdd` para o protocolo completo.
Regra resumida:
- **Aplicar**: lógica de negócio isolada, funções puras, parsers, validações, ETL transforms
- **Não aplicar**: endpoints de API sem lógica complexa, UI, scripts de automação simples
- A spec deve declarar `"tdd_required": true/false` explicitamente

---

## 6. Estilo e convenções
<!-- /init: preencher com padrões específicos do projeto -->
- Nomes de variáveis: snake_case (Python)
- Nomes de classes: PascalCase
- Evitar lógica complexa em arquivos de configuração
- Manter arquivos pequenos e com responsabilidade única
- Docstrings em funções públicas e classes

---

## 7. Arquivos de referência
- Protocolo de planejamento: `.opencode/rules/planning.md`
- Template de spec: `.opencode/templates/spec_template.json`
- Specs anteriores: `.opencode/specs/`
- ADRs: `.opencode/docs/adr/`
- Diagramas C4 + sequência (Mermaid): skill `diagrams`
