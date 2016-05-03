-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-17
-- Description:	Reservs VIN via windows service reading user config and updates Recall_Reservation
--		Ignoring all the VINs not found in campaign file, ignoring invalid vins
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_WS_Reserve_Vin]
	@Debug INT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TotalVin INT, @Cnt INT, @CurrentUserId VARCHAR(20), @CurrentUserResCnt INT
	DECLARE @User TABLE (ID INT IDENTITY, UserId INT, ResCnt INT)

	SELECT @TotalVin = COUNT(1), @Cnt=1 FROM dbo.Recall_VinInfo v (NOLOCK)
		JOIN (SELECT DISTINCT MAKETXT,MODELTXT,YEARTXT FROM [dbo].[Recall_Campaign] (NOLOCK)) c  ON v.Make=c.MAKETXT AND v.Model=c.MODELTXT AND v.ModelYear=c.YEARTXT
		AND LEN(VIN)>=17 AND SUBSTRING(VIN,1,1)<>'0'

	IF @Debug=1
		SELECT *, @TotalVin, CEILING(@TotalVin*WorkRatio/UserCnt) FROM dbo.Recall_UserGroup ug (NOLOCK) JOIN dbo.Recall_User u (NOLOCK) ON ug.UserGroupId=u.UserGroupId
			JOIN (SELECT UserGroupId, UserCnt = COUNT(1) FROM dbo.Recall_User u (NOLOCK) GROUP BY UserGroupId) uc ON u.UserGroupId=uc.UserGroupId 

	INSERT INTO @User (UserId, ResCnt)
	SELECT UserId, CEILING(@TotalVin*WorkRatio/UserCnt) FROM dbo.Recall_UserGroup ug (NOLOCK) JOIN dbo.Recall_User u (NOLOCK) ON ug.UserGroupId=u.UserGroupId
			JOIN (SELECT UserGroupId, UserCnt = COUNT(1) FROM dbo.Recall_User u (NOLOCK) GROUP BY UserGroupId) uc ON u.UserGroupId=uc.UserGroupId 

	WHILE @Cnt<=(SELECT COUNT(1) FROM @User)
	BEGIN
		SELECT @CurrentUserId = UserId, @CurrentUserResCnt=ResCnt FROM @User WHERE ID=@Cnt
		
		INSERT INTO dbo.Recall_VinReservation(UserId,VIN)
		SELECT TOP (@CurrentUserResCnt) @CurrentUserId,VIN FROM dbo.Recall_VinInfo v (NOLOCK) 
			JOIN (SELECT DISTINCT MAKETXT,MODELTXT,YEARTXT FROM [dbo].[Recall_Campaign] (NOLOCK)) c ON v.Make=c.MAKETXT AND v.Model=c.MODELTXT AND v.ModelYear=c.YEARTXT
			WHERE v.VIN NOT IN (SELECT VIN FROM dbo.Recall_VinReservation (NOLOCK))
			AND LEN(VIN)>=17 AND SUBSTRING(VIN,1,1)<>'0'
			ORDER BY RAND()

		SET @Cnt=@Cnt+1
	END
END

