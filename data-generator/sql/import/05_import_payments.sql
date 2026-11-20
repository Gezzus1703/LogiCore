
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE #Payments (
        PaymentReference VARCHAR(40),
        InvoiceNumber VARCHAR(30),
        PaymentDateTime VARCHAR(50),
        Amount VARCHAR(50),
        PaymentMethod VARCHAR(20),
        PaymentStatus VARCHAR(20),
        ExternalTransactionReference VARCHAR(100)
    );

    BULK INSERT #Payments
    FROM '/var/opt/mssql/import/payments.utf16.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        DATAFILETYPE = 'widechar'
    );

    INSERT INTO dbo.Payments (
        PaymentReference,
        InvoiceID,
        PaymentDateTime,
        Amount,
        PaymentMethod,
        PaymentStatus,
        ExternalTransactionReference
    )
    SELECT
        TRIM(s.PaymentReference),
        i.InvoiceID,
        TRY_CONVERT(DATETIME2, s.PaymentDateTime),
        TRY_CONVERT(DECIMAL(19,4), s.Amount),
        TRIM(s.PaymentMethod),
        TRIM(CHAR(13) + CHAR(10) FROM s.PaymentStatus),
        NULLIF(TRIM(s.ExternalTransactionReference), '')
    FROM #Payments AS s
    INNER JOIN dbo.Invoices AS i
        ON i.InvoiceNumber = s.InvoiceNumber;

    COMMIT TRANSACTION;

    SELECT
        COUNT(*) AS PaymentsCount
    FROM dbo.Payments;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
