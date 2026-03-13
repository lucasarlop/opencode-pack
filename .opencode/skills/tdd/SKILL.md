---
name: tdd
description: Protocolo TDD para projetos Python. Use quando spec tiver tdd_required true, ao criar lógica de negócio isolada, funções puras, parsers, validações ou transforms ETL. Não usar para UI, endpoints sem lógica complexa ou scripts de automação simples.
license: MIT
compatibility: opencode
---

## O que faço

Guio a implementação no ciclo Red → Green → Refactor com pytest.

## Quando usar

- `tdd_required: true` na spec
- Lógica de negócio isolada (cálculos, transformações, validações)
- Funções puras sem efeitos colaterais
- Transforms de pipeline ETL
- Parsers e serializadores

## Quando NÃO usar

- Endpoints de API sem lógica complexa
- Componentes de UI
- Scripts de automação simples
- Código de configuração e infraestrutura

## Ciclo de trabalho

### 1. Red — escreva o teste primeiro

```python
# tests/test_<modulo>.py
import pytest
from app.<modulo> import <funcao>

def test_<funcao>_<cenario>():
    # Arrange
    entrada = ...
    esperado = ...

    # Act
    resultado = <funcao>(entrada)

    # Assert
    assert resultado == esperado
```

Confirme com o usuário que o teste captura a intenção antes de continuar.

### 2. Green — implemente o mínimo para passar

- Escreva apenas o suficiente para o teste passar
- Não antecipe casos não testados ainda

### 3. Refactor — melhore sem quebrar

- Rode `pytest` após cada mudança
- Se o teste quebrar, desfaça e tente diferente

## Regras

- Nunca altere o teste para fazer a implementação passar — altere a implementação
- Um teste por comportamento, não por função
- Nomes de teste: `test_<o_que_faz>_<quando>_<resultado_esperado>`
- Use fixtures para setup compartilhado
- Prefira `assert` direto a `assertEqual` (pytest style)

## Estrutura de arquivos

```
projeto/
├── app/
│   └── <modulo>.py
└── tests/
    ├── conftest.py      # fixtures compartilhadas
    └── test_<modulo>.py
```

## Comandos úteis

```bash
pytest                          # todos os testes
pytest tests/test_modulo.py     # arquivo específico
pytest -v                       # verbose
pytest --cov=app                # com cobertura
pytest -x                       # para no primeiro erro
```
