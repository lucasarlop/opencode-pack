#!/usr/bin/env bash
# install.sh — instala opencode-pack num projeto
# Setup interativo na primeira vez; reusa config de máquina nas próximas.
set -euo pipefail

PRESET=""
DRY_RUN=0
FORCE=0
NON_INTERACTIVE=0
VAULT_SLUG=""

for arg in "$@"; do
  case "$arg" in
    --preset=*)        PRESET="${arg#*=}" ;;
    --vault-slug=*)    VAULT_SLUG="${arg#*=}" ;;
    --dry-run)         DRY_RUN=1 ;;
    --force)           FORCE=1 ;;
    --non-interactive) NON_INTERACTIVE=1 ;;
    -h|--help)
      cat <<EOF
opencode-pack install

Uso:
  bash install.sh [opções]

Opções:
  --preset=python|node|generic   stack do projeto (default pergunta)
  --vault-slug=SLUG              slug deste projeto no vault (default pergunta)
  --non-interactive              não pergunta nada, usa defaults
  --force                        sobrescreve arquivos existentes sem perguntar
  --dry-run                      mostra o que faria, não escreve

Config de máquina: ~/.config/opencode-pack/config
  criada na primeira instalação e reusada nas próximas.
EOF
      exit 0 ;;
  esac
done

PACK_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$(pwd)"
CFG_DIR="$HOME/.config/opencode-pack"
CFG_FILE="$CFG_DIR/config"

# ---------- helpers ----------

ask() {
  # ask "pergunta" "default" -> ecoa resposta
  local prompt="$1" default="${2:-}" ans
  if [ "$NON_INTERACTIVE" = "1" ]; then
    echo "$default"
    return
  fi
  if [ -n "$default" ]; then
    read -r -p "  $prompt [$default]: " ans
    echo "${ans:-$default}"
  else
    read -r -p "  $prompt: " ans
    echo "$ans"
  fi
}

ask_yn() {
  local prompt="$1" default="${2:-n}" ans
  if [ "$NON_INTERACTIVE" = "1" ]; then
    [ "$default" = "y" ] && return 0 || return 1
  fi
  read -r -p "  $prompt [${default^^}/$([ "$default" = "y" ] && echo n || echo y)]: " ans
  ans="${ans:-$default}"
  [[ "$ans" =~ ^[yY] ]]
}

copy() {
  local src="$1" dst="$2"
  if [ "$DRY_RUN" = "1" ]; then
    echo "  would copy: $dst"; return
  fi
  if [ -e "$dst" ] && [ "$FORCE" != "1" ]; then
    if ! ask_yn "$dst já existe. Sobrescrever?" "n"; then
      echo "  skip: $dst"; return
    fi
  fi
  mkdir -p "$(dirname "$dst")"
  cp -r "$src" "$dst"
  echo "  ok: $dst"
}

ensure_gitignore_line() {
  # Garante uma linha no .gitignore do TARGET, sem duplicar, sem apagar o que já existe
  local line="$1"
  local file="$TARGET/.gitignore"
  if [ "$DRY_RUN" = "1" ]; then
    echo "  would ensure in .gitignore: $line"
    return
  fi
  touch "$file"
  grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

# ---------- setup de máquina (primeira vez) ----------

machine_setup() {
  echo
  echo "Primeira instalação nesta máquina. Vou fazer algumas perguntas (uma vez só)."
  echo

  local use_vault vault_root tg_token tg_chat

  if ask_yn "Integrar com um vault pessoal de notas (git repo com markdown)?" "y"; then
    use_vault="true"
    vault_root="$(ask "Caminho local do vault" "$HOME/workspace/vault")"
  else
    use_vault="false"
    vault_root=""
  fi

  if ask_yn "Configurar Telegram para /notify agora? (pode deixar pra depois)" "n"; then
    tg_token="$(ask "Telegram bot token" "")"
    tg_chat="$(ask "Telegram chat id" "")"
  else
    tg_token=""
    tg_chat=""
  fi

  if [ "$DRY_RUN" != "1" ]; then
    mkdir -p "$CFG_DIR"
    cat > "$CFG_FILE" <<EOF
# opencode-pack machine config
# Gerado por install.sh em $(date -Iseconds)
USE_VAULT=$use_vault
VAULT_ROOT=$vault_root
TELEGRAM_BOT_TOKEN=$tg_token
TELEGRAM_CHAT_ID=$tg_chat
EOF
    echo
    echo "  ok: $CFG_FILE"
  else
    echo "  would write: $CFG_FILE"
  fi
}

# ---------- main ----------

echo "opencode-pack installer"
echo "  source : $PACK_DIR"
echo "  target : $TARGET"
[ "$DRY_RUN" = "1" ]         && echo "  MODE   : dry-run"
[ "$NON_INTERACTIVE" = "1" ] && echo "  MODE   : non-interactive"

# Carrega ou cria config de máquina
if [ ! -f "$CFG_FILE" ]; then
  machine_setup
fi

# shellcheck disable=SC1090
[ -f "$CFG_FILE" ] && . "$CFG_FILE"

# ---------- perguntas de projeto ----------

echo
echo "Setup deste projeto:"

if [ -z "$PRESET" ]; then
  PRESET="$(ask "Preset de stack (python/node/generic)" "generic")"
fi
echo "  preset : $PRESET"

if [ "${USE_VAULT:-false}" = "true" ] && [ -z "$VAULT_SLUG" ]; then
  VAULT_SLUG="$(ask "Slug deste projeto no vault (vazio = linkar depois)" "")"
fi

# ---------- copy ----------

echo
echo "Copiando arquivos:"
copy "$PACK_DIR/AGENTS.md"              "$TARGET/AGENTS.md"
copy "$PACK_DIR/opencode.json"          "$TARGET/opencode.json"
copy "$PACK_DIR/.opencode/rules"        "$TARGET/.opencode/rules"
copy "$PACK_DIR/.opencode/templates"    "$TARGET/.opencode/templates"
copy "$PACK_DIR/.opencode/commands"     "$TARGET/.opencode/commands"
copy "$PACK_DIR/.opencode/agents"       "$TARGET/.opencode/agents"
copy "$PACK_DIR/.opencode/skills/utils" "$TARGET/.opencode/skills/utils"

case "$PRESET" in
  python)
    copy "$PACK_DIR/.opencode/skills/python" "$TARGET/.opencode/skills/python" ;;
  node)
    echo "  preset node: nenhuma skill ainda (placeholder)" ;;
  generic)
    echo "  preset generic: sem skills de stack" ;;
  *)
    echo "  preset desconhecido: $PRESET" >&2; exit 1 ;;
