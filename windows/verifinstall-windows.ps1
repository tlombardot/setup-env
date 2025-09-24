#!/bin/bash

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

function check-choco($cmd, $label=$null, $3) {
    Write-Host "Verification $cmd" -ForegroundColor Yellow
    if (-not $label) { $label = $cmd }
    if (Has $cmd) {
        try {
            $version = & $cmd --version 2>$null | Select-Object -First 1
        } catch { $version = "version indisponible" }
        Ok "$label détecté : $version"
    } else {
        Err "$label non installé"
        choco install $3 -y
    }
}

function Check-VSCode-Cpptools {
    if (-not (Has "code")) {
        Err "VS Code non installé (binaire 'code' introuvable) — impossible de vérifier l’extension C/C++"
        return
    }
    Write-Host "Vérification Extensions VSCode" -ForegroundColor Yellow
    $exts = code --list-extensions 2>$null
    if ($exts -match "^ms-vscode.cpptools$") {
        Ok "Extension VS Code 'ms-vscode.cpptools' installée"
    } else {
        Err "Extension VS Code 'ms-vscode.cpptools' absente"
        Info "Pour installer : code --install-extension ms-vscode.cpptools"
    }
}


Write-Host "=== Vérification des installations (Windows) ===
 " -ForegroundColor Red

check-choco "gcc"   "GCC (compilateur)" "mingw"
check-choco "git"   "Git (gestion de version)" "git"
check-choco "docker" "Docker" "docker-desktop"
check-choco "node"  "Node.js" "nodejs-lts"
check-choco "npm"   "npm" 
check-choco "code"  "Visual Studio Code"
check-choco "java"  "Java (OpenJDK)" "openjdk"
check-choco "phpstorm" "PhpStorm" "phpstorm"

Check-VSCode-Cpptools

if ($global:missing) {
    exit 1
} else {
    exit 0
}
