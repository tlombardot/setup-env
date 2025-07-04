#!/bin/bash

# Installer Homebrew si ce n'est pas déjà fait
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Installer Git
brew install git

# Installer github-desktop : https://github.com/apps/desktop
brew install --cask github

echo "Git et GitHub ont été installés avec succès."
