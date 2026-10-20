# ISTAT — prezzi agricoli (venduti e acquistati)

## Domanda

Chi produce cibo riesce a coprire i costi? La forbice tra prezzi dei prodotti
venduti e prezzi dei mezzi di produzione si sta aprendo o chiudendo?

## Fonte

ISTAT, due flussi SDMX (base 2020=100):

- `101_12_DF_DCSP_PREZZIAGR_10` — indici mensili dei prezzi dei prodotti venduti dagli agricoltori
- `101_12_DF_DCSP_PREZZIAGR_9` — indici mensili dei prezzi dei prodotti acquistati dagli agricoltori

## Perimetro

Italia, gennaio 2020 - giugno 2026. Tutti i gruppi di prodotto e le categorie
di input esposti dai due flussi. Unità: indice, base 2020=100.

## Output

- `mart_prezzi_mensili` — serie mensile per tipo (venduto/acquistato), categoria, indice, variazioni MoM e YoY.
- `mart_ragione_scambio` — indice output totale / indice input totale, con variazione annua.

## Note

Vedi `notes.md` per limiti e scelte di mapping.
