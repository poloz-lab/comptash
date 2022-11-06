SELECT
    rec_occ_id AS 'ID',
    rec_typ_libelle AS 'Libellé',
    rec_occ_montant AS 'Montant',
    strftime('%Y-%m',rec_occ_mois, 'unixepoch') AS 'Mois'
FROM RecurrentOccurences
    NATURAL JOIN RecurrentTypes
WHERE
	rec_occ_mois = strftime('%s','now','start of month')
ORDER BY
    rec_typ_libelle ASC
;