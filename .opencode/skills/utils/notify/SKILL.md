# Notify

Notifica o usuário ao concluir uma tarefa longa. Usado pelo comando `/notify`.

## Configuração (.env na raiz do projeto)
```
TELEGRAM_BOT_TOKEN=seu_token
TELEGRAM_CHAT_ID=seu_chat_id
```

Se não configurado, cai em `notify-send` (Linux desktop) como fallback.

## Uso
```bash
bash .opencode/skills/utils/notify/notify.sh "Mensagem aqui"
```
