# Définir les couleurs
$green = "Green"
$magenta = "Magenta"

Write-Host "Bravo, tu viens d'exécuter ton premier script chez" -ForegroundColor $green

Write-Host @"
   _____ ____  _____          
  / ____/ __ \|  __ \   /\    
 | |   | |  | | |  | | /  \   
 | |   | |  | | |  | |/ /\ \  
 | |___| |__| | |__| / ____ \ 
  \_____\____/|_____/_/    \_\
"@ -ForegroundColor $green

Write-Host ""
Write-Host "Le premier d'une longue série !!!" -ForegroundColor $magenta
