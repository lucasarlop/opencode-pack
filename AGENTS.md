# Projeto

<!-- INIT:START -->
<!-- O agente, ao rodar /init, deve:
     1. Substituir tudo entre INIT:START e INIT:END pelo contexto real descoberto no projeto.
     2. Remover os próprios marcadores INIT:START e INIT:END.
     3. Remover este comentário de instrução.
     Resultado final: nenhum placeholder, nenhum marcador, só conteúdo real. -->

## Stack
- Linguagem: ?
- Framework: ?
- Infra: ?

## Comandos
```bash
# rodar local
?

# testes
?

# deploy
?
```

## Estrutura
?

## Convenções
?
<!-- INIT:END -->

---

## OpenPack — comandos disponíveis

**Spec**
- `/new-spec <descrição>` — cria uma spec (planejamento, não executa)
- `/exec-spec [NNNN]` — executa spec aprovada (default: menor NNNN em draft)

**Vault** (opcional)
- `/vault-setup` — configura caminho do vault pessoal (uma vez por máquina)
- `/vault-link <slug>` — vincula este projeto a uma pasta do vault
- `/vault-sync` — sincroniza o vault com git remoto (pull + push)

**Utilitários**
- `/notify <mensagem>` — notifica conclusão

Protocolo Spec-First só ativa dentro desses comandos. Fora deles, conversa e tarefas diretas funcionam normalmente.
