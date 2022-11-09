#!/bin/bash

set -e

if [ -z "${CHEMIN_BASE_COMPTABILITE}" ]
then
	echo "Erreur : préciser la variable d'environnement 'CHEMIN_BASE_COMPTABILITE'" >&2
	exit 1
fi

# Sélectionner les catégories
mapfile -t categories < <(sqlite3 "${CHEMIN_BASE_COMPTABILITE}" "SELECT cat_nom FROM Categories ORDER BY cat_nom;")

# Pour chaque caétgorie, demander le budget et insérer
for categorie in "${categories[@]}"
do
    read -p "${categorie} : " "budget"
    if [ ! -z "${budget}" ]
    then
        sqlite3 -echo "${CHEMIN_BASE_COMPTABILITE}" "INSERT INTO Budgets (cat_id,bu_montant,bu_mois) VALUES ((SELECT cat_id FROM Categories WHERE cat_nom = \"${categorie}\"), ${budget}, strftime('%s','now','start of month'));"
    fi
done

exit 0
