---
title: 
status: draft
tipo:  # auditoria | mudanca
created_at: 
---

## Objetivo
<!-- 1-3 linhas. O que e por quê. -->

## Critérios de aceite
<!-- Cada critério deve poder ser respondido com sim/não. -->
- [ ] 
- [ ] 

## Passos
<!-- Passos concretos na ordem. Cada passo deve ser executável. -->
1. 
2. 

## Change budget
<!-- Limites rígidos para o executor. Calibre pelo tamanho real da tarefa. -->
- Máximo de arquivos: 
- Novas dependências: não | sim, apenas: 
- Novas abstrações: não | no máximo 1
- Permitido:
  - `src/<módulo>/**`
  - `tests/<módulo>/**`
- Proibido:
  - `migrations/**`
  - `infra/**`

## Comando de teste
<!-- Como rodar os testes neste projeto. Ajuste conforme o ambiente. -->
<!-- Exemplos: -->
<!-- docker compose exec api pytest tests/<módulo> -x --tb=short -->
<!-- make test-<módulo> -->
<!-- npm test -- --testPathPattern=<módulo> -->
- Escopo: 
- Suite completa: 

## Arquivos prováveis
<!-- Estimativa dos arquivos que serão tocados. -->
- 

## Fora de escopo
<!-- O que explicitamente NÃO faz parte desta spec. -->
- 

## Dúvidas em aberto
<!-- Preencha se houver ambiguidade não resolvida. Vazio é bom sinal. -->

## Resultado
<!-- Preenchido pelo spec-executor ao terminar. Não edite antes. -->
arquivos_tocados:
budget_usado:
testes_executados:
resultado_dos_testes:
notas:

## Code Review
<!-- Preenchido pelo code-reviewer. Não edite antes. -->
veredito:
observacoes:
