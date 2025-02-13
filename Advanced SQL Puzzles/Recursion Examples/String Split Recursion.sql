/*----------------------------------------------------
Scott Peters
https://AdvancedSQLPuzzles.com

Same as the STRING_SPLIT function.
Splits a string into rows of substrings, based on a specified separator character 

*/----------------------------------------------------

-------------------------------
-------------------------------
DROP TABLE IF EXISTS #Example;
GO

-------------------------------
-------------------------------
SELECT *
INTO #Example
FROM (VALUES(1,'George Washington'),(2,'Thomas Jefferson')) n(Id,String);
GO

-------------------------------
-------------------------------
;WITH cte_String AS
(
SELECT Id, 
       CAST(String AS VARCHAR(200)) AS String
FROM   #Example
),
cte_Recursion AS
(
SELECT Id,
       String,
       1 AS Starts,
       CHARINDEX(' ', String) AS Position
FROM   cte_String
UNION ALL
SELECT Id,
       String,
       Position + 1,
       CHARINDEX(' ', String, Position + 1)
FROM   cte_Recursion
WHERE  Position > 0
)
SELECT  ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Starts) AS RowNumber,
        *,
        SUBSTRING(String, Starts, CASE WHEN Position > 0 THEN Position - Starts ELSE LEN(String) END) Word,
        LEN(String) - LEN(REPLACE(String,' ','')) AS TotalSpaces
FROM   cte_Recursion
ORDER BY Id, Starts;