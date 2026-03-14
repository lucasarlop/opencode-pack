---
name: notify
description: Notificações automáticas ao concluir tarefas. Executado automaticamente pelo /execute ao finalizar uma spec. Suporta notify-send (Linux desktop) e Telegram como override.
license: MIT
compatibility: opencode
---

## O que faço

Notifico o usuário automaticamente ao final da execução de uma spec, via o script `.opencode/commands/notify.sh`.

## Comportamento padrão

A notificação é **automática** — o `/execute` chama `notify.sh` ao concluir a spec. O usuário não precisa lembrar de notificar manualmente.

Prioridade de envio:
1. **Telegram** — se `TELEGRAM_BOT_TOKEN` e `TELEGRAM_CHAT_ID` estiverem no `.env`
2. **notify-send** — notificação desktop Linux (sempre tenta, independente do Telegram)
3. **Terminal** — fallback se nenhum dos anteriores estiver disponível

## Configuração do Telegram (opcional)

Para ativar notificações Telegram, adicione ao `.env`:

```env
TELEGRAM_BOT_TOKEN=seu_token_aqui
TELEGRAM_CHAT_ID=seu_chat_id_aqui
```

Para obter o token: crie um bot via @BotFather no Telegram.
Para obter o chat_id: envie uma mensagem ao bot e acesse:
`https://api.telegram.org/bot<TOKEN>/getUpdates`

## Uso manual

Caso queira notificar fora do fluxo do `/execute`:

```bash
.opencode/commands/notify.sh "Mensagem aqui"
```
