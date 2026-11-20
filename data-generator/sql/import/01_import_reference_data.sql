SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Countries
    CREATE TABLE #Countries (
        CountryCode VARCHAR(10),
        CountryName NVARCHAR(200),
        IsActive VARCHAR(10)
    );

    BULK INSERT #Countries
    FROM '/var/opt/mssql/import/countries.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO ref.Countries (
        CountryCode,
        CountryName,
        IsActive
    )
    SELECT
        TRIM(CountryCode),
        TRIM(CountryName),
        TRY_CONVERT(BIT, TRIM(CHAR(13) + CHAR(10) FROM IsActive))
    FROM #Countries;

    -- Currencies
    CREATE TABLE #Currencies (
        CurrencyCode VARCHAR(10),
        CurrencyName NVARCHAR(200),
        DecimalPlaces VARCHAR(10),
        IsActive VARCHAR(10)
    );

    BULK INSERT #Currencies
    FROM '/var/opt/mssql/import/currencies.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO ref.Currencies (
        CurrencyCode,
        CurrencyName,
        DecimalPlaces,
        IsActive
    )
    SELECT
        TRIM(CurrencyCode),
        TRIM(CurrencyName),
        TRY_CONVERT(TINYINT, TRIM(DecimalPlaces)),
        TRY_CONVERT(BIT, TRIM(CHAR(13) + CHAR(10) FROM IsActive))
    FROM #Currencies;

    -- Units of measure
    CREATE TABLE #UnitsOfMeasure (
        UnitOfMeasureCode VARCHAR(20),
        UnitName NVARCHAR(100),
        IsActive VARCHAR(10)
    );

    BULK INSERT #UnitsOfMeasure
    FROM '/var/opt/mssql/import/units_of_measure.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO ref.UnitsOfMeasure (
        UnitOfMeasureCode,
        UnitName,
        IsActive
    )
    SELECT
        TRIM(UnitOfMeasureCode),
        TRIM(UnitName),
        TRY_CONVERT(BIT, TRIM(CHAR(13) + CHAR(10) FROM IsActive))
    FROM #UnitsOfMeasure;

    COMMIT TRANSACTION;

    SELECT 'Reference data imported successfully.' AS ImportStatus;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
