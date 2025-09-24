#!/usr/bin/env bash

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

has() { command -v "$1" >/dev/null 2>&1; }
ok()   { printf "${GREEN}[OK]${NC} $*"; }
err()  { printf "${RED}[ABSENT]${NC} $*"; }
info() { printf "${YELLOW}[INFO]${NC} $*"; }

missing=0
mark_missing() { missing=+1; }

check_brew() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}\n"
    info "Déjà installé\n"
  else
    #err "$label non installé"
    brew install $3
    mark_missing
  fi
}

printf " ${GREEN}Verification installation."
sleep 1
printf "."
sleep 1
printf ".\n"
printf "${YELLOW}
   _____ ____  _____          
  / ____/ __ \|  __ \   /\    
 | |   | |  | | |  | | /  \   
 | |   | |  | | |  | |/ /\ \  
 | |___| |__| | |__| / ____ \ 
  \_____\____/|_____/_/    \_\
${NC}\n
"
sleep 1
check_brew gcc   "GCC (compilateur)" gcc
sleep 1
check_brew git   "Git (gestion de version)" git
sleep 1
check_brew docker "Docker" "--cask docker"
sleep 1
check_brew java  "Java (OpenJDK)" openjdk
sleep 1
check_brew npm   "npm" npm
sleep 1
check_brew node  "Node.js" node
sleep 1
check_brew phpstorm "PhpStorm" "--cask phpstorm"
sleep 1
check_brew code  "Visual Studio Code" "--cask visual-studio-code"
sleep 1
check_brew github "Github" "--cask github"

printf "${missing} Applictation manquante(s) et installé\n"