-- Retail alimentare: aggregato annuo del perimetro food retail core.
-- Il perimetro esclude online, tabacco e commercio non-food; 4711 e'
-- predominantly food e puo' includere assortimenti non-food.
-- 2022 ha 7/8 NACE per riservatezza Eurostat su 4781.

SELECT
    anno,
    ROUND(SUM(va_eur), 0) AS va_eur,
    ROUND(SUM(costo_lavoro_eur), 0) AS costo_lavoro_eur,
    ROUND(SUM(ore), 0) AS ore,
    ROUND(SUM(imprese), 0) AS imprese,
    ROUND(SUM(costo_lavoro_eur) / NULLIF(SUM(va_eur), 0) * 100, 2) AS quota_lavoro_pct,
    ROUND(SUM(va_eur) / NULLIF(SUM(ore), 0), 2) AS va_per_ora_eur,
    COUNT(DISTINCT nace_codice) AS nace_coperti,
    COUNT(DISTINCT nace_codice) = 8 AS perimetro_completo,
    MAX(fonte) AS fonte,
    MAX(fonte_dataset) AS fonte_dataset,
    MAX(definizione_costo_lavoro) AS definizione_costo_lavoro,
    'Retail alimentare core: NACE 4711 + 4721-4725 + 4729 + 4781; esclusi tabacco, commercio non-food e online. 4711 puo'' includere assortimenti non-food.' AS nota
FROM clean_input
GROUP BY anno
ORDER BY anno
