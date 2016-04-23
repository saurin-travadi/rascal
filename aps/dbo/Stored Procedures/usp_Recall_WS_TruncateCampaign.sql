-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-4-17
-- Description:	truncates Campaign table
-- =============================================
CREATE PROCEDURE [dbo].[usp_Recall_WS_TruncateCampaign]
WITH EXECUTE AS owner
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE [dbo].[Recall_Campaign]

END
