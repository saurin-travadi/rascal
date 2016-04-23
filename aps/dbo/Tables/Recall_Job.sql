CREATE TABLE [dbo].[Recall_Job] (
    [JobId]   INT          IDENTITY (1, 1) NOT NULL,
    [JobName] VARCHAR (50) NULL,
    [NextRun] DATETIME     NULL,
    CONSTRAINT [PK_Recall_Job] PRIMARY KEY CLUSTERED ([JobId] ASC)
);

