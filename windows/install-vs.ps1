# Installer Visual Studio Code avec Chocolatey
Write-Host "Installation de Visual Studio Code..."
choco install vscode -y
Start-Sleep -Seconds 5

# Installer l'extension C/C++ de Microsoft
code --install-extension ms-vscode.cpptools