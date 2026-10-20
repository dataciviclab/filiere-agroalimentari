#!/usr/bin/env python3
"""RICA/AREA — estrae i risultati economici da report_create.php e li normalizza in CSV long.

Fonte ufficiale: CREA-PB, AREA RICA (https://arearica.crea.gov.it).
Endpoint: report_create.php?report=c&type=excel&filter[...]
Il file Excel è un BIFF con header multi-riga; xlrd lo legge con
ignore_workbook_corruption=True.

Output: raw.csv con una riga per (tipo_dati, stratificazione, anno, territorio,
comparto, indicatore). I workbook originali restano in data/rica/ per audit.

Uso (toolkit raw source):
    python3 extract.py raw.csv
"""

from __future__ import annotations

import csv
import math
import sys
import time
import urllib.parse
import urllib.request
from datetime import date
from pathlib import Path

import xlrd

BASE_URL = "https://arearica.crea.gov.it/report_create.php"
USER_AGENT = "DataCivicLab/1.0 (+https://dataciviclab.org)"
DATA_DIR = Path("data/rica")
OUTPUT = Path(sys.argv[1] if len(sys.argv) > 1 else "raw.csv")
REPORT_YEAR = int(sys.argv[2]) if len(sys.argv) > 2 else 2024

OTE = {
    100: "Altri seminativi",
    110: "Cerealicoltura",
    200: "Ortofloricoltura",
    310: "Viticoltura",
    320: "Olivicoltura",
    330: "Frutticoltura",
    400: "Altri erbivori",
    410: "Bovini da latte",
    500: "Granivori",
    800: "Miste coltivazioni e allevamenti",
}

SIZE = {
    "Piccole": ("PIC", "Piccole"),
    "Medio Piccole": ("MEDP", "Medio Piccole"),
    "Medie": ("MED", "Medie"),
    "Medio Grandi": ("MEDG", "Medio Grandi"),
    "Grandi": ("GRA", "Grandi"),
}

REGION = {
    "Abruzzo": "292",
    "Alto Adige": "242",
    "Basilicata": "312",
    "Calabria": "303",
    "Campania": "302",
    "Emilia Romagna": "260",
    "Friuli Venezia Giulia": "244",
    "Lazio": "291",
    "Liguria": "250",
    "Lombardia": "230",
    "Marche": "281",
    "Molise": "301",
    "Piemonte": "222",
    "Puglia": "311",
    "Sardegna": "330",
    "Sicilia": "320",
    "Toscana": "270",
    "Trentino": "241",
    "Umbria": "282",
    "Valle D'Aosta": "221",
    "Veneto": "243",
}

QUERIES = [
    (
        "universo",
        "anno",
        None,
        {
            "filter[Stratificazione]": "anno",
            "filter[TipoDati]": "universo",
            "filter[IdRegioneUE]": "all",
        },
    ),
    (
        "campionari",
        "anno",
        None,
        {
            "filter[Stratificazione]": "anno",
            "filter[TipoDati]": "campionari",
            "filter[IdRegioneUE][]": "all",
        },
    ),
]

# Cross-section per OTE, dimensione e regione: una query per anno.
for _year in range(2008, REPORT_YEAR + 1):
    for _strat in ("ote", "ude", "terr"):
        _params = {
            "filter[Stratificazione]": _strat,
            "filter[TipoDati]": "universo",
            "filter[Anno]": str(_year),
        }
        if _strat != "terr":
            _params["filter[IdRegioneUE]"] = "all"
        QUERIES.append(("universo", _strat, _year, _params))

FIELDNAMES = [
    "tipo_dati",
    "stratificazione",
    "anno",
    "territorio_codice",
    "territorio",
    "comparto_codice",
    "comparto",
    "indicatore_codice",
    "indicatore",
    "unita",
    "valore",
    "fonte",
    "url",
    "data_accesso",
]


def _download(params: dict[str, str]) -> tuple[bytes, str]:
    query = urllib.parse.urlencode({"report": "c", "type": "excel", **params})
    url = f"{BASE_URL}?{query}"
    last_err: Exception | None = None
    for attempt in range(1, 4):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
            with urllib.request.urlopen(req, timeout=90) as response:
                content = response.read()
            if not content.startswith(b"\xd0\xcf\x11\xe0"):
                raise ValueError(f"Risposta non Excel (primi byte: {content[:8]!r})")
            return content, url
        except Exception as exc:  # noqa: BLE001 - retry esplicito
            last_err = exc
            if attempt < 3:
                time.sleep(attempt * 2)
    raise RuntimeError(f"Download fallito per {url}: {last_err}")


def _text(value: object) -> str:
    text = str(value) if value is not None else ""
    return text.replace("\xa0", " ").strip()


