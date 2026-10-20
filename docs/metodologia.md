# Metodologia

## Fonti

- **ISTAT** — prezzi agricoli (SDMX), NIC (via DBnomics), SBS (in `dataset-incubator`).
- **Eurostat** — prezzi agricoli assoluti, HICP.
- **CREA-PB / RICA-AREA** — risultati economici medi delle aziende agricole.

Endpoint, copertura e licenze sono nel `dataset.yml` di ogni dataset e nelle
note locali. RICA consente studi/formazione/divulgazione con citazione
RICA-CREA; non uso commerciale.

## Unità e basi

- ISTAT prezzi agricoli: indice base 2020=100, mensile.
- Eurostat prezzi agricoli: EUR per 100 kg/litri/pezzi, annuale.
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
5. **SBS fuori da questo repo**: copre trasformazione e retail, non agricoltura
   (`A`/`01` assente); vive in `dataset-incubator`.
6. **Nessun join implicito** tra ECOICOP, NACE e OTE: la bridge di categoria è
   esplicita e vale per trend, non per livelli.

## Revisioni e qualità

- ISTAT: dati provvisori e revisioni mensili; il 2026 è provvisorio.
- Eurostat: revisioni periodiche; HICP con lag.
- RICA: aggiornamento annuale, universo modellato dal campione.

## Gap dichiarati

- prezzi retail assoluti nazionali (MIMIT/ISMEA non pipeline-ready);
- distribuzione PAC per beneficiario (AGEA consultabile, non bulk);
- margini di prodotto lungo la filiera.
