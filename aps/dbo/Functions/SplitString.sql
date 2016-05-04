-- =============================================
-- Author:		Saurin Travadi
-- Create date: 2016-5-4
-- Description:	Splits string and returns a table
-- =============================================
CREATE FUNCTION dbo.SplitString
(
    @List       NVARCHAR(MAX),
    @Delimiter  NVARCHAR(255)
)
RETURNS TABLE
AS
    RETURN 
    (  
        SELECT Item = RTRIM(LTRIM(y.i.value('(./text())[1]', 'varchar(1000)')))
        FROM 
        ( 
			SELECT x = CONVERT(XML, '<i>' 
				+ REPLACE(@List, @Delimiter, '</i><i>') 
				+ '</i>').query('.')
        ) AS a CROSS APPLY x.nodes('i') AS y(i)
    );