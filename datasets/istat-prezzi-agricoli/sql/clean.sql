-- ISTAT PREZZIAGR: due flussi SDMX (venduti/acquistati) fusi in schema long.
-- Le due fonti hanno colonne parzialmente diverse: il toolkit le unisce per nome,
-- quindi SOLD_PRODUCTS e PURCHASE_PRODUCTS arrivano con NULL dove non applicabili.

WITH unione AS (
    SELECT
        cast_int(substr(TIME_PERIOD, 1, 4)) AS anno,
        cast_int(substr(TIME_PERIOD, 6, 2)) AS mese,
        CASE
            WHEN normalize_string(SOLD_PRODUCTS) = 'ALL' THEN 'acquistato'
            ELSE 'venduto'
        END AS tipo,
        CASE
            WHEN normalize_string(SOLD_PRODUCTS) = 'ALL'
                THEN normalize_string(PURCHASE_PRODUCTS)
            ELSE normalize_string(SOLD_PRODUCTS)
        END AS categoria_codice,
        CASE
            WHEN normalize_string(SOLD_PRODUCTS) = 'ALL'
                THEN normalize_string(PURCHASE_PRODUCTS_label)
            ELSE normalize_string(SOLD_PRODUCTS_label)
        END AS categoria_label_raw,
        cast_double(value) AS indice
    FROM raw_input
    WHERE normalize_string(TIME_PERIOD) IS NOT NULL
)

SELECT
    anno,
    mese,
    make_date(anno, mese, 1) AS data,
    tipo,
    categoria_codice,
    CASE categoria_codice
        WHEN 'TOTAGRICOUT' THEN 'Produzione agricola totale'
        WHEN 'TOTAGRICOUT_NOFV' THEN 'Produzione agricola totale (escl. frutta e verdura)'
        WHEN 'CROPUT' THEN 'Produzione vegetale'
        WHEN 'CROPUTE' THEN 'Produzione vegetale (escl. frutta e verdura)'
        WHEN 'ANIMATPUT' THEN 'Produzione animale'
        WHEN 'CEREA' THEN 'Cereali'
        WHEN 'FRUIT' THEN 'Frutta'
        WHEN 'FRESHETABL' THEN 'Ortaggi freschi'
        WHEN 'VEGETSAND' THEN 'Ortaggi e prodotti ortofloricoli'
        WHEN 'OLIVE' THEN 'Olive'
        WHEN 'WINE' THEN 'Vino'
        WHEN 'POTAT' THEN 'Patate'
        WHEN 'PLANTDFLO' THEN 'Piante e fiori'
        WHEN 'INDUSLCRO' THEN 'Colture industriali'
        WHEN 'FORAGANTS' THEN 'Foraggi'
        WHEN 'ANIMA' THEN 'Animali'
        WHEN 'ANIMAODUCT' THEN 'Prodotti animali'
        WHEN 'CATTL' THEN 'Bovini'
        WHEN 'PIGS' THEN 'Suini'
        WHEN 'POULT' THEN 'Avicoli'
        WHEN 'SHEEPGOAT' THEN 'Ovini e caprini'
        WHEN 'WHEATSPEL' THEN 'Frumento e spelta'
        WHEN 'INPUTAL' THEN 'Input totale'
        WHEN 'GOODSSERV' THEN 'Beni e servizi correnti'
        WHEN 'FERTIRSS' THEN 'Fertilizzanti e ammendanti'
        WHEN 'ENERGDLUB' THEN 'Energia e lubrificanti'
        WHEN 'FUELSHEAT' THEN 'Combustibili per riscaldamento'
        WHEN 'LUBRIS' THEN 'Lubrificanti'
        WHEN 'ANIMAEDING' THEN 'Mangimi'
        WHEN 'COMPOFEEDI' THEN 'Mangimi composti'
        WHEN 'COMPOFERTI' THEN 'Fertilizzanti composti'
        WHEN 'FUNGIS' THEN 'Fungicidi'
        WHEN 'HERBIS' THEN 'Erbicidi'
        WHEN 'INSECDES' THEN 'Insetticidi'
        WHEN 'MACHIAND' THEN 'Macchine e attrezzature'
        WHEN 'BUILD' THEN 'Costruzioni'
        WHEN 'FARMDINGS' THEN 'Fabbricati agricoli'
        WHEN 'MAINTOFBUILD' THEN 'Manutenzione fabbricati'
        WHEN 'INVEST' THEN 'Investimenti'
        ELSE categoria_label_raw
    END AS categoria,
    categoria_label_raw,
    indice
FROM unione
WHERE
    anno BETWEEN 2020 AND 2026
    AND mese BETWEEN 1 AND 12
    AND indice IS NOT NULL
