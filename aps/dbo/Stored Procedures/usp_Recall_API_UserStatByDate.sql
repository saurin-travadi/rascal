-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-23
-- Description:	Get User Stats by date. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_API_UserStatByDate]
	@User VARCHAR(20)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @UserID INT

	--Get User stats 
	IF @User=''
		SELECT u.UserName,DataCollectionOn=CONVERT(DATE,DataCollectionOn),Cnt=COUNT(1)
			FROM [dbo].[Recall_VinReservation] vr (NOLOCK) JOIN [dbo].[Recall_User] u ON vr.UserId=u.UserId
			WHERE vr.RecallData IS NOT NULL
			GROUP BY u.UserName, CONVERT(DATE,DataCollectionOn)
				ORDER BY 1, 2 DESC
	ELSE
	BEGIN
		SELECT @UserID=UserId FROM dbo.[Recall_User] (NOLOCK) WHERE UserName=@User
		
		SELECT UserName,DataCollectionOn=CONVERT(DATE,DataCollectionOn),Cnt=COUNT(1)
			FROM [dbo].[Recall_VinReservation] vr (NOLOCK) JOIN [dbo].[Recall_User] u ON vr.UserId=u.UserId
			WHERE vr.RecallData IS NOT NULL AND vr.[UserId]=@UserID
			GROUP BY UserName,CONVERT(DATE,DataCollectionOn)
			ORDER BY 2 DESC
	END
END