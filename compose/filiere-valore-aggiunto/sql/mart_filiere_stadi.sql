-- Valore aggiunto per stadio: agricoltura (RICA) + trasformazione/retail (SBS).
-- Agricoltura: VA e costo lavoro medi per OTE × aziende rappresentate.
-- Trasformazione: NACE 10+11+12. Retail: NACE 47.
-- Nessun margine di prodotto: è un aggregato per stadio.

WITH rica AS (
    SELECT
        anno,
        comparto_codice,
        MAX(CASE WHEN indicatore_codice = 'VA' THEN valore END) AS va_eur_farm,
        MAX(CASE WHEN indicatore_codice = 'CL' THEN valore END) AS cl_eur_farm,
        MAX(CASE WHEN indicatore_codice = 'AZIENDE' THEN valore END) AS aziende
    FROM read_parquet('{support.rica.mart.mart_redditi_comparti}')
    WHERE stratificazione = 'ote'
    GROUP BY anno, comparto_codice
),

agricoltura AS (
    SELECT
        anno,
        'agricoltura' AS stadio,
        SUM(COALESCE(va_eur_farm, 0) * COALESCE(aziende, 0)) AS va_eur,
        SUM(COALESCE(cl_eur_farm, 0) * COALESCE(aziende, 0)) AS costo_lavoro_eur,
        NULL::DOUBLE AS ore,
        SUM(COALESCE(aziende, 0)) AS imprese,
        'RICA-CREA AREA' AS fonte,
        'modelled_universe' AS metodo,
        'Stima modellata dal campione RICA; medie aziendali per OTE.' AS note
    FROM rica
    GROUP BY anno
),

sbs AS (
    SELECT
        anno,
        CASE WHEN nace_codice = '47' THEN 'retail' ELSE 'trasformazione' END AS stadio,
        SUM(va_mila_eur) * 1000 AS va_eur,
        SUM(costo_lavoro_mila_eur) * 1000 AS costo_lavoro_eur,
        SUM(ore_migliaia) * 1000 AS ore,
        SUM(imprese) AS imprese,
        'ISTAT SBS' AS fonte,
        'survey' AS metodo,
        'SBS non copre agricoltura; imprese con dipendenti.' AS note
    FROM read_parquet('{support.sbs_filiere.path}')
    WHERE anno BETWEEN 2008 AND {year}
      AND nace_codice IN ('10', '11', '12', '47')
    GROUP BY anno, CASE WHEN nace_codice = '47' THEN 'retail' ELSE 'trasformazione' END
),

unione AS (
    SELECT * FROM agricoltura
    UNION ALL
    SELECT * FROM sbs
)

SELECT
    anno,
    stadio,
    ROUND(va_eur, 0) AS va_eur,
    ROUND(costo_lavoro_eur, 0) AS costo_lavoro_eur,
    ROUND(ore, 0) AS ore,
    ROUND(imprese, 0) AS imprese,
    ROUND(costo_lavoro_eur / NULLIF(va_eur, 0) * 100, 2) AS quota_lavoro_pct,
    ROUND(va_eur / NULLIF(ore, 0), 2) AS va_per_ora_eur,
    fonte,
    metodo,
    note
FROM unione
ORDER BY anno, stadio
