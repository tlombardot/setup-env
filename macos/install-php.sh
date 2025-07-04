# Lancer une image PHP avec la dernière version
echo "Lancement d'une image PHP avec la dernière version..."
docker run -d --name php-container -p 8080:80 php:latest

# Vérifier que le conteneur est bien démarré
echo "Vérification que le conteneur est bien démarré..."
if docker ps | grep -q "php-container"; then
    echo "Le conteneur PHP est bien démarré."
else
    echo "Échec du démarrage du conteneur PHP."
    exit 1
fi

echo "L'image PHP avec la dernière version a été lancée avec succès."

# Arrêter le conteneur
echo "Arrêt du conteneur PHP..."
docker stop php-container

# Arrêter Docker Desktop
echo "Arrêt de Docker Desktop..."
osascript -e 'quit app "Docker"'

echo "Le conteneur PHP et Docker Desktop ont été arrêtés avec succès."

# Installer IDE pour PHP
brew install --cask phpstorm

# Ouvrir PhpStorm et créez vous un compte Jetbrains
phpstorm