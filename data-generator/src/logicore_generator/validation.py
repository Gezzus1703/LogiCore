import csv
from decimal import Decimal

from .config import OUTPUT_DIR


def read_csv(file_name):
    with (OUTPUT_DIR / file_name).open("r", newline="", encoding="utf-8-sig") as file:
        return list(csv.DictReader(file))


def validate_data():
    print("\nStarting LogiCore data validation...\n")

    files = [
        "countries.csv",
        "currencies.csv",
        "units_of_measure.csv",
        "customers.csv",
        "products.csv",
        "orders.csv",
        "order_details.csv",
        "invoices.csv",
        "invoice_lines.csv",
        "payments.csv",
    ]

    data = {}

    for file_name in files:
        file_path = OUTPUT_DIR / file_name

        if not file_path.exists():
            print(f"FAIL: {file_name} does not exist.")
            return False

        data[file_name] = read_csv(file_name)

        if not data[file_name]:
            print(f"FAIL: {file_name} is empty.")
            return False

        print(f"OK: {file_name} - {len(data[file_name])} rows")

    print("\nChecking duplicate business keys...")

    unique_keys = {
        "countries.csv": "CountryCode",
        "currencies.csv": "CurrencyCode",
        "units_of_measure.csv": "UnitOfMeasureCode",
        "customers.csv": "CustomerCode",
        "products.csv": "ProductCode",
        "orders.csv": "OrderNumber",
        "invoices.csv": "InvoiceNumber",
        "payments.csv": "PaymentReference",
    }

    for file_name, column in unique_keys.items():
        values = [row[column] for row in data[file_name]]

        if len(values) != len(set(values)):
            print(f"FAIL: Duplicate values in {file_name}.{column}")
            return False

    print("OK: No duplicate business keys.")

    print("\nChecking relationships...")

    customers = {row["CustomerCode"] for row in data["customers.csv"]}
    products = {row["ProductCode"] for row in data["products.csv"]}
    orders = {row["OrderNumber"] for row in data["orders.csv"]}
    invoices = {row["InvoiceNumber"] for row in data["invoices.csv"]}

    for order in data["orders.csv"]:
        if order["CustomerCode"] not in customers:
            print(f"FAIL: Unknown customer in {order['OrderNumber']}")
            return False

    for detail in data["order_details.csv"]:
        if detail["OrderNumber"] not in orders:
            print("FAIL: Order detail references an unknown order.")
            return False

        if detail["ProductCode"] not in products:
            print("FAIL: Order detail references an unknown product.")
            return False

    for invoice in data["invoices.csv"]:
        if invoice["OrderNumber"] not in orders:
            print("FAIL: Invoice references an unknown order.")
            return False

    for line in data["invoice_lines.csv"]:
        if line["InvoiceNumber"] not in invoices:
            print("FAIL: Invoice line references an unknown invoice.")
            return False

    for payment in data["payments.csv"]:
        if payment["InvoiceNumber"] not in invoices:
            print("FAIL: Payment references an unknown invoice.")
            return False

    print("OK: All checked relationships are valid.")

    print("\nChecking numeric values...")

    for file_name, column in [
        ("products.csv", "UnitPrice"),
        ("order_details.csv", "Quantity"),
        ("order_details.csv", "UnitPrice"),
        ("invoice_lines.csv", "Quantity"),
        ("invoice_lines.csv", "UnitPrice"),
        ("payments.csv", "Amount"),
    ]:
        for row in data[file_name]:
            if Decimal(row[column]) <= 0:
                print(f"FAIL: Invalid {column} in {file_name}.")
                return False

    print("OK: All checked numeric values are positive.")

    print("\nChecking payment statuses...")

    allowed_statuses = {
        "PENDING",
        "COMPLETED",
        "FAILED",
        "CANCELLED",
    }

    for payment in data["payments.csv"]:
        if payment["PaymentStatus"] not in allowed_statuses:
            print("FAIL: Invalid payment status.")
            return False

    print("OK: Payment statuses are valid.")

    print("\nLogiCore data validation completed successfully.")
    return True


if __name__ == "__main__":
    validate_data()