use BaseBall_Summer_2023
/****** Object: Table [dbo].[AllstarFull] Script Date: 8/5/2017 2:08:04 PM ******/
IF OBJECT_ID (N'dbo.salaries_backup', N'U') IS NOT NULL
DROP TABLE [dbo].[salaries_backup]
GO
select * into salaries_Backup from salaries

-- 1.a. Create a primary key for the salaries_backup table using the playerid, yearid, lgid and
-- teamid columns to create the primary key

ALTER TABLE salaries_Backup
ALTER COLUMN 
    yearID int not null;
GO
ALTER TABLE salaries_Backup
ALTER COLUMN 
    teamID varchar(255) not null;
GO
ALTER TABLE salaries_Backup
ALTER COLUMN 
    lgID varchar(25) not null;
GO
ALTER TABLE salaries_Backup
ALTER COLUMN 
    playerID varchar(255) not null;
GO

SELECT * FROM salaries_Backup WHERE lgID IS NULL

-- You need to decide if errors found here are easier to fix through
-- SQL or if you should just delete the rows causing problems and
-- provide a list of the deleted rows to analysists to input into the
-- database. Whichever you decide, include the SQL the resolved the
-- problem in your answer. There are 40 rows with lgid problem

-- We might possibly make a query that fills in according to team name, since 
-- teams usually start with their city name:
SELECT lgID, teamID, name FROM Teams WHERE name like 'San Diego%'

-- However, this won't return the same name or lgID in all cases:
SELECT lgID, teamID, name FROM Teams WHERE name like 'Cincinnati%'

-- So I've decided to remove the problem rows with the following query:
DELETE FROM salaries_Backup
WHERE lgID IS NULL

ALTER TABLE salaries_Backup
ALTER COLUMN 
    lgID varchar(25) not null;
GO

-- b. Write a query using the ROW_NUMBER function to delete
-- duplicate keys. Hint: you need a subquery to rank the columns by
-- the primary key and then the main query would delete the rows
-- where rank is > 1. I find it easiest to create the subquery using a
-- WITH statement. This will delete 49 rows

WITH cte AS
(SELECT playerID, yearID, lgID, teamID,
                Row_Number() OVER(PARTITION BY playerID, yearID, lgID, teamID
                                 ORDER BY playerID) rank
    FROM salaries_Backup)
DELETE FROM cte WHERE rank > 1
go

ALTER TABLE salaries_Backup
ADD CONSTRAINT salaries_BackupPK PRIMARY KEY (playerID, yearID, lgID, teamID)
GO

-- b. Create the appropriate foreign keys referencing the PEOPLE and TEAMS tables. You will get
-- errors the first time you try to create the foreign keys. You must write queries that:
ALTER TABLE salaries_Backup
ADD CONSTRAINT FK_people_SB FOREIGN KEY (playerID)
    REFERENCES People (playerID)
GO 

ALTER TABLE salaries_Backup
ADD CONSTRAINT FK_Teams_SB FOREIGN KEY (yearID, lgID, teamID)
    REFERENCES Teams (yearID, lgID, teamID)
GO

-- i. Delete rows in the salaries_backup table not found in the people table. 294 rows
-- should be deleted
SELECT *
FROM salaries_Backup SB LEFT JOIN People P ON P.playerID = SB.playerID
WHERE P.playerID is NULL

DELETE FROM salaries_Backup
WHERE playerID in (
    SELECT SB.playerID
    FROM salaries_Backup SB LEFT JOIN People P ON SB.playerID = P.playerID
    WHERE P.playerID is null
)


-- ii. Delete rows in the salaries_backup table not found in the teams table. 132 rows
-- should be deleted
SELECT *
FROM salaries_Backup SB LEFT JOIN Teams T ON SB.yearID = T.yearID AND SB.lgID = T.lgID AND SB.teamID = T.teamID
WHERE T.yearID is NULL

-- DELETE
DELETE SB FROM salaries_Backup SB LEFT JOIN Teams T ON SB.yearID = T.yearID AND SB.lgID = T.lgID AND SB.teamID = T.teamID
WHERE T.yearID is NULL


-- iii. After deleting the bad rows (it is very difficult to fix them) run the SQL to creare the
-- Foreig keys again
ALTER TABLE salaries_Backup
ADD CONSTRAINT FK_people_SB FOREIGN KEY (playerID)
    REFERENCES People (playerID)
GO 

ALTER TABLE salaries_Backup
ADD CONSTRAINT FK_Teams_SB FOREIGN KEY (yearID, lgID, teamID)
    REFERENCES Teams (yearID, lgID, teamID)
GO



-- 2. Using the view provided in the assignment page, write a query that uses the RANK function to rank
-- the careerBA column where the careerBA < 0.3240 and > 0.10. Your results must show the playerid,
-- Full Name, CareerBA and the rank for the players. This query returns 13,526 rows. The highest rank
-- should be 13,562
SELECT playerID, [Full Name], careerBA, BA_rank
FROM (SELECT playerID, [Full Name], CareerBA,
     RANK() OVER(ORDER BY CareerBA DESC) BA_rank
    FROM IS631View
    WHERE CareerBA BETWEEN .10 AND 0.3240) AS a



