# Analysis — filiera agroalimentare

Questa cartella ospita le query e i primi output analitici, **non** la pipeline.
I dataset e i mart vivono in `datasets/`; qui si costruisce la lettura civica.

## Stato

Primo ciclo: redditi, aiuti e trend prezzi. Nessuna analisi pubblicata: il repo
è privato in alpha.

## Domande

1. Quanto pesano gli aiuti sul reddito netto, per OTE e dimensione economica?
2. Come cambia il reddito netto medio dal 2008 al 2024?
3. Come si muovono i prezzi al consumo rispetto ai prezzi alla produzione?
4. Quali filiere mostrano dinamiche diverse (cereali, ortofrutta, olio, latte)?

## Query

Le query di esempio sono in [`queries.sql`](queries.sql). Usano i nomi dei mart;
adattare i path `read_parquet(...)` all'output locale o GCS.

## Caveat

- Medie aziendali RICA ≠ margini di prodotto.
- NIC, HICP e prezzi alla produzione sono definizioni diverse: confrontare solo
  variazioni tendenziali, mai livelli.
- Basi 2015/2020/2025 separate; nessuno splicing.
- Retail assoluto e PAC beneficiari non sono coperti: i gap sono dichiarati.
