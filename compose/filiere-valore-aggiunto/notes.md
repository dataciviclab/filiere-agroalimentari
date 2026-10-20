# Note — filiere_valore_aggiunto

## Fonti

- `rica`: support `type: dataset`, config `../../datasets/rica-area-redditi/dataset.yml`.
  Usa `mart_redditi_comparti` (OTE, Italia, 2008-2024).
- `sbs_filiere`: support `type: external`, URI GCS del mart `mart_sbs_filiere`
  prodotto da `dataset-incubator/candidates/istat-sbs-imprese`.
  NACE 10 (alimentare), 11 (bevande), 12 (tabacco).
- `food_retail`: support `type: dataset`, config
  `../../datasets/eurostat-sbs-food-retail/dataset.yml`.
  NACE 4711 + 4721-4725 + 4729 + 4781.

## Calcolo

- Agricoltura: `VA` e `CL` medi per OTE × `AZIENDE` rappresentate; somma su OTE.
- Trasformazione: somma NACE 10+11+12.
- Retail alimentare: somma NACE food retail core.
- `quota_lavoro_pct = costo_lavoro_eur / va_eur * 100`.
- `va_per_ora_eur = va_eur / ore` (solo SBS; RICA non ha ore).
- `definizione_costo_lavoro` distingue RICA, ISTAT SBS e le due definizioni
  Eurostat SBS (`personnel_costs` 2008-2020, `employee_benefits_expense`
  2021-2024).

## Perché external

Solo la trasformazione SBS è già pubblicata su GCS dalla pipeline di
`dataset-incubator`; non la duplichiamo nel repo. Il retail alimentare è locale
perché oggi il plugin ESTAT non copre ancora i due flow SBS; quando il toolkit
lo supporterà, si potrà migrare a `type: sdmx`. Se il path SBS cambia,
aggiornare l'URI e rifare `make check`.

## Limiti

- RICA: universo modellato dal campione; licenza non commerciale con citazione.
- SBS: survey, imprese con dipendenti; non copre agricoltura.
- Nessun join di prodotto e nessun margine: solo stadi.
- 2008-2024; SBS può avere anni mancanti in alcune combinazioni.
- Retail alimentare: core proxy; esclude online, tabacco e commercio non-food.
  `4711` è *predominantly food* e può includere assortimenti non-food.
- 2022 copre 7/8 NACE: Eurostat non pubblica `4781` per riservatezza.
- Il break 2020/2021 è di definizione del costo del lavoro, non un salto
  economico puro: leggere `definizione_costo_lavoro`.
