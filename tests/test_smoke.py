"""Smoke test del contratto repo: dataset attesi e file minimi.

Non duplica la validazione del toolkit (preflight/run): verifica solo che il
repo esponga i 6 dataset, il compose e i file dichiarati.
"""

from __future__ import annotations

from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_DATASETS = {
    "eurostat-hicp-prezzi-consumo",
    "eurostat-prezzi-agricoli",
    "eurostat-sbs-food-retail",
    "istat-nic-prezzi-consumo",
    "istat-prezzi-agricoli",
    "rica-area-redditi",
}
EXPECTED_COMPOSES = {"filiere-valore-aggiunto"}


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


@pytest.mark.contract
def test_food_retail_adapter_present() -> None:
    assert (ROOT / "datasets" / "eurostat-sbs-food-retail" / "extract.py").is_file()


@pytest.mark.contract
def test_expected_composes_present() -> None:
    dirs = {p.name for p in (ROOT / "compose").iterdir() if p.is_dir()}
    assert dirs == EXPECTED_COMPOSES, f"Compose inattesi: {dirs ^ EXPECTED_COMPOSES}"


@pytest.mark.contract
def test_compose_minimum_files() -> None:
    for slug in EXPECTED_COMPOSES:
        base = ROOT / "compose" / slug
        assert (base / "dataset.yml").is_file(), f"{slug}: manca dataset.yml"
        assert list((base / "sql").glob("mart_*.sql")), f"{slug}: manca sql/mart_*.sql"


@pytest.mark.contract
def test_compose_uses_food_retail() -> None:
    base = ROOT / "compose" / "filiere-valore-aggiunto"
    sql = (base / "sql" / "mart_filiere_stadi.sql").read_text(encoding="utf-8")
    config = (base / "dataset.yml").read_text(encoding="utf-8")
    assert "support.food_retail" in sql
    assert "retail_alimentare" in sql
    assert "food_retail" in config
