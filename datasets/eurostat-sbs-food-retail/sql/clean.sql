-- Eurostat SBS — perimetro retail alimentare.
-- Fonti: sbs_na_dt_r2 (2008-2020) + sbs_ovw_act (2021-2024).
-- NACE: 4711 + 4721 + 4722 + 4723 + 4724 + 4725 + 4729 + 4781.
-- Esclusi: tabacco 4726, non-food 4719, online 479.

WITH base AS (
    SELECT
        cast_int(anno) AS anno,
        normalize_string(nace_codice) AS nace_codice,
        normalize_string(nace) AS nace,
        cast_double(va_eur) AS va_eur,
        cast_double(costo_lavoro_eur) AS costo_lavoro_eur,
        cast_double(ore) AS ore,
        cast_double(imprese) AS imprese,
        normalize_string(fonte_dataset) AS fonte_dataset,
        normalize_string(definizione_costo_lavoro) AS definizione_costo_lavoro
    FROM raw_input
)

SELECT
    anno,
    nace_codice,
    nace,
    CASE
        WHEN nace_codice = '4711' THEN 'supermercati'
        WHEN nace_codice = '4781' THEN 'mercati'
        ELSE 'specializzati'
    END AS segmento,
    va_eur,
    costo_lavoro_eur,
    ore,
    imprese,
    ROUND(costo_lavoro_eur / NULLIF(va_eur, 0) * 100, 2) AS quota_lavoro_pct,
    ROUND(va_eur / NULLIF(ore, 0), 2) AS va_per_ora_eur,
    'Eurostat SBS' AS fonte,
    fonte_dataset,
    definizione_costo_lavoro,
    CASE
        WHEN fonte_dataset = 'sbs_na_dt_r2'
            THEN 'VA at factor cost; personnel costs; ore non disponibili.'
        ELSE 'Value added; employee benefits expense.'
    END AS nota
FROM base
WHERE
    anno BETWEEN 2008 AND {year}
    AND nace_codice IN ('4711', '4721', '4722', '4723', '4724', '4725', '4729', '4781')
