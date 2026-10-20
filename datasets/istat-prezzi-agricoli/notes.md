# Note — istat_prezzi_agricoli

## Scelte

- **Due flussi in un solo candidate**: venduti e acquistati condividono struttura e
  periodo; il clean li unisce in schema long con `tipo`.
- **Filtri raw**: solo `FREQ=M`, `REF_AREA=IT`, `DATA_TYPE` (76 venduti, 75 acquistati).
  Le dimensioni prodotto restano wildcard, così il dataset copre tutti i gruppi.
- **Mapping categorie**: i codici SDMX sono tradotti in italiano nel clean; il
  `categoria_label_raw` inglese resta come traccia.
- **Ragione di scambio**: `TOTAGRICOUT / INPUTAL * 100`. È un rapporto tra indici,
  non un margine di profitto.

## Limiti

- ISTAT pubblica **indici**, non prezzi assoluti. Per i livelli servono ISMEA o Eurostat.
- I gruppi venduti e acquistati non sono perfettamente speculari: la ragione di
  scambio aggregata è corretta, il confronto per singolo prodotto no.
- Base 2020: le serie precedenti usano basi diverse e non sono unite qui.
- Il download parte dal 2020; il run 2026 porta con sé l'intera serie disponibile.

## Prossimo passo

Confronto con Eurostat `apri_ap_*` per i prezzi assoluti annuali e con i prezzi
al consumo per la parte filiera.
