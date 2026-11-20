import csv
from pathlib import Path

import pytest


PROJECT_ROOT = Path(__file__).resolve().parents[2]
OUTPUT_DIR = PROJECT_ROOT / "output"


@pytest.fixture
def customers():
    file_path = OUTPUT_DIR / "customers.csv"

    with file_path.open(newline="", encoding="utf-8-sig") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def countries():
    file_path = OUTPUT_DIR / "countries.csv"

    with file_path.open(newline="", encoding="utf-8-sig") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def products():
    file_path = OUTPUT_DIR / "products.csv"

    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def currencies():
    file_path = OUTPUT_DIR / "currencies.csv"

    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def units_of_measure():
    file_path = OUTPUT_DIR / "units_of_measure.csv"


    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def orders():
    file_path = OUTPUT_DIR / "orders.csv"

    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def order_details():
    file_path = OUTPUT_DIR / "order_details.csv"

    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def invoices():
    file_path = OUTPUT_DIR / "invoices.csv"

    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def invoice_lines():
    file_path = OUTPUT_DIR / "invoice_lines.csv"

    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def payments():
    file_path = OUTPUT_DIR / "payments.csv"

    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))


@pytest.fixture
def countries():
    file_path = OUTPUT_DIR / "countries.csv"

    with file_path.open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))