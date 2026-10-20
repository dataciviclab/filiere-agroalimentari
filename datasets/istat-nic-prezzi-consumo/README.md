# ISTAT NIC — prezzi al consumo alimentari

## Domanda

Come si muovono i prezzi al consumo dei prodotti alimentari rispetto ai prezzi
alla produzione? Serve per confrontare i **trend**, non per calcolare margini.

## Fonte

ISTAT, indici NIC mensili per categorie ECOICOP, via DBnomics (mirror pubblico
dello SDMX ISTAT):

- base 2015: dataset `167_744_DF_DCSP_NIC1B2015_4`, 2016-01 → 2025-12;
- base 2025: dataset `167_745_DF_DCSP_NIC1B2025_6`, 2026-01 → oggi.

Categorie: `0111` cereali e prodotti a base di cereali, `0112` carne, `0114`
latte/formaggi/uova, `0115` oli e grassi, `0116` frutta, `0117` ortaggi.

## Perimetro

Italia, mensile, 2016-2026. Le due basi restano separate in `base_anno`; non
sono confrontabili in livello. Le categorie 2025 sono più aggregate.

## Output

- `mart_prezzi_consumo` — serie mensile per base/categoria, con variazioni MoM e YoY.
- `mart_sintesi` — ultimo mese disponibile per base/categoria, con YoY e numero mesi.

## Limiti

Sono indici, non prezzi assoluti. Non sono margini e non vanno sottratti ai
prezzi alla produzione. La base 2025 non è ancora confrontabile a 12 mesi.

## Note

Vedi `notes.md`.
