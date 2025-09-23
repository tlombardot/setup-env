# Installer Docker Desktop via Chocolatey
Write-Output "Installation de Docker Desktop..."
choco install docker-desktop -y

# Démarrer Docker Desktop
Write-Output "Lancement de Docker Desktop..."
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Attendre que Docker Desktop soit prêt
Write-Output "Attente que Docker Desktop soit prêt..."
$dockerReady = $false
while (-not $dockerReady) {
    try {
        docker system info | Out-Null
        $dockerReady = $true
    } catch {
        Start-Sleep -Seconds 1
    }
}

Write-Output "Docker Desktop est prêt à l'emploi."