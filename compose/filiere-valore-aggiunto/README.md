# Filiere — valore aggiunto per stadio

## Cosa fa

Unisce fonti già processate per leggere il valore aggiunto della filiera
agroalimentare per **stadio**, non per prodotto:

- **agricoltura** ← RICA/AREA (OTE, universo)
- **trasformazione** ← ISTAT SBS NACE 10+11+12
- **retail alimentare** ← Eurostat SBS NACE 4711 + 4721-4725 + 4729 + 4781

La trasformazione SBS è nel repo `dataset-incubator` e viene letta da GCS come
support `external`. Il retail alimentare è il dataset locale
`eurostat-sbs-food-retail`.

## Output

- `mart_filiere_stadi`: una riga per stadio, 2008-2024, con VA, costo del lavoro,
  ore, imprese, quota lavoro, VA per ora e `definizione_costo_lavoro`.
- `mart_filiere_dettaglio`: OTE RICA e NACE SBS/Eurostat SBS, stessi indicatori.

## Limiti

- Agricoltura: media aziendale RICA × aziende rappresentate; è una stima
  modellata dall'universo, non un censimento.
- SBS: imprese con dipendenti; non copre l'agricoltura (`A`/`01`).
- Non è un margine di filiera: è un aggregato per stadio.
- 2008-2024; SBS può avere anni mancanti in alcune combinazioni.
- Retail alimentare: core proxy; esclude online, tabacco e commercio non-food.
  `4711` è *predominantly food* e può includere assortimenti non-food.
- 2008-2020 usa `personnel costs`; 2021-2024 `employee benefits expense`:
  `definizione_costo_lavoro` segnala il break nella serie aggregata.

## Support external

`https://storage.googleapis.com/dataciviclab-mart/istat_sbs_imprese/{year}/mart_sbs_filiere.parquet`

Prodotto da `dataset-incubator/candidates/istat-sbs-imprese` (PR #895).
