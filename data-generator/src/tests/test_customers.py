
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
OUTPUT_DIR = PROJECT_ROOT / "output"
CUSTOMERS_FILE = OUTPUT_DIR / "customers.csv"


def test_customers_file_exists():
    assert CUSTOMERS_FILE.exists()


def test_customers_file_is_not_empty(customers):
    assert len(customers) > 0


def test_customer_codes_are_unique(customers):
    customer_codes = [
        customer["CustomerCode"]
        for customer in customers
    ]

    assert len(customer_codes) == len(set(customer_codes))


def test_customer_company_names_are_not_empty(customers):
    for customer in customers:
        assert customer["CompanyName"].strip() != ""


def test_customers_have_valid_country_codes(customers, countries):
    valid_country_codes = {
        country["CountryCode"]
        for country in countries
    }

    for customer in customers:
        assert customer["CountryCode"] in valid_country_codes
