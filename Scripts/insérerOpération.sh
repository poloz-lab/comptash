#!/bin/bash

set -e

if [ -z "${CHEMIN_BASE_COMPTABILITE}" ]
then
	echo "Erreur : préciser la variable d'environnement 'CHEMIN_BASE_COMPTABILITE'" >&2
	exit 1
fi

# Test si pas assez d'arguments
if [ ${#} -lt 2 ]
then
    echo -e "Usage:\n${0} type_opération montant optionnel_date optionel_part optionnel_commentaire\nSi la date n'est pas renseignée, c'est la date du jour qui est insérée\nSi on veut insérer un argument optionnel, il faut rentrer tous ceux avant"
    exit 1
fi

# Si la date n'est pas fournie, on calcule la date du jour
if [ ${#} -lt 3 ]
then
    op_occ_date="strftime('%s','now','start of day')"
else
    op_occ_date="strftime('%s','${3}','start of day')"
fi

# On teste si on trouve exactement la chaîne indiquée pour le type
resulat=`sqlite3 "${CHEMIN_BASE_COMPTABILITE}" "SELECT op_typ_id,op_typ_libelle FROM OperationTypes WHERE op_typ_libelle = \"${1}\" LIMIT 1;"`
if [ -z "${resulat}" ]
then
    # Sinon on cherche le type d'opération le plus proche de la chaîne indiquée
    resulat=`sqlite3 "${CHEMIN_BASE_COMPTABILITE}" "SELECT op_typ_id,op_typ_libelle FROM OperationTypes WHERE op_typ_libelle LIKE \"%${1}%\" LIMIT 1;"`
fi

# Test si un id a été trouvé
if [ -z "${resulat}" ]
then
    echo "Opération inconnue, aucune insertion"
    exit 2
fi

# On sépare les informations de la requête, pour pouvoir afficher l'id trouvé et le nom complet du type
op_typ_id=`echo "${resulat}" | cut -d '|' -f 1`
op_typ_libelle=`echo "${resulat}" | cut -d '|' -f 2`

echo "Type d'opération trouvé : id ${op_typ_id} pour '${op_typ_libelle}'"

# Requête d'insertion en fonction des arguments passés
case ${#} in
# Si rien d'optionnel (la date sera forcément insérée)
2 | 3) sqlite3 -echo "${CHEMIN_BASE_COMPTABILITE}" "INSERT INTO OperationOccurences (op_typ_id,op_occ_montant,op_occ_date) VALUES (${op_typ_id},${2},${op_occ_date});";;
# Si il y a la part on l'insère
4) sqlite3 -echo "${CHEMIN_BASE_COMPTABILITE}" "INSERT INTO OperationOccurences (op_typ_id,op_occ_montant,op_occ_date,op_occ_part) VALUES (${op_typ_id},${2} * ${4},${op_occ_date},${4});";;
# Si il y a un commentaire, on l'insère, les arguments suivants ne sont pas pris en compte
*) sqlite3 -echo "${CHEMIN_BASE_COMPTABILITE}" "INSERT INTO OperationOccurences (op_typ_id,op_occ_montant,op_occ_date,op_occ_part,op_occ_commentaire) VALUES (${op_typ_id},${2} * ${4},${op_occ_date},${4},\"${5}\");";;
esac

exit 0
