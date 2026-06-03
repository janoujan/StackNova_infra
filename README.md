# StackNova Infra

Projet réalisé dans le cadre de l'évaluation **Infrastructure as Code
(IaC)**.

## Présentation

StackNova est une startup SaaS spécialisée dans les tableaux de bord
analytiques RH. Dans le cadre de cette évaluation, l'objectif est de
mettre en œuvre une solution de déploiement automatisée et reproductible
permettant de provisionner et configurer un environnement de recette.

Le projet s'appuie sur les technologies suivantes :

-   Terraform
-   Docker
-   Ansible
-   Bash
-   Git / GitHub

L'ensemble du déploiement doit être réalisable via une seule commande.

# Objectifs

-   Provisionner automatiquement un conteneur Docker Nginx avec
    Terraform
-   Configurer le conteneur avec Ansible
-   Générer une page web personnalisée
-   Garantir la reproductibilité de l'environnement
-   Versionner l'infrastructure sous Git
-   Automatiser entièrement le processus de déploiement

# Architecture du projet

    stacknova-infra/

    ├── terraform/
    │   ├── providers.tf
    │   ├── main.tf
    │   └── outputs.tf

    ├── ansible/
    │   ├── inventory.ini
    │   └── playbook.yml

    ├── scripts/
    │   └── deploy.sh

    ├── screens/
    │   ├── terraform_apply.png
    │   ├── nginx_default.png
    │   ├── ansible_execution.png
    │   └── stacknova_page.png

    ├── .gitignore
    └── README.md

# Prérequis

Le projet a été testé sur :

-   Ubuntu 22.04 LTS
-   Docker 28.x
-   Terraform 1.13.x
-   Ansible Core 2.19.x

## Vérification des dépendances

### Docker

    docker --version

Exemple :

    Docker version 28.3.2, build 578ccf6

### Terraform

    terraform version

Exemple :

    Terraform v1.13.0

### Ansible

    ansible --version

Exemple :

    ansible [core 2.19.x]

# Déploiement

Depuis la racine du projet :

    bash scripts/deploy.sh

Le script réalise automatiquement :

1.  Initialisation Terraform
2.  Provisionnement de l'infrastructure Docker
3.  Exécution du playbook Ansible
4.  Vérification du service Nginx

Aucune intervention manuelle n'est nécessaire.

# Infrastructure déployée

Terraform crée :

-   Une image Docker Nginx version 1.25.3
-   Un conteneur nommé `stacknova-recette`
-   Une exposition du port `8080` de l'hôte vers le port `80` du
    conteneur
-   Des labels de gestion

Configuration :

    localhost:8080 → stacknova-recette:80

Labels appliqués :

    env=recette
    project=stacknova

# Configuration Ansible

Le playbook Ansible configure automatiquement le conteneur après son
déploiement.

Actions réalisées :

-   Création d'une page HTML personnalisée
-   Affichage du nom du projet
-   Affichage de l'environnement
-   Affichage de la date et de l'heure du déploiement
-   Vérification du processus Nginx

Exemple de contenu généré :

    <html>
      <body>
        <h1>StackNova</h1>
        <h2>Environnement : recette</h2>
        <p>Déployé le : 2026-06-03 14:30:00</p>
      </body>
    </html>

# Vérification du fonctionnement

Accès via navigateur :

    http://localhost:8080

Ou en ligne de commande :

    curl http://localhost:8080

Résultat attendu :

    <h1>StackNova</h1>
    <h2>Environnement : recette</h2>

# Choix techniques

## Terraform pour le provisionnement

Terraform a été utilisé afin de décrire l'infrastructure sous forme
déclarative. Cette approche permet de conserver l'ensemble de la
configuration dans le dépôt Git et de reconstruire l'environnement à
l'identique à tout moment.

## Provider Docker Kreuzwerker

Le provider Docker de Kreuzwerker est la référence pour la gestion des
ressources Docker avec Terraform. Il permet de créer et administrer des
conteneurs directement depuis les fichiers Terraform.

## Version d'image épinglée

L'image utilisée est :

    nginx:1.25.3

L'utilisation d'une version fixe garantit la stabilité et la
reproductibilité des déploiements. Le tag `latest` a volontairement été
évité afin d'empêcher les changements imprévus entre deux exécutions.

## Utilisation des labels

Les labels :

    env=recette
    project=stacknova

facilitent l'identification des ressources et constituent une bonne
pratique de gestion des environnements Docker.

