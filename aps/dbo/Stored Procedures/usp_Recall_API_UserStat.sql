-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-23
-- Description:	Get User Stats. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_API_UserStat]
	@User VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @UserID INT, @TotalReserved INT, @TotalRemaining INT

	SELECT @UserID=UserId FROM dbo.[Recall_User] (NOLOCK) WHERE UserName=@User

	--Get User stats 
	SELECT @TotalReserved = COUNT(*), 
			@TotalRemaining = SUM(CASE WHEN RecallData IS NULL THEN 1 ELSE 0 END)  
		FROM [dbo].[Recall_VinReservation] (NOLOCK) WHERE [UserId]=@UserID
		GROUP BY [UserId]

	--Return result
	SELECT TotalReserved=@TotalReserved, TotalRemaining=@TotalRemaining

END