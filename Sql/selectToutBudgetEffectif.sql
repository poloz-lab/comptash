SELECT
	strftime('%Y-%m',bu_mois, 'unixepoch') AS 'Mois',
	cat_nom AS 'Catégorie',
	bu_montant || ' €' AS 'Budget prévu',
	coalesce(sum(op_occ_montant),0) + coalesce(sum(rec_occ_montant),0) || ' €' AS 'Montant effectif',
	(coalesce(sum(op_occ_montant),0) + coalesce(sum(rec_occ_montant),0) - bu_montant) || ' €' AS 'Différence'
FROM Budgets
	JOIN Categories ON Budgets.cat_id = Categories.cat_id
	LEFT JOIN OperationTypes ON Categories.cat_id = OperationTypes.cat_id
	LEFT JOIN OperationOccurences ON bu_mois = strftime('%s',op_occ_date,'unixepoch','start of month') AND OperationTypes.op_typ_id = OperationOccurences.op_typ_id
	LEFT JOIN RecurrentTypes ON Categories.cat_id = RecurrentTypes.cat_id
    LEFT JOIN RecurrentOccurences ON bu_mois = rec_occ_mois AND RecurrentTypes.rec_typ_id = RecurrentOccurences.rec_typ_id
GROUP BY
	bu_mois,
	Budgets.cat_id
ORDER BY
	date(bu_mois,'unixepoch') DESC,
	cat_nom ASC
;