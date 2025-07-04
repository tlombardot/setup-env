# Installer Chocolatey si ce n'est pas déjà fait
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Installer Git
choco install git -y

# Installer github-desktop : https://github.com/apps/desktop
choco install github-desktop

Write-Output "Git (incluant Git Bash) et GitHub Desktop ont été installés avec succès."