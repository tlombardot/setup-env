## Installer les prérequis
### Sur Windows
**Installer [Chocolatey](https://chocolatey.org/)** :

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Sur macOS
**Installer [Homebrew]([https://brew.sh/fr/](https://brew.sh/fr/))** :

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Sur Linux
**Installer [Snap](https://doc.ubuntu-fr.org/snap)** :

Par exemple, sur Ubuntu :
```sh
sudo apt update
sudo apt install snapd
```