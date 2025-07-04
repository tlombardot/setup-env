#!/bin/bash
# Installer Docker Desktop via Homebrew Cask
echo "Installation de Docker Desktop..."
brew install --cask docker

# Démarrer Docker Desktop
echo "Lancement de Docker Desktop..."
open -a Docker

# Attendre que Docker Desktop soit prêt
echo "Attente que Docker Desktop soit prêt..."
until docker system info &> /dev/null; do
    sleep 1
done

echo "Docker Desktop a été installé et est prêt à l'emploi."