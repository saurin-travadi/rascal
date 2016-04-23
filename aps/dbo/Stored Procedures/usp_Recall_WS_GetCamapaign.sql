-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-04-20
-- Description:	Gets no row (just schema for datatable) from Recall_Campaign, so windows service can use SQLBulkCopy to insert rows
-- =============================================
CREATE PROCEDURE dbo.[usp_Recall_WS_GetCamapaign]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [RECORD_ID]
      ,[CAMPNO]
      ,[MAKETXT]
      ,[MODELTXT]
      ,[YEARTXT]
      ,[MFGCAMPNO]
      ,[COMPNAME]
      ,[MFGNAME]
      ,[BGMAN]
      ,[ENDMAN]
      ,[RCLTYPECD]
      ,[POTAFF]
      ,[ODATE]
      ,[INFLUENCED_BY]
      ,[MFGTXT]
      ,[RCDATE]
      ,[DATEA]
      ,[RPNO]
      ,[FMVSS]
      ,[DESC_DEFECT]
      ,[CONEQUENCE_DEFECT]
      ,[CORRECTIVE_ACTION]
      ,[NOTES]
      ,[RCL_CMPT_ID]
  FROM [dbo].[Recall_Campaign]
	WHERE 1=0

END
