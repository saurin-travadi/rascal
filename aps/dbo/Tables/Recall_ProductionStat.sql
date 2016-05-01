CREATE TABLE [dbo].[Recall_ProductionStat] (
    [ProdId]           INT        IDENTITY (1, 1) NOT NULL,
    [UserId]           INT        NULL,
    [DataCollectionOn] NCHAR (10) NULL,
    [CollectionCount]  INT        NULL,
    CONSTRAINT [PK_Recall_ProductionStat] PRIMARY KEY CLUSTERED ([ProdId] ASC),
    CONSTRAINT [FK_Recall_ProductionStat_Recall_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Recall_User] ([UserId])
);

