CREATE TABLE [dbo].[Recall_VinReservation] (
    [ResId]            INT           IDENTITY (1, 1) NOT NULL,
    [UserId]           INT           NULL,
    [VIN]              VARCHAR (20)  NULL,
    [LockOut]          DATETIME      NULL,
    [RecallData]       VARCHAR (200) NULL,
    [DataCollectionOn] DATETIME      NULL,
    [ErrorOut]         BIT           NULL,
    CONSTRAINT [PK_VinReservation] PRIMARY KEY CLUSTERED ([ResId] ASC),
    CONSTRAINT [FK_VinReservation_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Recall_User] ([UserId])
);






GO
CREATE NONCLUSTERED INDEX [IDX_Recall_VinReservation_VIN]
    ON [dbo].[Recall_VinReservation]([VIN] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_Recall_VinReservation_UserId_DataCollectionOn]
    ON [dbo].[Recall_VinReservation]([UserId] ASC, [DataCollectionOn] ASC);

