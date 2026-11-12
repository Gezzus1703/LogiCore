CREATE TABLE [dbo].[Payments] (
    [PaymentID]                    INT                                                IDENTITY (1, 1) NOT NULL,
    [PaymentReference]             NVARCHAR (40)                                      NOT NULL,
    [InvoiceID]                    INT                                                NOT NULL,
    [PaymentDateTime]              DATETIME2 (3)                                      NOT NULL,
    [Amount]                       DECIMAL (19, 4)                                    NOT NULL,
    [PaymentMethod]                NVARCHAR (20)                                      NOT NULL,
    [PaymentStatus]                NVARCHAR (20)                                      NOT NULL,
    [ExternalTransactionReference] NVARCHAR (100)                                     NULL,
    [CreatedAt]                    DATETIME2 (3)                                      NOT NULL,
    [ValidFrom]                    DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [ValidTo]                      DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[History].[PaymentsHistory], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [DF_Payments_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [DF_Payments_ValidFrom] DEFAULT (sysutcdatetime()) FOR [ValidFrom];
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [DF_Payments_ValidTo] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) FOR [ValidTo];
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [DF_Payments_PaymentStatus] DEFAULT (N'PENDING') FOR [PaymentStatus];
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [UQ_Payments_PaymentReference] UNIQUE NONCLUSTERED ([PaymentReference] ASC);
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [CK_Payments_Amount] CHECK ([Amount]>(0));
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [CK_Payments_PaymentMethod] CHECK ([PaymentMethod]=N'OTHER' OR [PaymentMethod]=N'DIRECT_DEBIT' OR [PaymentMethod]=N'CASH' OR [PaymentMethod]=N'CARD' OR [PaymentMethod]=N'BANK_TRANSFER');
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [CK_Payments_PaymentStatus] CHECK ([PaymentStatus]=N'CANCELLED' OR [PaymentStatus]=N'FAILED' OR [PaymentStatus]=N'COMPLETED' OR [PaymentStatus]=N'PENDING');
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [CK_Payments_PaymentReference] CHECK (len(ltrim(rtrim([PaymentReference])))>(0));
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED ([PaymentID] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_Payments_InvoiceID_PaymentDateTime]
    ON [dbo].[Payments]([InvoiceID] ASC, [PaymentDateTime] ASC);
GO

ALTER TABLE [dbo].[Payments]
    ADD CONSTRAINT [FK_Payments_Invoices] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoices] ([InvoiceID]);
GO

