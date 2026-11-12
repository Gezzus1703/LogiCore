CREATE TABLE [History].[OrdersHistory] (
    [OrderID]               INT            NOT NULL,
    [OrderNumber]           NVARCHAR (30)  NOT NULL,
    [CustomerID]            INT            NOT NULL,
    [OrderDate]             DATETIME2 (3)  NOT NULL,
    [RequestedDeliveryDate] DATE           NULL,
    [OrderStatus]           NVARCHAR (20)  NOT NULL,
    [CurrencyCode]          CHAR (3)       NOT NULL,
    [ShipToName]            NVARCHAR (150) NULL,
    [ShipToStreetAddress]   NVARCHAR (200) NULL,
    [ShipToCity]            NVARCHAR (100) NULL,
    [ShipToPostalCode]      NVARCHAR (20)  NULL,
    [ShipToCountryCode]     CHAR (2)       NULL,
    [CreatedAt]             DATETIME2 (3)  NOT NULL,
    [ValidFrom]             DATETIME2 (7)  NOT NULL,
    [ValidTo]               DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_OrdersHistory]
    ON [History].[OrdersHistory]([ValidTo] ASC, [ValidFrom] ASC) WITH (DATA_COMPRESSION = PAGE);
GO

