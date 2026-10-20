WITH per_prodotto AS (
    SELECT
        gruppo,
        prodotto_codice,
        prodotto,
        unita,
        MIN(anno) AS primo_anno,
        MAX(anno) AS ultimo_anno,
        COUNT(*) AS n_anni,
        COUNT(valore) AS n_valori
    FROM clean_input
    GROUP BY gruppo, prodotto_codice, prodotto, unita
)

SELECT
    gruppo,
    prodotto_codice,
    prodotto,
    unita,
    primo_anno,
    ultimo_anno,
    n_anni,
    n_valori,
    (ultimo_anno - primo_anno + 1) AS n_anni_attesi,
    (ultimo_anno - primo_anno + 1) - n_anni AS n_mancanti,
    ROUND(n_anni * 100.0 / NULLIF(ultimo_anno - primo_anno + 1, 0), 1) AS copertura_pct
FROM per_prodotto
