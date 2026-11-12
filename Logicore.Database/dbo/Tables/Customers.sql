CREATE TABLE [dbo].[Customers] (
    [CustomerID]    INT                                                IDENTITY (1, 1) NOT NULL,
    [CustomerCode]  NVARCHAR (20)                                      NOT NULL,
    [CompanyName]   NVARCHAR (150)                                     NOT NULL,
    [ContactName]   NVARCHAR (100)                                     NULL,
    [Email]         NVARCHAR (254)                                     NULL,
    [Phone]         NVARCHAR (30)                                      NULL,
    [StreetAddress] NVARCHAR (200)                                     NULL,
    [City]          NVARCHAR (100)                                     NULL,
    [PostalCode]    NVARCHAR (20)                                      NULL,
    [CountryCode]   CHAR (2)                                           NULL,
    [CreatedAt]     DATETIME2 (3)                                      NOT NULL,
    [IsActive]      BIT                                                NOT NULL,
    [ValidFrom]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [ValidTo]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[History].[CustomersHistory], DATA_CONSISTENCY_CHECK=ON));
GO

ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [DF_Customers_ValidTo] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) FOR [ValidTo];
GO

ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [DF_Customers_ValidFrom] DEFAULT (sysutcdatetime()) FOR [ValidFrom];
GO

ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [DF_Customers_IsActive] DEFAULT ((1)) FOR [IsActive];
GO

ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [DF_Customers_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO

ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [FK_Customers_Countries] FOREIGN KEY ([CountryCode]) REFERENCES [ref].[Countries] ([CountryCode]);
GO

ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC);
GO

ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [UQ_Customers_CustomerCode] UNIQUE NONCLUSTERED ([CustomerCode] ASC);
GO