def _number(value: object) -> float | None:
    if isinstance(value, bool) or value is None:
        return None
    if isinstance(value, (int, float)):
        if isinstance(value, float) and math.isnan(value):
            return None
        return float(value)
    text = _text(value).replace(".", "").replace(",", ".")
    if not text:
        return None
    try:
        return float(text)
    except ValueError:
        return None


def _header_columns(
    header: list[object], stratificazione: str, report_year: int
) -> list[tuple[int, object]]:
    columns: list[tuple[int, object]] = []
    for index, raw in enumerate(header[3:], start=3):
        text = _text(raw)
        if stratificazione == "anno":
            year = _number(raw)
            if year is not None and 2008 <= int(year) <= report_year:
                columns.append((index, int(year)))
        elif stratificazione == "ote":
            code = _number(raw)
            if code is not None and int(code) in OTE:
                columns.append((index, int(code)))
        elif stratificazione == "ude":
            if text in SIZE:
                columns.append((index, text))
        elif stratificazione == "terr":
            if text in REGION:
                columns.append((index, text))
    return columns


def _parse_sheet(
    content: bytes,
    *,
    tipo_dati: str,
    stratificazione: str,
    query_year: int | None,
    report_year: int,
    url: str,
) -> list[dict[str, object]]:
    workbook = xlrd.open_workbook(file_contents=content, ignore_workbook_corruption=True)
    sheet = workbook.sheet_by_index(0)

    header_row = None
    for row in range(sheet.nrows):
        if _text(sheet.cell_value(row, 0)) == "Indice":
            header_row = row
            break
    if header_row is None:
        raise ValueError(f"Header 'Indice' non trovato per {url}")

    header = [sheet.cell_value(header_row, col) for col in range(sheet.ncols)]
    columns = _header_columns(header, stratificazione, report_year)
    if not columns:
        raise ValueError(f"Nessuna colonna valida per {stratificazione} in {url}")

    access_date = date.today().isoformat()
    rows: list[dict[str, object]] = []

    for row in range(header_row + 1, sheet.nrows):
        code = _text(sheet.cell_value(row, 0))
        definition = _text(sheet.cell_value(row, 1))
        unit = _text(sheet.cell_value(row, 2))
        if not definition:
            continue
        if not code:
            if "Aziende rappresentate" not in definition:
                continue
            code = "AZIENDE"
            definition = "Aziende rappresentate"
            unit = "numero"

        for col, key in columns:
            value = _number(sheet.cell_value(row, col))
            if value is None:
                continue

            if stratificazione == "anno":
                anno = int(key)
                territorio_codice, territorio = "IT", "Italia"
                comparto_codice, comparto = "ALL", "Italia"
            elif stratificazione == "ote":
                anno = int(query_year or report_year)
                territorio_codice, territorio = "IT", "Italia"
                comparto_codice = str(int(key))
                comparto = OTE[int(key)]
            elif stratificazione == "ude":
                anno = int(query_year or report_year)
                territorio_codice, territorio = "IT", "Italia"
                comparto_codice, comparto = SIZE[str(key)]
            elif stratificazione == "terr":
                anno = int(query_year or report_year)
                territorio_codice = REGION[str(key)]
                territorio = str(key)
                comparto_codice, comparto = "ALL", "Tutte le aziende"
            else:
                raise ValueError(f"Stratificazione non gestita: {stratificazione}")

            rows.append(
                {
                    "tipo_dati": tipo_dati,
                    "stratificazione": stratificazione,
                    "anno": anno,
                    "territorio_codice": territorio_codice,
                    "territorio": territorio,
                    "comparto_codice": comparto_codice,
                    "comparto": comparto,
                    "indicatore_codice": code,
                    "indicatore": definition,
                    "unita": unit,
                    "valore": value,
                    "fonte": "RICA-CREA AREA",
                    "url": url,
                    "data_accesso": access_date,
                }
            )

    return rows


def main() -> int:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    all_rows: list[dict[str, object]] = []

    for tipo_dati, stratificazione, query_year, params in QUERIES:
        content, url = _download(params)
        suffix = f"{tipo_dati}_{stratificazione}_{query_year or 'all'}.xls"
        (DATA_DIR / suffix).write_bytes(content)
        rows = _parse_sheet(
            content,
            tipo_dati=tipo_dati,
            stratificazione=stratificazione,
            query_year=query_year,
            report_year=REPORT_YEAR,
            url=url,
        )
        print(f"{tipo_dati}/{stratificazione}: {len(rows)} righe", file=sys.stderr)
        all_rows.extend(rows)

    if not all_rows:
        print("Nessuna riga estratta", file=sys.stderr)
        return 1

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with OUTPUT.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDNAMES, lineterminator="\n")
        writer.writeheader()
        writer.writerows(all_rows)

    print(f"Scritto {OUTPUT} ({len(all_rows)} righe)", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
