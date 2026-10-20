# Eurostat HICP — prezzi al consumo alimentari

## Domanda

I prezzi al consumo alimentari italiani crescono come i prezzi alla produzione?
HICP serve come **benchmark armonizzato** e separato da NIC.

## Fonte

Eurostat, `prc_hicp_midx` (HICP — monthly data, index):

- `geo=IT`, `unit=I15` (base 2015=100), mensile;
- `coicop=CP0111, CP0112, CP0114, CP0115, CP0116, CP0117`;
- copertura verificata: 2016-01 → 2025-12.

Categorie: cereali, carne, latte/formaggi/uova, oli e grassi, frutta, ortaggi.
Pesca esclusa per allinearsi al perimetro agricolo.

## Perimetro

Italia, mensile, 2016-2025. È un indice, non un prezzo assoluto. Non va fuso con
NIC né confrontato in livello con i prezzi alla produzione.

## Output

- `mart_hicp_prezzi` — serie mensile per categoria, con MoM e YoY.
- `mart_hicp_sintesi` — ultimo mese disponibile per categoria, con YoY e numero mesi.

## Limiti

HICP e NIC hanno pesi e definizioni diverse. Le differenze tra i due indici non
sono margini. HICP non copre ancora il 2026.

## Note

Vedi `notes.md`.
