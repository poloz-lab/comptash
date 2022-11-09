#!/bin/bash

set -e

if [ -z "${CHEMIN_BASE_COMPTABILITE}" ]
then
	echo "Erreur : préciser la variable d'environnement 'CHEMIN_BASE_COMPTABILITE'" >&2
	exit 1
fi

# Test si pas assez d'arguments
if [ ${#} -lt 1 ]
then
    echo -e "Usage:\n${0} catégorie"
    exit 1
fi

# Requête
sqlite3 -header "${CHEMIN_BASE_COMPTABILITE}" "SELECT cat_id,cat_nom FROM Categories WHERE cat_nom LIKE '%${1}%' ORDER BY cat_nom ASC;"

exit 0
