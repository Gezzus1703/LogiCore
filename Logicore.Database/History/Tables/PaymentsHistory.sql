CREATE TABLE [History].[PaymentsHistory] (
    [PaymentID]                    INT             NOT NULL,
    [PaymentReference]             NVARCHAR (40)   NOT NULL,
    [InvoiceID]                    INT             NOT NULL,
    [PaymentDateTime]              DATETIME2 (3)   NOT NULL,
    [Amount]                       DECIMAL (19, 4) NOT NULL,
    [PaymentMethod]                NVARCHAR (20)   NOT NULL,
    [PaymentStatus]                NVARCHAR (20)   NOT NULL,
    [ExternalTransactionReference] NVARCHAR (100)  NULL,
    [CreatedAt]                    DATETIME2 (3)   NOT NULL,
    [ValidFrom]                    DATETIME2 (7)   NOT NULL,
    [ValidTo]                      DATETIME2 (7)   NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_PaymentsHistory]
    ON [History].[PaymentsHistory]([ValidTo] ASC, [ValidFrom] ASC) WITH (DATA_COMPRESSION = PAGE);
GO

