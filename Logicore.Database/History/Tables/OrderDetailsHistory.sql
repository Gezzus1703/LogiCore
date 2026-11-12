CREATE TABLE [History].[OrderDetailsHistory] (
    [OrderDetailID]     INT             NOT NULL,
    [OrderID]           INT             NOT NULL,
    [LineNumber]        INT             NOT NULL,
    [ProductID]         INT             NOT NULL,
    [Quantity]          DECIMAL (18, 3) NOT NULL,
    [UnitOfMeasureCode] NVARCHAR (10)   NOT NULL,
    [UnitPrice]         DECIMAL (19, 4) NOT NULL,
    [DiscountPercent]   DECIMAL (5, 2)  NOT NULL,
    [TaxRatePercent]    DECIMAL (5, 2)  NOT NULL,
    [CreatedAt]         DATETIME2 (3)   NOT NULL,
    [ValidFrom]         DATETIME2 (7)   NOT NULL,
    [ValidTo]           DATETIME2 (7)   NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_OrderDetailsHistory]
    ON [History].[OrderDetailsHistory]([ValidTo] ASC, [ValidFrom] ASC) WITH (DATA_COMPRESSION = PAGE);
GO

