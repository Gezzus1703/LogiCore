
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Orders staging
    CREATE TABLE #Orders (
        OrderNumber VARCHAR(30),
        CustomerCode VARCHAR(20),
        OrderDate VARCHAR(50),
        RequestedDeliveryDate VARCHAR(50),
        OrderStatus VARCHAR(20),
        CurrencyCode VARCHAR(10),
        ShipToName NVARCHAR(150),
        ShipToStreetAddress NVARCHAR(200),
        ShipToCity NVARCHAR(100),
        ShipToPostalCode VARCHAR(20),
        ShipToCountryCode VARCHAR(10)
    );

    BULK INSERT #Orders
    FROM '/var/opt/mssql/import/orders.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO dbo.Orders (
        OrderNumber,
        CustomerID,
        OrderDate,
        RequestedDeliveryDate,
        OrderStatus,
        CurrencyCode,
        ShipToName,
        ShipToStreetAddress,
        ShipToCity,
        ShipToPostalCode,
        ShipToCountryCode
    )
    SELECT
        TRIM(s.OrderNumber),
        c.CustomerID,
        TRY_CONVERT(DATETIME2, s.OrderDate),
        TRY_CONVERT(DATE, s.RequestedDeliveryDate),
        TRIM(s.OrderStatus),
        TRIM(s.CurrencyCode),
        TRIM(s.ShipToName),
        TRIM(s.ShipToStreetAddress),
        TRIM(s.ShipToCity),
        TRIM(s.ShipToPostalCode),
        TRIM(CHAR(13) + CHAR(10) FROM s.ShipToCountryCode)
    FROM #Orders AS s
    INNER JOIN dbo.Customers AS c
        ON c.CustomerCode = s.CustomerCode;

    -- Order details staging
    CREATE TABLE #OrderDetails (
        OrderNumber VARCHAR(30),
        LineNumber VARCHAR(10),
        ProductCode VARCHAR(30),
        Quantity VARCHAR(50),
        UnitOfMeasureCode VARCHAR(20),
        UnitPrice VARCHAR(50),
        DiscountPercent VARCHAR(50),
        TaxRatePercent VARCHAR(50)
    );

    BULK INSERT #OrderDetails
    FROM '/var/opt/mssql/import/order_details.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO dbo.OrderDetails (
        OrderID,
        LineNumber,
        ProductID,
        Quantity,
        UnitOfMeasureCode,
        UnitPrice,
        DiscountPercent,
        TaxRatePercent
    )
    SELECT
        o.OrderID,
        TRY_CONVERT(INT, s.LineNumber),
        p.ProductID,
        TRY_CONVERT(DECIMAL(18,3), s.Quantity),
        TRIM(s.UnitOfMeasureCode),
        TRY_CONVERT(DECIMAL(19,4), s.UnitPrice),
        TRY_CONVERT(DECIMAL(5,2), s.DiscountPercent),
        TRY_CONVERT(
            DECIMAL(5,2),
            TRIM(CHAR(13) + CHAR(10) FROM s.TaxRatePercent)
        )
    FROM #OrderDetails AS s
    INNER JOIN dbo.Orders AS o
        ON o.OrderNumber = s.OrderNumber
    INNER JOIN dbo.Products AS p
        ON p.ProductCode = s.ProductCode;

    COMMIT TRANSACTION;

    SELECT
        (SELECT COUNT(*) FROM dbo.Orders) AS OrdersCount,
        (SELECT COUNT(*) FROM dbo.OrderDetails) AS OrderDetailsCount;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
