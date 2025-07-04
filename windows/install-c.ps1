# Installer MinGW qui inclut GCC
choco install mingw -y

# Ajouter MinGW au PATH
$mingwPath = "C:\tools\mingw64\bin"
$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$mingwPath*") {
    [Environment]::SetEnvironmentVariable("Path", $envPath + ";" + $mingwPath, "Machine")
}

# Installer SDL2 via Chocolatey
choco install sdl2 -y

Write-Output "GCC et SDL2 ont été installés avec succès."