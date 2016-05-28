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

		CREATE TABLE #Recall(VIN varchar(20),Make VARCHAR(100), Model VARCHAR(100), ModelYear INT, RecallData VARCHAR(100), CampNo VARCHAR(50), CompName VARCHAR(256))

		--Get all VINs not given to humans		
		INSERT INTO #Recall(VIN, Make, Model, ModelYear, RecallData)
		SELECT VIN,Make,Model,ModelYear,NULL FROM [dbo].[Recall_VinInfo] vi (NOLOCK) WHERE VIN NOT IN (SELECT VIN FROM [dbo].[Recall_VinReservation] (NOLOCK) WHERE LEN(RecallDatA)>1)

		--Get all VINs given to humans
		INSERT INTO #Recall(VIN, Make, Model, ModelYear, RecallData)
		SELECT vi.VIN,Make,Model,ModelYear,Item FROM [dbo].[Recall_VinInfo] vi (NOLOCK)
			JOIN (SELECT VIN,Item FROM [dbo].[Recall_VinReservation] vr (NOLOCK) CROSS APPLY dbo.SplitString(ISNULL(RecallData,''),'~') 
				WHERE VIN IN (SELECT VIN FROM [dbo].[Recall_VinReservation] (NOLOCK) WHERE LEN(RecallDatA)>1)
				AND Item IS NOT NULL
			)vr ON vi.VIN=vr.VIN

		UPDATE r SET CampNo=c.CAMPNO, CompName=c.COMPNAME
			FROM #Recall r JOIN [dbo].[Recall_Campaign] c ON c.[CAMPNO]=REPLACE(r.[RecallData],'-','') AND c.MAKETXT=r.Make AND c.MODELTXT=r.Model AND c.YEARTXT=r.ModelYear

		UPDATE r SET CampNo=c.CAMPNO, CompName=c.COMPNAME
			FROM #Recall r JOIN [dbo].[Recall_Campaign] c ON c.[CAMPNO]=REPLACE(r.[RecallData],'-','')+'000' AND c.MAKETXT=r.Make AND c.MODELTXT=r.Model AND c.YEARTXT=r.ModelYear


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
