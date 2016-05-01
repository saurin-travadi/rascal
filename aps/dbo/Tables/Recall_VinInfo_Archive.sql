CREATE TABLE [dbo].[Recall_VinInfo_Archive] (
    [VinInfoId] INT          IDENTITY (1, 1) NOT NULL,
    [VIN]       VARCHAR (20) NULL,
    [Make]      VARCHAR (50) NULL,
    [Model]     VARCHAR (80) NULL,
    [ModelYear] INT          NULL,
    CONSTRAINT [PK_VinInfo_Archive] PRIMARY KEY CLUSTERED ([VinInfoId] ASC)
);

