CREATE TABLE [dbo].[OrderDetails] (
    [OrderDetailID]     INT                                                IDENTITY (1, 1) NOT NULL,
    [OrderID]           INT                                                NOT NULL,
    [LineNumber]        INT                                                NOT NULL,
    [ProductID]         INT                                                NOT NULL,
    [Quantity]          DECIMAL (18, 3)                                    NOT NULL,
    [UnitOfMeasureCode] NVARCHAR (10)                                      NOT NULL,
    [UnitPrice]         DECIMAL (19, 4)                                    NOT NULL,
    [DiscountPercent]   DECIMAL (5, 2)                                     NOT NULL,
    [TaxRatePercent]    DECIMAL (5, 2)                                     NOT NULL,
    [CreatedAt]         DATETIME2 (3)                                      NOT NULL,
    [ValidFrom]         DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [ValidTo]           DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[History].[OrderDetailsHistory], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [FK_OrderDetails_UnitsOfMeasure] FOREIGN KEY ([UnitOfMeasureCode]) REFERENCES [ref].[UnitsOfMeasure] ([UnitOfMeasureCode]);
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]);
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID]);
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [DF_OrderDetails_TaxRatePercent] DEFAULT ((0)) FOR [TaxRatePercent];
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [DF_OrderDetails_DiscountPercent] DEFAULT ((0)) FOR [DiscountPercent];
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [DF_OrderDetails_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [DF_OrderDetails_ValidTo] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) FOR [ValidTo];
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [DF_OrderDetails_ValidFrom] DEFAULT (sysutcdatetime()) FOR [ValidFrom];
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [CK_OrderDetails_LineNumber] CHECK ([LineNumber]>(0));
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [CK_OrderDetails_Quantity] CHECK ([Quantity]>(0));
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [CK_OrderDetails_UnitPrice] CHECK ([UnitPrice]>=(0));
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [CK_OrderDetails_DiscountPercent] CHECK ([DiscountPercent]>=(0) AND [DiscountPercent]<=(100));
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [CK_OrderDetails_TaxRatePercent] CHECK ([TaxRatePercent]>=(0) AND [TaxRatePercent]<=(100));
GO

CREATE NONCLUSTERED INDEX [IX_OrderDetails_ProductID]
    ON [dbo].[OrderDetails]([ProductID] ASC);
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [UQ_OrderDetails_Order_Line] UNIQUE NONCLUSTERED ([OrderID] ASC, [LineNumber] ASC);
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [UQ_OrderDetails_OrderDetailID_OrderID] UNIQUE NONCLUSTERED ([OrderDetailID] ASC, [OrderID] ASC);
GO

ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED ([OrderDetailID] ASC);
GO

