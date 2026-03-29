#!/usr/bin/env bash
# install.sh
# Instala o opencode-pack no projeto atual
#
# Uso direto (repo clonado):
#   bash install.sh [caminho/do/projeto] [--force]
#
# Uso remoto (one-liner):
#   bash <(curl -s https://raw.githubusercontent.com/lucasarlop/opencode-pack/main/install.sh)
#   → clona automaticamente e instala no diretório atual

set -euo pipefail

REPO_URL="https://github.com/lucasarlop/opencode-pack.git"
TARGET_DIR="$(pwd)"
FORCE=false

for arg in "$@"; do
  case $arg in
    --force) FORCE=true ;;
    -*) ;;
    *) TARGET_DIR="$arg" ;;
  esac
done

# Detecta se está rodando via pipe/curl (BASH_SOURCE[0] não é um arquivo real)
PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$PACK_DIR" == /proc/* ]] || [[ ! -f "$PACK_DIR/VERSION" ]]; then
  echo "opencode-pack — modo remoto detectado, clonando repositório..."
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT
  git clone --depth=1 "$REPO_URL" "$TMP_DIR" --quiet
  PACK_DIR="$TMP_DIR"
  echo "✓ Repositório clonado"
  echo ""
fi

PACK_VERSION="$(cat "$PACK_DIR/VERSION" 2>/dev/null || echo "unknown")"

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
mkdir -p "$TARGET_DIR/.opencode/docs/brainstorming"
mkdir -p "$TARGET_DIR/docs/diagrams"
touch "$TARGET_DIR/.opencode/specs/.gitkeep"
touch "$TARGET_DIR/.opencode/docs/adr/.gitkeep"
touch "$TARGET_DIR/.opencode/docs/brainstorming/.gitkeep"
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
echo "  opencode.json                    ← carrega rules, specs e docs automaticamente"
echo "  .opencode/rules/planning.md      ← protocolo Spec-First"
echo "  .opencode/templates/             ← template de spec v2.1"
echo "  .opencode/commands/              ← /new-spec, /execute, /spec-review, /brainstorming, /plan-specs"
echo "  .opencode/skills/                ← tdd, python-docker, diagrams, ..."
echo "  .opencode/docs/adr/              ← ADRs (commitado)"
echo "  .opencode/docs/brainstorming/    ← notas de brainstorming (commitado)"
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
