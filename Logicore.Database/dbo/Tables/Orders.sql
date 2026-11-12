CREATE TABLE [dbo].[Orders] (
    [OrderID]               INT                                                IDENTITY (1, 1) NOT NULL,
    [OrderNumber]           NVARCHAR (30)                                      NOT NULL,
    [CustomerID]            INT                                                NOT NULL,
    [OrderDate]             DATETIME2 (3)                                      NOT NULL,
    [RequestedDeliveryDate] DATE                                               NULL,
    [OrderStatus]           NVARCHAR (20)                                      NOT NULL,
    [CurrencyCode]          CHAR (3)                                           NOT NULL,
    [ShipToName]            NVARCHAR (150)                                     NULL,
    [ShipToStreetAddress]   NVARCHAR (200)                                     NULL,
    [ShipToCity]            NVARCHAR (100)                                     NULL,
    [ShipToPostalCode]      NVARCHAR (20)                                      NULL,
    [ShipToCountryCode]     CHAR (2)                                           NULL,
    [CreatedAt]             DATETIME2 (3)                                      NOT NULL,
    [ValidFrom]             DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [ValidTo]               DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[History].[OrdersHistory], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [CK_Orders_OrderStatus] CHECK ([OrderStatus]=N'CANCELLED' OR [OrderStatus]=N'DELIVERED' OR [OrderStatus]=N'SHIPPED' OR [OrderStatus]=N'PARTIALLY_SHIPPED' OR [OrderStatus]=N'PROCESSING' OR [OrderStatus]=N'CONFIRMED' OR [OrderStatus]=N'NEW');
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [CK_Orders_OrderNumber] CHECK (len(ltrim(rtrim([OrderNumber])))>(0));
GO

CREATE NONCLUSTERED INDEX [IX_Orders_CustomerID_OrderDate]
    ON [dbo].[Orders]([CustomerID] ASC, [OrderDate] ASC);
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [FK_Orders_Currencies] FOREIGN KEY ([CurrencyCode]) REFERENCES [ref].[Currencies] ([CurrencyCode]);
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [FK_Orders_Countries] FOREIGN KEY ([ShipToCountryCode]) REFERENCES [ref].[Countries] ([CountryCode]);
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([CustomerID]);
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_ValidFrom] DEFAULT (sysutcdatetime()) FOR [ValidFrom];
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_ValidTo] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) FOR [ValidTo];
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_OrderStatus] DEFAULT (N'NEW') FOR [OrderStatus];
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_OrderDate] DEFAULT (sysutcdatetime()) FOR [OrderDate];
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderID] ASC);
GO

ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [UQ_Orders_OrderNumber] UNIQUE NONCLUSTERED ([OrderNumber] ASC);
GO

