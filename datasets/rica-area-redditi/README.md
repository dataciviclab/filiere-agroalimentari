# RICA/AREA — redditi e aiuti delle aziende agricole

## Domanda

Chi produce cibo riesce a vivere del proprio lavoro? Quanto pesano i costi e gli
aiuti pubblici sul reddito, e come cambia tra piccole e grandi aziende, tra
coltivazioni e allevamenti, tra territori?

## Fonte

CREA-PB, **RICA** (Rete di Informazione Contabile Agricola, implementazione
italiana della FADN), data warehouse pubblico **AREA**:

- `report_create.php?report=c` — risultati gestionali;
- export Excel (`type=excel`) e HTML;
- 2008-2024, annuale;
- universo (stima modellata) e campione, separati;
- stratificazioni: anno, OTE, dimensione economica, regione.

## Perimetro

Italia. Serie nazionale 2008-2024 (universo + campione) e cross-section
2008-2024 per OTE, dimensione economica e regione. Indicatori: RTA, PLV, AP1, AP2, CC, FC, ST,
VA, CP, PN, CL, RO, RN, aziende rappresentate.

## Output

- `mart_redditi_anni` — serie nazionale 2008-2024, long, con variazione annua.
- `mart_redditi_comparti` — cross-section 2008-2024 per OTE/dimensione/regione, long.
- `mart_aiuti` — 2008-2024: AP1, AP2, aiuti totali, RN, RTA, VA e incidenza aiuti.

## Limiti

Sono **medie aziendali**, non margini di prodotto. L'universo è una stima
modellata dal campione RICA, non un censimento. La licenza consente studi,
formazione e divulgazione con citazione RICA-CREA; **non** uso commerciale.
Nessun microdato aziendale è incluso.

## Note

Vedi `notes.md` per endpoint, quirk Excel, mapping e licenza.
