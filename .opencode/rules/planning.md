# Protocolo de planejamento e execução (Spec-First v2.0)

Este protocolo garante previsibilidade e rastreabilidade em cada tarefa.

---

## Regras fundamentais

1. **Nunca inicie codificação sem spec aprovada.** Sem exceções.
2. No modo PLAN, sua única permissão de escrita é criar o arquivo de spec.
3. Cada step da spec deve ter `reasoning` preenchido — justificativa técnica real, não genérica.
4. O `definition_of_done` deve ser verificável — evite critérios vagos como "funciona corretamente".

---

## Modo PLAN

Ao receber uma solicitação de nova funcionalidade, refatoração ou correção:

1. **Análise de contexto**
   - Leia os arquivos relevantes antes de planejar
   - Mapeie dependências no código atual
   - Verifique ADRs em `.opencode/docs/adr/` para decisões anteriores relevantes

2. **Identificação sequencial**
   - Liste arquivos em `.opencode/specs/` para identificar o próximo índice
   - Se o último for `0005_...`, o novo será `0006_...`

3. **Geração da spec**
   - **OBRIGATÓRIO:** Crie o arquivo físico `.opencode/specs/NNNN_<nome_descritivo>.json`
   - Use obrigatoriamente o template em `.opencode/templates/spec_template.json`
   - Preencha `tdd_required` com base nas regras de TDD do AGENTS.md
   - Preencha `environment_checks` se houver dependências Docker ou serviços externos
   - ⚠️ Apresentar o plano em texto sem criar o arquivo JSON **é uma violação do protocolo**

4. **Apresentação**
   - Após criar o arquivo, mostre o plano ao usuário de forma legível (não apenas o JSON bruto)
   - Informe o caminho do arquivo criado: `.opencode/specs/NNNN_<nome>.json`
   - Aguarde aprovação explícita

---

## Modo BUILD

Somente após aprovação:

1. Execute os steps em ordem, respeitando `dependencies`
2. Ao concluir cada step, verifique o critério em `verification`
3. Se um step falhar, pare e informe — não improvise uma solução fora do escopo
4. Ao finalizar, atualize `outcome.summary`, `generated_artifacts` e `status: "completed"`

---

## Regras de TDD (quando `tdd_required: true`)

1. Escreva o teste **antes** da implementação
2. Confirme com o usuário que o teste captura a intenção correta
3. Implemente até o teste passar
4. Não altere o teste para fazer a implementação passar — altere a implementação

---

## Regras de ambiente Docker/Python

- Antes de qualquer step que envolva serviços externos, verifique se estão rodando com `docker compose ps`
- Se um serviço necessário não estiver ativo, inclua um step de inicialização na spec
- Em projetos Python, sempre ative o `.venv` antes de rodar comandos
- Nunca instale pacotes globalmente — use o gerenciador do projeto

---

## Quando criar um ADR

Crie um ADR em `.opencode/docs/adr/NNN_<decisao>.md` quando:
- Escolher entre duas ou mais abordagens arquiteturais relevantes
- Adicionar uma dependência significativa ao projeto
- Mudar um padrão existente do projeto
- A decisão tiver impacto duradouro e não for óbvia

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

---

## O que NÃO fazer no planejamento

- Não criar steps genéricos como "melhorar o código" sem ação específica
- Não planejar mais de 7-8 steps por spec — quebre em specs menores
- Não assumir que o ambiente está configurado — verifique
- Não incluir refatorações não solicitadas no plano
