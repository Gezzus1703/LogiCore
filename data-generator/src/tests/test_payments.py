
from datetime import datetime
from decimal import Decimal

from logicore_generator.payments import PAYMENT_METHODS, PAYMENT_STATUSES


def test_payments_file_is_not_empty(payments):
    assert len(payments) > 0


def test_payment_references_are_unique(payments):
    references = [payment["PaymentReference"] for payment in payments]

    assert len(references) == len(set(references))


def test_payment_references_are_not_empty(payments):
    assert all(payment["PaymentReference"] for payment in payments)


def test_invoice_numbers_exist(payments, invoices):
    invoice_numbers = {invoice["InvoiceNumber"] for invoice in invoices}

    assert all(
        payment["InvoiceNumber"] in invoice_numbers
        for payment in payments
    )


def test_payment_amounts_are_positive(payments):
    assert all(
        Decimal(payment["Amount"]) > 0
        for payment in payments
    )


def test_payment_dates_are_valid(payments):
    for payment in payments:
        datetime.strptime(
            payment["PaymentDateTime"],
            "%Y-%m-%d %H:%M:%S",
        )


def test_payment_methods_are_valid(payments):
    assert all(
        payment["PaymentMethod"] in PAYMENT_METHODS
        for payment in payments
    )


def test_payment_statuses_are_valid(payments):
    assert all(
        payment["PaymentStatus"] in PAYMENT_STATUSES
        for payment in payments
    )


def test_external_transaction_references_are_unique_when_present(payments):
    references = [
        payment["ExternalTransactionReference"]
        for payment in payments
        if payment["ExternalTransactionReference"]
    ]

    assert len(references) == len(set(references))


def test_external_transaction_references_are_not_empty_for_completed_payments(payments):
    completed_payments = [
        payment
        for payment in payments
        if payment["PaymentStatus"] == "Completed"
    ]

    assert all(
        payment["ExternalTransactionReference"]
        for payment in completed_payments
    )
