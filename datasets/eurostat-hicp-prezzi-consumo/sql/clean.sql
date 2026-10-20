-- Eurostat HICP — indice mensile armonizzato, Italia, categorie alimentari COICOP.
-- Serie separata da NIC e dai prezzi alla produzione: benchmark, non sostituto.

SELECT
    cast_int(year) AS anno,
    cast_int(month) AS mese,
    make_date(cast_int(year), cast_int(month), 1) AS data,
    normalize_string(coicop) AS codice,
    CASE normalize_string(coicop)
        WHEN 'CP0111' THEN 'Cereali e prodotti a base di cereali'
        WHEN 'CP0112' THEN 'Carne'
        WHEN 'CP0114' THEN 'Latte, formaggi e uova'
        WHEN 'CP0115' THEN 'Oli e grassi'
        WHEN 'CP0116' THEN 'Frutta'
        WHEN 'CP0117' THEN 'Ortaggi'
        ELSE normalize_string(coicop)
    END AS categoria,
    cast_double(value) AS indice,
    'indice_2015_100' AS unita,
    2015 AS base_anno,
    'eurostat:prc_hicp_midx:IT:' || normalize_string(coicop) || ':I15' AS serie_id,
    'eurostat' AS fonte_id,
    'index' AS metodo_calcolo,
    'harmonized' AS qualita,
    'Italia, 2016-' || cast({year} AS VARCHAR) || ', mensile' AS copertura,
    'Indice HICP armonizzato; non confrontabile in livello con NIC o prezzi alla produzione.'
        AS limitazioni,
    'Eurostat HICP' AS fonte
FROM raw_input
WHERE
    cast_int(year) BETWEEN 2016 AND {year}
    AND cast_int(month) BETWEEN 1 AND 12
    AND normalize_string(coicop) IN ('CP0111', 'CP0112', 'CP0114', 'CP0115', 'CP0116', 'CP0117')
    AND cast_double(value) IS NOT NULL
