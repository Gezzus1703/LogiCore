import csv

from .config import OUTPUT_DIR
from .csv_utils import save_to_csv


def generate_invoice_lines():
    invoices_file = OUTPUT_DIR / "invoices.csv"
    order_details_file = OUTPUT_DIR / "order_details.csv"
    products_file = OUTPUT_DIR / "products.csv"

    with invoices_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        invoices = list(csv.DictReader(csv_file))

    with order_details_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        order_details = list(csv.DictReader(csv_file))

    with products_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        products = list(csv.DictReader(csv_file))

    if not invoices:
        raise ValueError("Invoices CSV is empty. Generate invoices first.")

    if not order_details:
        raise ValueError("Order details CSV is empty. Generate order details first.")

    if not products:
        raise ValueError("Products CSV is empty. Generate products first.")

    invoices_by_order = {
        invoice["OrderNumber"]: invoice
        for invoice in invoices
    }

    products_by_code = {
        product["ProductCode"]: product
        for product in products
    }

    invoice_lines = []

    for order_detail in order_details:
        order_number = order_detail["OrderNumber"]

        if order_number not in invoices_by_order:
            continue

        invoice = invoices_by_order[order_number]

        product = products_by_code[order_detail["ProductCode"]]

        invoice_line = {
            "InvoiceNumber": invoice["InvoiceNumber"],
            "OrderNumber": order_number,
            "LineNumber": order_detail["LineNumber"],
            "ProductCode": order_detail["ProductCode"],
            "LineDescription": product["ProductName"],
            "Quantity": order_detail["Quantity"],
            "UnitOfMeasureCode": order_detail["UnitOfMeasureCode"],
            "UnitPrice": order_detail["UnitPrice"],
            "DiscountPercent": order_detail["DiscountPercent"],
            "TaxRatePercent": order_detail["TaxRatePercent"],
        }

        invoice_lines.append(invoice_line)

    save_to_csv("invoice_lines.csv", invoice_lines)


if __name__ == "__main__":
    generate_invoice_lines()
