# Installer MinGW qui inclut GCC
choco install mingw -y

# Ajouter MinGW au PATH
$mingwPath = "C:\tools\mingw64\bin"
$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$mingwPath*") {
    [Environment]::SetEnvironmentVariable("Path", $envPath + ";" + $mingwPath, "Machine")
}

Write-Output "GCC a été installé avec succès."