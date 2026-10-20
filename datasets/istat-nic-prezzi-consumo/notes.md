# Note — istat_nic_prezzi_consumo

## Canale

- Fonte ufficiale: ISTAT, dataflow `167_744_DF_DCSP_NIC1B2015_4` e
  `167_745_DF_DCSP_NIC1B2025_6`.
- Canale usato: `type: dbnomics`, provider `ISTAT`, perché l'endpoint SDMX
  `esploradati.istat.it` è stato intermittente durante la verifica.
- DBnomics è un mirror strutturato dello stesso SDMX; ogni riga conserva
  `dataset` e `series_code`, quindi la serie è ricostruibile.

## Dimensioni e filtri

- Base 2015: `DATA_TYPE=39`, `MEASURE=4`, `E_COICOP_REV_ISTAT=0111..0117`.
- Base 2025: `DATA_TYPE=85`, `MEASURE=4`, `ECOICOP_2=0111..0117`.
- `FREQ=M`, `REF_AREA=IT`.
- Codici con zeri iniziali: normalizzati con `lpad` nel clean.

## Base 2015 vs 2025

- Non sono la stessa serie: cambiano base, pesi e aggregazioni.
- `0116` passa da “Frutta” a “Frutta e frutta a guscio”.
- `0117` passa da “Ortaggi” a “Ortaggi, tuberi, banane plantain, banane da
  cucina e legumi”.
- Nessuno splicing in v0: `base_anno` è una dimensione.

## Qualità

- `qualita='mirror'`: dato ISTAT, accesso via DBnomics.
- `metodo_calcolo='index'`: numero indice, non prezzo.
- La base 2025 ha pochi mesi: la YoY è NULL finché non ci sono 12 mesi.

## Licenza

Dati ISTAT aperti (CC BY 4.0), con citazione della fonte. Il candidate conserva
`serie_id` e `fonte_id`; per la pubblicazione aggiungere la citazione ISTAT.

## Prossimo passo

Confronto di trend con `istat-prezzi-agricoli` (base 2020) e `eurostat-prezzi-agricoli`
(livelli annuali), senza leggere le differenze come margini. HICP può fare da
benchmark separato.
