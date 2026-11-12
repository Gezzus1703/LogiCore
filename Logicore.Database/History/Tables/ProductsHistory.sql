CREATE TABLE [History].[ProductsHistory] (
    [ProductID]          INT             NOT NULL,
    [ProductCode]        NVARCHAR (30)   NOT NULL,
    [ProductName]        NVARCHAR (150)  NOT NULL,
    [ProductDescription] NVARCHAR (500)  NULL,
    [UnitOfMeasureCode]  NVARCHAR (10)   NOT NULL,
    [UnitPrice]          DECIMAL (19, 4) NOT NULL,
    [CurrencyCode]       CHAR (3)        NOT NULL,
    [NetWeightKg]        DECIMAL (10, 3) NULL,
    [IsActive]           BIT             NOT NULL,
    [CreatedAt]          DATETIME2 (3)   NOT NULL,
    [ValidFrom]          DATETIME2 (7)   NOT NULL,
    [ValidTo]            DATETIME2 (7)   NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_ProductsHistory]
    ON [History].[ProductsHistory]([ValidTo] ASC, [ValidFrom] ASC) WITH (DATA_COMPRESSION = PAGE);
GO

