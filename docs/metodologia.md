# Metodologia

## Fonti

- **ISTAT** — prezzi agricoli (SDMX), NIC (via DBnomics), SBS (in `dataset-incubator`).
- **Eurostat** — prezzi agricoli assoluti, HICP, SBS retail alimentare.
- **CREA-PB / RICA-AREA** — risultati economici medi delle aziende agricole.

Endpoint, copertura e licenze sono nel `dataset.yml` di ogni dataset e nelle
note locali. RICA consente studi/formazione/divulgazione con citazione
RICA-CREA; non uso commerciale.

## Unità e basi

- ISTAT prezzi agricoli: indice base 2020=100, mensile.
- Eurostat prezzi agricoli: EUR per 100 kg/litri/pezzi, annuale.
- Eurostat SBS retail alimentare: euro, ore e imprese, annuale.
- RICA: euro per azienda media, annuale; universo modellato o campione.
- NIC: indice base 2015=100 (2016-2025) e base 2025=100 (2026+), mensile.
- HICP: indice base 2015=100, mensile.

## Decisioni

1. **Basi separate**: NIC 2015/2025, ISTAT agricolo 2020, HICP 2015 non si
   fondono. Nessuno splicing senza coefficienti ufficiali.
2. **Differenze tra indici non sono margini**: produttore, consumo e
   trasformazione hanno definizioni e panieri diversi.
3. **RICA universo vs campione**: `tipo_dati` distingue la stima modellata dal
   campione; le due serie non si uniscono.
4. **NIC via DBnomics**: mirror strutturato dello SDMX ISTAT, usato perché
   l'endpoint ufficiale è intermittente. `qualita='mirror'`.
5. **SBS trasformazione fuori da questo repo**: `istat_sbs_imprese` vive in
   `dataset-incubator` e copre NACE 10/11/12; non copre agricoltura (`A`/`01`
   assente). Il retail alimentare è un dataset locale Eurostat SBS.
6. **Nessun join implicito** tra ECOICOP, NACE e OTE: la bridge di categoria è
   esplicita e vale per trend, non per livelli.
7. **Compose per stadio**: agricoltura da RICA (OTE), trasformazione da SBS
   (NACE 10/11/12), retail alimentare da Eurostat SBS (NACE 4711 + 4721-4725 +
   4729 + 4781). Non è un margine di prodotto.
8. **Retail alimentare core**: esclude tabacco (4726), commercio non-food (4719)
   e online (479). `4711` è *predominantly food* e può includere assortimenti
   non-food. Il 2022 ha 7/8 NACE per riservatezza Eurostat su 4781.

## Revisioni e qualità

- ISTAT: dati provvisori e revisioni mensili; il 2026 è provvisorio.
- Eurostat: revisioni periodiche; HICP con lag; SBS 2024 provvisorio.
- RICA: aggiornamento annuale, universo modellato dal campione.
- Eurostat SBS: 2008-2020 usa personnel costs; 2021-2024 employee benefits
  expense. Le ore sono disponibili solo dal 2021.

## Gap dichiarati

- prezzi retail assoluti nazionali (MIMIT/ISMEA non pipeline-ready);
- distribuzione PAC per beneficiario (AGEA consultabile, non bulk);
- margini di prodotto lungo la filiera;
- retail alimentare online e vendite non in store non separate.
