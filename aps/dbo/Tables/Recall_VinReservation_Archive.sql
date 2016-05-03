CREATE TABLE [dbo].[Recall_VinReservation_Archive] (
    [ResId]            INT           IDENTITY (1, 1) NOT NULL,
    [UserId]           INT           NULL,
    [VIN]              VARCHAR (20)  NULL,
    [RecallData]       VARCHAR (200) NULL,
    [DataCollectionOn] DATETIME      NULL,
    [ErrorOut]         BIT           NULL,
    CONSTRAINT [PK_VinReservation_Archive] PRIMARY KEY CLUSTERED ([ResId] ASC),
    CONSTRAINT [FK_VinReservation_Archive_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Recall_User] ([UserId])
);




GO
CREATE NONCLUSTERED INDEX [IX_Recall_VinReservation_Archive_VIN]
    ON [dbo].[Recall_VinReservation_Archive]([VIN] ASC);

