-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-24
-- Description:	Archive Recall information recd from users, archive vininfo
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_WS_ArchiveVinReservation]
WITH EXECUTE AS owner
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Ignore if any vin has not recd any information
	IF NOT EXISTS(SELECT 1 FROM [dbo].[Recall_VinReservation] (NOLOCK) WHERE [RecallData] IS NULL)
	BEGIN
		BEGIN TRAN
	
		--Get Production count before archiving current set
		INSERT INTO [dbo].[Recall_ProductionStat]([UserId],[DataCollectionOn],[CollectionCount])
		EXEC [dbo].[usp_Recall_API_UserStatByDate]

		--Archive current set
		INSERT INTO [dbo].[Recall_VinReservation_Archive]
			   ([UserId],[VIN],[RecallData],[DataCollectionOn],[ErrorOut])
		SELECT [UserId],[VIN],[RecallData],[DataCollectionOn],[ErrorOut]
			FROM [dbo].[Recall_VinReservation] (NOLOCK)

		INSERT INTO [dbo].[Recall_VinInfo_Archive]
           ([VIN],[Make],[Model],[ModelYear])
		SELECT [VIN],[Make],[Model],[ModelYear] 
			FROM [dbo].[Recall_VinInfo] (NOLOCK)


		--truncate current set
		TRUNCATE TABLE [dbo].[Recall_VinReservation]
		TRUNCATE TABLE [dbo].[Recall_VinInfo] 

		COMMIT
	END

END