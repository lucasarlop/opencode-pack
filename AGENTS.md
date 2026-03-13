# AGENTS.md

<!-- INSTRUÇÕES PARA /init:
  - Preencha APENAS as seções marcadas com [PREENCHER]
  - NÃO modifique seções marcadas com [FIXO] — são parte do protocolo do projeto
  - NÃO altere caminhos como .opencode/, são convenções do projeto
-->

---

## 1. Protocolo operacional — Spec-First [FIXO]

**CRÍTICO:** Todo trabalho de modificação segue o protocolo Spec-First.
Regras detalhadas estão em `.opencode/rules/planning.md`.

1. **Modo PLAN**:
   - Analise o pedido e mapeie dependências no código atual
   - **Crie obrigatoriamente o arquivo** `.opencode/specs/NNNN_<nome>.json` usando `.opencode/templates/spec_template.json`
   - Apresente o plano ao usuário
   - ⚠️ Apresentar o plano apenas em texto **sem criar o arquivo JSON é uma violação do protocolo**
   - **Nunca edite arquivos de código nesta fase**
2. **Revisão**: Aguarde aprovação explícita antes de avançar.
3. **Modo BUILD**: Execute passo a passo → verifique cada step → atualize o `outcome` da spec ao concluir.

---

## 2. Visão geral do projeto [PREENCHER]

<!-- /init: descreva stack, entry point, módulos principais e propósito do projeto -->

---

## 3. Ambiente e infraestrutura [FIXO + PREENCHER]

### Python [FIXO]
- Virtualenv: sempre usar `.venv` local ao projeto
- Formatação: ruff — rodar antes de commitar
- Testes: pytest — obrigatório para lógica de negócio isolada

### Docker [FIXO]
- Sempre verificar se existe `docker-compose.yml` antes de rodar serviços
- Preferir `docker compose up -d` para subir dependências locais
- Nunca hardcodar portas ou credenciais — usar `.env` (nunca commitado)
- Verificar saúde dos containers com `docker compose ps` após subir

### Versões e comandos [PREENCHER]

<!-- /init: preencha versão Python, gerenciador de pacotes e comandos reais do projeto -->
- Python: 
- Gerenciador de pacotes: 
- Instalar deps: 
- Rodar local: 
- Testes: 
- Subir ambiente Docker: 

---

## 4. O que NÃO fazer [FIXO]

- Não modificar arquivos fora do escopo da spec aprovada
- Não introduzir dependências sem aprovação explícita
- Não hardcodar credenciais, URLs de produção ou secrets
- Não reformatar arquivos sem necessidade
- Não commitar `.env`, `.venv`, `__pycache__`, `node_modules/` ou arquivos de build
- Não alterar `docker-compose.yml` sem mencionar explicitamente no plano

---

## 5. TDD — quando aplicar [FIXO]

Consulte a skill `tdd` para o protocolo completo.

- **Aplicar**: lógica de negócio isolada, funções puras, parsers, validações, ETL transforms
- **Não aplicar**: endpoints de API sem lógica complexa, UI, scripts de automação simples
- A spec deve declarar `"tdd_required": true/false` explicitamente

---

## 6. Estilo e convenções [PREENCHER]

<!-- /init: preencha com padrões específicos do projeto (nomenclatura, imports, etc.) -->

---

## 7. Arquivos de referência [FIXO]

- Protocolo de planejamento: `.opencode/rules/planning.md`
- Template de spec: `.opencode/templates/spec_template.json`
- Specs anteriores: `.opencode/specs/`
- ADRs: `.opencode/docs/adr/`
- Diagramas C4 + sequência (Mermaid): skill `diagrams`
