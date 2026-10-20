SELECT
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
    AND anno = {year}
ORDER BY stratificazione, territorio, comparto, indicatore_codice
