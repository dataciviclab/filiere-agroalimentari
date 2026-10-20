# Filiere agroalimentari — DataCivicLab

Questo repository raccoglie i dataset sulla **filiera agroalimentare italiana**
per rispondere a una domanda civica: **chi produce cibo riesce a sostenere i
costi, ottenere un reddito dignitoso e competere sul mercato?**

È un repo **multi-dataset**: ogni dataset vive in `datasets/<slug>/`, le
anagrafiche condivise in `support/`. L'analisi pubblica vive in `analysis/` e
nell'Explorer del Lab.

- **Stato:** alpha (repo privato)
- **Copertura:** 2000-2026, Italia
- **Unità di analisi:** prodotto/categoria, azienda agricola media, regione

## La domanda civica

**Come si distribuiscono prezzi, costi, redditi e aiuti lungo la filiera
agroalimentare? Chi assorbe i margini e chi i rischi?**

La domanda si scompone in tre lati:

- **produzione e costi**: prezzi alla produzione, input, ragione di scambio;
- **redditività**: valore aggiunto, reddito netto, aiuti PAC/PSR per OTE,
  dimensione economica e regione;
- **consumo**: prezzi al consumo alimentari, separati dalle serie di produzione.

## Dataset

| Slug | Cosa contiene | Anni | Stato |
|---|---|---|---|
| `istat-prezzi-agricoli` | Indici mensili prezzi venduti/acquistati dagli agricoltori, base 2020=100 | 2020-2026 | ready |
| `eurostat-prezzi-agricoli` | Prezzi assoluti annuali alla produzione, 23 prodotti Italia | 2000-2024 | ready |
| `rica-area-redditi` | RICA/AREA: redditi, VA, costi e aiuti per OTE/dimensione/regione | 2008-2024 | ready |
| `istat-nic-prezzi-consumo` | NIC mensile, 6 categorie alimentari, basi 2015 e 2025 separate | 2016-2026 | ready |
| `eurostat-hicp-prezzi-consumo` | HICP mensile, 6 categorie alimentari, benchmark armonizzato | 2016-2025 | ready |

Definizioni e colonne: [`docs/data_dictionary.md`](docs/data_dictionary.md).
Contratto analitico: [`docs/analytical_contract.md`](docs/analytical_contract.md).

## Cosa possiamo dire, e cosa no

**Sì:**
- come si muovono i prezzi alla produzione e i costi degli input;
- come cambia la ragione di scambio output/input;
- quanto pesano gli aiuti sul reddito netto per OTE, dimensione e regione;
- come si muovono i prezzi al consumo rispetto alla produzione, **in trend**.

**No, con i dati attuali:**
- margini di prodotto lungo la filiera;
- prezzi retail assoluti nazionali (MIMIT/ISMEA non sono pipeline-ready);
- distribuzione dei pagamenti PAC per beneficiario (AGEA è consultabile, non bulk).

Le differenze tra indici **non sono margini**. Le basi 2015/2020/2025 restano
separate; nessuno splicing silenzioso.

## Fonti

- **ISTAT** — prezzi agricoli, NIC, SBS (quest'ultimo in `dataset-incubator`).
- **Eurostat** — prezzi agricoli assoluti, HICP.
- **CREA-PB / RICA-AREA** — risultati economici medi delle aziende agricole.

Dettagli, endpoint e licenze: [`docs/sources.md`](docs/sources.md).
Per NIC il canale è il mirror DBnomics dello SDMX ISTAT; ogni riga conserva
`dataset` e `series_code`.

## Perché fidarsi

- fonti ufficiali o verificabili;
- trasformazioni documentate in [`docs/decisions.md`](docs/decisions.md);
- contratto analitico esplicito (unità, basi, qualità, limitazioni);
- CI + contract test prima della pubblicazione;
- standard condivisi del DataCivicLab ([`.github`](https://github.com/dataciviclab/.github)).

## Struttura

```
datasets/       un dataset per directory (dataset.yml + sql/)
support/        anagrafiche/dizionari condivisi
analysis/       query e primi output analitici (non pipeline)
docs/           fonti, decisioni, dizionario, contratto
tests/          contract test del repo
registry/       artifact registry (generato dalla pipeline)
```

## Esecuzione tecnica

```bash
pip install -e ".[dev,pipeline]"
make check        # valida tutti i dataset.yml (preflight)
make run-all      # esegue tutti i dataset (RAW → CLEAN → MART)
python -m pytest tests/
```

Il dataset RICA usa `type: script` per leggere l'export Excel ufficiale; il
`Makefile` esporta `TOOLKIT_ALLOW_SCRIPT_SOURCE=1` per il run locale. La
pipeline CI passa lo stesso flag.

Nota di contratto:

- i path relativi in `dataset.yml` sono risolti rispetto alla directory del
  file (`root: "../../out"`);
- gli output di run vivono in `out/` e non vanno committati;
- `metadata.json` è il payload ricco del layer, `manifest.json` il summary stabile.

## Partecipa

- **Discussions** → domande civiche, interpretazioni, proposte di metriche
- **Issues** → bug, problemi tecnici, miglioramenti della pipeline

Il repo è **privato in alpha**. La pubblicazione su Explorer arriverà dopo la
chiusura dei gap su retail assoluto e PAC beneficiari.

## Dove andare per il resto

- contesto del Lab, mappa repo, catalogo: `dataciviclab`
- policy comuni e componenti CI: `.github`
- motore tecnico della pipeline: `toolkit`
- incubazione candidate e source mapping: `dataset-incubator`

Riferimenti rapidi: [`docs/lab_links.md`](docs/lab_links.md)
