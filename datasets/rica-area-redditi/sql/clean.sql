-- RICA/AREA report c — normalizzazione long.
-- Una riga = tipo_dati × stratificazione × anno × territorio × comparto × indicatore.

WITH base AS (
    SELECT
        normalize_string(tipo_dati) AS tipo_dati,
        normalize_string(stratificazione) AS stratificazione,
        cast_int(anno) AS anno,
        normalize_string(territorio_codice) AS territorio_codice,
        normalize_string(territorio) AS territorio,
        normalize_string(comparto_codice) AS comparto_codice,
        normalize_string(comparto) AS comparto,
        normalize_string(indicatore_codice) AS indicatore_codice,
        regexp_replace(normalize_string(indicatore), '\s+', ' ', 'g') AS indicatore,
        normalize_string(unita) AS unita_raw,
        cast_double(valore) AS valore,
        normalize_string(fonte) AS fonte,
        normalize_string(url) AS url,
        normalize_string(data_accesso) AS data_accesso
    FROM raw_input
    WHERE cast_double(valore) IS NOT NULL
)

SELECT
    tipo_dati,
    stratificazione,
    anno,
    territorio_codice,
    territorio,
    comparto_codice,
    comparto,
    indicatore_codice,
    indicatore,
    CASE unita_raw
        WHEN '€' THEN 'eur_per_azienda'
        WHEN 'numero' THEN 'num'
        ELSE unita_raw
    END AS unita,
    valore,
    CASE WHEN tipo_dati = 'universo' THEN 'modelled' ELSE 'raw' END AS metodo_calcolo,
    CASE
        WHEN tipo_dati = 'universo' THEN 'official_modelled'
        ELSE 'official_sample'
    END AS qualita,
    'rica_crea' AS fonte_id,
    'rica_crea:c:' || tipo_dati || ':' || stratificazione || ':' ||
        cast(anno AS VARCHAR) || ':' || territorio_codice || ':' ||
        indicatore_codice AS serie_id,
    CASE stratificazione
        WHEN 'anno' THEN 'Italia, 2008-' || cast({year} AS VARCHAR) || ', annuale'
        WHEN 'ote' THEN 'Italia, ' || cast({year} AS VARCHAR) || ', per orientamento tecnico-economico'
        WHEN 'ude' THEN 'Italia, ' || cast({year} AS VARCHAR) || ', per dimensione economica'
        WHEN 'terr' THEN 'Italia, ' || cast({year} AS VARCHAR) || ', per regione'
        ELSE 'Italia'
    END AS copertura,
    CASE
        WHEN tipo_dati = 'universo'
            THEN 'Stima modellata dal campione RICA; medie aziendali, non margini di prodotto.'
        ELSE 'Campione RICA; non rappresentativo dell''universo.'
    END AS limitazioni,
    fonte,
    url,
    data_accesso
FROM base
WHERE
    anno BETWEEN 2008 AND {year}
    AND tipo_dati IN ('universo', 'campionari')
    AND stratificazione IN ('anno', 'ote', 'ude', 'terr')
