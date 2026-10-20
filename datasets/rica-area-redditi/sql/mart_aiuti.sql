WITH aggregati AS (
    SELECT
        anno,
        stratificazione,
        territorio_codice,
        territorio,
        comparto_codice,
        comparto,
        MAX(CASE WHEN indicatore_codice = 'AP1' THEN valore END) AS ap1_eur,
        MAX(CASE WHEN indicatore_codice = 'AP2' THEN valore END) AS ap2_eur,
        MAX(CASE WHEN indicatore_codice = 'RN' THEN valore END) AS rn_eur,
        MAX(CASE WHEN indicatore_codice = 'RTA' THEN valore END) AS rta_eur,
        MAX(CASE WHEN indicatore_codice = 'VA' THEN valore END) AS va_eur,
        MAX(CASE WHEN indicatore_codice = 'AZIENDE' THEN valore END) AS aziende_rappresentate
    FROM clean_input
    WHERE
        stratificazione IN ('ote', 'ude', 'terr')
        AND anno BETWEEN 2008 AND {year}
    GROUP BY anno, stratificazione, territorio_codice, territorio, comparto_codice, comparto
)

SELECT
    anno,
    stratificazione,
    territorio_codice,
    territorio,
    comparto_codice,
    comparto,
    ROUND(ap1_eur, 2) AS ap1_eur,
    ROUND(ap2_eur, 2) AS ap2_eur,
    ROUND(COALESCE(ap1_eur, 0) + COALESCE(ap2_eur, 0), 2) AS aiuti_tot_eur,
    ROUND(rn_eur, 2) AS rn_eur,
    ROUND(rta_eur, 2) AS rta_eur,
    ROUND(va_eur, 2) AS va_eur,
    ROUND(aziende_rappresentate, 0) AS aziende_rappresentate,
    ROUND(
        (COALESCE(ap1_eur, 0) + COALESCE(ap2_eur, 0)) / NULLIF(rn_eur, 0) * 100,
        2
    ) AS incidenza_aiuti_rn_pct,
    ROUND(
        (COALESCE(ap1_eur, 0) + COALESCE(ap2_eur, 0)) / NULLIF(rta_eur, 0) * 100,
        2
    ) AS incidenza_aiuti_rta_pct
FROM aggregati
ORDER BY anno, stratificazione, territorio, comparto
