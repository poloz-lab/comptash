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
    echo -e "Usage:\n${0} catégorie"
    exit 1
fi

# Requête d'insertion
sqlite3 -echo "${CHEMIN_BASE_COMPTABILITE}" "INSERT INTO Categories (cat_nom) VALUES (\"${1}\");"

exit 0
