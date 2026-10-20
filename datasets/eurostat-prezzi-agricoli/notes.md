# Note — eurostat_prezzi_agricoli

## Scelte

- **Due dataset in un candidate**: colture e animali hanno schema quasi identico;
  il clean li unisce e deriva `gruppo`.
- **Support codelists**: `PROD_VEG`, `PROD_ANI` per le label, `OBS_FLAG` per i flag
  di qualità. Le label Eurostat includono l'unità nel nome: il clean separa
  `prodotto` e `unita`.
- **Normalizzazione**: il mart divide per 100 e converte in €/kg, €/litro, €/pezzo.
  È una comodità di lettura, non un cambio di unità della fonte.
- **Selezione mart**: 18 prodotti delle filiere pilota; il clean resta completo.

## Limiti

- Prezzi **annuali**, non mensili. Per il 2026 non c'è ancora l'annuale.
- Prezzi alla produzione, IVA esclusa; non sono prezzi al consumo.
- La copertura varia per prodotto: `mart_copertura` lo rende esplicito.
- Eurostat non espone un prezzo per la pasta o per il formaggio: la trasformazione
  resta fuori.

## Prossimo passo

Unire questi livelli agli indici mensili ISTAT e, se si sblocca l'accesso,
ai prezzi al consumo MIMIT/ISMEA.
