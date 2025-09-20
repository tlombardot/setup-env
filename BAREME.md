# Barème de notation ( /20 )
1. **Structure du dépôt et script exécutable** – **2 pts**
* Script présent à la racine du fork, exécutable (`install.sh` ou `install.ps1`).

2. **Exécution fonctionnelle de bout en bout** – **5 pts**
* Le script s’exécute sans erreur sur l’OS annoncé et installe ce qui est nécessaire.

3. **Vérification de présence avant installation (sobriété)** – **4 pts**
* Chaque logiciel/package est testé avant tentative d’installation.

4. **Idempotence** – **5 pts**
* Une deuxième exécution n’entraîne ni réinstallation inutile ni casse de l’environnement.

5. **Logs et lisibilité** – **2 pts**
* Messages explicites et colorés (`ok`, `err`, `info`), clairs pour l’utilisateur.

6. **Gestion des erreurs et codes de sortie** – **2 pts**
* Gestion des échecs (installation ratée, commande introuvable) avec sortie en erreur (`exit 1`).