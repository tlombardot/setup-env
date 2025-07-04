# Lancer une image PHP avec la dernière version
Write-Output "Lancement d'une image PHP avec la dernière version..."
docker run -d --name php-container -p 8080:80 php:latest

# Vérifier que le conteneur est bien démarré
Write-Output "Vérification que le conteneur est bien démarré..."
$containerRunning = docker ps | Select-String "php-container"
if ($containerRunning) {
    Write-Output "Le conteneur PHP est bien démarré."
} else {
    Write-Output "Échec du démarrage du conteneur PHP."
    exit 1
}

Write-Output "L'image PHP avec la dernière version a été lancée avec succès."

# Arrêter le conteneur
Write-Output "Arrêt du conteneur PHP..."
docker stop php-container

# Arrêter Docker Desktop
Write-Output "Arrêt de Docker Desktop..."
Stop-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue

Write-Output "Le conteneur PHP et Docker Desktop ont été arrêtés avec succès."

# Installer IDE pour PHP
choco install phpstorm -y

# Ouvrir PhpStorm et créez vous un compte Jetbrains
phpstorm