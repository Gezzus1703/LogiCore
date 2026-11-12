CREATE TABLE [dbo].[InvoiceLines] (
    [InvoiceLineID]     INT                                                IDENTITY (1, 1) NOT NULL,
    [InvoiceID]         INT                                                NOT NULL,
    [OrderID]           INT                                                NOT NULL,
    [OrderDetailID]     INT                                                NOT NULL,
    [LineNumber]        INT                                                NOT NULL,
    [ProductCode]       NVARCHAR (30)                                      NOT NULL,
    [LineDescription]   NVARCHAR (200)                                     NOT NULL,
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
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[History].[InvoiceLinesHistory], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [FK_InvoiceLines_Invoices] FOREIGN KEY ([InvoiceID], [OrderID]) REFERENCES [dbo].[Invoices] ([InvoiceID], [OrderID]);
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [FK_InvoiceLines_OrderDetails] FOREIGN KEY ([OrderDetailID], [OrderID]) REFERENCES [dbo].[OrderDetails] ([OrderDetailID], [OrderID]);
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [FK_InvoiceLines_UnitsOfMeasure] FOREIGN KEY ([UnitOfMeasureCode]) REFERENCES [ref].[UnitsOfMeasure] ([UnitOfMeasureCode]);
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [CK_InvoiceLines_TaxRatePercent] CHECK ([TaxRatePercent]>=(0) AND [TaxRatePercent]<=(100));
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [CK_InvoiceLines_LineNumber] CHECK ([LineNumber]>(0));
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [CK_InvoiceLines_Quantity] CHECK ([Quantity]>(0));
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [CK_InvoiceLines_UnitPrice] CHECK ([UnitPrice]>=(0));
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [CK_InvoiceLines_DiscountPercent] CHECK ([DiscountPercent]>=(0) AND [DiscountPercent]<=(100));
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [DF_InvoiceLines_ValidFrom] DEFAULT (sysutcdatetime()) FOR [ValidFrom];
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [DF_InvoiceLines_ValidTo] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) FOR [ValidTo];
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [DF_InvoiceLines_DiscountPercent] DEFAULT ((0)) FOR [DiscountPercent];
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [DF_InvoiceLines_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [UQ_InvoiceLines_Invoice_Line] UNIQUE NONCLUSTERED ([InvoiceID] ASC, [LineNumber] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_InvoiceLines_OrderDetailID_OrderID]
    ON [dbo].[InvoiceLines]([OrderDetailID] ASC, [OrderID] ASC);
GO

ALTER TABLE [dbo].[InvoiceLines]
    ADD CONSTRAINT [PK_InvoiceLines] PRIMARY KEY CLUSTERED ([InvoiceLineID] ASC);
GO

