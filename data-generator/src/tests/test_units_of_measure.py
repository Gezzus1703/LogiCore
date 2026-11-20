
def test_units_of_measure_file_is_not_empty(units_of_measure):
    assert len(units_of_measure) > 0


def test_unit_codes_are_unique(units_of_measure):
    unit_codes = [
        unit["UnitOfMeasureCode"]
        for unit in units_of_measure
    ]

    assert len(unit_codes) == len(set(unit_codes))


def test_unit_codes_are_not_empty(units_of_measure):
    assert all(
        unit["UnitOfMeasureCode"].strip()
        for unit in units_of_measure
    )


def test_unit_names_are_not_empty(units_of_measure):
    assert all(
        unit["UnitName"].strip()
        for unit in units_of_measure
    )


def test_unit_codes_are_uppercase(units_of_measure):
    assert all(
        unit["UnitOfMeasureCode"].isupper()
        for unit in units_of_measure
    )


def test_unit_active_statuses_are_valid(units_of_measure):
    assert all(
        unit["IsActive"] in {"0", "1"}
        for unit in units_of_measure
    )
