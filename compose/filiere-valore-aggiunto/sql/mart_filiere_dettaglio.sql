-- Dettaglio per stadio: OTE RICA (agricoltura), NACE SBS (trasformazione)
-- e NACE Eurostat SBS (retail alimentare).
-- Unità: euro, ore, imprese; quota lavoro in percentuale.

WITH rica AS (
    SELECT
        anno,
        comparto_codice,
        comparto,
        MAX(CASE WHEN indicatore_codice = 'VA' THEN valore END) AS va_eur_farm,
        MAX(CASE WHEN indicatore_codice = 'CL' THEN valore END) AS cl_eur_farm,
        MAX(CASE WHEN indicatore_codice = 'AZIENDE' THEN valore END) AS aziende
    FROM read_parquet('{support.rica.mart.mart_redditi_comparti}')
    WHERE stratificazione = 'ote'
    GROUP BY anno, comparto_codice, comparto
),

agricoltura AS (
    SELECT
        anno,
        'agricoltura' AS stadio,
        'OTE' AS classificazione,
        comparto_codice AS codice,
        comparto AS nome,
        COALESCE(va_eur_farm, 0) * COALESCE(aziende, 0) AS va_eur,
        COALESCE(cl_eur_farm, 0) * COALESCE(aziende, 0) AS costo_lavoro_eur,
        NULL::DOUBLE AS ore,
        COALESCE(aziende, 0) AS imprese,
        CASE
            WHEN COALESCE(va_eur_farm, 0) > 0
                THEN cl_eur_farm / va_eur_farm * 100
        END AS quota_lavoro_pct,
        NULL::DOUBLE AS va_per_ora_eur,
        'RICA-CREA AREA' AS fonte,
        'modelled_universe' AS metodo,
        'Stima modellata; media aziendale per OTE.' AS note
    FROM rica
),

sbs AS (
    SELECT
        anno,
        'trasformazione' AS stadio,
        'NACE' AS classificazione,
        nace_codice AS codice,
        nace AS nome,
        va_mila_eur * 1000 AS va_eur,
        costo_lavoro_mila_eur * 1000 AS costo_lavoro_eur,
        ore_migliaia * 1000 AS ore,
        imprese,
        CASE
            WHEN va_mila_eur > 0 THEN costo_lavoro_mila_eur / va_mila_eur * 100
        END AS quota_lavoro_pct,
        CASE
            WHEN ore_migliaia > 0 THEN va_mila_eur / ore_migliaia
        END AS va_per_ora_eur,
        'ISTAT SBS' AS fonte,
        'survey' AS metodo,
        'SBS; imprese con dipendenti.' AS note
    FROM read_parquet('{support.sbs_filiere.path}')
    WHERE anno BETWEEN 2008 AND {year}
      AND nace_codice IN ('10', '11', '12')
),

retail AS (
    SELECT
        anno,
        'retail_alimentare' AS stadio,
        'NACE' AS classificazione,
        nace_codice AS codice,
        nace AS nome,
        va_eur,
        costo_lavoro_eur,
        ore,
        imprese,
        quota_lavoro_pct,
        va_per_ora_eur,
        fonte,
        'survey' AS metodo,
        nota AS note
    FROM read_parquet('{support.food_retail.mart.mart_retail_alimentare_dettaglio}')
    WHERE anno BETWEEN 2008 AND {year}
)

SELECT
    anno,
    stadio,
    classificazione,
    codice,
    nome,
    ROUND(va_eur, 0) AS va_eur,
    ROUND(costo_lavoro_eur, 0) AS costo_lavoro_eur,
    ROUND(ore, 0) AS ore,
    ROUND(imprese, 0) AS imprese,
    ROUND(quota_lavoro_pct, 2) AS quota_lavoro_pct,
    ROUND(va_per_ora_eur, 2) AS va_per_ora_eur,
    fonte,
    metodo,
    note
FROM (
    SELECT * FROM agricoltura
    UNION ALL
    SELECT * FROM sbs
    UNION ALL
    SELECT * FROM retail
)
ORDER BY anno, stadio, classificazione, codice
