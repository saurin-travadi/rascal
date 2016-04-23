-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-17
-- Description:	gets VIN recall information via windows service and output to drive
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_WS_Get_VinRecall]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS(SELECT 1 FROM [dbo].[Recall_VinReservation] (NOLOCK) WHERE [RecallData] IS NULL)
	BEGIN

		--Read RecallData + VIN in windows service, convert to .csv
		SELECT [VIN], [RecallData] FROM [dbo].[Recall_VinReservation] (NOLOCK)

		--Clear tables
		TRUNCATE TABLE [dbo].[Recall_VinReservation]
		TRUNCATE TABLE [dbo].[Recall_VinInfo]

	END
	
END
