import csv
import random

from datetime import datetime, timedelta
from decimal import Decimal, ROUND_HALF_UP

from .config import OUTPUT_DIR, RANDOM_SEED
from .csv_utils import save_to_csv


random.seed(RANDOM_SEED)


PAYMENT_METHODS = [
    "BANK_TRANSFER",
    "CARD",
    "CASH",
    "DIRECT_DEBIT",
    "OTHER",
]

PAYMENT_METHOD_WEIGHTS = [55, 25, 5, 10, 5]

PAYMENT_STATUSES = [
    "COMPLETED",
    "PENDING",
    "FAILED",
    "CANCELLED",
]

PAYMENT_STATUS_WEIGHTS = [70, 20, 7, 3]


def generate_payments():
    invoices_file = OUTPUT_DIR / "invoices.csv"
    invoice_lines_file = OUTPUT_DIR / "invoice_lines.csv"

    with invoices_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        invoices = list(csv.DictReader(csv_file))

    with invoice_lines_file.open("r", newline="", encoding="utf-8-sig") as csv_file:
        invoice_lines = list(csv.DictReader(csv_file))

    if not invoices:
        raise ValueError("Invoices CSV is empty. Generate invoices first.")

    if not invoice_lines:
        raise ValueError("Invoice lines CSV is empty. Generate invoice lines first.")

    invoice_totals = {}

    for invoice_line in invoice_lines:
        invoice_number = invoice_line["InvoiceNumber"]

        quantity = Decimal(invoice_line["Quantity"])
        unit_price = Decimal(invoice_line["UnitPrice"])
        discount_percent = Decimal(invoice_line["DiscountPercent"])
        tax_rate_percent = Decimal(invoice_line["TaxRatePercent"])

        discount = discount_percent / Decimal("100")
        tax_rate = tax_rate_percent / Decimal("100")

        line_net_amount = (
            quantity * unit_price * (Decimal("1") - discount)
        )

        line_total = line_net_amount * (Decimal("1") + tax_rate)

        invoice_totals[invoice_number] = (
            invoice_totals.get(invoice_number, Decimal("0")) + line_total
        )

    payments = []

    today = datetime.now()

    payment_number = 1

    for invoice in invoices:
        if invoice["InvoiceStatus"] != "ISSUED":
            continue

        invoice_number = invoice["InvoiceNumber"]

        if invoice_number not in invoice_totals:
            raise ValueError(f"No invoice lines found for {invoice_number}")

        invoice_date = datetime.strptime(invoice["InvoiceDate"], "%Y-%m-%d")

        days_since_invoice = max(0, (today.date() - invoice_date.date()).days)

        payment_datetime = invoice_date + timedelta(
            days=random.randint(0, min(days_since_invoice, 30))
        )

        payment_status = random.choices(
            PAYMENT_STATUSES,
            weights=PAYMENT_STATUS_WEIGHTS,
            k=1,
        )[0]

        payment = {
            "PaymentReference": f"PAY-{payment_number:06d}",
            "InvoiceNumber": invoice_number,
            "PaymentDateTime": payment_datetime.strftime(
                "%Y-%m-%d %H:%M:%S"
            ),
            "Amount": str(
                invoice_totals[invoice_number].quantize(
                    Decimal("0.0001"),
                    rounding=ROUND_HALF_UP,
                )
            ),
            "PaymentMethod": random.choices(
                PAYMENT_METHODS,
                weights=PAYMENT_METHOD_WEIGHTS,
                k=1,
            )[0],
            "PaymentStatus": payment_status,
            "ExternalTransactionReference": (
                f"EXT-{random.randint(10000000, 99999999)}"
                if payment_status in ["COMPLETED", "FAILED"]
                else ""
            ),
        }

        payments.append(payment)
        payment_number += 1

    save_to_csv("payments.csv", payments)


if __name__ == "__main__":
    generate_payments()
