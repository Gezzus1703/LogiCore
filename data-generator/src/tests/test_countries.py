
def test_countries_file_is_not_empty(countries):
    assert len(countries) > 0


def test_country_codes_are_unique(countries):
    country_codes = [country["CountryCode"] for country in countries]

    assert len(country_codes) == len(set(country_codes))


def test_country_codes_are_not_empty(countries):
    assert all(country["CountryCode"].strip() for country in countries)


def test_country_names_are_not_empty(countries):
    assert all(country["CountryName"].strip() for country in countries)


def test_country_codes_have_two_characters(countries):
    assert all(len(country["CountryCode"]) == 2 for country in countries)


def test_country_active_statuses_are_valid(countries):
    assert all(
        country["IsActive"] in {"0", "1"}
        for country in countries
    )
