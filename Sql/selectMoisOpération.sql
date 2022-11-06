SELECT
    op_occ_id AS 'ID',
    op_typ_libelle AS 'Libellé',
    op_occ_montant AS 'Montant',
    date(op_occ_date,'unixepoch') AS 'Date',
    op_occ_part AS 'Part',
    op_occ_commentaire AS 'Commentaire'
FROM OperationOccurences
    NATURAL JOIN OperationTypes
WHERE
	strftime('%s',op_occ_date,'unixepoch','start of month') = strftime('%s','now','start of month')
ORDER BY
    op_occ_date DESC,
    op_typ_libelle ASC
;