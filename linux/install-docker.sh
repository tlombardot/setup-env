#!/bin/bash

# Ajouter la clé GPG officielle de Docker et le dépôt
echo "Ajout de la clé GPG et du dépôt Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installer Docker
echo "Installation de Docker..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Démarrer et activer Docker
echo "Démarrage et activation de Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Vérifier que Docker est en cours d'exécution
echo "Vérification que Docker est en cours d'exécution..."
if sudo systemctl is-active --quiet docker; then
    echo "Docker est en cours d'exécution."
else
    echo "Échec du démarrage de Docker."
    exit 1
fi