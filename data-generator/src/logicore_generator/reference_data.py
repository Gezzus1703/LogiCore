from .csv_utils import save_to_csv


COUNTRIES = [
    {"CountryCode": "PL", "CountryName": "Poland", "IsActive": 1},
    {"CountryCode": "DE", "CountryName": "Germany", "IsActive": 1},
    {"CountryCode": "CZ", "CountryName": "Czechia", "IsActive": 1},
    {"CountryCode": "SK", "CountryName": "Slovakia", "IsActive": 1},
    {"CountryCode": "AT", "CountryName": "Austria", "IsActive": 1},
    {"CountryCode": "NL", "CountryName": "Netherlands", "IsActive": 1},
    {"CountryCode": "BE", "CountryName": "Belgium", "IsActive": 1},
    {"CountryCode": "FR", "CountryName": "France", "IsActive": 1},
    {"CountryCode": "IT", "CountryName": "Italy", "IsActive": 1},
    {"CountryCode": "ES", "CountryName": "Spain", "IsActive": 1},
    {"CountryCode": "GB", "CountryName": "United Kingdom", "IsActive": 1},
    {"CountryCode": "US", "CountryName": "United States", "IsActive": 1},
    {"CountryCode": "CA", "CountryName": "Canada", "IsActive": 1},
    {"CountryCode": "SE", "CountryName": "Sweden", "IsActive": 1},
    {"CountryCode": "NO", "CountryName": "Norway", "IsActive": 1},
]


CURRENCIES = [
    {
        "CurrencyCode": "PLN",
        "CurrencyName": "Polish Zloty",
        "DecimalPlaces": 2,
        "IsActive": 1,
    },
    {
        "CurrencyCode": "EUR",
        "CurrencyName": "Euro",
        "DecimalPlaces": 2,
        "IsActive": 1,
    },
    {
        "CurrencyCode": "USD",
        "CurrencyName": "US Dollar",
        "DecimalPlaces": 2,
        "IsActive": 1,
    },
    {
        "CurrencyCode": "GBP",
        "CurrencyName": "British Pound",
        "DecimalPlaces": 2,
        "IsActive": 1,
    },
    {
        "CurrencyCode": "CZK",
        "CurrencyName": "Czech Koruna",
        "DecimalPlaces": 2,
        "IsActive": 1,
    },
]


# Synthetic exchange rates relative to EUR.
# ExchangeRate represents the EUR value of one unit of the currency.
EXCHANGE_RATES = [
    {
        "CurrencyCode": "PLN",
        "BaseCurrencyCode": "EUR",
        "ExchangeRate": "0.230000",
        "IsActive": 1,
    },
    {
        "CurrencyCode": "EUR",
        "BaseCurrencyCode": "EUR",
        "ExchangeRate": "1.000000",
        "IsActive": 1,
    },
    {
        "CurrencyCode": "USD",
        "BaseCurrencyCode": "EUR",
        "ExchangeRate": "0.920000",
        "IsActive": 1,
    },
    {
        "CurrencyCode": "GBP",
        "BaseCurrencyCode": "EUR",
        "ExchangeRate": "1.180000",
        "IsActive": 1,
    },
    {
        "CurrencyCode": "CZK",
        "BaseCurrencyCode": "EUR",
        "ExchangeRate": "0.040000",
        "IsActive": 1,
    },
]


UNITS_OF_MEASURE = [
    {"UnitOfMeasureCode": "PCS", "UnitName": "Pieces", "IsActive": 1},
    {"UnitOfMeasureCode": "PAIR", "UnitName": "Pair", "IsActive": 1},
    {"UnitOfMeasureCode": "ROLL", "UnitName": "Roll", "IsActive": 1},
    {"UnitOfMeasureCode": "KG", "UnitName": "Kilogram", "IsActive": 1},
    {"UnitOfMeasureCode": "G", "UnitName": "Gram", "IsActive": 1},
    {"UnitOfMeasureCode": "L", "UnitName": "Liter", "IsActive": 1},
    {"UnitOfMeasureCode": "M", "UnitName": "Meter", "IsActive": 1},
    {"UnitOfMeasureCode": "M2", "UnitName": "Square Meter", "IsActive": 1},
    {"UnitOfMeasureCode": "M3", "UnitName": "Cubic Meter", "IsActive": 1},
    {"UnitOfMeasureCode": "HOUR", "UnitName": "Hour", "IsActive": 1},
]


def generate_reference_data():
    save_to_csv("countries.csv", COUNTRIES)
    save_to_csv("currencies.csv", CURRENCIES)
    save_to_csv("exchange_rates.csv", EXCHANGE_RATES)
    save_to_csv("units_of_measure.csv", UNITS_OF_MEASURE)


if __name__ == "__main__":
    generate_reference_data()
