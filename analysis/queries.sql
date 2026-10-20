-- Prime query di analisi — filiera agroalimentare.
-- Non sono pipeline: leggono i mart prodotti dal toolkit.
-- Adattare i path read_parquet(...) all'output locale o GCS.

-- 1. Reddito e aiuti per OTE, 2024
SELECT
    comparto,
    rn_eur,
    aiuti_tot_eur,
    incidenza_aiuti_rn_pct
FROM read_parquet('out/data/mart/rica_area_redditi/2024/mart_aiuti.parquet')
WHERE stratificazione = 'ote'
ORDER BY incidenza_aiuti_rn_pct DESC;

-- 2. Serie del reddito netto, 2008-2024 (universo)
SELECT
    anno,
    valore
FROM read_parquet('out/data/mart/rica_area_redditi/2024/mart_redditi_anni.parquet')
WHERE indicatore_codice = 'RN'
  AND tipo_dati = 'universo'
ORDER BY anno;

-- 3. Piccole vs grandi, 2024
SELECT
    comparto,
    rn_eur,
    aiuti_tot_eur,
    incidenza_aiuti_rn_pct
FROM read_parquet('out/data/mart/rica_area_redditi/2024/mart_aiuti.parquet')
WHERE stratificazione = 'ude'
ORDER BY rn_eur;

-- 4. Trend NIC per categoria (basi separate)
SELECT
    base_anno,
    anno,
    mese,
    categoria,
    indice,
    variazione_anno_prec_pct
FROM read_parquet('out/data/mart/istat_nic_prezzi_consumo/2026/mart_prezzi_consumo.parquet')
WHERE codice IN ('0111', '0116')
ORDER BY base_anno, anno, mese;

-- 5. Trend HICP per categoria (benchmark separato)
SELECT
    anno,
    mese,
    categoria,
    indice,
    variazione_anno_prec_pct
FROM read_parquet('out/data/mart/eurostat_hicp_prezzi_consumo/2025/mart_hicp_prezzi.parquet')
WHERE codice IN ('CP0111', 'CP0116')
ORDER BY anno, mese;

-- 6. Prezzi assoluti alla produzione, 2024
SELECT
    filiera,
    prodotto,
    unita_base,
    valore_eur_per_unita
FROM read_parquet('out/data/mart/eurostat_prezzi_agricoli/2024/mart_prezzi_prodotti.parquet')
WHERE anno = 2024
ORDER BY filiera, prodotto;
