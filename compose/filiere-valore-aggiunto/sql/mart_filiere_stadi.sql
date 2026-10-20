-- Valore aggiunto per stadio: agricoltura (RICA), trasformazione (SBS 10/11/12)
-- e retail alimentare (Eurostat SBS 4711 + 4721-4725 + 4729 + 4781).
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
        'rica_costo_lavoro' AS definizione_costo_lavoro,
        'Stima modellata dal campione RICA; medie aziendali per OTE.' AS note
    FROM rica
    GROUP BY anno
),

sbs AS (
    SELECT
        anno,
        'trasformazione' AS stadio,
        SUM(va_mila_eur) * 1000 AS va_eur,
        SUM(costo_lavoro_mila_eur) * 1000 AS costo_lavoro_eur,
        SUM(ore_migliaia) * 1000 AS ore,
        SUM(imprese) AS imprese,
        'ISTAT SBS' AS fonte,
        'survey' AS metodo,
        'istat_sbs_personnel_costs' AS definizione_costo_lavoro,
        'SBS; imprese con dipendenti; NACE 10/11/12.' AS note
    FROM read_parquet('{support.sbs_filiere.path}')
    WHERE anno BETWEEN 2008 AND {year}
      AND nace_codice IN ('10', '11', '12')
    GROUP BY anno
),

retail AS (
    SELECT
        anno,
        'retail_alimentare' AS stadio,
        va_eur,
        costo_lavoro_eur,
        ore,
        imprese,
        fonte,
        'survey' AS metodo,
        definizione_costo_lavoro,
        nota AS note
    FROM read_parquet('{support.food_retail.mart.mart_retail_alimentare}')
    WHERE anno BETWEEN 2008 AND {year}
),

unione AS (
    SELECT * FROM agricoltura
    UNION ALL
    SELECT * FROM sbs
    UNION ALL
    SELECT * FROM retail
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
    definizione_costo_lavoro,
    note
FROM unione
ORDER BY anno, stadio
