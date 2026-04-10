---
description: Sincroniza o vault (git pull --rebase && git push)
---

1. Leia `VAULT_ROOT` de `~/.config/opencode-pack/config`.
   - Se não existe ou `USE_VAULT=false`, informe e encerre.

2. Verifique se `<VAULT_ROOT>/.git` existe.
   - Se não for repo git, avise e encerre.

3. Execute:
   ```bash
   cd <VAULT_ROOT>
   git add -A
   if ! git diff --cached --quiet; then
     git commit -m "sync: $(date -Iseconds)"
   fi
   git pull --rebase
   git push
   ```

4. Reporte:
   - Arquivos commitados localmente (se houver).
   - Resultado do pull (fast-forward, rebase, já atualizado).
   - Resultado do push.

5. Em caso de conflito de rebase, **pare** e instrua o usuário a resolver manualmente. Não tente resolver.

Rode no início e no fim de cada sessão.
