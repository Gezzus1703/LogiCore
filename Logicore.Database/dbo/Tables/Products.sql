CREATE TABLE [dbo].[Products] (
    [ProductID]          INT                                                IDENTITY (1, 1) NOT NULL,
    [ProductCode]        NVARCHAR (30)                                      NOT NULL,
    [ProductName]        NVARCHAR (150)                                     NOT NULL,
    [ProductDescription] NVARCHAR (500)                                     NULL,
    [UnitOfMeasureCode]  NVARCHAR (10)                                      NOT NULL,
    [UnitPrice]          DECIMAL (19, 4)                                    NOT NULL,
    [CurrencyCode]       CHAR (3)                                           NOT NULL,
    [NetWeightKg]        DECIMAL (10, 3)                                    NULL,
    [IsActive]           BIT                                                NOT NULL,
    [CreatedAt]          DATETIME2 (3)                                      NOT NULL,
    [ValidFrom]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [ValidTo]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[History].[ProductsHistory], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [DF_Products_ValidTo] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) FOR [ValidTo];
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [DF_Products_ValidFrom] DEFAULT (sysutcdatetime()) FOR [ValidFrom];
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [DF_Products_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [DF_Products_IsActive] DEFAULT ((1)) FOR [IsActive];
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [CK_Products_ProductName] CHECK (len(ltrim(rtrim([ProductName])))>(0));
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [CK_Products_UnitPrice] CHECK ([UnitPrice]>=(0));
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [CK_Products_NetWeight] CHECK ([NetWeightKg] IS NULL OR [NetWeightKg]>=(0));
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [CK_Products_ProductCode] CHECK (len(ltrim(rtrim([ProductCode])))>(0));
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID] ASC);
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [UQ_Products_ProductCode] UNIQUE NONCLUSTERED ([ProductCode] ASC);
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [FK_Products_Currencies] FOREIGN KEY ([CurrencyCode]) REFERENCES [ref].[Currencies] ([CurrencyCode]);
GO

ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [FK_Products_UnitsOfMeasure] FOREIGN KEY ([UnitOfMeasureCode]) REFERENCES [ref].[UnitsOfMeasure] ([UnitOfMeasureCode]);
GO

