CREATE TABLE [dbo].[Recall_VinReservation] (
    [ResId]      INT            IDENTITY (1, 1) NOT NULL,
    [UserId]     INT            NULL,
    [VIN]        VARCHAR (20)   NULL,
    [LockOut]    DATETIME       NULL,
    [RecallData] VARCHAR (8000) NULL,
    CONSTRAINT [PK_VinReservation] PRIMARY KEY CLUSTERED ([ResId] ASC),
    CONSTRAINT [FK_VinReservation_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Recall_User] ([UserId])
);

