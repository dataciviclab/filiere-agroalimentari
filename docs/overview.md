# Overview — filiera agroalimentare

## Cos'è questo repo

Organizza dati pubblici sulla filiera agroalimentare italiana per rispondere a
una domanda civica: **chi produce cibo riesce a sostenere i costi, ottenere un
reddito dignitoso e competere sul mercato?**

La filiera è letta in tre stadi, con fonti e definizioni separate:

1. **Produzione e costi** — prezzi alla produzione, input, ragione di scambio.
2. **Redditività** — valore aggiunto, reddito netto, aiuti PAC/PSR per OTE,
   dimensione economica e regione.
3. **Consumo** — prezzi al consumo alimentari, come trend separato.

## Dataset

| Dataset | Stadio | Copertura | Unità |
|---|---|---|---|
| `istat-prezzi-agricoli` | produzione/costi | 2020-2026, mensile | indice base 2020=100 |
| `eurostat-prezzi-agricoli` | produzione | 2000-2024, annuale | €/kg, €/litro, €/pezzo |
| `rica-area-redditi` | redditività | 2008-2024, annuale | €/azienda media |
| `istat-nic-prezzi-consumo` | consumo | 2016-2026, mensile | indice base 2015/2025 |
| `eurostat-hicp-prezzi-consumo` | consumo benchmark | 2016-2025, mensile | indice base 2015=100 |

## Domande che puoi esplorare

- La ragione di scambio output/input si sta aprendo o chiudendo?
- Quanto pesano gli aiuti sul reddito netto delle aziende, per OTE e dimensione?
- Come cambiano i prezzi al consumo rispetto ai prezzi alla produzione?
- Quali filiere mostrano dinamiche diverse (cereali, ortofrutta, olio, latte)?
- Quanto contano le differenze tra piccole e grandi aziende?

## Limiti

- **Niente margini di prodotto**: mancano prezzi retail assoluti e prezzi di
  acquisto della trasformazione. Le differenze tra indici non sono margini.
- **Niente distribuzione PAC per beneficiario**: AGEA/SIAN è consultabile, non
  bulk; il FOIA MASAF è stato respinto. RICA dà l'incidenza media degli aiuti.
- **RICA**: medie aziendali, universo modellato dal campione; licenza non
  commerciale con citazione RICA-CREA.
- **Basi diverse**: NIC 2015/2025, ISTAT agricolo 2020, HICP 2015. Nessuno
  splicing silenzioso.
- **2024/2026**: dati provvisori o ultimo anno disponibile.

## Metodo

`RAW → CLEAN → MART` con il toolkit del Lab. Ogni dataset ha un `dataset.yml`,
SQL di clean/mart, note e contract test. La pipeline pubblica clean/mart su GCS
e aggiorna il registry; l'analisi pubblica vive nell'Explorer.

Per il contratto analitico completo: [`analytical_contract.md`](analytical_contract.md).
