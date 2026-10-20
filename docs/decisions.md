# Decision log — filiera agroalimentare

## D-001 — Basi separate, nessuno splicing silenzioso

- **Decisione**: NIC 2015, NIC 2025, ISTAT agricolo 2020 e HICP 2015 restano
  serie separate con `base_anno` esplicita.
- **Motivo**: cambiano base, pesi e aggregazioni; lo splicing non è neutro.
- **Impatto**: i confronti sono su variazioni tendenziali, non su livelli.
- **Alternative**: coefficienti di splicing ufficiali, solo se documentati.

## D-002 — Differenze tra indici non sono margini

- **Decisione**: un rapporto tra indici è `ratio`; non viene chiamato margine.
- **Motivo**: produttore, consumo e trasformazione hanno definizioni, panieri e
  unità diverse.
- **Impatto**: niente claim su “chi prende cosa” senza prezzi assoluti e dati
  di acquisto/vendita per stadio.

## D-003 — RICA universo vs campione

- **Decisione**: `tipo_dati` distingue `universo` (stima modellata) e
  `campionari` (campione).
- **Motivo**: l'universo è una stima, non un censimento; il campione non è
  rappresentativo dell'universo.
- **Impatto**: le due serie non si fondono; ogni riga dichiara `metodo_calcolo`
  e `qualita`.

## D-004 — NIC via DBnomics

- **Decisione**: usare il mirror DBnomics per NIC.
- **Motivo**: l'endpoint SDMX ISTAT è stato intermittente durante la verifica;
  DBnomics è un mirror strutturato dello stesso SDMX.
- **Impatto**: `qualita='mirror'`; `dataset` e `series_code` restano in ogni riga.
- **Alternativa**: passare a `type: sdmx` quando l'endpoint è stabile.

## D-005 — SBS fuori da questo repo

- **Decisione**: SBS resta in `dataset-incubator` (`istat-sbs-imprese`).
- **Motivo**: SBS copre trasformazione e retail, non agricoltura (`A`/`01`
  assente per `12150`); l'agricoltura resta su RICA.
- **Impatto**: per un quadro strutturale di valore aggiunto per stadio si può
  usare SBS 10/11/12/47 + RICA, senza fonderli in un unico dataset.

## D-006 — Retail assoluto e PAC beneficiari fuori pipeline

- **Decisione**: non creare pipeline per retail assoluto e PAC beneficiari.
- **Motivo**: MIMIT non raggiungibile/instabile, ISMEA manuale, AGEA search-only,
  FOIA respinto; Genova ferma al 2016.
- **Impatto**: i gap sono dichiarati; eventuali accessi passano da FOIA/richiesta
  istituzionale o pilot regionale, non da scraping fragile.

## D-007 — Adapter RICA

- **Decisione**: `type: script` con `extract.py` per l'export Excel RICA.
- **Motivo**: header multi-riga e BIFF che richiede
  `ignore_workbook_corruption=True`; il reader Excel del toolkit non lo imposta.
- **Impatto**: `TOOLKIT_ALLOW_SCRIPT_SOURCE=1` nel Makefile e nella pipeline;
  i workbook originali restano in `data/rica/` (gitignored).

## D-008 — Bridge di categoria, non join di prodotto

- **Decisione**: mappare ECOICOP ↔ prodotto Eurostat/ISTAT ↔ OTE RICA solo per
  analisi di trend, con una bridge esplicita.
- **Motivo**: le categorie non sono equivalenti e i panieri cambiano.
- **Impatto**: nessun join implicito su etichette; le note di copertura sono
  obbligatorie.