esac

if [ "$DRY_RUN" != "1" ]; then
  mkdir -p "$TARGET/.opencode/specs"
  echo "  ok: .opencode/specs/"

  # Garante entradas do pack no .gitignore do projeto-alvo (append-only, preserva o que já existe)
  ensure_gitignore_line ".opencode/specs/"
  ensure_gitignore_line ".opencode/.pack-version"
  ensure_gitignore_line ".env"
  echo "  ok: .gitignore atualizado (append-only)"
  
  if [ -n "$VAULT_SLUG" ]; then
    echo "$VAULT_SLUG" > "$TARGET/.vault-link"
    echo "  ok: .vault-link ($VAULT_SLUG)"

    # Cria a pasta no vault, se vault estiver configurado e ainda não existir
    if [ "${USE_VAULT:-false}" = "true" ] && [ -n "${VAULT_ROOT:-}" ]; then
      VAULT_NOTE_DIR="$VAULT_ROOT/10-duon/$VAULT_SLUG"
      if [ ! -d "$VAULT_NOTE_DIR" ]; then
        mkdir -p "$VAULT_NOTE_DIR"
        # Copia templates se existirem
        if [ -f "$VAULT_ROOT/90-templates/_template-estado.md" ]; then
          cp "$VAULT_ROOT/90-templates/_template-estado.md" "$VAULT_NOTE_DIR/estado.md"
          # Substitui o placeholder NOME_DO_PROJETO pelo slug
          sed -i "s/NOME_DO_PROJETO/$VAULT_SLUG/g" "$VAULT_NOTE_DIR/estado.md"
          # Atualiza a data
          sed -i "s/AAAA-MM-DD/$(date +%Y-%m-%d)/g" "$VAULT_NOTE_DIR/estado.md"
        fi
        if [ -f "$VAULT_ROOT/90-templates/_template-tecnico.md" ]; then
          cp "$VAULT_ROOT/90-templates/_template-tecnico.md" "$VAULT_NOTE_DIR/tecnico.md"
          sed -i "s/NOME_DO_PROJETO/$VAULT_SLUG/g" "$VAULT_NOTE_DIR/tecnico.md"
        fi
        echo "  ok: vault note criada em $VAULT_NOTE_DIR"
      else
        echo "  skip: vault note já existe em $VAULT_NOTE_DIR"
      fi
    fi
  fi

  [ -f "$PACK_DIR/VERSION" ] && cp "$PACK_DIR/VERSION" "$TARGET/.opencode/.pack-version"
fi

# ---------- fim ----------

echo
echo "Pronto."
echo
echo "Próximos passos:"
echo "  1. opencode"
echo "  2. /init                              (preenche AGENTS.md)"
if [ "${USE_VAULT:-false}" = "true" ] && [ -z "$VAULT_SLUG" ]; then
echo "  3. /vault-link <slug>                 (linka ao vault)"
echo "  4. /vault-sync                        (sincroniza vault)"
echo "  5. /new-spec <descrição>              (cria primeira spec)"
else
echo "  3. /new-spec <descrição>              (cria primeira spec)"
fi
