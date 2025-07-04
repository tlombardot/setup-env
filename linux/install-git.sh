#!/bin/bash

# Installer Snap si ce n'est pas déjà fait
if ! command -v snap &> /dev/null; then
    sudo apt update
    sudo apt install -y snapd
fi

# Installer github-desktop : https://github.com/apps/desktop
sudo snap install github-desktop --classic

echo "GitHub Desktop a été installé avec succès."