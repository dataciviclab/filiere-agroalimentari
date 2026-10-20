-- Eurostat PREZZI: due flussi (colture/animali) fusi in schema long.
-- Le label Eurostat contengono l'unità nel nome prodotto ("... - prices per 100 kg"):
-- la separiamo in prodotto + unità, così il mart può normalizzare a €/kg, €/litro, €/pezzo.

WITH base AS (
    SELECT
        cast_int(year) AS anno,
        CASE
            WHEN normalize_string(prod_veg) IS NOT NULL THEN 'colture'
            ELSE 'animali'
        END AS gruppo,
        COALESCE(
            normalize_string(prod_veg),
            normalize_string(prod_ani)
        ) AS prodotto_codice,
        COALESCE(v.label_en, a.label_en) AS prodotto_label_raw,
        cast_double(value) AS valore,
        normalize_string(flag) AS flag
    FROM raw_input
    LEFT JOIN read_parquet('{support.prod_veg.path}') v
        ON normalize_string(prod_veg) = v.code
    LEFT JOIN read_parquet('{support.prod_ani.path}') a
        ON normalize_string(prod_ani) = a.code
    WHERE normalize_string(year) IS NOT NULL
)

SELECT
    b.anno,
    b.gruppo,
    b.prodotto_codice,
    CASE
        WHEN b.prodotto_label_raw LIKE '% - prices per %'
            THEN regexp_extract(b.prodotto_label_raw, '^(.*) - prices per ', 1)
        ELSE b.prodotto_label_raw
    END AS prodotto,
    CASE
        WHEN b.prodotto_label_raw LIKE '% - prices per %'
            THEN regexp_extract(b.prodotto_label_raw, ' - prices per (.*)$', 1)
        ELSE NULL
    END AS unita,
    b.valore,
    b.flag
FROM base b
WHERE
    b.anno BETWEEN 2000 AND 2024
    AND b.valore IS NOT NULL
