
from datetime import datetime

import pytest

from logicore_generator.orders import ORDER_STATUSES

def test_orders_file_is_not_empty(orders):
    assert len(orders) > 0


def test_order_numbers_are_unique(orders):
    order_numbers = [order["OrderNumber"] for order in orders]

    assert len(order_numbers) == len(set(order_numbers))


def test_order_numbers_are_not_empty(orders):
    assert all(order["OrderNumber"] for order in orders)


def test_order_customers_exist(orders, customers):
    customer_codes = {customer["CustomerCode"] for customer in customers}

    assert all(
        order["CustomerCode"] in customer_codes
        for order in orders
    )


def test_order_currencies_exist(orders, currencies):
    currency_codes = {currency["CurrencyCode"] for currency in currencies}

    assert all(
        order["CurrencyCode"] in currency_codes
        for order in orders
    )


def test_order_statuses_are_valid(orders):
    assert all(
        order["OrderStatus"] in ORDER_STATUSES
        for order in orders
    )


def test_order_dates_are_valid(orders):
    for order in orders:
        datetime.strptime(order["OrderDate"], "%Y-%m-%d %H:%M:%S")


def test_requested_delivery_dates_are_valid(orders):
    for order in orders:
        delivery_date = order["RequestedDeliveryDate"]

        if delivery_date:
            datetime.strptime(delivery_date, "%Y-%m-%d")


def test_delivery_date_is_not_before_order_date(orders):
    for order in orders:
        delivery_date = order["RequestedDeliveryDate"]

        if delivery_date:
            order_date = datetime.strptime(
                order["OrderDate"],
                "%Y-%m-%d %H:%M:%S",
            ).date()

            requested_date = datetime.strptime(
                delivery_date,
                "%Y-%m-%d",
            ).date()

            assert requested_date >= order_date


def test_shipping_address_fields_are_consistent(orders):
    address_fields = [
        "ShipToName",
        "ShipToStreetAddress",
        "ShipToCity",
        "ShipToPostalCode",
        "ShipToCountryCode",
    ]

    for order in orders:
        values = [order[field] for field in address_fields]

        assert all(values) or not any(values)
