CREATE TABLE [dbo].[Recall_Mapper] (
    [MapId]   INT          IDENTITY (1, 1) NOT NULL,
    [MapFrom] VARCHAR (50) NULL,
    [MapTo]   VARCHAR (50) NULL,
    [MapType] CHAR (1)     NULL,
    CONSTRAINT [PK_Mapper] PRIMARY KEY CLUSTERED ([MapId] ASC)
);

