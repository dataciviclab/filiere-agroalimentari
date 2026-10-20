WITH serie AS (
    SELECT
        anno,
        mese,
        data,
        codice,
        categoria,
        indice,
        unita,
        base_anno,
        LAG(indice, 12) OVER (
            PARTITION BY codice
            ORDER BY anno, mese
        ) AS indice_12m,
        COUNT(*) OVER (PARTITION BY codice) AS n_mesi
    FROM clean_input
),

ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY codice
            ORDER BY anno DESC, mese DESC
        ) AS rn
    FROM serie
)

SELECT
    codice,
    categoria,
    anno AS ultimo_anno,
    mese AS ultimo_mese,
    data AS ultimo_periodo,
    indice AS ultimo_indice,
    unita,
    base_anno,
    ROUND(
        (indice / NULLIF(indice_12m, 0) - 1) * 100,
        2
    ) AS variazione_anno_prec_pct,
    n_mesi
FROM ranked
WHERE rn = 1
