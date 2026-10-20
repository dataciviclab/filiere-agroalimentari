# Note — eurostat_sbs_food_retail

## Fonti

- `sbs_na_dt_r2` — 2008-2020; `V12150` VA at factor cost, `V13310` personnel
  costs, `V11110` enterprises.
- `sbs_ovw_act` — 2021-2024; `AV_MEUR` value added, `EXPN_SAL_BEN_MEUR`
  employee benefits expense, `HW_NR` hours, `ENT_NR` enterprises.

Entrambi i dataflow sono Eurostat SBS, `geo=IT`, NACE food retail core.

## Perché uno script e non `type: sdmx`

Il plugin `sdmx` del toolkit legge un singolo dataflow SDMX e filtra le
dimensioni di serie. Qui servono due dataflow con nomi diversi delle dimensioni
e degli indicatori (`indic_sb` vs `indic_sbs`), e va costruito uno schema
unificato con un flag di definizione del costo del lavoro. Il payload Eurostat
è JSON-stat, non SDMX-ML/CSV: `extract.py` fa il flatten e la normalizzazione in
modo esplicito e testabile. Se in futuro il toolkit espone un plugin JSON-stat
per SBS, questo adapter può essere migrato.

## Perché lo splice 2020/2021

Il totale NACE 47 dei due dataflow coincide con l'SBS ISTAT già usato dal repo
negli anni di sovrapposizione (2008, 2019, 2020, 2022-2024). Il cambio di
dataflow è quindi un cambio di fonte Eurostat, non un cambio di perimetro.

## Perimetro

Somma di NACE `4711 + 4721 + 4722 + 4723 + 4724 + 4725 + 4729 + 4781`.
Esclusi tabacco (`4726`), commercio non-food (`4719`) e online (`479`).
`4711` è *predominantly food* e può includere assortimenti non-food.

## Limiti

- 2024 provvisorio.
- 2008-2020 `personnel costs`; 2021-2024 `employee benefits expense`: il break
  è esposto in `definizione_costo_lavoro`.
- Ore solo dal 2021; `va_per_ora_eur` è null prima.
- 2022 copre 7/8 NACE: `4781` non pubblicato da Eurostat per riservatezza.
- L'online alimentare non è separato e resta fuori dal perimetro.
