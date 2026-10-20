SELECT
    anno,
    mese,
    data,
    tipo,
    categoria_codice,
    categoria,
    indice,
    ROUND(
        (indice / NULLIF(LAG(indice, 12) OVER (
            PARTITION BY tipo, categoria_codice
            ORDER BY anno, mese
        ), 0) - 1) * 100,
        2
    ) AS variazione_anno_prec_pct,
    ROUND(
        (indice / NULLIF(LAG(indice, 1) OVER (
            PARTITION BY tipo, categoria_codice
            ORDER BY anno, mese
        ), 0) - 1) * 100,
        2
    ) AS variazione_mese_prec_pct
FROM clean_input
