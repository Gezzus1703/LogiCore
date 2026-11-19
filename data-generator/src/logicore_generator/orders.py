import csv
import random

from faker import Faker

from .config import ORDERS_COUNT, OUTPUT_DIR, RANDOM_SEED
from .reference_data import CURRENCIES
from .csv_utils import save_to_csv


Faker.seed(RANDOM_SEED)
random.seed(RANDOM_SEED)

fake = Faker("en_US")


ORDER_STATUSES = [
    "NEW",
    "CONFIRMED",
    "PROCESSING",
    "PARTIALLY_SHIPPED",
    "SHIPPED",
    "DELIVERED",
    "CANCELLED",
]

ORDER_STATUS_WEIGHTS = [10, 15, 20, 10, 15, 25, 5]


def generate_orders():
    customers_file = OUTPUT_DIR / "customers.csv"

    with customers_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        customers = list(csv.DictReader(csv_file))

    if not customers:
        raise ValueError("Customers CSV is empty. Generate customers first.")

    orders = []

    for number in range(1, ORDERS_COUNT + 1):
        customer = random.choice(customers)

        order_date = fake.date_time_between(
            start_date="-2y",
            end_date="now",
        )

        delivery_date = fake.date_between(
            start_date=order_date.date(),
            end_date="+30d",
        )

        order = {
            "OrderNumber": f"ORD-{number:06d}",
            "CustomerCode": customer["CustomerCode"],
            "OrderDate": order_date.strftime("%Y-%m-%d %H:%M:%S"),
            "RequestedDeliveryDate": delivery_date.strftime("%Y-%m-%d"),
            "OrderStatus": random.choices(
                ORDER_STATUSES,
                weights=ORDER_STATUS_WEIGHTS,
            )[0],
            "CurrencyCode": random.choice(CURRENCIES)["CurrencyCode"],
            "ShipToName": customer["CompanyName"],
            "ShipToStreetAddress": customer["StreetAddress"],
            "ShipToCity": customer["City"],
            "ShipToPostalCode": customer["PostalCode"],
            "ShipToCountryCode": customer["CountryCode"],
        }

        if random.random() < 0.15:
            order["RequestedDeliveryDate"] = ""

        if random.random() < 0.10:
            order["ShipToName"] = ""
            order["ShipToStreetAddress"] = ""
            order["ShipToCity"] = ""
            order["ShipToPostalCode"] = ""
            order["ShipToCountryCode"] = ""

        orders.append(order)

    save_to_csv("orders.csv", orders)


if __name__ == "__main__":
    generate_orders()
