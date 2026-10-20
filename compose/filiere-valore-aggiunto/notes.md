# Note — filiere_valore_aggiunto

## Fonti

- `rica`: support `type: dataset`, config `../../datasets/rica-area-redditi/dataset.yml`.
  Usa `mart_redditi_comparti` (OTE, Italia, 2024).
- `sbs_filiere`: support `type: external`, URI GCS del mart `mart_sbs_filiere`
  prodotto da `dataset-incubator/candidates/istat-sbs-imprese`.
  NACE 10 (alimentare), 11 (bevande), 12 (tabacco), 47 (retail).

## Calcolo

- Agricoltura: `VA` e `CL` medi per OTE × `AZIENDE` rappresentate; somma su OTE.
- Trasformazione: somma NACE 10+11+12; retail: NACE 47.
- `quota_lavoro_pct = costo_lavoro_eur / va_eur * 100`.
- `va_per_ora_eur = va_eur / ore` (solo SBS; RICA non ha ore).

## Perché external

SBS è già pubblicato su GCS dalla pipeline di `dataset-incubator`. Non lo
duplichiamo nel repo: il compose legge il mart pubblico. Se il path cambia,
aggiornare l'URI e rifare `make check`.

## Limiti

- RICA: universo modellato dal campione; licenza non commerciale con citazione.
- SBS: survey, imprese con dipendenti; non copre agricoltura.
- Nessun join di prodotto e nessun margine: solo stadi.
- 2024 in v0.
