
def test_currencies_file_is_not_empty(currencies):
    assert len(currencies) > 0


def test_currency_codes_are_unique(currencies):
    currency_codes = [currency["CurrencyCode"] for currency in currencies]

    assert len(currency_codes) == len(set(currency_codes))


def test_currency_codes_are_not_empty(currencies):
    assert all(currency["CurrencyCode"].strip() for currency in currencies)


def test_currency_names_are_not_empty(currencies):
    assert all(currency["CurrencyName"].strip() for currency in currencies)


def test_currency_codes_have_three_characters(currencies):
    assert all(len(currency["CurrencyCode"]) == 3 for currency in currencies)


def test_decimal_places_are_valid(currencies):
    assert all(
        currency["DecimalPlaces"].isdigit()
        and 0 <= int(currency["DecimalPlaces"]) <= 4
        for currency in currencies
    )


def test_currency_active_statuses_are_valid(currencies):
    assert all(
        currency["IsActive"] in {"0", "1"}
        for currency in currencies
    )
