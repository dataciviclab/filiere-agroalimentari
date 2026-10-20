# Filiere agroalimentari

**Chi produce cibo riesce a sostenere i costi, ottenere un reddito dignitoso e
competere sul mercato?**

Questo repo raccoglie i dataset della filiera agroalimentare italiana: prezzi
alla produzione e input, redditi e aiuti delle aziende agricole, prezzi al
consumo. È un repo multi-dataset del DataCivicLab.

- **Stato:** alpha (repo privato)
- **Copertura:** 2000-2026, Italia
- **Unità:** prodotto/categoria, azienda agricola media, regione

## Dataset

| Slug | Cosa contiene | Anni |
|---|---|---|
| `istat-prezzi-agricoli` | Indici mensili prezzi venduti/acquistati, base 2020=100 | 2020-2026 |
| `eurostat-prezzi-agricoli` | Prezzi assoluti annuali alla produzione, 23 prodotti | 2000-2024 |
| `rica-area-redditi` | Redditi, VA, costi e aiuti per OTE/dimensione/regione | 2008-2024 |
| `istat-nic-prezzi-consumo` | NIC mensile, 6 categorie alimentari, basi 2015/2025 | 2016-2026 |
| `eurostat-hicp-prezzi-consumo` | HICP mensile, 6 categorie alimentari | 2016-2025 |

## Esempi di domande

- La ragione di scambio output/input si sta aprendo o chiudendo?
- Quanto pesano gli aiuti sul reddito netto delle aziende, per OTE e dimensione?
- Come cambiano i prezzi al consumo rispetto ai prezzi alla produzione?
- Quali filiere mostrano dinamiche diverse (cereali, ortofrutta, olio, latte)?

## Cosa possiamo dire, e cosa no

**Sì:** prezzi alla produzione e input, ragione di scambio, reddito netto e
incidenza aiuti per OTE/dimensione/regione, trend dei prezzi al consumo.

**No, con i dati attuali:** margini di prodotto, prezzi retail assoluti
nazionali, distribuzione dei pagamenti PAC per beneficiario. Le differenze tra
indici non sono margini; le basi 2015/2020/2025 restano separate.

## Accesso

```bash
pip install -e ".[dev,pipeline]"
make check       # preflight dei dataset.yml
make run-all     # RAW → CLEAN → MART
make test        # pytest
```

Output locali in `out/data/mart/<dataset>/<anno>/`. Il dataset RICA usa
`type: script`; il `Makefile` esporta `TOOLKIT_ALLOW_SCRIPT_SOURCE=1`.

## Documenti

- [Pipeline](docs/pipeline.md) — struttura, run, output, CI
- [Metodologia](docs/metodologia.md) — fonti, basi, decisioni, limiti
- [Dataset registry](docs/dataset-registry.md) — dataset, mart, colonne, serie

## Partecipa

- **Discussions** — domande, interpretazioni, proposte
- **Issues** — bug, task e blocchi operativi

Il repo è privato in alpha. La pubblicazione su Explorer arriverà dopo la
chiusura dei gap su retail assoluto e PAC beneficiari.

## License

[MIT](LICENSE)

Questo progetto fa parte di [DataCivicLab](https://github.com/dataciviclab).
