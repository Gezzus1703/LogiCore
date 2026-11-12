CREATE TABLE [dbo].[Invoices] (
    [InvoiceID]           INT                                                IDENTITY (1, 1) NOT NULL,
    [InvoiceNumber]       NVARCHAR (30)                                      NOT NULL,
    [OrderID]             INT                                                NOT NULL,
    [InvoiceDate]         DATE                                               NOT NULL,
    [DueDate]             DATE                                               NOT NULL,
    [InvoiceStatus]       NVARCHAR (20)                                      NOT NULL,
    [CurrencyCode]        CHAR (3)                                           NOT NULL,
    [BillToName]          NVARCHAR (150)                                     NOT NULL,
    [BillToStreetAddress] NVARCHAR (200)                                     NOT NULL,
    [BillToCity]          NVARCHAR (100)                                     NOT NULL,
    [BillToPostalCode]    NVARCHAR (20)                                      NULL,
    [BillToCountryCode]   CHAR (2)                                           NOT NULL,
    [CreatedAt]           DATETIME2 (3)                                      NOT NULL,
    [ValidFrom]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [ValidTo]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[History].[InvoicesHistory], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [UQ_Invoices_InvoiceID_OrderID] UNIQUE NONCLUSTERED ([InvoiceID] ASC, [OrderID] ASC);
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [UQ_Invoices_InvoiceNumber] UNIQUE NONCLUSTERED ([InvoiceNumber] ASC);
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [CK_Invoices_Dates] CHECK ([DueDate]>=[InvoiceDate]);
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [CK_Invoices_Status] CHECK ([InvoiceStatus]=N'CANCELLED' OR [InvoiceStatus]=N'ISSUED' OR [InvoiceStatus]=N'DRAFT');
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [CK_Invoices_InvoiceNumber] CHECK (len(ltrim(rtrim([InvoiceNumber])))>(0));
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [FK_Invoices_Orders] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]);
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [FK_Invoices_Currencies] FOREIGN KEY ([CurrencyCode]) REFERENCES [ref].[Currencies] ([CurrencyCode]);
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [FK_Invoices_Countries] FOREIGN KEY ([BillToCountryCode]) REFERENCES [ref].[Countries] ([CountryCode]);
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [DF_Invoices_InvoiceStatus] DEFAULT (N'DRAFT') FOR [InvoiceStatus];
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [DF_Invoices_ValidFrom] DEFAULT (sysutcdatetime()) FOR [ValidFrom];
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [DF_Invoices_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [DF_Invoices_ValidTo] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) FOR [ValidTo];
GO

ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [PK_Invoices] PRIMARY KEY CLUSTERED ([InvoiceID] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_Invoices_OrderID_InvoiceDate]
    ON [dbo].[Invoices]([OrderID] ASC, [InvoiceDate] ASC);
GO

