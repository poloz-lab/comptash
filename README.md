# COMPTASH

## Description

Outil de gestion de comptabilité personnelle dans le terminal.

## Dépendances

- sqlite3
- bash

## Utilisation

### Initilisation

`sqlite3 base.sqlite < Sql/créerBase.sql`

### Catégories

Les types d'opération sont répartis dans des catégories.

On peut chercher les catégories existantes avec :
`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/vérifierCatégorie.sh 'boutdemot'`

On peut ajouter une catégorie avec :
`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/ajouterCatégorie.sh 'nomdelacatégorie'`

### Types d'opération

Les types d'opération définissent les opérations que l'on peut instancier lorsque l'opération a lieu.
Ils permettent de regrouper les différentes opérations possibles.

On peut chercher les types d'opération existants avec :
`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/vérifierTypeOpération.sh 'boutdemot'`

On peut ajouter un type d'opération avec :
`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/ajouterTypeOpération.sh 'nomdutype' 'catégorie'`

### Insérer une opération

Insérer une opération instancie un type d'opération. On peut ensuite préciser un montant, une date, une part dans le cadre d'un partage et un commentaire.

Si le type de l'opération n'est pas complet, alors le plus ressemblant est sélectionné.

Le montant pour une sortie d'argent doit être négatif.
Il est positif pour une entrée d'argent.

La date doit être spécifiée au format AAAA-MM-JJ

La part doit être spécifié par un ratio entre 0 et 1.
Pour indiquer que l'on paye la moitié d'un repas, on rentre le prix total du repas, avec une part de 0.5.
La valeur stockée est la moitié du repas, mais en stockant également la part, il est possible de retrouver le montant initial.

Plusieurs commandes sont possibles en fonction des arguments spécifiés :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/insérerOpération.sh 'typedoperation' 'montant' 'date' 'part' 'commentaire'`

Sans le commentaire :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/insérerOpération.sh 'typedoperation' 'montant' 'date' 'part'`

Sans la part qui par défaut vaut 1 :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/insérerOpération.sh 'typedoperation' 'montant' 'date'`

Sans la date qui par défaut vaut la date du jour :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/insérerOpération.sh 'typedoperation' 'montant'`

### Visualiser les opérations

Il est possible d'afficher les opérations du mois courant :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scripts/afficherMoisOpérations.sh`

Ou bien toutes les opérations :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scripts/afficherToutOpérations.sh`

Dans les affichages précédents, les opérations sont classées de manière chronologique, de la plus récente à la plus ancienne.

Un affichage est dédié au système de part. Il affiche le montant à charge, la part, le montant initial et la différence entre le montant initial et le montant à charge.

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scripts/afficherToutPart.sh`

### Opérations récurrentes

Un système permet de gérer les opérations récurrentes (qui surviennent tous les mois).

#### Types

Similaire aux types d'opérations, mais pour les opérations récurrentes.

On peut vérifier les types d'opérations récurrentes :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/vérifierTypeRécurrent.sh 'boutdemot'`

Et pour ajouter un type d'opération :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scrits/ajouterTypeRécurrent.sh 'nomdutype' 'catégorie'`

#### Provisionner les opérations récurrentes

Les opérations peuvent être stockées dans un fichier de requêtes SQL. Le fichier aurait la structure suivante :

```sql
INSERT INTO RecurrentOccurences (
    rec_typ_id,
    rec_occ_montant,
    rec_occ_mois
    ) VALUES (
        (SELECT rec_typ_id FROM RecurrentTypes WHERE rec_typ_libelle = 'Loyer'),
        -500,
        strftime('%s','now','start of month')
    )
;

INSERT INTO RecurrentOccurences (
    rec_typ_id,
    rec_occ_montant,
    rec_occ_mois
    ) VALUES (
        (SELECT rec_typ_id FROM RecurrentTypes WHERE rec_typ_libelle = 'Salaire'),
        1000,
        strftime('%s','now','start of month')
    )
;
```

Et chaque mois, on insère les opérations comme ceci :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' sqlite3 $CHEMIN_BASE_COMPTABILITE < chemin_vers_les_opérations_occurentes.sql`

#### Visualiser les opérations récurrentes

Il est possible d'afficher les opérations du mois courant :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scripts/afficherMoisRécurrent.sh`

Ou bien toutes les opérations récurrentes :

`CHEMIN_BASE_COMPTABILITE='chemin/vers/base.sqlite' Scripts/afficherToutRécurrent.sh`

### Budgets

Un système de budgets qui comporte des objectifs pour le mois et un résumé des mouvements par catégorie est en cours de développement.
Il n'est pas stable pour le moment.
