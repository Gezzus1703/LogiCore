
from collections import defaultdict
from decimal import Decimal


def test_invoice_lines_file_is_not_empty(invoice_lines):
    assert len(invoice_lines) > 0


def test_invoice_line_keys_are_unique(invoice_lines):
    keys = [
        (row["InvoiceNumber"], row["LineNumber"])
        for row in invoice_lines
    ]

    assert len(keys) == len(set(keys))


def test_invoice_numbers_exist(invoice_lines, invoices):
    invoice_numbers = {invoice["InvoiceNumber"] for invoice in invoices}

    assert all(
        row["InvoiceNumber"] in invoice_numbers
        for row in invoice_lines
    )


def test_order_numbers_match_invoice_orders(invoice_lines, invoices):
    invoice_orders = {
        invoice["InvoiceNumber"]: invoice["OrderNumber"]
        for invoice in invoices
    }

    assert all(
        row["OrderNumber"] == invoice_orders[row["InvoiceNumber"]]
        for row in invoice_lines
    )


def test_product_codes_exist(invoice_lines, products):
    product_codes = {product["ProductCode"] for product in products}

    assert all(
        row["ProductCode"] in product_codes
        for row in invoice_lines
    )


def test_quantities_are_positive(invoice_lines):
    assert all(
        Decimal(row["Quantity"]) > 0
        for row in invoice_lines
    )


def test_unit_prices_are_positive(invoice_lines):
    assert all(
        Decimal(row["UnitPrice"]) > 0
        for row in invoice_lines
    )


def test_discount_percentages_are_valid(invoice_lines):
    assert all(
        Decimal("0") <= Decimal(row["DiscountPercent"]) <= Decimal("100")
        for row in invoice_lines
    )


def test_tax_rates_are_not_negative(invoice_lines):
    assert all(
        Decimal(row["TaxRatePercent"]) >= 0
        for row in invoice_lines
    )


def test_line_numbers_start_at_one(invoice_lines):
    invoice_lines_by_number = defaultdict(list)

    for row in invoice_lines:
        invoice_lines_by_number[row["InvoiceNumber"]].append(
            int(row["LineNumber"])
        )

    for line_numbers in invoice_lines_by_number.values():
        assert min(line_numbers) == 1


def test_line_numbers_are_sequential(invoice_lines):
    invoice_lines_by_number = defaultdict(list)

    for row in invoice_lines:
        invoice_lines_by_number[row["InvoiceNumber"]].append(
            int(row["LineNumber"])
        )

    for line_numbers in invoice_lines_by_number.values():
        assert sorted(line_numbers) == list(
            range(1, len(line_numbers) + 1)
        )


def test_line_descriptions_are_not_empty(invoice_lines):
    assert all(row["LineDescription"].strip() for row in invoice_lines)


def test_units_of_measure_exist(invoice_lines, units_of_measure):
    unit_codes = {unit["UnitOfMeasureCode"] for unit in units_of_measure}

    assert all(
        row["UnitOfMeasureCode"] in unit_codes
        for row in invoice_lines
    )
