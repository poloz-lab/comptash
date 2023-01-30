#!/bin/bash

set -e

if [ -z "${CHEMIN_BASE_COMPTABILITE}" ]
then
	echo "Erreur : préciser la variable d'environnement 'CHEMIN_BASE_COMPTABILITE'" >&2
	exit 1
fi

# Test si pas assez d'arguments
if [ "${#}" -lt "1" ]
then
    echo -e "Usage:\n${0} type_opération catégorie"
    exit 1
fi

# On teste si on trouve exactement la chaîne indiquée pour la catégorie
resulat=`sqlite3 "${CHEMIN_BASE_COMPTABILITE}" "SELECT cat_id,cat_nom FROM Categories WHERE cat_nom = \"${2}\" LIMIT 1;"`
if [ -z "${resulat}" ]
then
    # Sinon on cherche la catégorie la plus proche de la chaîne indiquée
    resulat=`sqlite3 "${CHEMIN_BASE_COMPTABILITE}" "SELECT cat_id,cat_nom FROM Categories WHERE cat_nom LIKE \"${2}\" LIMIT 1;"`
fi

# Test si un id a été trouvé
if [ -z "${resulat}" ]
then
    echo "Catégorie inconnue, aucune insertion"
    exit 2
fi

# On sépare les informations de la requête, pour pouvoir afficher l'id trouvé et le nom complet de la catégorie
cat_id=`echo "${resulat}" | cut -d '|' -f 1`
cat_nom=`echo "${resulat}" | cut -d '|' -f 2`

echo "Catégorie trouvée : id ${cat_id} pour '${cat_nom}'"

# Requête d'insertion
sqlite3 -echo "${CHEMIN_BASE_COMPTABILITE}" "INSERT INTO OperationTypes (op_typ_libelle,cat_id) VALUES (\"${1}\", ${cat_id});"

exit 0
