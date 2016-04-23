/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/



IF NOT EXISTS(SELECT 1 FROM [dbo].[Recall_UserGroup])
BEGIN
	SET IDENTITY_INSERT [dbo].[Recall_UserGroup] ON 
	INSERT [dbo].[Recall_UserGroup] ([UserGroupId], [UserGroupName], [WorkRatio]) VALUES (1, N'J', CAST(0.50 AS Numeric(18, 2)))
	INSERT [dbo].[Recall_UserGroup] ([UserGroupId], [UserGroupName], [WorkRatio]) VALUES (2, N'S', CAST(0.50 AS Numeric(18, 2)))
	SET IDENTITY_INSERT [dbo].[Recall_UserGroup] OFF
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[Recall_UserGroup])
BEGIN
	SET IDENTITY_INSERT [dbo].[Recall_User] ON 
	INSERT [dbo].[Recall_User] ([UserId], [UserName], [UserGroupId]) VALUES (1, N'Shabnam', 2)
	INSERT [dbo].[Recall_User] ([UserId], [UserName], [UserGroupId]) VALUES (2, N'Joe', 1)
	INSERT [dbo].[Recall_User] ([UserId], [UserName], [UserGroupId]) VALUES (3, N'Saurin', 2)
	SET IDENTITY_INSERT [dbo].[Recall_User] OFF
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[Recall_Information])
BEGIN
	SET IDENTITY_INSERT [dbo].[Recall_Information] ON 
	INSERT [dbo].[Recall_Information] ([InfoId], [Information], [InformationDescription]) VALUES (1, N'Campaign Import Instructions', N'http://www-odi.nhtsa.dot.gov/downloads/folders/Recalls/Import_Instructions_Recalls.pdf')
	INSERT [dbo].[Recall_Information] ([InfoId], [Information], [InformationDescription]) VALUES (2, N'NHTSA Database', N'http://www-odi.nhtsa.dot.gov/downloads/index.cfm')
	INSERT [dbo].[Recall_Information] ([InfoId], [Information], [InformationDescription]) VALUES (3, N'Campaign Information (zip file)', N'http://www-odi.nhtsa.dot.gov/downloads/folders/Recalls/FLAT_RCL.zip')
	SET IDENTITY_INSERT [dbo].[Recall_Information] OFF
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[Recall_Job])
BEGIN
	SET IDENTITY_INSERT [dbo].[Recall_Job] ON 
	INSERT [dbo].[Recall_Job] ([JobId], [JobName], [NextRun]) VALUES (1, N'Weekly_Campaign', CAST(N'2016-04-20 00:00:00.000' AS DateTime))
	INSERT [dbo].[Recall_Job] ([JobId], [JobName], [NextRun]) VALUES (2, N'Daily_Vin_Download', CAST(N'2016-04-20 00:00:00.000' AS DateTime))
	INSERT [dbo].[Recall_Job] ([JobId], [JobName], [NextRun]) VALUES (3, N'Daily_Output', CAST(N'2016-04-27 00:00:00.000' AS DateTime))
	SET IDENTITY_INSERT [dbo].[Recall_Job] OFF
END