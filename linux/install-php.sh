#!/bin/bash
# Lancer une image PHP avec la dernière version
echo "Lancement d'une image PHP avec la dernière version..."
sudo docker run -d --name my-php-container -p 8080:80 php:latest

# Vérifier que le conteneur est bien démarré
echo "Vérification que le conteneur est bien démarré..."
if sudo docker ps | grep -q "my-php-container"; then
    echo "Le conteneur PHP est bien démarré."
else
    echo "Échec du démarrage du conteneur PHP."
    exit 1
fi

echo "L'image PHP avec la dernière version a été lancée avec succès."

# Arrêter le conteneur
echo "Arrêt du conteneur PHP..."
sudo docker stop my-php-container

# Arrêter Docker
echo "Arrêt de Docker..."
sudo systemctl stop docker

echo "Le conteneur PHP et Docker ont été arrêtés avec succès."

# Installer IDE pour PHP
sudo snap install phpstorm --classic

# Ouvrir PhpStorm et créez vous un compte Jetbrains
phpstorm