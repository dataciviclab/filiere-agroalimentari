# Fonti — filiera agroalimentare

## Dataset e fonti

| Dataset | Fonte | Endpoint / canale | Periodo | Licenza |
|---|---|---|---|---|
| `istat-prezzi-agricoli` | ISTAT SDMX | `101_12_DF_DCSP_PREZZIAGR_10/9` via `esploradati.istat.it` | 2020-2026 | CC BY 4.0 |
| `eurostat-prezzi-agricoli` | Eurostat SDMX | `apri_ap_crpouta`, `apri_ap_anouta` | 2000-2024 | CC BY 4.0 |
| `rica-area-redditi` | CREA-PB RICA/AREA | `arearica.crea.gov.it/report_create.php?report=c` | 2008-2024 | citazione RICA-CREA, non commerciale |
| `istat-nic-prezzi-consumo` | ISTAT via DBnomics | `167_744_DF_DCSP_NIC1B2015_4`, `167_745_DF_DCSP_NIC1B2025_6` | 2016-2026 | CC BY 4.0 |
| `eurostat-hicp-prezzi-consumo` | Eurostat SDMX | `prc_hicp_midx`, `geo=IT`, `unit=I15` | 2016-2025 | CC BY 4.0 |

## Dettagli

### ISTAT prezzi agricoli

- Due flussi SDMX: prodotti venduti (`DATA_TYPE=76`) e acquistati (`DATA_TYPE=75`).
- Base 2020=100; mensile; Italia.
- Il candidate usa `type: sdmx` con timeout e retry.

### Eurostat prezzi agricoli

- Prezzi assoluti annuali alla produzione, EUR per 100 kg/litri/pezzi.
- Italia effettivamente coperta: 16 colture + 7 prodotti animali.
- Il mart normalizza a €/kg, €/litro, €/pezzo e conserva il valore originale.

### RICA / AREA

- Fonte ufficiale: CREA-PB, RICA (implementazione italiana della FADN).
- `report_create.php?report=c&type=excel&filter[...]`; export Excel con header
  multi-riga e BIFF leggibile con `xlrd` + `ignore_workbook_corruption=True`.
- Universo (stima modellata) e campione separati in `tipo_dati`.
- Licenza: studi/formazione/divulgazione con citazione RICA-CREA; non commerciale.
- Microdati: solo ricercatori accreditati, non inclusi.

### ISTAT NIC

- Base 2015: `167_744_DF_DCSP_NIC1B2015_4` (`DATA_TYPE=39`), 2016-2025.
- Base 2025: `167_745_DF_DCSP_NIC1B2025_6` (`DATA_TYPE=85`), 2026+.
- Canale: DBnomics (mirror pubblico dello SDMX ISTAT) per evitare il rate limit
  e l'intermittenza dell'endpoint ufficiale.
- Categorie: `0111`, `0112`, `0114`, `0115`, `0116`, `0117`. Pesca esclusa.

### Eurostat HICP

- `prc_hicp_midx`, `geo=IT`, `unit=I15`, `coicop=CP0111..CP0117`, 2016-2025.
- Benchmark armonizzato, non sostituto di NIC; non copre il 2026.

## Revisioni e qualità

- ISTAT: dati provvisori e revisioni mensili; il 2026 è provvisorio.
- Eurostat: revisioni periodiche; HICP aggiornato con lag.
- RICA: aggiornamento annuale; universo modellato dal campione.
- Conservare sempre `fonte_id`, `serie_id`, `data_accesso` e `limitazioni`.

## Fonti non incluse (gap)

- **MIMIT Osservaprezzi**: host non raggiungibile da questa rete; nessuna API
  ufficiale stabile; non inserito.
- **ISMEA**: dati dietro report legacy/Tableau, export manuale; non pipeline-ready.
- **AGEA/SIAN**: beneficiari PAC consultabili, non bulk; FOIA MASAF respinto.
- **SBS**: copre trasformazione e retail (NACE 10/11/12/47), non agricoltura;
  vive in `dataset-incubator/candidates/istat-sbs-imprese`.
