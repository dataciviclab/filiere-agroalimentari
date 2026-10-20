-- ISTAT NIC — due basi in un unico schema long, con base_anno esplicita.
-- Base 2015: 2016-01 → 2025-12. Base 2025: 2026-01 → oggi.
-- Le due basi non sono confrontabili in livello e le categorie 2025 sono più aggregate.

WITH base AS (
    SELECT
        CASE
            WHEN normalize_string(dataset) = '167_744_DF_DCSP_NIC1B2015_4' THEN 2015
            ELSE 2025
        END AS base_anno,
        cast_int(substr(normalize_string(TIME_PERIOD), 1, 4)) AS anno,
        cast_int(substr(normalize_string(TIME_PERIOD), 6, 2)) AS mese,
        CASE
            WHEN normalize_string(E_COICOP_REV_ISTAT) IS NOT NULL
                THEN lpad(cast(cast_int(E_COICOP_REV_ISTAT) AS VARCHAR), 4, '0')
            ELSE lpad(cast(cast_int(ECOICOP_2) AS VARCHAR), 4, '0')
        END AS codice,
        normalize_string(dataset) AS dataset,
        normalize_string(series_code) AS series_code,
        cast_double(OBS_VALUE) AS indice
    FROM raw_input
    WHERE normalize_string(TIME_PERIOD) IS NOT NULL
)

SELECT
    base_anno,
    anno,
    mese,
    make_date(anno, mese, 1) AS data,
    codice,
    CASE
        WHEN codice = '0111' THEN 'Cereali e prodotti a base di cereali'
        WHEN codice = '0112' THEN 'Carne'
        WHEN codice = '0114' THEN 'Latte, formaggi e uova'
        WHEN codice = '0115' THEN 'Oli e grassi'
        WHEN codice = '0116' AND base_anno = 2015 THEN 'Frutta'
        WHEN codice = '0116' AND base_anno = 2025 THEN 'Frutta e frutta a guscio'
        WHEN codice = '0117' AND base_anno = 2015 THEN 'Ortaggi'
        WHEN codice = '0117' AND base_anno = 2025
            THEN 'Ortaggi, tuberi, banane plantain, banane da cucina e legumi'
        ELSE codice
    END AS categoria,
    indice,
    CASE base_anno
        WHEN 2015 THEN 'indice_2015_100'
        ELSE 'indice_2025_100'
    END AS unita,
    'istat_dbnomics:' || dataset || ':' || series_code AS serie_id,
    'istat_dbnomics' AS fonte_id,
    'index' AS metodo_calcolo,
    'mirror' AS qualita,
    CASE base_anno
        WHEN 2015 THEN 'Italia, 2016-2025, mensile'
        ELSE 'Italia, 2026-, mensile'
    END AS copertura,
    'Indice NIC; basi 2015 e 2025 non confrontabili in livello. Categorie 2025 più aggregate.'
        AS limitazioni,
    'ISTAT NIC via DBnomics' AS fonte
FROM base
WHERE
    anno BETWEEN 2016 AND 2026
    AND mese BETWEEN 1 AND 12
    AND indice IS NOT NULL
    AND codice IN ('0111', '0112', '0114', '0115', '0116', '0117')
