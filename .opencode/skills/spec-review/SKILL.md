---
name: spec-review
description: Revisa specs antes da execução. Use quando o usuário pedir para revisar um plano, ao validar se uma spec está bem formada, ou antes de aprovar o modo BUILD em tarefas críticas.
license: MIT
compatibility: opencode
---

## O que faço

Avalio uma spec JSON e aponto problemas antes da execução.

## Checklist de revisão

### Estrutura
- [ ] `task_id` sequencial em relação às specs existentes
- [ ] `status` está como `planned`
- [ ] `definition_of_done` tem critérios verificáveis (não vagos)

### Planejamento
- [ ] Cada step tem `reasoning` preenchido com justificativa real
- [ ] Steps têm `dependencies` corretas (sem ciclos)
- [ ] Nenhum step é genérico demais (ex: "melhorar o código")
- [ ] Máximo de 7-8 steps — se mais, sugerir quebrar em specs menores

### Ambiente
- [ ] `docker.required_services` preenchido se há dependências de serviços
- [ ] `python.venv_required` correto para o projeto
- [ ] Sem credenciais ou secrets hardcoded

### TDD
- [ ] `tdd_required` preenchido explicitamente
- [ ] Se `true`, existe step de criação de teste **antes** do step de implementação
- [ ] `test_files` listados

### Constraints
- [ ] `constraints` lista o que NÃO deve ser modificado
- [ ] `rollback` preenchido nos steps críticos

## Como usar

```
/spec-review
```

Ou mencione a skill diretamente: `@spec-review revise a spec 0003`

## Fluxo após a revisão

### Se APROVADO
O usuário pode prosseguir com `/execute`.

### Se REQUER AJUSTES
1. O agente lista os problemas encontrados e as correções sugeridas.
2. O usuário indica quais ajustes aceita (ou todos).
3. O agente **corrige o JSON da spec existente** — não cria uma nova spec. É o mesmo plano sendo refinado.
4. O agente apresenta as mudanças realizadas de forma legível.
5. O ciclo volta para aguardar aprovação explícita antes de avançar para `/execute`.

> ⚠️ O agente **não deve corrigir a spec automaticamente** sem o usuário indicar quais ajustes aceita. A decisão é sempre do usuário.
