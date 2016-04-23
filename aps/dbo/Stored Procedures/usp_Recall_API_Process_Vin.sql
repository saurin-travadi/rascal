-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-17
-- Description:	Get next available VIN by User. 
--	if post, update previous VIN and get next available VIN by user.
--	return user stats
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_API_Process_Vin]
	@User VARCHAR(20)
	,@VIN VARCHAR(20)=null
	,@Data VARCHAR(8000)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @UserID INT, @TotalReserved INT, @TotalRemaining INT

	SELECT @UserID=UserId FROM dbo.[Recall_User] (NOLOCK) WHERE UserName=@User

	BEGIN TRAN

	--Update Recall Info with matching VIN
	IF @VIN IS NOT NULL	--Update VIN information
		UPDATE [dbo].[Recall_VinReservation]
		   SET [LockOut] = NULL ,[RecallData] = @Data
			WHERE VIN = @VIN AND UserId = @UserID
	
	--Get User stats and next VIN
	SELECT @VIN = MIN(CASE WHEN (LockOut IS NULL OR LockOut<GETDATE()) AND RecallData IS NULL THEN VIN ELSE 'ZZZZZZZZZZZZZZZZZ' END),
			@TotalReserved = COUNT(*), 
			@TotalRemaining = SUM(CASE WHEN RecallData IS NULL THEN 1 ELSE 0 END)-1  
		FROM [dbo].[Recall_VinReservation] (NOLOCK) WHERE [UserId]=@UserID
		GROUP BY [UserId]

	--Lock VIN which we are returning 
	UPDATE [dbo].[Recall_VinReservation] SET [LockOut]=DATEADD(mi,1,GETDATE())
		WHERE [VIN]=@VIN
		

	COMMIT


	--Return result
	SELECT VIN=@VIN, TotalReserved=@TotalReserved, TotalRemaining=@TotalRemaining

END
