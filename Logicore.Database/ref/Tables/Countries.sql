CREATE TABLE [ref].[Countries] (
    [CountryCode] CHAR (2)       NOT NULL,
    [CountryName] NVARCHAR (100) NOT NULL,
    [IsActive]    BIT            NOT NULL
);
GO

ALTER TABLE [ref].[Countries]
    ADD CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED ([CountryCode] ASC);
GO

ALTER TABLE [ref].[Countries]
    ADD CONSTRAINT [DF_Countries_IsActive] DEFAULT ((1)) FOR [IsActive];
GO

ALTER TABLE [ref].[Countries]
    ADD CONSTRAINT [UQ_Countries_CountryName] UNIQUE NONCLUSTERED ([CountryName] ASC);
GO

