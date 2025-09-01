#!/bin/bash

# Installer les outils de ligne de commande de Xcode
xcode-select --install

# Attendre que l'utilisateur ait terminé l'installation des outils de ligne de commande
read -p "Appuyez sur Entrée une fois l'installation des outils de ligne de commande terminée..."

# Accepter les conditions d'utilisation de Xcode
sudo xcodebuild -license accept

# Installer gcc via Homebrew
brew install gcc

echo "gcc a bien été installé avec succès."