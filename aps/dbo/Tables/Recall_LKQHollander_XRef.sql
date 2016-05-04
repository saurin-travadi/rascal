CREATE TABLE [dbo].[Recall_LKQHollander_XRef] (
    [XRefID]            INT           IDENTITY (1, 1) NOT NULL,
    [LKQPartCode]       VARCHAR (10)  NULL,
    [LKQPartName]       VARCHAR (255) NULL,
    [HollanderPartType] INT           NULL,
    CONSTRAINT [PK_Recall_LKQHollander_XRef] PRIMARY KEY CLUSTERED ([XRefID] ASC)
);

