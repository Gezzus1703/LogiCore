
from datetime import datetime

from logicore_generator.invoices import INVOICE_STATUSES


def test_invoices_file_is_not_empty(invoices):
    assert len(invoices) > 0


def test_invoice_numbers_are_unique(invoices):
    invoice_numbers = [invoice["InvoiceNumber"] for invoice in invoices]

    assert len(invoice_numbers) == len(set(invoice_numbers))


def test_invoice_numbers_are_not_empty(invoices):
    assert all(invoice["InvoiceNumber"] for invoice in invoices)


def test_invoice_orders_exist(invoices, orders):
    order_numbers = {order["OrderNumber"] for order in orders}

    assert all(
        invoice["OrderNumber"] in order_numbers
        for invoice in invoices
    )


def test_invoice_statuses_are_valid(invoices):
    assert all(
        invoice["InvoiceStatus"] in INVOICE_STATUSES
        for invoice in invoices
    )


def test_invoice_dates_are_valid(invoices):
    for invoice in invoices:
        datetime.strptime(invoice["InvoiceDate"], "%Y-%m-%d")


def test_due_dates_are_valid(invoices):
    for invoice in invoices:
        datetime.strptime(invoice["DueDate"], "%Y-%m-%d")


def test_due_dates_are_not_before_invoice_dates(invoices):
    for invoice in invoices:
        invoice_date = datetime.strptime(
            invoice["InvoiceDate"], "%Y-%m-%d"
        ).date()

        due_date = datetime.strptime(
            invoice["DueDate"], "%Y-%m-%d"
        ).date()

        assert due_date >= invoice_date


def test_invoice_currencies_exist(invoices, currencies):
    currency_codes = {currency["CurrencyCode"] for currency in currencies}

    assert all(
        invoice["CurrencyCode"] in currency_codes
        for invoice in invoices
    )
