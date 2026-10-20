WITH selezionati AS (
    SELECT
        anno,
        prodotto_codice,
        unita,
        valore,
        flag,
        CASE prodotto_codice
            WHEN '01110000' THEN 'Grano tenero'
            WHEN '01120000' THEN 'Grano duro'
            WHEN '04121000' THEN 'Pomodori (pieno campo)'
            WHEN '04122000' THEN 'Pomodori (serra)'
            WHEN '05120000' THEN 'Patate (coltura principale)'
            WHEN '06110000' THEN 'Mele'
            WHEN '06120000' THEN 'Pere'
            WHEN '06130000' THEN 'Pesche'
            WHEN '06210000' THEN 'Arance'
            WHEN '06230000' THEN 'Limoni'
            WHEN '06510000' THEN 'Olive da tavola'
            WHEN '06590000' THEN 'Olive da olio'
            WHEN '08100000' THEN 'Olio extravergine di oliva'
            WHEN '12111000' THEN 'Latte bovino (3,7% grassi)'
            WHEN '12112000' THEN 'Latte bovino (grassi effettivi)'
            WHEN '12200000' THEN 'Uova fresche'
            WHEN '06490000' THEN 'Uva da vino'
            WHEN '07110000' THEN 'Vino da tavola'
            WHEN '07200000' THEN 'Vino di qualità'
        END AS prodotto,
        CASE prodotto_codice
            WHEN '01110000' THEN 'cereali'
            WHEN '01120000' THEN 'cereali'
            WHEN '04121000' THEN 'ortofrutta'
            WHEN '04122000' THEN 'ortofrutta'
            WHEN '05120000' THEN 'ortofrutta'
            WHEN '06110000' THEN 'ortofrutta'
            WHEN '06120000' THEN 'ortofrutta'
            WHEN '06130000' THEN 'ortofrutta'
            WHEN '06210000' THEN 'ortofrutta'
            WHEN '06230000' THEN 'ortofrutta'
            WHEN '06510000' THEN 'olio'
            WHEN '06590000' THEN 'olio'
            WHEN '08100000' THEN 'olio'
            WHEN '12111000' THEN 'latte'
            WHEN '12112000' THEN 'latte'
            WHEN '12200000' THEN 'uova'
            WHEN '06490000' THEN 'vino'
            WHEN '07110000' THEN 'vino'
            WHEN '07200000' THEN 'vino'
        END AS filiera
    FROM clean_input
    WHERE prodotto_codice IN (
        '01110000', '01120000',
        '04121000', '04122000', '05120000',
        '06110000', '06120000', '06130000',
        '06210000', '06230000',
        '06510000', '06590000', '08100000',
        '12111000', '12112000', '12200000',
        '06490000', '07110000', '07200000'
    )
)

SELECT
    anno,
    filiera,
    prodotto_codice,
    prodotto,
    unita,
    CASE
        WHEN unita LIKE '%kg%' THEN '€/kg'
        WHEN unita LIKE '%litre%' THEN '€/litro'
        WHEN unita LIKE '%item%' THEN '€/pezzo'
        ELSE NULL
    END AS unita_base,
    ROUND(valore / 100.0, 4) AS valore_eur_per_unita,
    valore AS valore_originale,
    flag
FROM selezionati
ORDER BY filiera, prodotto, anno
