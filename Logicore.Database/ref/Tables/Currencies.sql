CREATE TABLE [ref].[Currencies] (
    [CurrencyCode]  CHAR (3)       NOT NULL,
    [CurrencyName]  NVARCHAR (100) NOT NULL,
    [DecimalPlaces] TINYINT        NOT NULL,
    [IsActive]      BIT            NOT NULL
);
GO

ALTER TABLE [ref].[Currencies]
    ADD CONSTRAINT [DF_Currencies_IsActive] DEFAULT ((1)) FOR [IsActive];
GO

ALTER TABLE [ref].[Currencies]
    ADD CONSTRAINT [CK_Currencies_DecimalPlaces] CHECK ([DecimalPlaces]>=(0) AND [DecimalPlaces]<=(4));
GO

ALTER TABLE [ref].[Currencies]
    ADD CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED ([CurrencyCode] ASC);
GO

