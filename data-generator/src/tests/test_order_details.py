
from collections import defaultdict
from decimal import Decimal


def test_order_details_file_is_not_empty(order_details):
    assert len(order_details) > 0


def test_order_detail_keys_are_unique(order_details):
    keys = [
        (row["OrderNumber"], row["LineNumber"])
        for row in order_details
    ]

    assert len(keys) == len(set(keys))


def test_order_numbers_exist(order_details, orders):
    order_numbers = {order["OrderNumber"] for order in orders}

    assert all(
        row["OrderNumber"] in order_numbers
        for row in order_details
    )


def test_product_codes_exist(order_details, products):
    product_codes = {product["ProductCode"] for product in products}

    assert all(
        row["ProductCode"] in product_codes
        for row in order_details
    )


def test_unit_of_measure_matches_product(order_details, products):
    product_units = {
        product["ProductCode"]: product["UnitOfMeasureCode"]
        for product in products
    }

    assert all(
        row["UnitOfMeasureCode"] == product_units[row["ProductCode"]]
        for row in order_details
    )


def test_quantities_are_positive(order_details):
    assert all(
        Decimal(row["Quantity"]) > 0
        for row in order_details
    )


def test_unit_prices_are_positive(order_details):
    assert all(
        Decimal(row["UnitPrice"]) > 0
        for row in order_details
    )


def test_discount_percentages_are_valid(order_details):
    assert all(
        Decimal("0") <= Decimal(row["DiscountPercent"]) <= Decimal("100")
        for row in order_details
    )


def test_tax_rates_are_not_negative(order_details):
    assert all(
        Decimal(row["TaxRatePercent"]) >= 0
        for row in order_details
    )


def test_line_numbers_start_at_one(order_details):
    order_lines = defaultdict(list)

    for row in order_details:
        order_lines[row["OrderNumber"]].append(
            int(row["LineNumber"])
        )

    for line_numbers in order_lines.values():
        assert min(line_numbers) == 1


def test_line_numbers_are_sequential(order_details):
    order_lines = defaultdict(list)

    for row in order_details:
        order_lines[row["OrderNumber"]].append(
            int(row["LineNumber"])
        )

    for line_numbers in order_lines.values():
        assert sorted(line_numbers) == list(
            range(1, len(line_numbers) + 1)
        )
