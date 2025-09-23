Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force | Out-Null
$global:missing = $false

function Ok   ($msg){
    Write-Host "[OK] $msg" -ForegroundColor Green
}
function Err  ($msg){
    Write-Host "[ERREUR] $msg" -ForegroundColor Red
    $script:FAILED = $true
}
function Info ($msg){
    Write-Host "[INFO] $msg" -ForegroundColor Yellow
}
function Has  ($cmd){
    [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
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
