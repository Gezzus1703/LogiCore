CREATE TABLE [History].[CustomersHistory] (
    [CustomerID]    INT            NOT NULL,
    [CustomerCode]  NVARCHAR (20)  NOT NULL,
    [CompanyName]   NVARCHAR (150) NOT NULL,
    [ContactName]   NVARCHAR (100) NULL,
    [Email]         NVARCHAR (254) NULL,
    [Phone]         NVARCHAR (30)  NULL,
    [StreetAddress] NVARCHAR (200) NULL,
    [City]          NVARCHAR (100) NULL,
    [PostalCode]    NVARCHAR (20)  NULL,
    [CountryCode]   CHAR (2)       NULL,
    [CreatedAt]     DATETIME2 (3)  NOT NULL,
    [IsActive]      BIT            NOT NULL,
    [ValidFrom]     DATETIME2 (7)  NOT NULL,
    [ValidTo]       DATETIME2 (7)  NOT NULL
);
GO

CREATE CLUSTERED INDEX [ix_CustomersHistory]
    ON [History].[CustomersHistory]([ValidTo] ASC, [ValidFrom] ASC) WITH (DATA_COMPRESSION = PAGE);
GO

