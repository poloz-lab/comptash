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
    echo -e "Usage:\n${0} type_opération"
    exit 1
fi

# Requête
sqlite3 -header "${CHEMIN_BASE_COMPTABILITE}" "SELECT rec_typ_id,rec_typ_libelle FROM RecurrentTypes WHERE op_typ_libelle LIKE '%${1}%' ORDER BY op_typ_libelle ASC;"

exit 0
