#!/usr/bin/env bash
# .opencode/commands/notify.sh
# Notifica o usuário ao concluir uma tarefa
# Suporta: notify-send (Linux desktop) e Telegram
#
# Configuração Telegram (opcional — adicionar ao .env):
#   TELEGRAM_BOT_TOKEN=seu_token
#   TELEGRAM_CHAT_ID=seu_chat_id

set -euo pipefail

MESSAGE="${1:-Tarefa concluída pelo agente OpenCode}"
TITLE="${2:-OpenCode}"
SENT=false

# Carrega .env se existir
if [ -f ".env" ]; then
  set -o allexport
  # shellcheck disable=SC1091
  source .env 2>/dev/null || true
  set +o allexport
fi

# --- Telegram ---
if [ -n "${TELEGRAM_BOT_TOKEN:-}" ] && [ -n "${TELEGRAM_CHAT_ID:-}" ]; then
  PAYLOAD=$(printf '{"chat_id":"%s","text":"*%s*\n%s","parse_mode":"Markdown"}' \
    "$TELEGRAM_CHAT_ID" "$TITLE" "$MESSAGE")

  if curl -s -X POST \
    "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" \
    --max-time 5 \
    > /dev/null 2>&1; then
    echo "[notify] Telegram: enviado"
    SENT=true
  else
    echo "[notify] Telegram: falhou (verifique TOKEN e CHAT_ID)" >&2
  fi
fi

# --- notify-send (Linux desktop) ---
if command -v notify-send &> /dev/null; then
  notify-send \
    --urgency=normal \
    --expire-time=8000 \
    --icon=dialog-information \
    "$TITLE" "$MESSAGE" 2>/dev/null || true
  echo "[notify] notify-send: enviado"
  SENT=true
fi

# --- Fallback: terminal ---
if [ "$SENT" = false ]; then
  echo ""
  echo "╔══════════════════════════════════════╗"
  printf "║  %-36s ║\n" "$TITLE"
  printf "║  %-36s ║\n" "$MESSAGE"
  echo "╚══════════════════════════════════════╝"
fi
