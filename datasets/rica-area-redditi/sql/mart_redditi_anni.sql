SELECT
    tipo_dati,
    anno,
    indicatore_codice,
    indicatore,
    unita,
    ROUND(valore, 2) AS valore,
    ROUND(
        (valore / NULLIF(LAG(valore, 1) OVER (
            PARTITION BY tipo_dati, indicatore_codice
            ORDER BY anno
        ), 0) - 1) * 100,
        2
    ) AS variazione_anno_prec_pct,
    metodo_calcolo,
    qualita
FROM clean_input
WHERE stratificazione = 'anno'
