CREATE TABLE [ref].[UnitsOfMeasure] (
    [UnitOfMeasureCode] NVARCHAR (10) NOT NULL,
    [UnitName]          NVARCHAR (50) NOT NULL,
    [IsActive]          BIT           NOT NULL
);
GO

ALTER TABLE [ref].[UnitsOfMeasure]
    ADD CONSTRAINT [DF_UnitsOfMeasure_IsActive] DEFAULT ((1)) FOR [IsActive];
GO

ALTER TABLE [ref].[UnitsOfMeasure]
    ADD CONSTRAINT [PK_UnitsOfMeasure] PRIMARY KEY CLUSTERED ([UnitOfMeasureCode] ASC);
GO

ALTER TABLE [ref].[UnitsOfMeasure]
    ADD CONSTRAINT [UQ_UnitsOfMeasure_UnitName] UNIQUE NONCLUSTERED ([UnitName] ASC);
GO

