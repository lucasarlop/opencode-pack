#!/usr/bin/env bash
# install.sh
# Instala o opencode-pack no projeto atual
# Uso: bash install.sh [caminho/do/projeto] [--force]

set -euo pipefail

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_VERSION="$(cat "$PACK_DIR/VERSION" 2>/dev/null || echo "unknown")"
TARGET_DIR="$(pwd)"
FORCE=false

for arg in "$@"; do
  case $arg in
    --force) FORCE=true ;;
    -*) ;;
    *) TARGET_DIR="$arg" ;;
  esac
done

echo "opencode-pack v$PACK_VERSION — instalando em: $TARGET_DIR"
echo ""

copy_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && [ "$FORCE" = false ]; then
    read -r -p "  $dst já existe. Sobrescrever? [s/N] " resp
    if [[ ! "$resp" =~ ^[Ss]$ ]]; then
      echo "  → ignorado"
      return
    fi
  fi
  cp "$src" "$dst"
  echo "  ✓ $dst"
}

# AGENTS.md (raiz)
if [ ! -f "$TARGET_DIR/AGENTS.md" ]; then
  copy_file "$PACK_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
else
  echo "  → AGENTS.md já existe — preservando (rode /init para enriquecer)"
fi

# opencode.json
copy_file "$PACK_DIR/opencode.json" "$TARGET_DIR/opencode.json"

# .opencode/ — estrutura completa
for src_file in $(find "$PACK_DIR/.opencode" -type f); do
  rel="${src_file#$PACK_DIR/}"
  dst="$TARGET_DIR/$rel"
  copy_file "$src_file" "$dst"
done

chmod +x "$TARGET_DIR/.opencode/commands/notify.sh" 2>/dev/null || true

# Diretórios vazios necessários
mkdir -p "$TARGET_DIR/.opencode/specs"
mkdir -p "$TARGET_DIR/.opencode/docs/adr"
mkdir -p "$TARGET_DIR/docs/diagrams"
touch "$TARGET_DIR/.opencode/specs/.gitkeep"
touch "$TARGET_DIR/.opencode/docs/adr/.gitkeep"
touch "$TARGET_DIR/docs/diagrams/.gitkeep"

# Registra versão instalada no projeto
echo "$PACK_VERSION" > "$TARGET_DIR/.opencode/.pack-version"
echo "  ✓ .opencode/.pack-version ($PACK_VERSION)"

# .gitignore — merge se já existir, cria se não existir
GITIGNORE="$TARGET_DIR/.gitignore"
PACK_GITIGNORE="$PACK_DIR/.gitignore"
if [ -f "$GITIGNORE" ]; then
  while IFS= read -r line; do
    if [[ -n "$line" && "$line" != \#* ]]; then
      if ! grep -qxF "$line" "$GITIGNORE"; then
        echo "$line" >> "$GITIGNORE"
      fi
    fi
  done < "$PACK_GITIGNORE"
  echo "  ✓ .gitignore atualizado"
else
  copy_file "$PACK_GITIGNORE" "$GITIGNORE"
fi

echo ""
echo "✓ opencode-pack v$PACK_VERSION instalado com sucesso!"
echo ""
echo "Estrutura criada:"
echo "  AGENTS.md                        ← contexto global do projeto"
echo "  opencode.json                    ← carrega rules automaticamente"
echo "  .opencode/rules/planning.md      ← protocolo Spec-First"
echo "  .opencode/templates/             ← template de spec v2.1"
echo "  .opencode/commands/              ← /notify, /new-spec, /spec-review"
echo "  .opencode/skills/                ← tdd, python-docker, diagrams, ..."
echo "  .opencode/docs/adr/              ← ADRs (commitado)"
echo "  .opencode/specs/                 ← specs de trabalho (.gitignore)"
echo "  docs/diagrams/                   ← diagramas C4 + sequência (commitado)"
echo "  .opencode/.pack-version          ← versão do pack instalada"
echo ""
echo "Próximos passos:"
echo "  1. opencode                      ← abre o agente"
echo "  2. /init                         ← enriquece AGENTS.md com contexto do projeto"
echo "  3. /new-spec <descrição>         ← cria a primeira spec"
echo "  4. (opcional) adicione ao .env:"
echo "       TELEGRAM_BOT_TOKEN=..."
echo "       TELEGRAM_CHAT_ID=..."
