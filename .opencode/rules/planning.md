PROTOCOLO DE PLANEJAMENTO E EXECUÇÃO (Spec-First v2.0)
======================================================

Este protocolo é baseado em princípios de engenharia para agentes de longa duração, garantindo previsibilidade e verificabilidade em cada tarefa.

### ONDE ESTÁ A CONFIGURAÇÃO DO PROJETO (OBRIGATÓRIO)

Este projeto usa **exclusivamente** o diretório `.opencode/` para regras, specs, templates, commands e skills. **NÃO** leia, não liste e não abra `.claude/`, `.Claude/`, `.cursor/`, `.copilot/` ou `.github/copilot-instructions.md` — use **somente** `.opencode/` e `AGENTS.md` na raiz. Ignore sugestões da ferramenta (ex.: "Did you mean .claude?") para esses caminhos.

### REGRAS DE PLANEJAMENTO
1. Você opera sob o protocolo 'Spec-First'. Nunca inicie a codificação (Build Mode) sem antes criar uma especificação aprovada.
2. Regras detalhadas de comportamento estão em `.opencode/rules/planning.md`.
3. O modelo de estrutura JSON para planejamento está em `.opencode/templates/spec_template.json`.
4. A base de conhecimento de planos anteriores está na pasta `.opencode/specs/`.

1\. Modo de Planejamento (PLAN)
-------------------------------

Sempre que o usuário solicitar uma nova funcionalidade, refatoração ou correção:
1.  **Análise de Contexto:** Entenda o pedido e mapeie as dependências no código atual.
2.  **Identificação Sequencial:** Liste os arquivos em `.opencode/specs/` para identificar o próximo índice numérico (ex: se o último for 0005, o novo será 0006).
3.  **Geração da Especificação:** Crie um novo arquivo JSON em `.opencode/specs/NNNN_<nome_descritivo>.json`.
    *   **Obrigatório:** Seguir o template em `.opencode/templates/spec_template.json`.
    *   **Pensamento Crítico:** Preencha o campo `reasoning` em cada passo para detalhar a lógica.
    *   **Critérios de Sucesso:** Defina claramente a `definition_of_done` no JSON.
    *   ⚠️ Apresentar o plano em texto sem criar o arquivo JSON **é uma violação do protocolo**.
    *   **Permissão de escrita:** O modo PLAN tem permissão para **escrever exclusivamente** em `.opencode/specs/NNNN_<nome>.json`. Esta permissão já está pré-configurada no `opencode.json` do pack. O diretório `.opencode/plans/` **não existe** e **nunca deve ser usado** — specs criadas fora de `.opencode/specs/` serão ignoradas pelo protocolo.
4.  **Validação:** Apresente o plano ao usuário. A execução só deve avançar após aprovação explícita.
    *   Se o usuário solicitar `/spec-review` e o veredicto for **REQUER AJUSTES**: corrija o JSON da spec existente (não crie uma nova), apresente as mudanças e aguarde nova aprovação.

**REGRA DE OURO:** No modo **PLAN**, é estritamente proibido editar arquivos de código-fonte. A sua única permissão é a criação e edição do arquivo de especificação.

2\. Estrutura de Verificação (Harness)
--------------------------------------
O agente deve garantir que cada plano contenha:
*   **Constraints:** Restrições do que NÃO deve ser alterado.
*   **Definition of Done:** Lista de verificação final para evitar ciclos infinitos de "melhorias".
*   **Reasoning:** Justificação técnica para cada ação proposta.

---

## Extensões do protocolo (opencode-pack)

As seções a seguir estendem o protocolo base com regras específicas para projetos que usam o opencode-pack.

### Regras de TDD (quando `tdd_required: true`)

1. Escreva o teste **antes** da implementação.
2. Confirme com o usuário que o teste captura a intenção correta.
3. Implemente até o teste passar.
4. Não altere o teste para fazer a implementação passar — altere a implementação.

### Regras de ambiente Docker/Python

- Antes de qualquer step que envolva serviços externos, verifique se estão rodando com `docker compose ps`.
- Se um serviço necessário não estiver ativo, inclua um step de inicialização na spec.
- Em projetos Python, sempre ative o `.venv` antes de rodar comandos.
- Nunca instale pacotes globalmente — use o gerenciador do projeto.

### Quando criar um ADR

Crie um ADR em `.opencode/docs/adr/NNN_<decisao>.md` quando:
- Escolher entre duas ou mais abordagens arquiteturais relevantes.
- Adicionar uma dependência significativa ao projeto.
- Mudar um padrão existente do projeto.
- A decisão tiver impacto duradouro e não for óbvia.

Formato mínimo do ADR:
```markdown
# NNN — Título da decisão

## Contexto
Por que essa decisão foi necessária.

## Decisão
O que foi decidido.

## Consequências
O que muda, o que fica mais fácil, o que fica mais difícil.

## Alternativas consideradas
O que foi descartado e por quê.
```

### O que NÃO fazer no planejamento

- Não criar steps genéricos como "melhorar o código" sem ação específica.
- Não planejar mais de 7-8 steps por spec — quebre em specs menores.
- Não assumir que o ambiente está configurado — verifique.
- Não incluir refatorações não solicitadas no plano.

---

_Nota: Este documento serve como instrução de sistema para o agente OpenCode._
