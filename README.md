# Filiere agroalimentari

**Chi produce cibo riesce a sostenere i costi, ottenere un reddito dignitoso e
competere sul mercato?**

[![CI](https://github.com/dataciviclab/filiere-agroalimentari/actions/workflows/ci.yml/badge.svg)](https://github.com/dataciviclab/filiere-agroalimentari/actions/workflows/ci.yml)

Repo multi-dataset del DataCivicLab sulla filiera agroalimentare italiana:
prezzi alla produzione e input, redditività delle aziende agricole, prezzi al
consumo e valore aggiunto per stadio.

- **Stato:** alpha
- **Copertura:** 2000-2026, Italia
- **Unità:** prodotto/categoria, azienda agricola media, regione, stadio

## Cosa contengono

| Dataset | Fonte | Cosa contiene | Righe clean | Periodo |
|---|---|---|---:|---|
| `istat-prezzi-agricoli` | ISTAT | Indici mensili prezzi venduti/acquistati, 55 serie | 4.290 | 2020-2026 |
| `eurostat-prezzi-agricoli` | Eurostat | Prezzi assoluti annuali alla produzione, 23 prodotti | 554 | 2000-2024 |
| `rica-area-redditi` | CREA-PB | Redditi, VA, costi e aiuti per OTE/dimensione/regione | 9.673 | 2008-2024 |
| `istat-nic-prezzi-consumo` | ISTAT/DBnomics | NIC mensile, 6 categorie, basi 2015/2025 | 762 | 2016-2026 |
| `eurostat-hicp-prezzi-consumo` | Eurostat | HICP mensile, 6 categorie | 720 | 2016-2025 |
| `compose/filiere-valore-aggiunto` | RICA + SBS | VA per stadio: agricoltura, trasformazione, retail | 286 mart | 2008-2024 |

RICA rappresenta circa **566.000 aziende agricole** (universo modellato dal
campione). Il compose legge SBS già processato da GCS come support `external`.

## Esempi di domande

- La ragione di scambio output/input si sta aprendo o chiudendo?
- Quanto pesano gli aiuti sul reddito netto per OTE e dimensione economica?
- Come cambiano i prezzi al consumo rispetto ai prezzi alla produzione?
- Quali filiere mostrano dinamiche diverse (cereali, ortofrutta, olio, latte)?
- Quanto valore aggiunto resta in agricoltura, trasformazione e retail?

## Come accedere

### MCP del Lab

Dopo il registry, i dataset sono raggiungibili dal server MCP `dataciviclab`:
`find` e `explore` per scoprirli, `gcs_query` per interrogare clean/mart.

### DuckDB / parquet

```python
import duckdb
duckdb.sql("""
    SELECT comparto, rn_eur, aiuti_tot_eur, incidenza_aiuti_rn_pct
    FROM read_parquet(
      'gs://dataciviclab-mart/filiere-agroalimentari/rica_area_redditi/2024/mart_aiuti.parquet'
    )
    WHERE stratificazione = 'ote'
    ORDER BY incidenza_aiuti_rn_pct DESC
""").show()
```

Bucket: `gs://dataciviclab-clean/filiere-agroalimentari/` e
`gs://dataciviclab-mart/filiere-agroalimentari/`.

### Locale

```bash
pip install -e ".[dev,pipeline]"
make check
make run-all
```

## Approfondimenti

- [Pipeline](docs/pipeline.md) — struttura, run, output, CI
- [Metodologia](docs/metodologia.md) — fonti, basi, decisioni, limiti
- [Dataset registry](docs/dataset-registry.md) — dataset, mart, colonne, serie
- [Discussions](https://github.com/dataciviclab/filiere-agroalimentari/discussions)

## Cosa non possiamo dire

Con i dati attuali non ricostruiamo margini di prodotto, prezzi retail assoluti
nazionali o distribuzione PAC per beneficiario. Le differenze tra indici non
sono margini; basi 2015/2020/2025 restano separate.

## Partecipa

- **Discussions** — domande, interpretazioni, proposte di metriche
- **Issues** — bug, task e blocchi operativi

## License

[MIT](LICENSE)

Questo progetto fa parte di [DataCivicLab](https://github.com/dataciviclab).
