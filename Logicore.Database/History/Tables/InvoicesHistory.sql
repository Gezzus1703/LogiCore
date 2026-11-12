CREATE TABLE [History].[InvoicesHistory] (
    [InvoiceID]           INT            NOT NULL,
    [InvoiceNumber]       NVARCHAR (30)  NOT NULL,
    [OrderID]             INT            NOT NULL,
    [InvoiceDate]         DATE           NOT NULL,
    [DueDate]             DATE           NOT NULL,
    [InvoiceStatus]       NVARCHAR (20)  NOT NULL,
    [CurrencyCode]        CHAR (3)       NOT NULL,
    [BillToName]          NVARCHAR (150) NOT NULL,
    [BillToStreetAddress] NVARCHAR (200) NOT NULL,
    [BillToCity]          NVARCHAR (100) NOT NULL,
    [BillToPostalCode]    NVARCHAR (20)  NULL,
    [BillToCountryCode]   CHAR (2)       NOT NULL,
    [CreatedAt]           DATETIME2 (3)  NOT NULL,
    [ValidFrom]           DATETIME2 (7)  NOT NULL,
    [ValidTo]             DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_InvoicesHistory]
    ON [History].[InvoicesHistory]([ValidTo] ASC, [ValidFrom] ASC) WITH (DATA_COMPRESSION = PAGE);
GO

