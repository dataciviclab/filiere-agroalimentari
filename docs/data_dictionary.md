# Data dictionary — filiera agroalimentare

Audience: maintainers e analisti. Il contratto completo è in
[`analytical_contract.md`](analytical_contract.md).

## Campi comuni

| Campo | Tipo | Note |
|---|---|---|
| `anno` / `mese` / `data` | int / int / date | periodo dell'osservazione |
| `fonte_id` | string | `istat_sdmx`, `istat_dbnomics`, `eurostat`, `rica_crea` |
| `serie_id` | string | identificativo riproducibile della serie |
| `unita` | string | `indice_2015_100`, `indice_2020_100`, `indice_2025_100`, `eur_per_kg`, `eur_per_litro`, `eur_per_pezzo`, `eur_per_azienda`, `num`, `pct` |
| `base_anno` | int | solo per indici |
| `metodo_calcolo` | string | `raw`, `index`, `ratio`, `share`, `modelled`, `provisional` |
| `qualita` | string | `official`, `official_provisional`, `official_modelled`, `official_sample`, `harmonized`, `mirror`, `derived` |
| `copertura` | string | periodo/territorio coperti |
| `limitazioni` | string | caveat obbligatorio per serie derivate/modellate/provvisorie |

## `istat-prezzi-agricoli`

**Clean**: `anno`, `mese`, `data`, `tipo` (`venduto`/`acquistato`),
`categoria_codice`, `categoria`, `categoria_label_raw`, `indice`.

**Mart**
- `mart_prezzi_mensili`: `indice`, `variazione_anno_prec_pct`,
  `variazione_mese_prec_pct`.
- `mart_ragione_scambio`: `indice_output` (`TOTAGRICOUT`),
  `indice_input` (`INPUTAL`), `ragione_scambio` = output/input*100,
  `ragione_scambio_var_anno_pct`.

Unità: indice base 2020=100. Non è un prezzo assoluto.

## `eurostat-prezzi-agricoli`

**Clean**: `anno`, `gruppo` (`colture`/`animali`), `prodotto_codice`,
`prodotto`, `unita`, `valore`, `flag`.

**Mart**
- `mart_prezzi_prodotti`: `filiera`, `prodotto_codice`, `prodotto`,
  `unita`, `unita_base`, `valore_eur_per_unita`, `valore_originale`, `flag`.
- `mart_copertura`: `primo_anno`, `ultimo_anno`, `n_anni`, `n_mancanti`,
  `copertura_pct`.

Unità originali: EUR per 100 kg/litri/pezzi. Il mart normalizza a €/kg,
€/litro, €/pezzo.

## `rica-area-redditi`

**Clean**: `tipo_dati` (`universo`/`campionari`), `stratificazione`
(`anno`/`ote`/`ude`/`terr`), `anno`, `territorio_codice`, `territorio`,
`comparto_codice`, `comparto`, `indicatore_codice`, `indicatore`, `unita`,
`valore`, `metodo_calcolo`, `qualita`, `serie_id`, `copertura`, `limitazioni`.

**Mart**
- `mart_redditi_anni`: serie nazionale 2008-2024, `tipo_dati`, `indicatore`,
  `valore`, `variazione_anno_prec_pct`.
- `mart_redditi_comparti`: cross-section per OTE/dimensione/regione.
- `mart_aiuti`: `ap1_eur`, `ap2_eur`, `aiuti_tot_eur`, `rn_eur`, `rta_eur`,
  `va_eur`, `aziende_rappresentate`, `incidenza_aiuti_rn_pct`,
  `incidenza_aiuti_rta_pct`.

Indicatori: RTA, PLV, AP1, AP2, CC, FC, ST, VA, CP, PN, CL, RO, RN, AZIENDE.
Sono medie aziendali, non margini di prodotto.

## `istat-nic-prezzi-consumo`

**Clean**: `base_anno` (2015/2025), `anno`, `mese`, `data`, `codice`,
`categoria`, `indice`, `unita`, `serie_id`, `fonte_id`, `metodo_calcolo`,
`qualita`, `copertura`, `limitazioni`.

**Mart**
- `mart_prezzi_consumo`: `indice`, `variazione_anno_prec_pct`,
  `variazione_mese_prec_pct`.
- `mart_sintesi`: ultimo mese per base/categoria, `ultimo_indice`,
  `variazione_anno_prec_pct`, `n_mesi`.

Categorie: `0111`, `0112`, `0114`, `0115`, `0116`, `0117`. La base 2025 non è
confrontabile in livello con la 2015.

## `eurostat-hicp-prezzi-consumo`

**Clean**: `anno`, `mese`, `data`, `codice`, `categoria`, `indice`, `unita`,
`base_anno` (2015), `serie_id`, `fonte_id`, `metodo_calcolo`, `qualita`,
`copertura`, `limitazioni`.

**Mart**
- `mart_hicp_prezzi`: serie mensile con MoM/YoY.
- `mart_hicp_sintesi`: ultimo mese per categoria, `ultimo_indice`,
  `variazione_anno_prec_pct`, `n_mesi`.

Categorie: `CP0111`, `CP0112`, `CP0114`, `CP0115`, `CP0116`, `CP0117`.
Benchmark armonizzato, non sostituto di NIC.
