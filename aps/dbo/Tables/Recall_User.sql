CREATE TABLE [dbo].[Recall_User] (
    [UserId]      INT          IDENTITY (1, 1) NOT NULL,
    [UserName]    VARCHAR (20) NULL,
    [UserGroupId] INT          NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [FK_User_User] FOREIGN KEY ([UserGroupId]) REFERENCES [dbo].[Recall_UserGroup] ([UserGroupId])
);

