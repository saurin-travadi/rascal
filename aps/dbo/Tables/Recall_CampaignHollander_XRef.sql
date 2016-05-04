CREATE TABLE [dbo].[Recall_CampaignHollander_XRef] (
    [XRefId]            INT           IDENTITY (1, 1) NOT NULL,
    [CompName]          VARCHAR (256) NULL,
    [HollanderPartType] INT           NULL,
    CONSTRAINT [PK_Recall_CampaignHollander_XRef] PRIMARY KEY CLUSTERED ([XRefId] ASC)
);

