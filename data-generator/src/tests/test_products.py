
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
OUTPUT_DIR = PROJECT_ROOT / "output"
PRODUCTS_FILE = OUTPUT_DIR / "products.csv"


def test_products_file_exists():
    assert PRODUCTS_FILE.exists()


def test_products_file_is_not_empty(products):
    assert len(products) > 0


def test_product_codes_are_unique(products):
    product_codes = [
        product["ProductCode"]
        for product in products
    ]

    assert len(product_codes) == len(set(product_codes))


def test_product_names_and_descriptions_are_not_empty(products):
    for product in products:
        assert product["ProductName"].strip() != ""
        assert product["Description"].strip() != ""


def test_product_prices_are_positive(products):
    for product in products:
        assert float(product["UnitPrice"]) > 0


def test_products_have_valid_currencies(products, currencies):
    valid_currency_codes = {
        currency["CurrencyCode"]
        for currency in currencies
    }

    for product in products:
        assert product["CurrencyCode"] in valid_currency_codes


def test_products_have_valid_units(products, units_of_measure):
    valid_unit_codes = {
        unit["UnitOfMeasureCode"]
        for unit in units_of_measure
    }

    for product in products:
        assert product["UnitOfMeasureCode"] in valid_unit_codes


def test_product_weights_are_valid(products):
    for product in products:
        weight = product["NetWeightKg"]

        if weight != "":
            assert float(weight) > 0


def test_product_active_status_is_valid(products):
    for product in products:
        assert product["IsActive"] in {"0", "1"}
