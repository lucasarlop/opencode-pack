# TDD

Use quando implementar lógica de negócio isolada, funções puras, ou transformações de dados.

## Ciclo
1. Escreva o teste primeiro. Rode. Deve falhar.
2. Implemente o mínimo para passar. Rode. Deve passar.
3. Refatore mantendo verde.

## Regras
- Um comportamento por teste.
- Nomes descritivos: `test_<o_que>_quando_<condição>`.
- Sem mock do que você está testando.
- Sem teste de getter/setter trivial.

## Não use TDD para
- Glue code, integrações externas, UI, scripts one-shot.
