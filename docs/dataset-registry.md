# Dataset registry

Catalogo dei dataset e dei mart del repo. Il registry pubblico è
`registry/registry.json`, generato dalla pipeline.

| Slug | Fonte | Periodo | Granularità | Mart |
|---|---|---|---|---|
| `istat-prezzi-agricoli` | ISTAT | 2020-2026 | mese × gruppo/input | `mart_prezzi_mensili`, `mart_ragione_scambio` |
| `eurostat-prezzi-agricoli` | Eurostat | 2000-2024 | anno × prodotto | `mart_prezzi_prodotti`, `mart_copertura` |
| `rica-area-redditi` | CREA RICA | 2008-2024 | anno × OTE/dimensione/regione | `mart_redditi_anni`, `mart_redditi_comparti`, `mart_aiuti` |
| `istat-nic-prezzi-consumo` | ISTAT/DBnomics | 2016-2026 | mese × ECOICOP | `mart_prezzi_consumo`, `mart_sintesi` |
| `eurostat-hicp-prezzi-consumo` | Eurostat | 2016-2025 | mese × COICOP | `mart_hicp_prezzi`, `mart_hicp_sintesi` |
| `eurostat-sbs-food-retail` | Eurostat SBS | 2008-2024 | anno × NACE food retail | `mart_retail_alimentare`, `mart_retail_alimentare_dettaglio` |

### Compose

| Compose | Fonti | Periodo | Output |
|---|---|---|---|
| `compose/filiere-valore-aggiunto` | RICA (agricoltura) + SBS (10/11/12, external GCS) + Eurostat SBS (retail alimentare) | 2008-2024 | `mart_filiere_stadi`, `mart_filiere_dettaglio` |

## Colonne chiave

- **ISTAT prezzi agricoli**: `tipo` (venduto/acquistato), `categoria_codice`,
  `indice`; `mart_ragione_scambio` ha `indice_output`, `indice_input`,
  `ragione_scambio`.
- **Eurostat prezzi agricoli**: `prodotto_codice`, `prodotto`, `unita_base`,
  `valore_eur_per_unita`; `mart_copertura` ha `primo_anno`, `ultimo_anno`,
  `n_mancanti`.
- **RICA**: `tipo_dati`, `stratificazione` (`anno`/`ote`/`ude`/`terr`),
  `comparto_codice`, `indicatore_codice`, `valore`; `mart_aiuti` ha
  `ap1_eur`, `ap2_eur`, `rn_eur`, `incidenza_aiuti_rn_pct`.
- **NIC/HICP**: `base_anno`, `codice`, `categoria`, `indice`; i mart aggiungono
  `variazione_anno_prec_pct` e `variazione_mese_prec_pct`.
- **Eurostat SBS food retail**: `anno`, `nace_codice`, `nace`, `va_eur`,
  `costo_lavoro_eur`, `ore`, `imprese`, `quota_lavoro_pct`, `va_per_ora_eur`,
  `definizione_costo_lavoro`; il mart aggregato aggiunge `nace_coperti` e
  `perimetro_completo`.
- **Compose filiere**: `stadio` (`agricoltura`, `trasformazione`,
  `retail_alimentare`), `va_eur`, `costo_lavoro_eur`, `ore`, `imprese`,
  `quota_lavoro_pct`, `va_per_ora_eur`, `definizione_costo_lavoro`; il dettaglio
  aggiunge `classificazione`, `codice`, `nome`.

## Serie e unità

`serie_id` è riproducibile e include la fonte e la chiave della serie, ad es.:

- `istat_sdmx:101_12_DF_DCSP_PREZZIAGR_10:M.IT.76..FRUIT`
- `eurostat:apri_ap_crpouta:IT:04121000:EUR`
- `rica_crea:c:universo:ote:2024:IT:RN`
- `istat_dbnomics:167_744_DF_DCSP_NIC1B2015_4:M.IT.39.4.0116`

Unità ammesse: `indice_2015_100`, `indice_2020_100`, `indice_2025_100`,
`eur_per_kg`, `eur_per_litro`, `eur_per_pezzo`, `eur_per_azienda`, `num`, `pct`.

## Regole di lettura

- Non confrontare livelli tra fonti diverse: usa variazioni tendenziali.
- Non leggere un rapporto tra indici come margine.
- Non unire universo e campione RICA.
- Non unire basi diverse (2015/2020/2025).
- Non fare join su etichette: usa codici e classificazione.
- Non leggere NACE 47 totale come retail alimentare: usa `retail_alimentare`.
- Il perimetro food retail esclude tabacco, commercio non-food e online; `4711`
  è *predominantly food* e può includere assortimenti non-food. Nel 2022 copre
  7/8 NACE per riservatezza Eurostat su 4781.
