CREATE TABLE [dbo].[Recall_UserGroup] (
    [UserGroupId]   INT             IDENTITY (1, 1) NOT NULL,
    [UserGroupName] VARCHAR (10)    NULL,
    [WorkRatio]     NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_UserGroup] PRIMARY KEY CLUSTERED ([UserGroupId] ASC)
);

