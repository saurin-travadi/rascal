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

		--Get recalldata='' (system marked, no recall found) for all the vins in VinInfo but not added to VinReservation

		--Map camp number to hollander number (Joe to provide spread sheet)

		--map hollander number to LKQ number (Joe to provide spread sheet)
		
		--Read RecallData + VIN in windows service, convert to .csv
		SELECT [VIN], [RecallData], CampNo='', CompName='', HollanderPart='', LKQPart=''  FROM [dbo].[Recall_VinReservation] (NOLOCK)

	END
	
END
