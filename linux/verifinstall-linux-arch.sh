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

check_pacman() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}\n"
    info "Déjà installé\n"
  else
    #err "$label non installé"
    sudo pacman -S $3
    mark_missing
  fi
}
check_yay() {
  local cmd="$1"
  local label="${2:-$1}"
  if has "$cmd"; then
    local version="$($cmd --version 2>/dev/null | head -n1 || true)"
    ok "$label détecté : ${version:-version indisponible}\n"
    info "Déjà installé\n"
  else
    #err "$label non installé"
    yay -S $3
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

check_pacman gcc   "GCC (compilateur)" gcc
sleep 1
check_pacman git   "Git (gestion de version)" git
sleep 1
check_pacman docker "Docker" docker
sleep 1
check_pacman java  "Java (OpenJDK)" jdk21-openjdk
sleep 1
check_pacman npm   "npm" npm
sleep 1
check_yay node  "Node.js" node
sleep 1
check_yay phpstorm "PhpStorm" phpstorm
sleep 1
check_yay code  "Visual Studio Code" visual-studio-code-bin

printf "${missing} Applictation manquante(s) et installé\n"