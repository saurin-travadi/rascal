-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-17
-- Description:	Get next available VIN by User. 
--	if post, update previous VIN and get next available VIN by user.
--	return user stats
/* Use
	[dbo].[usp_Recall_API_Process_Vin] @User='saurin'
	[dbo].[usp_Recall_API_Process_Vin] @User='joe', @VIN='1FMDU34X4TUB59529',@Data='09V399000~', @Error=0
*/
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_API_Process_Vin]
	@User VARCHAR(20)
	,@VIN VARCHAR(20)=null
	,@Data VARCHAR(200)=' '
	,@Error INT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @UserID INT, @TotalReserved INT, @TotalRemaining INT, @Last10MinRate NUMERIC(5,2), @TimeDiff INT

	SELECT @UserID=UserId FROM dbo.[Recall_User] (NOLOCK) WHERE UserName=@User

	BEGIN TRAN

	--Update Recall Info with matching VIN
	IF @VIN IS NOT NULL	--Update VIN information
		UPDATE [dbo].[Recall_VinReservation]
		   SET [LockOut] = NULL ,[RecallData] = @Data, [DataCollectionOn]=getdate(), [ErrorOut]=@Error
			WHERE VIN = @VIN AND UserId = @UserID
	
	--Get User stats and next VIN
	SELECT @VIN = MIN(CASE WHEN (LockOut IS NULL OR LockOut<GETDATE()) AND RecallData IS NULL THEN VIN ELSE 'ZZZZZZZZZZZZZZZZZ' END),
			@TotalReserved = COUNT(*), 
			@TotalRemaining = SUM(CASE WHEN RecallData IS NULL THEN 1 ELSE 0 END)  
		FROM [dbo].[Recall_VinReservation] (NOLOCK) WHERE [UserId]=@UserID
		GROUP BY [UserId]
		

	SELECT @Last10MinRate = COUNT(1) FROM [dbo].[Recall_VinReservation] (NOLOCK) 
		WHERE [UserId]=@UserID AND DataCollectionOn BETWEEN DATEADD(mi,-10,GETDATE()) AND GETDATE()	
	SELECT @TimeDiff = DATEDIFF(MI,min(DataCollectionOn),max(DataCollectionOn)) FROM [dbo].[Recall_VinReservation] (NOLOCK) 
		WHERE [UserId]=@UserID AND DataCollectionOn BETWEEN DATEADD(mi,-10,GETDATE()) AND GETDATE()	

	IF @TimeDiff<>0
		SET @Last10MinRate=@Last10MinRate/@TimeDiff

	--Lock VIN which we are returning 
	UPDATE [dbo].[Recall_VinReservation] SET [LockOut]=DATEADD(mi,1,GETDATE())
		WHERE [VIN]=@VIN
		
	COMMIT


	--Return result
	SELECT VIN=@VIN, TotalReserved=@TotalReserved, TotalRemaining=@TotalRemaining, Rate=ISNULL(@Last10MinRate,0)

END
