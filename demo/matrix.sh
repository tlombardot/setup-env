#!/usr/bin/env bash
# matrix.sh — pluie "Matrix" rapide avec traînée visible (macOS/Linux)
# Usage: ./matrix.sh [-s vitesse_ms] [-d densite] [-t trainee] [-c couleur]
#   -s : ms entre frames (défaut 20)   -d : 1–100 (défaut 70)
#   -t : longueur de traînée (défaut 8) -c : green|lime|white|cyan
# Quitter: Ctrl-C

set -euo pipefail

# --------- Paramètres par défaut ---------
SPEED_MS=20
DENSITY=70
TRAIL=8
COLOR="green"

# --------- Parsing options ---------
is_uint(){ [[ "$1" =~ ^[0-9]+$ ]]; }
while getopts ":s:d:t:c:" opt; do
  case "$opt" in
    s) is_uint "$OPTARG" || { echo "-s entier (ms)"; exit 2; }; SPEED_MS="$OPTARG" ;;
    d) is_uint "$OPTARG" || { echo "-d entier (1-100)"; exit 2; }; DENSITY="$OPTARG"; ((DENSITY>=1&&DENSITY<=100)) || { echo "-d 1..100"; exit 2; } ;;
    t) is_uint "$OPTARG" || { echo "-t entier >=1"; exit 2; }; TRAIL="$OPTARG"; ((TRAIL>=1)) || { echo "-t >=1"; exit 2; } ;;
    c) COLOR="$OPTARG" ;;
    \?|:) echo "Usage: $0 [-s ms] [-d 1-100] [-t n] [-c color]"; exit 2 ;;
  esac
done
shift $((OPTIND-1))

# --------- Pause portable (Linux/macOS) ---------
pause() {
  if command -v usleep >/dev/null 2>&1; then
    usleep "$(( SPEED_MS * 1000 ))"
  else
    # macOS: sleep accepte les décimales
    sleep "$(awk "BEGIN {print $SPEED_MS/1000}")"
  fi
}

# --------- Couleurs & styles ---------
color_code() {
  case "$1" in
    green) tput setaf 2 2>/dev/null || true ;;
    lime)  tput setaf 10 2>/dev/null || tput setaf 2 2>/dev/null || true ;;
    white) tput setaf 7 2>/dev/null || true ;;
    cyan)  tput setaf 6 2>/dev/null || true ;;
    *)     tput setaf 2 2>/dev/null || true ;;
  esac
}
RESET="$(tput sgr0 2>/dev/null || true)"
FG_MAIN="$(color_code "$COLOR")"
FG_DIM="$(tput dim 2>/dev/null || true)$(color_code "$COLOR")"
FG_BOLD="$(tput bold 2>/dev/null || true)"
FG_HEAD="$FG_BOLD$(tput setaf 7 2>/dev/null || true)"   # tête claire
FG_BRG="$FG_BOLD$(color_code "$COLOR")"                 # vert vif

# Palette de dégradé pour la traînée (sans nameref)
declare -a STYLE
build_style() {
  STYLE=()
  STYLE[0]="$FG_HEAD"   # tête
  STYLE[1]="$FG_BRG"    # très visible
  STYLE[2]="$FG_MAIN"   # normal
  local i
  for ((i=3;i<TRAIL;i++)); do STYLE[$i]="$FG_DIM"; done
}
build_style

# --------- Terminal ---------
stty -echo
tput civis || true
cleanup(){ tput cnorm 2>/dev/null || true; tput sgr0 2>/dev/null || true; stty echo; printf "\n"; }
trap cleanup INT TERM EXIT
tput clear || true

# --------- Taille ---------
cols="$(tput cols 2>/dev/null || echo 80)"
rows="$(tput lines 2>/dev/null || echo 24)"
(( rows < 5 )) && rows=5
(( cols < 5 )) && cols=5

# --------- État par colonne ---------
declare -a pos speed
for ((x=0; x<cols; x++)); do
  pos[$x]=$(( RANDOM % rows ))
  speed[$x]=$(( 2 + RANDOM % 4 ))  # plus rapide (2..5)
done

# --------- Caractères ---------
CHARS=(0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
      'ｱ' 'ｲ' 'ｳ' 'ｴ' 'ｵ' 'ｶ' 'ｷ' 'ｸ' 'ｹ' 'ｺ' 'ｻ' 'ｼ' 'ｽ' 'ｾ' 'ｿ' 'ﾀ' 'ﾁ' 'ﾂ' 'ﾃ' 'ﾄ')
rand_char(){ printf "%s" "${CHARS[$RANDOM % ${#CHARS[@]}]}"; }
active_col(){ (( RANDOM % 100 < DENSITY )); }

# --------- Boucle ---------
while :; do
  for ((x=0; x<cols; x++)); do
    if active_col; then
      y=${pos[$x]}
      sp=${speed[$x]}

      # Tête + traînée multi-niveaux
      k=0
      while (( k < TRAIL )); do
        yy=$(( y-k ))
        (( yy < 0 )) && break
        tput cup "$yy" "$x"
        printf "%b%s%b" "${STYLE[$k]:-$FG_DIM}" "$(rand_char)" "$RESET"
        ((k++))
      done

      # Efface loin derrière
      yy_clear=$(( y-TRAIL-1 ))
      if (( yy_clear >= 0 )); then
        tput cup "$yy_clear" "$x"; printf " "
      fi

      # Avance rapide
      y=$(( (y + sp) % rows ))
      pos[$x]=$y
    fi
  done

  pause

  # Redimensionnement dynamique
  new_cols="$(tput cols 2>/dev/null || echo "$cols")"
  new_rows="$(tput lines 2>/dev/null || echo "$rows")"
  if [[ "$new_cols" != "$cols" || "$new_rows" != "$rows" ]]; then
    cols="$new_cols"; rows="$new_rows"
    (( rows < 5 )) && rows=5
    (( cols < 5 )) && cols=5
    for ((i=${#pos[@]}; i<cols; i++)); do
      pos[$i]=$(( RANDOM % rows ))
      speed[$i]=$(( 2 + RANDOM % 4 ))
    done
    tput clear || true
  fi
done
