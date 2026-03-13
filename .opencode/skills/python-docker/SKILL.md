---
name: python-docker
description: Boas práticas para projetos Python com Docker. Use ao criar Dockerfile, docker-compose.yml, configurar ambientes de dev/prod, resolver problemas de container ou integrar serviços externos via Docker em projetos Python.
license: MIT
compatibility: opencode
---

## O que faço

Guio criação e configuração de ambientes Python + Docker seguindo boas práticas de segurança e performance.

## Dockerfile Python — padrão recomendado

```dockerfile
# Multi-stage: build separado de runtime
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.11-slim AS runtime

WORKDIR /app
# Copiar só os pacotes instalados
COPY --from=builder /root/.local /root/.local
COPY . .

# Usuário não-root por segurança
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

CMD ["python", "-m", "app"]
```

## docker-compose.yml — padrão dev

```yaml
services:
  app:
    build: .
    ports:
      - "${PORT:-8000}:8000"
    volumes:
      - .:/app  # hot reload em dev
    env_file:
      - .env
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
```

## .env.example — sempre commitar este, nunca o .env

```env
PORT=8000
DB_NAME=myapp
DB_USER=myapp
DB_PASSWORD=changeme
SECRET_KEY=changeme
```

## Regras

- Nunca commitar `.env` — apenas `.env.example`
- Sempre usar `healthcheck` em serviços com dependências
- Preferir imagens `slim` ou `alpine` para runtime
- Separar `docker-compose.yml` (dev) de `docker-compose.prod.yml` (prod)
- Variáveis de ambiente via `.env`, nunca hardcoded no compose

## Checklist antes de commitar

```bash
docker compose config          # valida o compose
docker compose build --no-cache
docker compose up -d
docker compose ps              # todos healthy?
docker compose logs app        # sem erros?
```

## Comandos úteis

```bash
docker compose up -d           # sobe em background
docker compose down -v         # derruba e remove volumes
docker compose exec app bash   # terminal no container
docker compose logs -f app     # logs em tempo real
docker system prune -f         # limpa imagens/containers órfãos
```
