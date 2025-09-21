$GREEN = "`e[32m"
$RED   = "`e[31m"
$YELLOW= "`e[33m"
$NC    = "`e[0m"

$global:missing = $false

function Has($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

function Ok($msg) {
    Write-Host "$GREEN[OK]$NC $msg"
}

function Err($msg) {
    Write-Host "$RED[ABSENT]$NC $msg"
    $global:missing = $true
}

function Info($msg) {
    Write-Host "$YELLOW[INFO]$NC $msg"
}

function Check-Cmd($cmd, $label=$null) {
    if (-not $label) { $label = $cmd }
    if (Has $cmd) {
        try {
            $version = & $cmd --version 2>$null | Select-Object -First 1
        } catch { $version = "version indisponible" }
        Ok "$label détecté : $version"
    } else {
        Err "$label non installé"
    }
}

function Check-VSCode-Cpptools {
    if (-not (Has "code")) {
        Err "VS Code non installé (binaire 'code' introuvable) — impossible de vérifier l’extension C/C++"
        return
    }

    $exts = code --list-extensions 2>$null
    if ($exts -match "^ms-vscode.cpptools$") {
        Ok "Extension VS Code 'ms-vscode.cpptools' installée"
    } else {
        Err "Extension VS Code 'ms-vscode.cpptools' absente"
        Info "Pour installer : code --install-extension ms-vscode.cpptools"
    }
}

Write-Host "=== Vérification des installations (Windows) ==="

Check-Cmd "gcc"   "GCC (compilateur)"
Check-Cmd "git"   "Git (gestion de version)"
Check-Cmd "docker" "Docker"
Check-Cmd "node"  "Node.js"
Check-Cmd "npm"   "npm"
Check-Cmd "code"  "Visual Studio Code"
Check-Cmd "java"  "Java (OpenJDK)"

Check-VSCode-Cpptools

if ($global:missing) {
    exit 1
} else {
    exit 0
}
