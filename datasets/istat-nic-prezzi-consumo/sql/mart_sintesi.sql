WITH serie AS (
    SELECT
        base_anno,
        anno,
        mese,
        data,
        codice,
        categoria,
        indice,
        unita,
        LAG(indice, 12) OVER (
            PARTITION BY base_anno, codice
            ORDER BY anno, mese
        ) AS indice_12m,
        COUNT(*) OVER (PARTITION BY base_anno, codice) AS n_mesi
    FROM clean_input
),

ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY base_anno, codice
            ORDER BY anno DESC, mese DESC
        ) AS rn
    FROM serie
)

SELECT
    base_anno,
    codice,
    categoria,
    anno AS ultimo_anno,
    mese AS ultimo_mese,
    data AS ultimo_periodo,
    indice AS ultimo_indice,
    unita,
    ROUND(
        (indice / NULLIF(indice_12m, 0) - 1) * 100,
        2
    ) AS variazione_anno_prec_pct,
    n_mesi
FROM ranked
WHERE rn = 1
