WITH base AS (
    SELECT
        anno,
        mese,
        data,
        MAX(CASE WHEN categoria_codice = 'TOTAGRICOUT' THEN indice END) AS indice_output,
        MAX(CASE WHEN categoria_codice = 'INPUTAL' THEN indice END) AS indice_input
    FROM clean_input
    WHERE categoria_codice IN ('TOTAGRICOUT', 'INPUTAL')
    GROUP BY anno, mese, data
),

serie AS (
    SELECT
        anno,
        mese,
        data,
        indice_output,
        indice_input,
        ROUND(indice_output / NULLIF(indice_input, 0) * 100, 2) AS ragione_scambio
    FROM base
)

SELECT
    anno,
    mese,
    data,
    indice_output,
    indice_input,
    ragione_scambio,
    ROUND(
        (ragione_scambio / NULLIF(LAG(ragione_scambio, 12) OVER (
            ORDER BY anno, mese
        ), 0) - 1) * 100,
        2
    ) AS ragione_scambio_var_anno_pct
FROM serie
