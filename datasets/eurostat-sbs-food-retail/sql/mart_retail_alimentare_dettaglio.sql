-- Dettaglio del retail alimentare per NACE.
-- 4711 = supermercati/discount/minimercati; 472x = specializzati; 4781 = mercati.

SELECT
    anno,
    nace_codice,
    nace,
    segmento,
    va_eur,
    costo_lavoro_eur,
    ore,
    imprese,
    quota_lavoro_pct,
    va_per_ora_eur,
    fonte,
    fonte_dataset,
    definizione_costo_lavoro,
    nota
FROM clean_input
ORDER BY anno, va_eur DESC
