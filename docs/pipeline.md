# Pipeline

## Struttura

- `datasets/<slug>/` — `dataset.yml` + `sql/` (clean + mart)
- `registry/` — `registry.json` (generato dalla pipeline)
- `tests/` — smoke test del contratto repo
- `.github/workflows/` — CI + pipeline

## Esecuzione

```bash
pip install -e ".[dev,pipeline]"
make check       # preflight di tutti i dataset.yml
make run-all     # RAW → CLEAN → MART
make test        # pytest
```

Il dataset RICA usa `type: script`: il `Makefile` esporta
`TOOLKIT_ALLOW_SCRIPT_SOURCE=1`.

## Output

| Dataset | Mart |
|---|---|
| `istat-prezzi-agricoli` | `mart_prezzi_mensili`, `mart_ragione_scambio` |
| `eurostat-prezzi-agricoli` | `mart_prezzi_prodotti`, `mart_copertura` |
| `rica-area-redditi` | `mart_redditi_anni`, `mart_redditi_comparti`, `mart_aiuti` |
| `istat-nic-prezzi-consumo` | `mart_prezzi_consumo`, `mart_sintesi` |
| `eurostat-hicp-prezzi-consumo` | `mart_hicp_prezzi`, `mart_hicp_sintesi` |

Gli output vivono in `out/` e non vanno committati.

## CI

- `ci.yml` — `dataset-config-check-reusable` + `python-ci` (ruff + pytest).
- `pipeline.yml` — post-merge e schedule: `make run-all`, sync GCS, registry.

GCS/WIF non sono configurati in alpha: il run locale e la CI restano verdi, la
pubblicazione su bucket va abilitata quando il repo esce dallo stato privato.

## Registry

`registry/registry.json` è generato da `toolkit registry build --write`.
Non va compilato a mano se non per i campi editoriali.
