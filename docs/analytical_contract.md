# Contratto analitico — filiera agroalimentare (v0, 2026-10-20)

## Principio

Un indicatore è confrontabile solo con un altro indicatore che condivide
definizione, unità, base, periodo e territorio. Il contratto rende esplicite
queste dimensioni; non le nasconde in un join.

## Schema minimo

### `fact_indicatore`

| Campo | Tipo | Note |
|---|---|---|
| `serie_id` | VARCHAR | chiave della serie in `dim_serie` |
| `periodo` | DATE | primo giorno del mese o dell'anno |
| `territorio_codice` | VARCHAR | codice in `dim_territorio` |
| `comparto_codice` | VARCHAR | codice in `dim_comparto`; NULL se non applicabile |
| `valore` | DOUBLE | valore osservato o derivato |
| `unita` | VARCHAR | vocabolario controllato |
| `base_anno` | INTEGER | solo per indici; NULL per prezzi/redditi |
| `metodo_calcolo` | VARCHAR | vocabolario controllato |
| `qualita` | VARCHAR | vocabolario controllato |
| `note` | VARCHAR | anomalie, revisioni, copertura |

Chiave: (`serie_id`, `periodo`, `territorio_codice`, `comparto_codice`).

### `dim_serie`

| Campo | Tipo | Note |
|---|---|---|
| `serie_id` | VARCHAR | PK, formato sotto |
| `fonte_id` | VARCHAR | `istat_sdmx`, `istat_dbnomics`, `eurostat`, `rica_crea`, … |
| `nome` | VARCHAR | leggibile |
| `definizione` | VARCHAR | cosa misura, non solo il titolo |
| `classificazione` | VARCHAR | `ECOICOP`, `ECOICOP_2`, `OTE`, `EUROSTAT_PROD`, `ISTAT_AGRI` |
| `codice` | VARCHAR | codice nella classificazione |
| `frequenza` | VARCHAR | `M`, `A` |
| `unita` | VARCHAR | vocabolario |
| `base_anno` | INTEGER | NULL se non indice |
| `territorio_livello` | VARCHAR | `IT`, `NUTS1`, `NUTS2`, `REG` |
| `copertura_start` | DATE | prima osservazione |
| `copertura_end` | DATE | ultima osservazione |
| `metodo_calcolo` | VARCHAR | `raw`, `index`, `ratio`, `share`, `modelled`, … |
| `qualita` | VARCHAR | `official`, `official_provisional`, `official_modelled`, … |
| `limitazioni` | VARCHAR | testo obbligatorio per `derived`/`modelled`/`provisional` |
| `licenza` | VARCHAR | es. CC BY 4.0, uso non commerciale con citazione |
| `url` | VARCHAR | endpoint o pagina |
| `query_params` | VARCHAR | parametri riproducibili |
| `data_accesso` | DATE | quando è stato verificato |
| `revisione` | VARCHAR | `provisional`, `final`, `unknown` |

### Dimensioni

- `dim_territorio`: `codice`, `nome`, `livello`, `parent_codice`.
- `dim_comparto`: `classificazione`, `codice`, `nome`, `parent_codice`, `note`.
- `dim_periodo`: `periodo`, `anno`, `mese`, `frequenza`.
- `bridge_comparto`: `classificazione_a`, `codice_a`, `classificazione_b`,
  `codice_b`, `copertura`, `note`. Non è un join di fatto: è una mappa
  semantica per l'analisi.

## Vocabolari controllati

**`frequenza`**: `M`, `A`.

**`unita`**: `indice_2015_100`, `indice_2020_100`, `indice_2025_100`,
`eur_per_kg`, `eur_per_litro`, `eur_per_pezzo`, `eur_per_azienda`, `pct`, `num`.

**`metodo_calcolo`**: `raw`, `index`, `ratio`, `share`, `deflated`, `modelled`,
`provisional`, `derived`.

**`qualita`**: `official`, `official_provisional`, `official_modelled`,
`official_sample`, `harmonized`, `mirror`, `derived`, `unknown`.

**`fonte_id`**: `istat_sdmx`, `istat_dbnomics`, `eurostat`, `rica_crea`,
`fadn_fsdn`, `mimit`, `ismea`, `agea`.

## Formato `serie_id`

- SDMX ISTAT: `istat_sdmx:<dataflow>:<key>`
  - `istat_sdmx:167_744_DF_DCSP_NIC1B2015_4:M.IT.39.4.0116`
  - `istat_sdmx:101_12_DF_DCSP_PREZZIAGR_10:M.IT.76..FRUIT`
- DBnomics: `istat_dbnomics:<dataset>:<series_code>`
- Eurostat: `eurostat:<flow>:<geo>:<codice>:<unita>`
  - `eurostat:prc_hicp_midx:IT:CP0116:I15`
  - `eurostat:apri_ap_crpouta:IT:04121000:EUR`
- RICA: `rica_crea:<report>:<tipo_dati>:<stratificazione>:<anno>:<territorio>:<indicatore>`
  - `rica_crea:c:universo:ote:2024:IT:RTA`
  - `rica_crea:c:universo:ude:2024:IT:RN`

## Regole

1. **Niente join su etichette**: usare codici + classificazione.
2. **Niente confronto di livelli tra fonti diverse** senza conversione esplicita:
   NIC, HICP e prezzi alla produzione sono definizioni diverse.
