SELECT
    op_occ_id AS 'ID',
    op_typ_libelle AS 'Libellé',
    op_occ_montant AS 'Montant',
    date(op_occ_date,'unixepoch') AS 'Date',
    op_occ_part AS 'Part',
    op_occ_montant / op_occ_part AS 'Montant initial',
    op_occ_montant - (op_occ_montant / op_occ_part) AS 'Différence',
    op_occ_commentaire AS 'Commentaire'
FROM OperationOccurences
    NATURAL JOIN OperationTypes
WHERE
    op_occ_part != 1
ORDER BY
	op_occ_date DESC, 
	op_typ_libelle ASC
;