-- 3. Write the same query as #2 but eliminate any gaps in the ranking by using dense_rank. This query
-- returns 13,562 rows the same as question 2. Note that the highest rank is now 1,962 and the
-- results no longer skip from 3 to 6. Dense_rank picks up at the next number which is 4.
SELECT playerID, [Full Name], careerBA, BA_rank
FROM (SELECT playerID, [Full Name], CareerBA,
     DENSE_RANK() OVER(ORDER BY CareerBA DESC) BA_rank
    FROM IS631View
    WHERE CareerBA BETWEEN .10 AND 0.3240) AS b



-- 4. Use the same query as #2, but find the ranking within the last year played by the player starting
-- with the most current year and working backwards. Partition By will restart the ranking for each
-- year.
SELECT playerID, [Full Name], LastPlayed, careerBA, BA_rank
FROM (SELECT playerID, [Full Name], LastPlayed, CareerBA,
     RANK() OVER(PARTITION BY LastPlayed ORDER BY CareerBA DESC) BA_rank
    FROM IS631View
    WHERE CareerBA BETWEEN .10 AND 0.3240) AS c
ORDER BY LastPlayed DESC



-- 5. Write the same query as #3, but show the ranking by tenths ( use the NTILE(10) parmeter). Each
-- ntile represents 1/10th of the players. Players with an ntile of 1 are in the top 10% of the batters for
-- the year. This query returns 13,562 rows.
SELECT playerID, [Full Name], LastPlayed, careerBA, Ntile
FROM (SELECT playerID, [Full Name], LastPlayed, CareerBA,
     NTILE(10) OVER(PARTITION BY LastPlayed ORDER BY CareerBA DESC) Ntile
    FROM IS631View
    WHERE CareerBA BETWEEN .10 AND 0.3240) AS c
ORDER BY LastPlayed DESC



-- 6. Using the Salaries table, write a query that compares the averages salary by team and year with
-- the windowed average (also called moving average) of the 3 prior years and the 1 year after the
-- current year. This query returns 1,068 rows. Note: I used a subquery to calculate the team’s
-- average salary and use the results of the subquery to get the windowed average.
SELECT teamID, yearID, format(Avg_Salary, 'c'),
    format(avg(Avg_Salary) OVER (ORDER BY teamID, yearID ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING), 'c') Windowed_Salary
-- , Windowed_Salary
FROM (
    SELECT teamID, yearID, avg(salary) Avg_Salary
    FROM Salaries
    GROUP BY teamID, yearID
) d



-- 7. Using the Batting table, write a query that shows that teamid, playerid, Player Full Name, total hits, total at
-- bats, total batting average (calculated by using sum(H)*1.0/sum(AB) as the formula) and show the players
-- rank within the team and the rank within all players. Only include players that have a minimum of 150 career
-- hits. This query returns 12, 964 rows
SELECT 
    *,
    RANK() OVER(PARTITION BY teamID ORDER BY [Total at Bats] DESC) [Team Rank], 
    RANK() OVER(ORDER BY [Total Hits] DESC) [All Player Batting Rank]
FROM (
    SELECT 
        B.teamID,
        -- name [Team Name], 
        P.playerID,
        nameGiven + ' ( ' + nameFirst + ' ) ' + nameLast [Player Full Name], 
        sum(B.H) [Total Hits],
        sum(B.AB) [Total At Bats],
        ISNULL(sum(B.H) * 1.0 / NULLIF(sum(B.AB), 0), 0) [Player BA],
        avg(ISNULL(sum(B.H) * 1.0 / NULLIF(sum(B.AB), 0), 0)) OVER(PARTITION BY B.teamID) [Team BA]
    FROM People P
        LEFT JOIN Batting B  ON B.playerId = P.playerID
        -- LEFT JOIN Teams T ON B.yearID = T.yearID AND B.lgID = T.lgID AND B.teamID = T.teamID
    -- WHERE B.teamID like 'BS1'
    GROUP BY B.teamID, 
        -- name, 
        P.playerId, nameFirst, nameLast, nameGiven) e
WHERE [Total At Bats] > 150
ORDER BY teamID, [Team Rank]



-- 8.	Using a recursive CTE, write a query that will generate the Months of the year using the function
-- DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), MonthNumber, 1))
WITH MonthsInAYear(MonthNumber, MonthName) AS (
    SELECT 1 AS MonthNumber, DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), 1, 1))
    UNION ALL
    SELECT MonthNumber + 1, DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), MonthNumber + 1, 1))
    FROM MonthsInAYear
    WHERE MonthNumber < 12
)
SELECT MonthNumber,MonthName
FROM MonthsInAYear




-- 9.   Using a query with the PIVOT option (see slide 26 of the Chapter 14 - Data Warehouse Presentation
-- 2022 Summer in Module 6 – Advanced SQL module), using the batting table write a query that
-- shows the number of home hrs (hr) hit in the last 5 years of each century (1895 to 1899, 1995 to
-- 1999 and 2018 to 2022) you want to use this data to see if the number of home runs hit has
-- increased over time. You must code each of the years individually in the IN cluse of the PIVOT
-- statement and enclose each year in brackets. The IN statement would start with yearid in ([1895],
-- [1896], [1897]
SELECT *
FROM (SELECT teamID, yearID, HR FROM Batting) B
PIVOT (sum(HR) for B.yearID in ([1895],[1896],[1897],[1898], [1899],
                                [1995],[1996],[1997],[1998],[1999],
                                [2018],[2019],[2020],[2021],[2022])) AS PivotTable