3. **Niente differenze tra indici lette come margini**: un rapporto tra indici
   è `ratio`, non `margine`.
4. **Niente splicing di basi** (NIC 2015 → 2025, indici agricoli 2015 → 2020)
   senza coefficienti ufficiali e una tabella `serie_linked` documentata.
5. **Niente mescolanza universo/campione RICA**: `tipo_dati` è una dimensione.
6. **Niente mescolanza OTE/dimensione/territorio** nella stessa serie: la
   stratificazione è una dimensione, non un dettaglio.
7. **Sempre** `data_accesso`, `url`, `query_params`, `licenza`.
8. **Sempre** marcare `provisional`, `modelled`, `sample`, `mirror`.
9. **Sempre** `n_units`/`sample_size` per RICA e per le fonti campionarie.
10. **Sempre** una nota di copertura per i prodotti non presenti in una fonte.

## Bridge di esempio (analisi, non join)

| ECOICOP | Eurostat prodotto | ISTAT agricolo | RICA OTE |
|---|---|---|---|
| 0111 cereali | 01110000, 01120000 | CEREA | 110 |
| 0112 carne | prodotti animali | ANIMA/ANIMAODUCT | 400, 410, 500 |
| 0114 latte/uova | 12112000, 12200000 | ANIMAODUCT | 410, 500 |
| 0115 oli/grassi | 08100000 | OLIVE | 320 |
| 0116 frutta | 06110000, 06120000, 06130000, 06210000, 06230000 | FRUIT | 330 |
| 0117 ortaggi | 04121000, 04122000, 05120000 | VEGETSAND | 200 |

La bridge dichiara la copertura: non tutti i prodotti di una categoria ECOICOP
sono nella fonte agricola, e non tutti gli OTE sono equivalenti.

## Note per fonte

### ISTAT NIC

- Base 2015: `167_744_DF_DCSP_NIC1B2015_4`, `DATA_TYPE=39`, `MEASURE=4`,
  `E_COICOP_REV_ISTAT=0111..0117`, 2016-01 → 2025-12.
- Base 2025: `167_745_DF_DCSP_NIC1B2025_6`, `DATA_TYPE=85`, `MEASURE=4`,
  `ECOICOP_2=0111..0117`, 2026-01 → 2026-07.
- Le etichette 2025 sono più aggregate; non sono la stessa serie.

### Eurostat HICP

- `prc_hicp_midx`, `geo=IT`, `unit=I15`, `coicop=CP0111..CP0117`,
  2016-01 → 2025-12.
- Armonizzato UE; usare come benchmark separato.

### ISTAT prezzi agricoli (già in Lab)

- Base 2020: `101_12_DF_DCSP_PREZZIAGR_10/9`, 2020-01 → 2026-06.
- Per il 2016-2019 esistono dataflow base 2015 (`..._1`/`..._2`): usarli solo
  come serie separate, senza splicing.

### Eurostat prezzi agricoli (già in Lab)

- `apri_ap_crpouta` / `apri_ap_anouta`, annuale 2000-2024, EUR per 100 kg/l/pz.
- Il mart normalizza a €/kg, €/litro, €/pezzo; conservare `valore_originale` e
  `unita` originale.

### RICA/AREA

- `report=c`, `type=excel`, `filter[Stratificazione]`, `filter[TipoDati]`,
  `filter[Anno]`, `filter[IdRegioneUE]`.
- `TipoDati=universo` è una stima modellata; `campionari` è il campione.
- Excel con header multi-riga e `xlrd` + `ignore_workbook_corruption=True`.
- Licenza: studi/formazione/divulgazione con citazione RICA-CREA; non commerciale.

## Esempi di righe

| serie_id | periodo | territorio | comparto | valore | unita | base | metodo | qualita |
|---|---|---|---|---|---:|---|---|---|
| `istat_sdmx:167_744_DF_DCSP_NIC1B2015_4:M.IT.39.4.0116` | 2025-12-01 | IT | 0116 | 139.3 | indice_2015_100 | 2015 | index | official |
| `eurostat:prc_hicp_midx:IT:CP0116:I15` | 2025-12-01 | IT | CP0116 | 137.4 | indice_2015_100 | 2015 | index | harmonized |
| `istat_sdmx:101_12_DF_DCSP_PREZZIAGR_10:M.IT.76..FRUIT` | 2026-06-01 | IT | FRUIT | 150.6 | indice_2020_100 | 2020 | index | official_provisional |
| `eurostat:apri_ap_crpouta:IT:04121000:EUR` | 2024-01-01 | IT | 04121000 | 0.8726 | eur_per_kg | NULL | raw | official |
| `rica_crea:c:universo:ote:2024:IT:RN` | 2024-01-01 | IT | 110 | 21583 | eur_per_azienda | NULL | modelled | official_modelled |

## Anti-pattern

- `producer_index / consumer_index` chiamato “margine”: è un `ratio`.
- `NIC 2016-2025` unito a `NIC 2026` senza base: serie rotta.
- `RICA universo` e `RICA campione` nella stessa serie: doppio conteggio.
- `OTE` e `dimensione economica` nella stessa riga: stratificazioni alternative.
- `ECOICOP 0116` join diretto su `prodotto` Eurostat: la categoria è più ampia.
- `HICP` e `NIC` fusi: definizioni e pesi diversi.
