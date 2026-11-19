import csv
import random

from datetime import datetime, timedelta

from .config import OUTPUT_DIR, RANDOM_SEED
from .csv_utils import save_to_csv


random.seed(RANDOM_SEED)


INVOICE_STATUSES = ["ISSUED", "DRAFT"]

INVOICE_STATUS_WEIGHTS = [75, 25]


def generate_invoices():
    orders_file = OUTPUT_DIR / "orders.csv"
    customers_file = OUTPUT_DIR / "customers.csv"

    with orders_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        orders = list(csv.DictReader(csv_file))

    with customers_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        customers = list(csv.DictReader(csv_file))

    if not orders:
        raise ValueError("Orders CSV is empty. Generate orders first.")

    if not customers:
        raise ValueError("Customers CSV is empty. Generate customers first.")

    customers_by_code = {
        customer["CustomerCode"]: customer
        for customer in customers
    }

    eligible_orders = [
        order
        for order in orders
        if order["OrderStatus"] in ["SHIPPED", "DELIVERED"]
    ]

    invoices = []

    for number, order in enumerate(eligible_orders, start=1):
        customer = customers_by_code[order["CustomerCode"]]

        order_date = datetime.strptime(
            order["OrderDate"],
            "%Y-%m-%d %H:%M:%S",
        ).date()

        today = datetime.now().date()

        days_since_order = (today - order_date).days

        invoice_date = order_date + timedelta(
            days=random.randint(
                0,
                min(30, days_since_order),
            )
        )

        due_date = invoice_date + timedelta(
            days=random.choice([14, 30]),
        )

        invoice = {
            "InvoiceNumber": f"INV-{invoice_date.year}-{number:06d}",
            "OrderNumber": order["OrderNumber"],
            "InvoiceDate": invoice_date.strftime("%Y-%m-%d"),
            "DueDate": due_date.strftime("%Y-%m-%d"),
            "InvoiceStatus": random.choices(
                INVOICE_STATUSES,
                weights=INVOICE_STATUS_WEIGHTS,
                k=1,
            )[0],
            "CurrencyCode": order["CurrencyCode"],
            "BillToName": customer["CompanyName"],
            "BillToStreetAddress": customer["StreetAddress"],
            "BillToCity": customer["City"],
            "BillToPostalCode": customer["PostalCode"],
            "BillToCountryCode": customer["CountryCode"],
        }

        invoices.append(invoice)

    save_to_csv("invoices.csv", invoices)


if __name__ == "__main__":
    generate_invoices()
