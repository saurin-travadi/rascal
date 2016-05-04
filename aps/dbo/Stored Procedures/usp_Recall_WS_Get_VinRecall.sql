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

		CREATE TABLE #Recall(VIN varchar(20),RecallData VARCHAR(100),CampNo VARCHAR(12), CompName VARCHAR(256))

		--Get recalldata='' (system marked, no recall found) for all the vins in VinInfo but not added to VinReservation
		INSERT INTO #Recall(VIN,RecallData,CampNo, CompName)		
		SELECT DISTINCT rv.VIN,rv.RecallData,CAMPNO,COMPNAME FROM 
			(SELECT VIN,RecallData=item FROM [dbo].[Recall_VinReservation] CROSS APPLY dbo.SplitString(RecallData,'~') WHERE item IS NOT NULL) rv
			JOIN [dbo].[Recall_Campaign] c ON c.[CAMPNO]=REPLACE(rv.[RecallData],'-','') 
		UNION				
			SELECT DISTINCT rv.VIN,rv.RecallData,CAMPNO,COMPNAME FROM 
			(SELECT VIN,RecallData=item FROM [dbo].[Recall_VinReservation] CROSS APPLY dbo.SplitString(RecallData,'~') WHERE item IS NOT NULL) rv
			JOIN [dbo].[Recall_Campaign] c ON c.[CAMPNO]=REPLACE(rv.[RecallData],'-','')+'000' 
		UNION
			SELECT VIN,'','','' FROM [dbo].[Recall_VinInfo] (NOLOCK) WHERE VIN NOT IN (SELECT VIN FROM [dbo].[Recall_VinReservation] (NOLOCK))

		--Map camp number to hollander number (Joe to provide spread sheet)
		--map hollander number to LKQ number (Joe to provide spread sheet)
		--Read RecallData + VIN in windows service, convert to .csv
		SELECT r.VIN,r.RecallData,r.CampNo,r.CompName,xref.HollanderPartType,xref.LKQPartCode FROM #Recall r
		LEFT JOIN 
			(SELECT [CompName],lh.[HollanderPartType],lh.[LKQPartCode] FROM
				[dbo].[Recall_CampaignHollander_XRef] ch 
				JOIN [dbo].[Recall_LKQHollander_XRef] lh ON ch.HollanderPartType=lh.HollanderPartType
			) xref ON  r.CompName=xref.CompName

		DROP TABLE #Recall

	END
	
END
