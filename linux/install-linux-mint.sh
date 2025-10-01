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

check_gcc() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}"
  else
    err "$label non installé"
    sudo apt-get install -y gcc
    mark_missing
  fi
}

check_git() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}"
  else
    err "$label non installé"
    sudo apt install git-all
    mark_missing
  fi
}

check_docker() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}"
  else
    err "$label non installé"
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    mark_missing
  fi
}
check_node() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}"
  else
    err "$label non installé"
    sudo apt update
    sudo apt install nodejs npm
    mark_missing
  fi
}
check_jdk() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}"
  else
    err "$label non installé"
    sudo apt update
    sudo apt install default-jdk
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

check_gcc gcc   "GCC (compilateur)" gcc
check_git git   "Git (gestion de version)" git
check_docker docker "Docker" docker
check_node node  "Node.js" node
check_cmd npm   "npm" npm
check_cmd code  "Visual Studio Code"
check_jdk java  "Java (OpenJDK)" jdk

check_vscode_cpptools

exit $missing