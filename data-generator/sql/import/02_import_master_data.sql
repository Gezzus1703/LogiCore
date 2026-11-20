SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Customers
    CREATE TABLE #Customers (
        CustomerCode VARCHAR(20),
        CompanyName NVARCHAR(150),
        ContactName NVARCHAR(100),
        Phone VARCHAR(30),
        StreetAddress NVARCHAR(200),
        City NVARCHAR(100),
        PostalCode VARCHAR(20),
        CountryCode VARCHAR(10),
        CreatedAt VARCHAR(50),
        IsActive VARCHAR(10),
        Email VARCHAR(254)
    );

    BULK INSERT #Customers
    FROM '/var/opt/mssql/import/customers.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO dbo.Customers (
        CustomerCode,
        CompanyName,
        ContactName,
        Email,
        Phone,
        StreetAddress,
        City,
        PostalCode,
        CountryCode,
        IsActive
    )
    SELECT
        TRIM(CustomerCode),
        TRIM(CompanyName),
        TRIM(ContactName),
        NULLIF(TRIM(Email), ''),
        NULLIF(TRIM(Phone), ''),
        TRIM(StreetAddress),
        TRIM(City),
        TRIM(PostalCode),
        TRIM(CountryCode),
        TRY_CONVERT(BIT, TRIM(CHAR(13) + CHAR(10) FROM IsActive))
    FROM #Customers;

    -- Products
    CREATE TABLE #Products (
        ProductCode VARCHAR(30),
        ProductName NVARCHAR(150),
        Description NVARCHAR(500),
        UnitOfMeasureCode VARCHAR(20),
        UnitPrice VARCHAR(50),
        CurrencyCode VARCHAR(10),
        NetWeightKg VARCHAR(50),
        IsActive VARCHAR(10),
        CreatedAt VARCHAR(50)
    );

    BULK INSERT #Products
    FROM '/var/opt/mssql/import/products.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO dbo.Products (
        ProductCode,
        ProductName,
        ProductDescription,
        UnitOfMeasureCode,
        UnitPrice,
        CurrencyCode,
        NetWeightKg,
        IsActive
    )
    SELECT
        TRIM(ProductCode),
        TRIM(ProductName),
        TRIM(Description),
        TRIM(UnitOfMeasureCode),
        TRY_CONVERT(DECIMAL(19,4), TRIM(UnitPrice)),
        TRIM(CurrencyCode),
        TRY_CONVERT(DECIMAL(10,3), TRIM(NetWeightKg)),
        TRY_CONVERT(BIT, TRIM(IsActive))
    FROM #Products;

    COMMIT TRANSACTION;

    SELECT
        (SELECT COUNT(*) FROM dbo.Customers) AS CustomersCount,
        (SELECT COUNT(*) FROM dbo.Products) AS ProductsCount;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
