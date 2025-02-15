/*********************************************************************
Scott Peters
Growing Numbers
https://advancedsqlpuzzles.com
Last Updated: 07/05/2022

This script is written in SQL Server's T-SQL


� This puzzle can also be solved using recursion
� This solution uses an initial numbers table (#Numbers) that must be populated
� Output is saved in the temporary table #Permutations
� Predicate logic is placed on the #Permutations table to limit the output to the correct records
� The code will run properly if the following conditions are met:
    1) The first number is a single digit
    2) All digits are successive and there are no gaps in numbers
    3) Two of the numbers cannot be two digits (i.e., 10 and 11)

**********************************************************************/

---------------------
---------------------
--Tables used
DROP TABLE IF EXISTS #Numbers;
DROP TABLE IF EXISTS #Permutations;
GO

---------------------
---------------------
--For this puzzle I manually create the #Numbers table to provide special testing cases (rather than using recursion)
CREATE TABLE #Numbers
(
Number INTEGER NOT NULL
);
GO

INSERT INTO #Numbers (Number) VALUES
(1),(2),(3),(4),(5); --Passes
--(6),(7),(8),(9),(10); --Passes
--(5),(7),(8),(9),(10); --Does Not Pass (Gap between 5 and 7)
--(7),(8),(9),(10),(11); --Does Not Pass (Two numbers greater than 10)
--(10),(11),(12); --Does Not Pass (Lowest number is not a single digit and the set contains two numbers greater than 10)
GO

---------------------
---------------------
--Declare and set variables
DECLARE @vTotalNumbers INTEGER = (SELECT COUNT(*) FROM #Numbers);

---------------------
---------------------
--Create the #Permutations table using recursion
WITH cte_Permutations (Permutation, Ids, Depth)
AS
(
SELECT  CAST(Number AS VARCHAR(MAX)) AS Permutation,
        CAST(CONCAT(Number,'') AS VARCHAR(MAX)) AS Ids,
        1 AS Depth
FROM    #Numbers
UNION ALL
SELECT  CONCAT(a.Permutation,b.Number),
        CONCAT(a.Ids,b.Number),
        a.Depth + 1
FROM    cte_Permutations a,
        #Numbers b
WHERE   a.Depth < @vTotalNumbers AND
        CAST(RIGHT(a.Ids,1) AS INTEGER) + 1  = b.Number
)
SELECT  Permutation
INTO    #Permutations
FROM    cte_Permutations;

---------------------
---------------------
--Display the results
SELECT  *
FROM    #Permutations
WHERE   LEFT(Permutation,1) = (SELECT MIN(Number) FROM #Numbers);
