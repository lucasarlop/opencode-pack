#!/usr/bin/env bash
# notify.sh — envia notificação via Telegram ou notify-send
set -euo pipefail

MSG="${1:-Tarefa concluída}"

# Carrega .env se existir
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . .env
  set +a
fi

if [ -n "${TELEGRAM_BOT_TOKEN:-}" ] && [ -n "${TELEGRAM_CHAT_ID:-}" ]; then
  curl -s -X POST \
    "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    -d "text=${MSG}" > /dev/null
  echo "Notificado via Telegram."
elif command -v notify-send > /dev/null; then
  notify-send "OpenCode" "${MSG}"
  echo "Notificado via notify-send."
else
  echo "Sem backend de notificação. Mensagem: ${MSG}"
fi
