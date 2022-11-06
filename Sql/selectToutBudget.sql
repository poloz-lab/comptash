SELECT
	bu_id AS 'ID',
	cat_nom AS 'Catégorie',
	bu_montant AS 'Montant',
	strftime('%Y-%m',bu_mois, 'unixepoch') AS 'Mois'
FROM Budgets 
	NATURAL JOIN Categories
ORDER BY
	bu_mois DESC,
	cat_nom ASC
;