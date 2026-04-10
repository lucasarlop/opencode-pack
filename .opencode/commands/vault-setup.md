---
description: Configura o caminho do vault pessoal (uma vez por máquina)
---

Configure o caminho absoluto do vault pessoal do usuário.

Fluxo:

1. Verifique se `~/.config/opencode-pack/vault-root` já existe.
   - Se existe, leia e mostre: "Vault já configurado em: <caminho>. Deseja substituir? [y/N]"
   - Se o usuário responder não, encerre.

2. Pergunte: "Caminho absoluto do vault (ex: /home/lucas/vault):"
   - Aceite o valor passado em $ARGUMENTS se não estiver vazio.

3. Valide:
   - O caminho deve existir como diretório.
   - Deve conter um `.git` (é um repo git) OU o usuário deve confirmar explicitamente que aceita um vault sem versionamento.

4. Grave o caminho em `~/.config/opencode-pack/vault-root`, criando o diretório se necessário:
   ```bash
   mkdir -p ~/.config/opencode-pack
   echo "<caminho>" > ~/.config/opencode-pack/vault-root
   ```

5. Confirme: "Vault configurado: <caminho>. Use `/vault-link <slug>` em cada projeto para linkar."
