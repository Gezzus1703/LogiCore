
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Invoices staging
    CREATE TABLE #Invoices (
        InvoiceNumber VARCHAR(30),
        OrderNumber VARCHAR(30),
        InvoiceDate VARCHAR(50),
        DueDate VARCHAR(50),
        InvoiceStatus VARCHAR(20),
        CurrencyCode VARCHAR(10),
        BillToName NVARCHAR(150),
        BillToStreetAddress NVARCHAR(200),
        BillToCity NVARCHAR(100),
        BillToPostalCode VARCHAR(20),
        BillToCountryCode VARCHAR(10)
    );

    BULK INSERT #Invoices
    FROM '/var/opt/mssql/import/invoices.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO dbo.Invoices (
        InvoiceNumber,
        OrderID,
        InvoiceDate,
        DueDate,
        InvoiceStatus,
        CurrencyCode,
        BillToName,
        BillToStreetAddress,
        BillToCity,
        BillToPostalCode,
        BillToCountryCode
    )
    SELECT
        TRIM(s.InvoiceNumber),
        o.OrderID,
        TRY_CONVERT(DATE, s.InvoiceDate),
        TRY_CONVERT(DATE, s.DueDate),
        TRIM(s.InvoiceStatus),
        TRIM(s.CurrencyCode),
        TRIM(s.BillToName),
        TRIM(s.BillToStreetAddress),
        TRIM(s.BillToCity),
        TRIM(s.BillToPostalCode),
        TRIM(CHAR(13) + CHAR(10) FROM s.BillToCountryCode)
    FROM #Invoices AS s
    INNER JOIN dbo.Orders AS o
        ON o.OrderNumber = s.OrderNumber;

    -- Invoice lines staging
    CREATE TABLE #InvoiceLines (
        InvoiceNumber VARCHAR(30),
        OrderNumber VARCHAR(30),
        LineNumber VARCHAR(10),
        ProductCode VARCHAR(30),
        LineDescription NVARCHAR(200),
        Quantity VARCHAR(50),
        UnitOfMeasureCode VARCHAR(20),
        UnitPrice VARCHAR(50),
        DiscountPercent VARCHAR(50),
        TaxRatePercent VARCHAR(50)
    );

    BULK INSERT #InvoiceLines
    FROM '/var/opt/mssql/import/invoice_lines.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO dbo.InvoiceLines (
        InvoiceID,
        OrderID,
        OrderDetailID,
        LineNumber,
        ProductCode,
        LineDescription,
        Quantity,
        UnitOfMeasureCode,
        UnitPrice,
        DiscountPercent,
        TaxRatePercent
    )
    SELECT
        i.InvoiceID,
        o.OrderID,
        od.OrderDetailID,
        TRY_CONVERT(INT, s.LineNumber),
        TRIM(s.ProductCode),
        TRIM(s.LineDescription),
        TRY_CONVERT(DECIMAL(18,3), s.Quantity),
        TRIM(s.UnitOfMeasureCode),
        TRY_CONVERT(DECIMAL(19,4), s.UnitPrice),
        TRY_CONVERT(DECIMAL(5,2), s.DiscountPercent),
        TRY_CONVERT(
            DECIMAL(5,2),
            TRIM(CHAR(13) + CHAR(10) FROM s.TaxRatePercent)
        )
    FROM #InvoiceLines AS s
    INNER JOIN dbo.Invoices AS i
        ON i.InvoiceNumber = s.InvoiceNumber
    INNER JOIN dbo.Orders AS o
        ON o.OrderNumber = s.OrderNumber
    INNER JOIN dbo.OrderDetails AS od
        ON od.OrderID = o.OrderID
        AND od.LineNumber = TRY_CONVERT(INT, s.LineNumber)
    INNER JOIN dbo.Products AS p
        ON p.ProductID = od.ProductID
        AND p.ProductCode = s.ProductCode;

    COMMIT TRANSACTION;

    SELECT
        (SELECT COUNT(*) FROM dbo.Invoices) AS InvoicesCount,
        (SELECT COUNT(*) FROM dbo.InvoiceLines) AS InvoiceLinesCount;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
