#!/usr/bin/env bash
set -euo pipefail

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

has() { command -v "$1" >/dev/null 2>&1; }
ok()   { echo "${GREEN}[OK]${NC} $*"; }
err()  { echo "${RED}[ABSENT]${NC} $*"; }
info() { echo "${YELLOW}[INFO]${NC} $*"; }

missing=0
mark_missing() { missing=1; }

check_cmd() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}"
  else
    err "$label non installé"
    mark_missing
  fi
}

check_vscode_cpptools() {
  if ! has code; then
    err "VS Code non installé (binaire 'code' introuvable) — impossible de vérifier l’extension C/C++"
    mark_missing
    return
  fi

  if code --list-extensions 2>/dev/null | grep -q '^ms-vscode\.cpptools$'; then
    ok "Extension VS Code 'ms-vscode.cpptools' installée"
    return
  fi

  local extdir="${HOME}/.vscode/extensions"
  if [ -d "$extdir" ] && ls "$extdir" 2>/dev/null | grep -qi '^ms-vscode\.cpptools'; then
    ok "Extension VS Code 'ms-vscode.cpptools' détectée (dossier)"
  else
    err "Extension VS Code 'ms-vscode.cpptools' absente"
    info "Pour installer : code --install-extension ms-vscode.cpptools"
    mark_missing
  fi
}

echo "=== Vérification des installations==="

check_cmd gcc   "GCC (compilateur)"
check_cmd git   "Git (gestion de version)"
check_cmd docker "Docker"
check_cmd node  "Node.js"
check_cmd npm   "npm"
check_cmd code  "Visual Studio Code"
check_cmd java  "Java (OpenJDK)"

check_vscode_cpptools

exit $missing