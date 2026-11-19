import random
import re
import unicodedata

from faker import Faker

from .config import CUSTOMERS_COUNT, OUTPUT_DIR, RANDOM_SEED
from .reference_data import COUNTRIES
from .csv_utils import save_to_csv


Faker.seed(RANDOM_SEED)
random.seed(RANDOM_SEED)

FAKERS = {
    "PL": Faker("pl_PL"),
    "DE": Faker("de_DE"),
    "CZ": Faker("cs_CZ"),
    "SK": Faker("sk_SK"),
    "AT": Faker("de_AT"),
    "NL": Faker("nl_NL"),
    "BE": Faker("fr_BE"),
    "FR": Faker("fr_FR"),
    "IT": Faker("it_IT"),
    "ES": Faker("es_ES"),
    "GB": Faker("en_GB"),
    "US": Faker("en_US"),
    "CA": Faker("en_CA"),
    "SE": Faker("sv_SE"),
    "NO": Faker("no_NO"),
}


def generate_email(contact_name, company_name):
    def clean(value):
        value = unicodedata.normalize("NFKD", value)
        value = value.encode("ascii", "ignore").decode("ascii")
        value = value.lower()
        return re.sub(r"[^a-z0-9]", "", value)

    name_parts = contact_name.split()

    first_name = clean(name_parts[0])
    last_name = clean(name_parts[-1])

    company = "".join(clean(part) for part in company_name.split())

    return f"{first_name}.{last_name}@{company}.test"


def generate_customers():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    countries = [country["CountryCode"] for country in COUNTRIES]

    customers = []

    for number in range(1, CUSTOMERS_COUNT + 1):
        country_code = random.choice(countries)
        fake = FAKERS[country_code]

        customer = {
            "CustomerCode": f"CUST-{number:05d}",
            "CompanyName": fake.company(),
            "ContactName": fake.name(),
            "Phone": fake.phone_number(),
            "StreetAddress": fake.street_address(),
            "City": fake.city(),
            "PostalCode": fake.postcode(),
            "CountryCode": country_code,
            "CreatedAt": fake.date_time_between(
                start_date="-3y",
                end_date="now",
            ).strftime("%Y-%m-%d %H:%M:%S"),
            "IsActive": random.choice([1, 1, 1, 0]),
        }

        customer["Email"] = generate_email(
            customer["ContactName"],
            customer["CompanyName"],
        )

        customers.append(customer)

    save_to_csv("customers.csv", customers)


if __name__ == "__main__":
    generate_customers()
