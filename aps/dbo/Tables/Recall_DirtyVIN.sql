CREATE TABLE [dbo].[Recall_DirtyVIN] (
    [Id]          INT          IDENTITY (1, 1) NOT NULL,
    [year]        INT          NULL,
    [make]        VARCHAR (50) NULL,
    [model]       VARCHAR (50) NULL,
    [vin]         VARCHAR (20) NULL,
    [source]      VARCHAR (10) NULL,
    [recallfound] BIT          NULL,
    [makefound]   BIT          NULL,
    [modelfound]  BIT          NULL,
    CONSTRAINT [PK_Recall_DirtyVIN] PRIMARY KEY CLUSTERED ([Id] ASC)
);

