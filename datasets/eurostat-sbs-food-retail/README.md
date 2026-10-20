# Eurostat SBS — retail alimentare

Retail alimentare italiano, 2008-2024, da Eurostat SBS.

## Perimetro

Somma di NACE:

- `4711` supermercati, discount e minimercati
- `4721` frutta e verdura
- `4722` carne e prodotti a base di carne
- `4723` pesce, crostacei e molluschi
- `4724` pane, dolci e prodotti da forno
- `4725` bevande
- `4729` altri alimentari specializzati
- `4781` mercati e banchi alimentari

Esclusi: tabacco (`4726`), non-food (`4719`), online (`479`).

## Fonti

- `sbs_na_dt_r2` — 2008-2020, VA at factor cost e personnel costs.
- `sbs_ovw_act` — 2021-2024, value added, employee benefits expense, ore.

## Caveat

- 2024 è provvisorio.
- Il costo del lavoro cambia definizione tra i due dataset; non leggere i salti
  2020/2021 come variazioni economiche pure.
- Le ore sono disponibili solo dal 2021.
- Nel 2022 Eurostat non pubblica `4781` per riservatezza: il perimetro copre
  7/8 NACE.
- Il perimetro esclude l'online alimentare.
