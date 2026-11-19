import csv
import random

from decimal import Decimal, ROUND_HALF_UP

from .config import OUTPUT_DIR, RANDOM_SEED
from .csv_utils import save_to_csv


random.seed(RANDOM_SEED)


def generate_order_details():
    orders_file = OUTPUT_DIR / "orders.csv"
    products_file = OUTPUT_DIR / "products.csv"
    exchange_rates_file = OUTPUT_DIR / "exchange_rates.csv"

    with orders_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        orders = list(csv.DictReader(csv_file))

    with products_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        products = list(csv.DictReader(csv_file))

    with exchange_rates_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        exchange_rates_data = list(csv.DictReader(csv_file))

    if not orders:
        raise ValueError("Orders CSV is empty. Generate orders first.")

    if not products:
        raise ValueError("Products CSV is empty. Generate products first.")

    exchange_rates = {
        row["CurrencyCode"]: Decimal(row["ExchangeRate"])
        for row in exchange_rates_data
    }

    active_products = [
        product
        for product in products
        if product["IsActive"] == "1"
    ]

    if not active_products:
        raise ValueError("No active products available.")

    order_details = []

    for order in orders:
        selected_products = random.sample(
            active_products,
            min(random.randint(1, 5), len(active_products)),
        )

        for line_number, product in enumerate(selected_products, start=1):
            product_price = Decimal(product["UnitPrice"])

            price_in_eur = (
                product_price * exchange_rates[product["CurrencyCode"]]
            )

            unit_price = (
                price_in_eur / exchange_rates[order["CurrencyCode"]]
            ).quantize(
                Decimal("0.0001"),
                rounding=ROUND_HALF_UP,
            )

            order_detail = {
                "OrderNumber": order["OrderNumber"],
                "LineNumber": line_number,
                "ProductCode": product["ProductCode"],
                "Quantity": f"{random.randint(1, 50):.3f}",
                "UnitOfMeasureCode": product["UnitOfMeasureCode"],
                "UnitPrice": f"{unit_price:.4f}",
                "DiscountPercent": "0.00",
                "TaxRatePercent": "23.00",
            }

            order_details.append(order_detail)

    save_to_csv("order_details.csv", order_details)


if __name__ == "__main__":
    generate_order_details()
