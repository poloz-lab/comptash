#!/bin/bash

set -e

if [ -z "${CHEMIN_BASE_COMPTABILITE}" ]
then
	echo "Erreur : préciser la variable d'environnement 'CHEMIN_BASE_COMPTABILITE'" >&2
	exit 1
fi

sqlite3 -header -column "${CHEMIN_BASE_COMPTABILITE}" < Sql/selectToutBudgetEffectif.sql
