# Eurostat — prezzi agricoli alla produzione

## Domanda

Quanto vale un prodotto agricolo alla produzione, e come cambia nel tempo?
È la base per confrontare costo, prezzo all'origine e prezzo al consumo.

## Fonte

Eurostat, due dataset SDMX:

- `apri_ap_crpouta` — prezzi assoluti annuali dei prodotti vegetali
- `apri_ap_anouta` — prezzi assoluti annuali dei prodotti animali

Italia, euro, 2000-2024.

## Perimetro

Tutti i prodotti dei due dataset nel clean; il mart `mart_prezzi_prodotti`
seleziona 18 prodotti delle filiere cereali, ortofrutta, olio, latte, uova e vino.
Unità originali: EUR per 100 kg / 100 litri / 100 pezzi. Il mart normalizza a
€/kg, €/litro, €/pezzo.

## Output

- `mart_prezzi_prodotti` — serie annuale per prodotto, filiera, unità normalizzata.
- `mart_copertura` — copertura per prodotto: primo/ultimo anno, anni mancanti.

## Note

Vedi `notes.md`.
