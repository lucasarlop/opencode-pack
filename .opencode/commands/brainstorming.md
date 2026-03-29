---
description: "Modo de brainstorming: discuta ideias, explore alternativas e refine soluções. Encerra opcionalmente com docs, specs ou /plan-specs."
agent: plan
---
**Configuração do projeto:** use apenas `.opencode/` e `AGENTS.md`. Não leia nem liste `.claude/`, `.Claude/`, `.cursor/` ou outros diretórios de ferramenta.

Você está em modo de **brainstorming** para o seguinte tópico:

**Tópico:** $ARGUMENTS

## Filosofia

- Explore livremente, incluindo abordagens complexas — o objetivo é pensar junto sem restrições prematuras.
- A busca por soluções simples será exigida na fase de spec e execução; aqui, o espaço é de exploração.
- Explore alternativas antes de convergir para uma solução.
- Desafie premissas construtivamente.
- Não existe resposta certa aqui: o objetivo é pensar junto.

## Como conduzir

### 1. Exploração

Analise o tópico em `$ARGUMENTS`. Preferencialmente, leia arquivos do projeto para embasar a discussão.

Conduza a conversa:

- Apresente diferentes ângulos do problema
- Explore trade-offs entre abordagens
- Questione premissas quando relevante
- Sugira alternativas que o usuário talvez não tenha considerado

### 2. Convergência

Quando o usuário sinalizar que quer convergir, resuma:

- Pontos principais discutidos
- Direção escolhida e sua justificativa
- O que foi descartado e por quê

### 3. Artefatos (opcional)

Pergunte se o usuário quer gerar algum artefato:

| Opção           | Resultado                                                             |
| ----------------- | --------------------------------------------------------------------- |
| Nenhum            | Encerra a conversa com um resumo dos principais pontos.               |
| Nota de decisão  | Cria `.opencode/docs/brainstorming/NNN_<topico>.md`                 |
| ADR               | Cria `.opencode/docs/adr/NNN_<decisao>.md`                          |
| Spec única       | Cria `.opencode/specs/NNNN_<nome>.json` via protocolo `/new-spec` |
| Conjunto de specs | Executa `/plan-specs` com a síntese da discussão                  |

## Formato da nota de brainstorming

```markdown
# NNN — Título do tópico

## Contexto
Por que esta discussão foi iniciada.

## Alternativas exploradas
O que foi considerado e os trade-offs de cada opção.

## Direção escolhida
O que foi decidido e a justificativa.

## Próximos passos
(opcional) Ações decorrentes desta discussão.
```

## Restrições

- Não modifique código-fonte neste modo.
- Artefatos permitidos apenas em:
  - `.opencode/specs/` — specs JSON
  - `.opencode/docs/brainstorming/` — notas de discussão
  - `.opencode/docs/adr/` — ADRs
