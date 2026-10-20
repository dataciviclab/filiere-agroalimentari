#!/usr/bin/env python3
"""Eurostat SBS — retail alimentare, 2008-2024.

Due dataset Eurostat coprono periodi diversi:
  - sbs_na_dt_r2  2008-2020  VA at factor cost, personnel costs, enterprises
  - sbs_ovw_act   2021-2024  value added, employee benefits expense, hours, enterprises

Il perimetro food retail e' la somma di NACE:
  4711 + 4721 + 4722 + 4723 + 4724 + 4725 + 4729 + 4781
Sono esclusi tabacco (4726), non-food (4719) e online (479).

Uso (toolkit raw source):
    python3 extract.py raw.csv
"""

from __future__ import annotations

import csv
import json
import sys
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Any

API = "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/{dataset}"
USER_AGENT = "DataCivicLab/1.0 (+https://dataciviclab.org)"
OUTPUT = Path(sys.argv[1] if len(sys.argv) > 1 else "raw.csv")

FOOD_RETAIL: dict[str, tuple[str, str]] = {
    "G4711": ("4711", "Supermercati, discount e minimercati"),
    "G4721": ("4721", "Frutta e verdura"),
    "G4722": ("4722", "Carne e prodotti a base di carne"),
    "G4723": ("4723", "Pesce, crostacei e molluschi"),
    "G4724": ("4724", "Pane, dolci e prodotti da forno"),
    "G4725": ("4725", "Bevande"),
    "G4729": ("4729", "Altri alimentari specializzati"),
    "G4781": ("4781", "Mercati e banchi alimentari"),
}

FIELDNAMES = [
    "anno",
    "nace_codice",
    "nace",
    "va_eur",
    "costo_lavoro_eur",
    "ore",
    "imprese",
    "fonte_dataset",
    "definizione_costo_lavoro",
]


def _fetch(dataset: str, dimension: str, indicators: list[str]) -> dict[str, Any]:
    params = [("format", "JSON"), ("lang", "EN"), ("geo", "IT")]
    for code in FOOD_RETAIL:
        params.append((dimension, code))
    for code in indicators:
        params.append(("indic_sb" if dataset == "sbs_na_dt_r2" else "indic_sbs", code))
    url = API.format(dataset=dataset) + "?" + urllib.parse.urlencode(params)
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(request, timeout=120) as response:
        return json.load(response)


def _flatten(data: dict[str, Any]) -> list[dict[str, Any]]:
    ids = data["id"]
    sizes = data["size"]
    dimensions = data["dimension"]

    positions: list[dict[int, str]] = []
    for name in ids:
        category = dimensions[name]["category"]
        index = category.get("index")
        if isinstance(index, dict):
            positions.append({int(pos): code for code, pos in index.items()})
        else:
            positions.append({pos: code for pos, code in enumerate(index)})

    rows: list[dict[str, Any]] = []
    for flat, value in data.get("value", {}).items():
        if value is None:
            continue
        remaining = int(flat)
        coords = [0] * len(sizes)
        for i in range(len(sizes) - 1, -1, -1):
            coords[i] = remaining % sizes[i]
            remaining //= sizes[i]
        row = {ids[i]: positions[i][coords[i]] for i in range(len(ids))}
        row["value"] = value
        rows.append(row)
    return rows


def _collect(
    dataset: str,
    dimension: str,
    metrics: dict[str, tuple[str, float]],
    years: range,
    definition: str,
) -> dict[tuple[int, str], dict[str, Any]]:
    data = _fetch(dataset, dimension, [code for code, _ in metrics.values()])
    indicator_to_metric = {code: metric for metric, (code, _) in metrics.items()}
    result: dict[tuple[int, str], dict[str, Any]] = {}

    for row in _flatten(data):
        nace = row.get(dimension)
        indicator = row.get("indic_sb" if dataset == "sbs_na_dt_r2" else "indic_sbs")
        year = row.get("time")
        if nace not in FOOD_RETAIL or indicator not in indicator_to_metric or year is None:
            continue
        year_int = int(year)
        if year_int not in years:
            continue

        metric = indicator_to_metric[indicator]
        multiplier = metrics[metric][1]
        key = (year_int, FOOD_RETAIL[nace][0])
        record = result.setdefault(
            key,
            {
                "anno": year_int,
                "nace_codice": FOOD_RETAIL[nace][0],
                "nace": FOOD_RETAIL[nace][1],
                "va_eur": None,
                "costo_lavoro_eur": None,
                "ore": None,
                "imprese": None,
                "fonte_dataset": dataset,
                "definizione_costo_lavoro": definition,
            },
        )
        record[metric] = float(row["value"]) * multiplier

    return result


def main() -> None:
    metrics_old = {
        "va_eur": ("V12150", 1_000_000.0),
        "costo_lavoro_eur": ("V13310", 1_000_000.0),
        "imprese": ("V11110", 1.0),
    }
    metrics_new = {
        "va_eur": ("AV_MEUR", 1_000_000.0),
        "costo_lavoro_eur": ("EXPN_SAL_BEN_MEUR", 1_000_000.0),
        "ore": ("HW_NR", 1.0),
        "imprese": ("ENT_NR", 1.0),
    }

    records = _collect(
        "sbs_na_dt_r2",
        "nace_r2",
        metrics_old,
        range(2008, 2021),
        "personnel_costs",
    )
    records.update(
        _collect(
            "sbs_ovw_act",
            "nace_r2",
            metrics_new,
            range(2021, 2025),
            "employee_benefits_expense",
        )
    )

    rows = sorted(records.values(), key=lambda row: (row["anno"], row["nace_codice"]))
    if not rows:
        raise SystemExit("Nessuna riga Eurostat SBS estratta")

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with OUTPUT.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDNAMES, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)

    print(f"Scritte {len(rows)} righe in {OUTPUT}")


if __name__ == "__main__":
    main()
