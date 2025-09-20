# Livrable
## Ce que tu dois faire
1. **Forker** ce repo dans ton espace GitHub.
2. **Créer un script d’installation** (`install.sh` ou `install.ps1`) qui :
   * s’exécute sur la machine cible (ta machine) ;
   * **vérifie la présence** de chaque logiciel/package **avant** d’installer ;
   * est **idempotent** : le relancer ne doit ni réinstaller, ni casser l’environnement (sobriété : pas de consommation inutile de CPU/bande passante/stockage) ;
   * loggue clairement ce qu’il fait (messages explicites).
3. **Valider l’idempotence** : exécuter ton script **au moins 2 fois**.
   * 1er run : installation.
   * 2e run : aucune réinstallation, sortie `0`.
   * **Copier-coller ou capturer les sorties complètes** de ces 2 exécutions et les joindre à ton rendu.

## Critères d’acceptation
* ✅ Le script fonctionne de bout en bout.
* ✅ Chaque installation est précédée d’un **test de présence**.
* ✅ Idempotence vérifiée (2ᵉ run = “rien à faire”).
* ✅ Code clair, défensif, messages utiles, erreurs gérées.

## Exigence “sobriété” : tester avant d’installer (ex. avec `gcc`)
- Exemple de vérification avec `gcc`

### Sur linux et macOS
```sh
# Retourne 0 si gcc est disponible, 1 sinon
if command -v gcc >/dev/null 2>&1; then
  echo "[ok] gcc déjà présent ($(gcc --version | head -n1))"
else
  echo "[info] gcc absent, installation..."
  # ... appel à la fonction d'installation selon l'OS ...
fi
```

On peut créer des fonctions "utilitaires" comme `has()`, `err()`, `ok()`, `info()`:

```sh
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # reset couleur

has() { command -v "$1" >/dev/null 2>&1; }

ok()   { echo -e "${GREEN}[OK]${NC} $*"; }
err()  { echo -e "${RED}[ERREUR]${NC} $*"; exit 1; }
info() { echo "[INFO] $*"; }


# Qu'on peut utiliser comme ici:
if ! has gcc; then
    # Lancer l'installation de gcc ici fonction de votre package manager
    brew install gcc || err "Échec installation gcc"
    ok "gcc installé."
else
    ok "gcc déjà présent ($(gcc --version | head -n1))."
fi
```

### Sur Windows avec Powershell
On peut créer des fonctions "utilitaires" comme `Has()`, `Err()`, `Ok()`, `Info()`:

```powershell
# --- Couleurs ANSI ---
$GREEN = "`e[32m"
$RED   = "`e[31m"
$NC    = "`e[0m"   # reset couleur

# --- Fonctions utilitaires ---
function Has($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

function Ok($msg) {
    Write-Host "$GREEN[OK]$NC $msg"
}

function Err($msg) {
    Write-Host "$RED[ERREUR]$NC $msg"
    exit 1
}

function Info($msg) {
    Write-Host "[INFO] $msg"
}

# --- Exemple d’utilisation ---
if (-not (Has "gcc")) {
    try {
        choco install mingw -y
        if ($LASTEXITCODE -eq 0) {
            Ok "gcc installé."
        } else {
            Err "Échec installation gcc"
        }
    } catch {
        Err "Échec installation gcc ($_)"
    }
} else {
    $version = (& gcc --version)[0]
    Ok "gcc déjà présent ($version)."
}
```

## Rendu attendu
* Le lien vers ton **fork GitHub**.
* Le fichier `install.sh` (Linux/macOS) ou `install.ps1` (Windows) à la racine, exécutable.
* Les **résultats des 2 runs** de ton script (copie des sorties console ou imprime écran).