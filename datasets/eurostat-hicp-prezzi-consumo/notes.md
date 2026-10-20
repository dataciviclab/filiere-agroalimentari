# Note — eurostat_hicp_prezzi_consumo

## Canale

- Eurostat SDMX: `prc_hicp_midx`, agency `ESTAT`.
- Il plugin `type: sdmx` usa l'API Eurostat in TSV e normalizza in CSV long.
- Filtri: `freq=M`, `unit=I15`, `geo=IT`, `coicop` multiplo (6 categorie).
- Il dataset Eurostat parte dal 1996; il clean taglia al 2016.

## Perché separato da NIC

- HICP è armonizzato UE, NIC è l'indice nazionale.
- Pesi, copertura e definizioni non coincidono.
- Le basi sono entrambe 2015, ma non sono la stessa serie.
- HICP è un benchmark: non sostituisce NIC e non si fonde con esso.

## Categorie

- `CP0111` cereali e prodotti a base di cereali
- `CP0112` carne
- `CP0114` latte, formaggi e uova
- `CP0115` oli e grassi
- `CP0116` frutta
- `CP0117` ortaggi

Pesca (`CP0113`) esclusa: non ha un corrispettivo nel perimetro agricolo RICA.

## Qualità

- `qualita='harmonized'`: indice ufficiale Eurostat.
- `metodo_calcolo='index'`: numero indice, non prezzo.
- La copertura 2026 dipende dall'aggiornamento Eurostat; oggi si ferma a 2025-12.

## Licenza

Dati Eurostat aperti (CC BY 4.0), con citazione della fonte. Il candidate conserva
`serie_id` e `fonte_id`; per la pubblicazione aggiungere la citazione Eurostat.

## Prossimo passo

Confronto di trend con NIC e con i prezzi alla produzione, solo variazioni
tendenziali. Coppie minime: `CP0111` ↔ `CEREA`; `CP0114` ↔ `ANIMAODUCT`;
`CP0115` ↔ `OLIVE`; `CP0116` ↔ `FRUIT`; `CP0117` ↔ `VEGETSAND`.
