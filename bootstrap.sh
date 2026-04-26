#!/usr/bin/env bash
# bootstrap.sh — baixa o opencode-pack e roda o install no diretório atual.
# Uso:
#   bash <(curl -s https://raw.githubusercontent.com/lucasarlop/opencode-pack/main/bootstrap.sh)
#   OPENCODE_PACK_BRANCH=<branch> bash <(curl -s https://raw.githubusercontent.com/lucasarlop/opencode-pack/main/bootstrap.sh)
set -euo pipefail

REPO="https://github.com/lucasarlop/opencode-pack.git"
BRANCH="${OPENCODE_PACK_BRANCH:-main}"
TMP_DIR="$(mktemp -d -t opencode-pack-XXXXXX)"

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "opencode-pack bootstrap"
echo "  repo   : $REPO"
echo "  branch : $BRANCH"
echo "  tmp    : $TMP_DIR"
echo

if ! command -v git >/dev/null 2>&1; then
  echo "erro: git não encontrado. instale o git primeiro." >&2
  exit 1
fi

git clone --depth=1 --branch "$BRANCH" "$REPO" "$TMP_DIR/pack" >/dev/null 2>&1 || {
  echo "erro: falha ao clonar $REPO (branch: $BRANCH)" >&2
  exit 1
}

echo "  ok: repo clonado"
echo

# Passa todos os argumentos do bootstrap pro install.sh
bash "$TMP_DIR/pack/install.sh" "$@"
