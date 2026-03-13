---
name: notify
description: Envia notificações ao encerrar tarefas longas. Use ao finalizar specs, builds demorados ou qualquer tarefa que o usuário pediu para ser notificado. Suporta notify-send (Linux desktop) e Telegram.
license: MIT
compatibility: opencode
---

## O que faço

Executo o script `.opencode/commands/notify.sh` para notificar o usuário ao final de tarefas longas.

## Quando usar

- Ao marcar spec como `completed`
- Ao finalizar build ou deploy demorado
- Quando o usuário pedir explicitamente para ser notificado

## Como usar

O comando `/notify` está disponível no OpenCode. Ele aceita uma mensagem opcional:

```
/notify Migração do banco concluída com sucesso
```

## Configuração do Telegram (opcional)

Para ativar notificações Telegram, adicione ao `.env`:

```env
TELEGRAM_BOT_TOKEN=seu_token_aqui
TELEGRAM_CHAT_ID=seu_chat_id_aqui
```

Para obter o token: crie um bot via @BotFather no Telegram.
Para obter o chat_id: envie uma mensagem ao bot e acesse:
`https://api.telegram.org/bot<TOKEN>/getUpdates`

## Fallback

Se Telegram não estiver configurado, usa `notify-send` (Linux).
Se nenhum estiver disponível, imprime no terminal.
