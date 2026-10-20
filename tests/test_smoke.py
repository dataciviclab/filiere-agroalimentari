"""Smoke test del contratto repo: dataset attesi e file minimi.

Non duplica la validazione del toolkit (preflight/run): verifica solo che il
repo esponga i 5 dataset e i file dichiarati.
"""

from __future__ import annotations

from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_DATASETS = {
    "eurostat-hicp-prezzi-consumo",
    "eurostat-prezzi-agricoli",
    "istat-nic-prezzi-consumo",
    "istat-prezzi-agricoli",
    "rica-area-redditi",
}


@pytest.mark.contract
def test_expected_datasets_present() -> None:
    dirs = {p.name for p in (ROOT / "datasets").iterdir() if p.is_dir()}
    assert dirs == EXPECTED_DATASETS, f"Dataset inattesi: {dirs ^ EXPECTED_DATASETS}"


@pytest.mark.contract
def test_dataset_minimum_files() -> None:
    for slug in EXPECTED_DATASETS:
        base = ROOT / "datasets" / slug
        assert (base / "dataset.yml").is_file(), f"{slug}: manca dataset.yml"
        assert (base / "sql" / "clean.sql").is_file(), f"{slug}: manca sql/clean.sql"
        assert list((base / "sql").glob("mart_*.sql")), f"{slug}: manca sql/mart_*.sql"


@pytest.mark.contract
def test_rica_adapter_present() -> None:
    assert (ROOT / "datasets" / "rica-area-redditi" / "extract.py").is_file()
