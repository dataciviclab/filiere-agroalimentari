SELECT
    anno,
    stratificazione,
    territorio_codice,
    territorio,
    comparto_codice,
    comparto,
    indicatore_codice,
    indicatore,
    unita,
    ROUND(valore, 2) AS valore,
    metodo_calcolo,
    qualita
FROM clean_input
WHERE
    stratificazione IN ('ote', 'ude', 'terr')
    AND anno BETWEEN 2008 AND {year}
ORDER BY anno, stratificazione, territorio, comparto, indicatore_codice
