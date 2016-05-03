-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-17
-- Description:	gets VIN information from drive via windows service and save into DB
--	Inserts everything you find in csv including invalid VINs
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_WS_Insert_Vin]
	@XMLData VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM [dbo].[Recall_VinInfo] (NOLOCK))
	BEGIN
		--insert into [dbo].[Recall_VinInfo]
		select 1
	END
	
END
