# Python + Docker

Use ao criar ou ajustar Dockerfile, docker-compose, ou ambiente Python.

## Dockerfile — regras
- Base oficial Python slim da versão do projeto.
- Multi-stage se houver build step (poetry, compilação).
- `COPY requirements.txt` antes de `COPY .` para cache.
- Usuário não-root.
- `HEALTHCHECK` se for serviço web.

## docker-compose
- `.env` para variáveis sensíveis, nunca hardcoded.
- Volumes nomeados para dados persistentes.
- `depends_on` com `condition: service_healthy` quando há dependência real.

## Não faça
- `latest` como tag de base.
- `pip install` sem `--no-cache-dir`.
- `COPY .` no início (quebra cache).
