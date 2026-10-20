# Note — rica_area_redditi

## Source ID

`rica_crea` è un id nuovo: va registrato in `source-observatory` (protocollo
HTML/export, observation mode da definire). In questo candidate è usato come
`source_id` per la tracciabilità.

## Fonte e accesso

- Endpoint ufficiale: `https://arearica.crea.gov.it/report_create.php`
- Query base: `report=c&type=excel&filter[Stratificazione]=...&filter[TipoDati]=...`
- Query usate:
  - `anno` + `universo` (2008-2024)
  - `anno` + `campionari` (2008-2024)
  - `ote` + `universo` + `Anno={year}`
  - `ude` + `universo` + `Anno={year}`
  - `terr` + `universo` + `Anno={year}`
- I workbook originali sono salvati in `data/rica/` (gitignored) per audit.

## Quirk Excel

L'export `type=excel` è un BIFF con header multi-riga e, con `xlrd` 2.x,
richiede `ignore_workbook_corruption=True`. Il reader Excel del toolkit non
imposta quel flag: per questo il candidate usa `type: script` e normalizza in
CSV. Non è scraping di layout: è un adapter su un export ufficiale.

## Mapping

- **OTE**: 100 Altri seminativi, 110 Cerealicoltura, 200 Ortofloricoltura,
  310 Viticoltura, 320 Olivicoltura, 330 Frutticoltura, 400 Altri erbivori,
  410 Bovini da latte, 500 Granivori, 800 Miste.
- **Dimensione**: PIC, MEDP, MED, MEDG, GRA.
- **Regioni**: codici ISTAT a 3 cifre usati da AREA (es. 311 Puglia, 230 Lombardia).
- **Unità**: `€` → `eur_per_azienda`; `numero` → `num`.

## Universo vs campione

- `universo`: stima riportata all'universo RICA, modellata dal campione.
- `campionari`: valori del campione, non rappresentativi dell'universo.
- Le due serie restano separate in `tipo_dati`; nessun merge.

## Licenza e citazione

Dal copyright AREA RICA: dati utilizzabili per studi scientifici, formazione e
divulgazione, citando fonte (RICA-CREA), indirizzo internet e data di accesso;
non è consentito l'uso commerciale senza autorizzazione. Il candidate conserva
`url` e `data_accesso` in ogni riga.

## Copertura e limiti

- 2008-2024; il 2024 è l'ultimo anno disponibile in AREA alla data di accesso.
- Le cross-section usano l'anno del run (`{year}`, default 2024).
- Medie aziendali: non sono margini di prodotto né prezzi.
- La composizione del campione RICA cambia nel tempo; le variazioni anno su anno
  vanno lette con cautela.
- `AZIENDE` è il numero di aziende rappresentate, non un valore monetario.
- La cross-section è per una sola stratificazione alla volta; OTE × regione
  richiederebbe 21 query aggiuntive (non incluse in v0).

## Prossimo passo

Unire `mart_aiuti` e `mart_redditi_comparti` ai prezzi (ISTAT/Eurostat) per un primo
quadro reddito-costi-prezzi, senza trattare le differenze tra indici come margini.
