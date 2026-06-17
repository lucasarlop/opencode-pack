# Tide Model Policy

O Tide Protocol prioriza qualidade, mas evita usar modelos fortes em tarefas mecânicas.

Perfil recomendado para Lucas: **balanced-quality**.

## Princípios

1. Use modelo forte quando houver risco real de erro caro.
2. Use modelo médio para implementação comum.
3. Use modelo leve apenas para tarefas mecânicas, leitura simples, commit e status.
4. Não economize em segurança, dados, infra e código durável sensível.
5. Limite passos para evitar loops e custo invisível.
6. Subagente só deve ser chamado quando agrega valor real.

## Política por risco

### Baixo risco

Exemplos:
- bug pequeno;
- até poucos arquivos;
- sem banco, auth, infra ou API pública;
- validação conhecida.

Fluxo:

```txt
tide → tide-runner → tide-verifier → checkpoint
```

Modelo:
- `tide`: medium;
- `tide-runner`: medium/high quando houver código;
- `tide-verifier`: low/medium;
- sem reviewer por padrão.

### Médio risco

Exemplos:
- comportamento relevante;
- validação não trivial;
- mais de um módulo;
- durabilidade importante.

Fluxo:

```txt
tide → tide-runner → tide-verifier → 0-1 reviewer focado → checkpoint
```

Modelo:
- `tide`: medium/high;
- `tide-runner`: high quando envolver lógica de domínio ou refactor relevante;
- `tide-reviewer-durability`: high quando a mudança afeta operação futura;
- `tide-reviewer-tests`: medium/high.

### Alto risco

Exemplos:
- segurança;
- permissões;
- tokens;
- banco;
- migração;
- reprocessamento;
- produção;
- SSH;
- deploy;
- CI/CD;
- API pública;
- nova dependência.

Fluxo:

```txt
tide → checkpoint prévio → runner/operator → verifier → reviewer especializado → checkpoint
```

Modelo:
- use high nos reviewers especializados;
- use high no runner quando a implementação for sensível;
- use medium/high no orquestrador;
- não use modelo leve para decisões de risco.

## Matriz recomendada por agente

| Agente | Recomendação | Observação |
|---|---|---|
| `tide` | medium/high | Decide risco, fronteira e subagentes. |
| `tide-runner` | high para código; medium para patches simples | Qualidade de código importa mais que economia. |
| `tide-verifier` | low/medium | Mecânico, mas precisa interpretar saídas. |
| `tide-steward` | low/medium | Approve/reject/commit deve ser barato e curto. |
| `tide-guide` | low/medium | Dúvidas simples; subir para medium se arquitetura. |
| `tide-operator` | medium/high | Comandos de projeto podem ter risco operacional. |
| `tide-reviewer-durability` | high | Código durável exige julgamento. |
| `tide-reviewer-simplicity` | medium | Julgamento de design, sem exagero. |
| `tide-reviewer-tests` | medium/high | Deve avaliar se testes provam o risco certo. |
| `tide-reviewer-security` | high | Segurança sempre prioriza qualidade. |
| `tide-reviewer-data` | high | Banco, integridade e reprocessamento são críticos. |
| `tide-reviewer-infra` | high | Infra/deploy quebram ambiente inteiro. |

## Steps recomendados

| Agente | steps sugerido |
|---|---:|
| `tide` | 20 |
| `tide-runner` | 18 |
| `tide-verifier` | 8 |
| `tide-steward` | 6 |
| `tide-guide` | 10 |
| `tide-operator` | 14 |
| `tide-reviewer-durability` | 12 |
| `tide-reviewer-simplicity` | 8 |
| `tide-reviewer-tests` | 10 |
| `tide-reviewer-security` | 14 |
| `tide-reviewer-data` | 14 |
| `tide-reviewer-infra` | 12 |

## Regras para reduzir custo sem perder qualidade

- Não chame reviewer em baixo risco, salvo sinal real de risco.
- Não use subagente só para repetir análise já feita.
- `tide-steward` deve ser direto: status, commit/reject, working tree e resultado.
- Validação executável deve preferir `tide run` ou `tide project run`.
- Depois de `validated`, não chame `tide wave park` novamente.
- Checkpoint final deve consultar estado real da Wave antes de resumir.

## Configuração futura

O Tide deve oferecer perfis:

```txt
balanced-quality  padrão recomendado
quality           usa high em runner/reviewers com mais frequência
economy           reduz reviewers e usa modelos menores em tarefas mecânicas
```

Para Lucas, o perfil recomendado é `balanced-quality`, com inclinação para `quality` em código de produção, dados, segurança, infra e bibliotecas compartilhadas.
