# Filiere — valore aggiunto per stadio

## Cosa fa

Unisce due fonti già processate per leggere il valore aggiunto della filiera
agroalimentare per **stadio**, non per prodotto:

- **agricoltura** ← RICA/AREA (OTE, universo)
- **trasformazione** ← SBS NACE 10+11+12
- **retail** ← SBS NACE 47

SBS non è nel repo: viene letto da GCS come support `external`.

## Output

- `mart_filiere_stadi`: una riga per stadio, 2008-2024, con VA, costo del lavoro,
  ore, imprese, quota lavoro e VA per ora.
- `mart_filiere_dettaglio`: OTE RICA e NACE SBS, stessi indicatori.

## Limiti

- Agricoltura: media aziendale RICA × aziende rappresentate; è una stima
  modellata dall'universo, non un censimento.
- SBS: imprese con dipendenti; non copre l'agricoltura (`A`/`01`).
- Non è un margine di filiera: è un aggregato per stadio.
- 2008-2024; SBS può avere anni mancanti in alcune combinazioni.

## Support external

`https://storage.googleapis.com/dataciviclab-mart/istat_sbs_imprese/{year}/mart_sbs_filiere.parquet`

Prodotto da `dataset-incubator/candidates/istat-sbs-imprese` (PR #895).