## Séparation des responsabilités

Terraform est utilisé pour créer l'infrastructure tandis qu'Ansible est
utilisé pour la configuration. Cette séparation permet de respecter les
principes DevOps et de faciliter la maintenance du projet.

## Utilisation du module Raw

Le conteneur Nginx ne dispose pas d'un interpréteur Python installé.
Afin de respecter cette contrainte, le playbook utilise le module `raw`
permettant d'exécuter directement des commandes shell dans le conteneur.

## Horodatage dynamique

La date et l'heure de déploiement sont générées dynamiquement lors de
l'exécution du playbook grâce à une variable Ansible. Cette information
permet d'identifier rapidement le dernier déploiement effectué.

## Script de déploiement unique

L'intégralité du processus est centralisée dans le script :

    scripts/deploy.sh

Cette approche répond à l'exigence d'un déploiement réalisable via une
seule commande.

## Gestion des erreurs

Le script utilise :

    set -e

Cette option provoque l'arrêt immédiat du déploiement dès qu'une
commande retourne une erreur. Cela évite les déploiements partiellement
exécutés ou incohérents.

# Reproductibilité

La reproductibilité a été validée en réalisant le cycle complet suivant
:

## Suppression de l'environnement

    cd terraform

    terraform destroy -auto-approve

## Redéploiement complet

    bash scripts/deploy.sh

Résultat observé :

-   recréation automatique du conteneur
-   réapplication des labels
-   régénération de la page web
-   redémarrage du service Nginx

L'environnement obtenu est identique à celui du premier déploiement.

# Captures d'écran

Le dossier `screens/` contient les preuves de fonctionnement suivantes :

  -----------------------------------------------------------------------
  Capture                             Description
  ----------------------------------- -----------------------------------
  screens/P2_capture_terraform_apply.png & screens/P2_capture_terraform_apply.png               Résultat du terraform apply

  screens/P2_capture_nginx.png                  Vérification du conteneur Nginx

  screens/P3_capture_ansible_playbook.png      Exécution du playbook Ansible

  screens/stacknova_page.png                  Résultat final dans le navigateur
  -----------------------------------------------------------------------

# Questions théoriques

## Q1. Quelle est la différence entre Terraform et Ansible ? En quoi sont-ils complémentaires dans ce projet ?

Terraform est un outil de provisionnement qui permet de créer et gérer
l'infrastructure. Ansible est un outil de configuration qui permet
d'administrer les systèmes après leur création. Dans ce projet,
Terraform crée le conteneur Docker tandis qu'Ansible personnalise son
contenu et vérifie son fonctionnement.

## Q2. À quoi sert le state file Terraform ? Quels risques pose sa mauvaise gestion en équipe ?

Le state file conserve l'état réel des ressources créées par Terraform.
Il permet à l'outil de déterminer les modifications à appliquer. Une
mauvaise gestion peut provoquer des conflits, des pertes d'informations
ou des suppressions involontaires de ressources.

## Q3. Qu'est-ce que l'idempotence ? Donnez un exemple concret tiré de ce projet.

L'idempotence désigne la capacité d'une opération à produire le même
résultat lorsqu'elle est exécutée plusieurs fois. Dans ce projet,
relancer le playbook Ansible produit toujours la même page web sans
créer de ressources supplémentaires.

## Q4. Quelle est la différence entre terraform apply et terraform apply -replace ? Dans quel cas utiliseriez-vous le second ?

`terraform apply` applique les modifications détectées dans la
configuration. `terraform apply -replace` force la destruction puis la
recréation d'une ressource donnée. Cette option est utile lorsqu'une
ressource est corrompue ou nécessite une reconstruction complète.

## Q5. Pourquoi est-il déconseillé d'utiliser le tag latest en production ?

Le tag `latest` ne correspond pas à une version fixe et peut évoluer à
tout moment. Son utilisation peut entraîner des différences de
comportement entre deux déploiements. L'utilisation d'une version
explicitement définie garantit la stabilité et la reproductibilité de
l'environnement.

# Conclusion

Cette évaluation a permis de mettre en œuvre une chaîne complète
d'automatisation basée sur les principes Infrastructure as Code.
L'environnement de recette StackNova peut être déployé, détruit et
reconstruit de manière fiable grâce à Terraform, Ansible et Docker, tout
en respectant les bonnes pratiques DevOps de versionnement,
d'automatisation et de reproductibilité.