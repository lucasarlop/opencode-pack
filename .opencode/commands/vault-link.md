---
description: Vincula este projeto a um slug do vault
---

Slug fornecido: $ARGUMENTS

1. Se $ARGUMENTS vazio, pergunte: "Slug do projeto no vault (ex: clube-autores):"

2. Leia `VAULT_ROOT` de `~/.config/opencode-pack/config`.
   - Se arquivo não existe ou `USE_VAULT=false`, informe que o vault não está configurado nesta máquina e encerre.

3. Verifique se existe `<VAULT_ROOT>/10-duon/<slug>/`.
   - Se não existir, pergunte: "Pasta não encontrada. Criar agora? [y/N]"
   - Se sim, crie e copie `<VAULT_ROOT>/90-templates/_template-estado.md` como `estado.md` e `_template-tecnico.md` como `tecnico.md` (se os templates existirem).

4. Escreva o slug em `.vault-link` na raiz do projeto atual.

5. Confirme: "Projeto linkado a <VAULT_ROOT>/10-duon/<slug>/"
