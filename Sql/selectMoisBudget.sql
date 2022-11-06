SELECT
	bu_id AS 'ID',
	cat_nom AS 'Catégorie',
	bu_montant AS 'Montant',
	strftime('%Y-%m',bu_mois, 'unixepoch') AS 'Mois'
FROM Budgets 
	NATURAL JOIN Categories
WHERE
	bu_mois = strftime('%s','now','start of month')
ORDER BY
	cat_nom ASC
;