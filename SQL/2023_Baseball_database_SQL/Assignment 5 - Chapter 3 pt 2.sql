USE BaseBall_Summer_2023
go
-- 1. Write a query that lists the playerid, birthcity, birthstate, Home Runs (HR), Runs Batted In (RBI), At Bats
-- (AB) salary and batting average for all players born in California sorted by first name and year in
-- ascending order using the PEOPLE, SALARIES and BATTING tables. The joins must be made using the
-- WHERE clause. Make sure values are properly formatted. Sort your results by namefirst and yearid.
-- Note: your query should return 4,219 rows using the where statement to resolve divide by zero error or
-- 5,384 rows using nullif.
SELECT P.playerID, birthCity, birthState, S.teamID, HR, RBI, AB, format(salary,'C') AS salary, CONVERT(decimal(10,4), ISNULL(H * 1.0 / NULLIF(AB,0),0)) AS Batting_Average
FROM People P, Batting B, Salaries S
WHERE 
    birthState = 'CA' AND 
    P.playerID = B.playerID AND
    P.playerID = S.playerID AND
    S.playerID = B.playerID AND         -- is this line required?
    S.lgID = B.lgID AND
    S.teamID = B.teamID AND
    S.yearID = B.yearID
ORDER BY nameFirst, B.yearID

-- 2. Write the same query as #2 but use LEFT JOINs. This time 11,948 rows will be returned. Using nullif,
-- 14,881 rows will be returned. Order of tables in the FROM statement matters in this question. If you
-- JOIN PEOPLE and SALARIES first, all players with no salary information will have a 0.0000 batting
-- average. You will see some duplicates in your results due to problems in the Salary table. Running the
-- following query will identify the duplicates.
select playerid, yearid, teamid, count(yearid)
from salaries
group by playerid, yearid, teamid
having count(yearid) > 1

SELECT P.playerID, birthCity, birthState, B.teamID, HR, RBI, AB, B.yearID, format(salary,'C') AS Salary, CONVERT(decimal(10,4), ISNULL(H * 1.0 / NULLIF(AB,0),0)) AS Batting_Average
FROM 
    People P LEFT JOIN Batting B ON 
        P.playerID = B.playerID LEFT JOIN 
    Salaries S ON
        P.playerID = S.playerID AND
        S.playerID = B.playerID AND
        S.lgID = B.lgID AND
        S.teamID = B.teamID AND
        S.yearID = B.yearID
WHERE 
    birthState = 'CA'
ORDER BY nameFirst, B.yearID

-- 3. You get into a debate regarding the level of school that professional sports players attend. Your stance
-- is that there are plenty of baseball players who attended Ivy League schools and were good batters in
-- addition to being scholars. Write a query to support your argument using the CollegePlaying and Batting
-- tables. You must use an IN clause in the WHERE clause to identify the Ivy League schools. Write a query
-- that shows the playerid, namefirst, namelast, schoolid, yearid (from batting table), home runs (HR), at
-- bats (AB) and batting average(h/ab) for the players who attended Ivy League Schools. Your results
-- should be sorted by the #of HR in descending order and the batting yeardis also in descending order.
-- Note the yearid is the year for the batting average not the year in College Playing. The colleges in the Ivy
-- League are Brown, Columbia, Cornell, Dartmouth, Harvard, Princeton, UPenn, and Yale. You will need to
-- use the People, Batting and Collegeplaying tables. Your query should return 1,573 rows ( 1,823 using
-- nullif )
SELECT P.playerID, nameFirst, nameLast, schoolID, B.yearID, HR, AB, CONVERT(decimal(10,4), ISNULL(H * 1.0 / NULLIF(AB,0),0)) AS Batting_Average
FROM People P, CollegePlaying CP, Batting B
WHERE
    P.playerID = CP.playerID AND
    P.playerID = B.playerID AND
    schoolID IN ('brown', 'columbia','cornell','dartmouth','harvard', 'princeton', 'upenn','yale')
ORDER BY HR DESC, B.yearID DESC

-- 4. You are now interested in the longevity of players careers. Using the BATTING table and the appropriate
-- SET clause from slide 45 of the Chapter 3 PowerPoint presentation, find the players that played for the
-- same teams in 2016 and 2021. Your query only needs to return the playerid and teamids. The query
-- should return 138 rows.
SELECT B.playerID, B.teamID
    -- , Bat.teamID, B.yearID, Bat.yearID
FROM Batting B, Batting Bat
WHERE 
    B.playerID = Bat.playerID AND
    B.teamID = Bat.teamID AND
    B.yearID = 2016 AND 
    Bat.yearID = 2021
-- SELECT * INTO #batting FROM Batting
-- UPDATE #batting
-- SET playerID = (CASE 
--     WHEN ()
--     ELSE not 
--     END 
--     )

-- 5. Using the BATTING table and the appropriate SET clause from slide 45 of the Chapter 3 PowerPoint
-- presentation, find the players that played for the different teams in 2016 and 2021 Your query only
-- needs to return the playerids and the 2016 teamid. The query should return 1,344 rows.
SELECT B.playerID, B.teamID
-- , Bat.teamID, B.yearID, Bat.yearID
FROM Batting B, Batting Bat
WHERE 
    B.playerID = Bat.playerID AND
    B.teamID <> Bat.teamID AND
    B.yearID = 2016 AND Bat.yearID = 2021 AND
    B.yearID <> Bat.yearID




-- 6. Using the Salaries table, calculate the average and total salary for each player. Make sure the amounts
-- are properly formatted and sorted by the total salary in descending order. Your query should return
-- 6,246 rows.
SELECT playerID, format(avg(salary),'C') AS [Average Salary], format(sum(salary),'c') AS [Total Salary]
FROM Salaries
GROUP BY playerID
ORDER BY sum(salary) DESC





-- 7. Now that you know how to use aggregates, you decide to revisit the discussion about players from Ivy
-- League schools. Modify your query from #3 to show the playerid, namefirst, namelast, schoolid, total
-- HR and Total Salary. You will also need to use LEFT JOINS so players without salary information (salary
-- information started to be collected in the 1980s) do not drop out of the result set. Make sure your
-- results only show players who when to college. Your query should return 178 rows.
SELECT P.playerID, nameFirst, nameLast, schoolID, sum(HR) AS [Total HR], format(sum(salary),'C') AS [Total Salary]
FROM CollegePlaying CP 
    LEFT JOIN People P ON P.playerID = CP.playerID 
    LEFT JOIN Batting B ON P.playerID = B.playerID 
    LEFT JOIN Salaries S ON P.playerID = S.playerID AND B.yearID = S.yearID AND B.teamID = S.teamID
WHERE schoolID IN ('brown', 'columbia','cornell','dartmouth','harvard', 'princeton', 'upenn','yale')
GROUP BY P.playerID, nameFirst, nameLast, schoolID
ORDER BY [Total HR] DESC
    
-- 8. Using the Batting and People tables and a HAVING clause, write a query that lists the playerid, the
-- players full name, the number of home runs (HR) for all players having more than 400 home runs and
-- the number of years they played. The query should return 57 rows.
Select B.playerID, nameFirst + ' (' + nameGiven + ') ' + nameLast AS [Full_Name], sum(HR) AS [Total Home Runs], count(yearID) AS [Years_Played]
FROM Batting B, People P
Where B.playerID = P.playerID
GROUP BY B.playerID, nameFirst, nameLast, nameGiven
HAVING sum(HR) > 400
ORDER BY sum(HR) DESC

-- 9. Hitting 500 home runs is a hallmark achievement in baseball. You want to project if the players with
-- under 500 but more than 400 home runs will have over 500 home runs, assuming they will play for a
-- total of 22 years like the top players in question 7. To create your estimates, divide the total number of
-- home runs by the years played and multiply by 22. Use a BETWEEN clause in the HAVING statement to
-- identify players having between 400 and 499 home runs. Only include playeris you estimate will reach
-- the 500 HR goal. This will return 18 rows
Select 
    B.playerID, 
    nameFirst + ' (' + nameGiven + ') ' + nameLast AS [Full_Name], 
    sum(HR) AS [Total Home Runs], 
    count(yearID) AS [Years_Played],
    sum(HR) / count(yearID) * 22 AS [Projected_HR]
FROM Batting B, People P
Where B.playerID = P.playerID
GROUP BY B.playerID, nameFirst, nameLast, nameGiven
HAVING sum(HR) BETWEEN 400 AND 499 AND sum(HR) / count(yearID) * 22 > 499
ORDER BY sum(HR) / count(yearID) * 22 DESC, Years_Played DESC


-- 10. Using a subquery along with an IN clause in the WHERE statement, write a query that identifies all the
-- playerids, the players full name and the team names who in 2022 that were playing on teams that
-- existed prior to 1900. You should use the appearances table to identify the players years and the TEAMS
-- table to identify the team name. Sort your results by team name and then the player’s last name. Your
-- query should return 360 rows.
SELECT name as Team_Name, A.playerID, nameFirst + ' (' + nameFirst + ') ' + nameLast AS [Full_Name]
FROM Teams T 
    LEFT JOIN Appearances A ON A.teamID = T.teamID AND A.lgID = T.lgID AND A.yearID = T.yearID
    LEFT JOIN People P ON A.playerID = P.playerID
WHERE 
    A.yearID = 2022 AND
    A.teamID IN (Select teamID
                FROM Appearances
                WHERE yearID < 1900)
ORDER BY name, nameLast

-- 11. Using the Salaries table, find the players full name, average salary and the last year they played for
-- each team they played for during their career. Also find the difference between the players salary and
-- the average team salary. You must use subqueries in the FROM statement to get the team and player
-- average salaries and calculate the difference in the SELECT statement. Sort your answer by the last year
-- in descending order , the difference in descending order and the playerid in ascending order. The query
-- should return 13,829 rows
SELECT 
    P.playerID, 
    nameGiven + ' (' + nameFirst + ') ' + nameLast AS [Full_Name], 
    TS.teamID, 
    [Last Year],
    format(pavg_salary,'C') AS [Player Average],
    format(tavg_salary,'C') AS [Team Average],
    format(pavg_salary - tavg_salary,'C') AS Difference
FROM 
    (SELECT teamID, avg(salary) AS tavg_salary
    FROM Salaries
    GROUP BY teamID) TS,
    (SELECT playerID, teamID, avg(salary) AS pavg_salary, max(yearID) AS [Last Year]
    FROM Salaries
    GROUP BY playerID, teamID) PS,
    People P
WHERE TS.teamID = PS.teamID
    AND P.playerID = PS.playerID
ORDER BY [Last Year] DESC, pavg_salary - tavg_salary DESC, P.playerID


-- 12. Rewrite the query in #11 using a WITH statement for the subqueries instead of having the subqueries in
-- the from statement. The answer will be the same. Please make sure you put a GO statement before
-- and after this problem. 5 points will be deducted if the GO statements are missing and I have to add
-- them manually.
GO
WITH TS AS (SELECT teamID, avg(salary) AS tavg_salary
            FROM Salaries
            GROUP BY teamID),
    PS AS (SELECT playerID, teamID, avg(salary) AS pavg_salary, max(yearID) AS [Last Year]
            FROM Salaries
            GROUP BY playerID, teamID)
SELECT 
    P.playerID, 
    nameGiven + ' (' + nameFirst + ') ' + nameLast AS [Full_Name], 
    TS.teamID, 
    [Last Year],
    format(pavg_salary,'C') AS [Player Average],
    format(tavg_salary,'C') AS [Team Average],
    format(pavg_salary - tavg_salary,'C') AS Difference
FROM TS, PS, People P
WHERE TS.teamID = PS.teamID
    AND P.playerID = PS.playerID
ORDER BY [Last Year] DESC, pavg_salary - tavg_salary DESC, P.playerID

GO

-- 13. Using a scalar queries in the SELECT statement and the salaries, batting, pitching and people tables ,
-- write a query that shows the full Name, the average salary (from SALARIES table), career batting
-- average (from the BATTING table), career ERA (the average of the ERA from the PITCHING table), total
-- errors (sum of E from the Fielding table) and the number of teams the player played (from the BATTING
-- table). Format the results as shown below and only use the PEOPLE table in the FROM statement of the
-- top level select. This query returns 20,676 rows
SELECT 
    nameGiven + ' (' + nameFirst + ') ' + nameLast AS [Full Name], 
    (SELECT count(teamID) FROM Batting WHERE Batting.playerID = P.playerID GROUP BY Batting.playerID) AS [Total Teams],
    (format((SELECT avg(salary) FROM Salaries WHERE Salaries.playerID = P.playerID GROUP BY Salaries.playerID),'c')) AS [Avg Salary],
    (SELECT avg(ERA) FROM Pitching WHERE Pitching.playerID = P.playerID GROUP BY Pitching.playerID) AS [Avg ERA],
    (SELECT avg(E) FROM Fielding WHERE Fielding.playerID = P.playerID GROUP BY Fielding.playerID) AS [Total Errors],
    (SELECT avg(ISNULL(H * 1.0 /NULLIF(AB,0),0)) FROM Batting WHERE Batting.playerID = P.playerID GROUP BY Batting.playerID) AS [Avg BA]
FROM People P
ORDER BY nameLast

-- 14. The player’s union has negotiated that players will start to have a 401K retirement plan. Using the
-- [401K_Player_Contributions] column in the Salaries table, populate this column for each row by updating
-- it to contain 6% of the salary in the row. You must use an UPDATE query to fill in the amount. This query
-- updates 32,036 rows. Use the column names given, do not create your own columns. Include a select
-- query with the results sorted by playerid as part of your answer that results the rows shown below.
-- Note the column names need to be inside brackets because they start with a number. This is bad
-- naming conventions on my part.
-- SELECT * INTO #salaries FROM Salaries
-- UPDATE #salaries
--     SET [401K_Player_Contributions] = .06 * salary
-- SELECT playerID, salary, [401K_Player_Contributions] FROM #salaries ORDER BY playerID

UPDATE Salaries
    SET [401K_Player_Contributions] = .06 * salary
SELECT playerID, salary, [401K_Player_Contributions] FROM Salaries ORDER BY playerID

-- 15. Contract negotiations have proceeded and now the team owner will make a seperate contribution to
-- each players 401K each year. If the player’s salary is under $1 million, the team will contribute another
-- 5%. If the salary is over $1 million, the team will contribute 2.5%. You now need to write an UPDATE
-- query for the [401K_Team_Contributions] column in the Salaries table to populate the team contribution
-- with the correct amount. You must use a CASE clause in the UPDATE query to handle the different
-- amounts contributed. This query updates 32,036 rows.
-- UPDATE #salaries
--     SET [401K_Team_Contributions] = CASE
--         WHEN salary <= 1000000 THEN salary * .05
--         ELSE salary * .025
--         END
-- SELECT playerID, salary, [401K_Player_Contributions], [401K_Team_Contributions] FROM #salaries ORDER BY playerID
UPDATE Salaries
    SET [401K_Team_Contributions] = CASE
        WHEN salary <= 1000000 THEN salary * .05
        ELSE salary * .025
        END
SELECT playerID, salary, [401K_Player_Contributions], [401K_Team_Contributions] FROM Salaries ORDER BY playerID

-- 16. You have now been asked to populate the columns to the PEOPLE table that contain the total number
-- of HRs hit ( Total_HR column) by the player and the highest Batting Average the player had during any
-- year they played ( High_BA column). Write a single query that correctly populates these columns. You
-- will need to use a subquery to make is a single query. This query updates 18,003 rows if you use AB > 0
-- in the where statement. It updates 20,469 rows in nullif is used for batting average. After your update
-- query, write a query that shows the playerid, Total HRs and Highest Batting Average for each player.
-- The Batting Average must be formatted to only show 4 decimal places. Sort the results by playerid. The
-- update query will update 20,676 rows and the select query will return 20,370 rows.
UPDATE  P
SET     [Total_HR] = new_calc.[HR_total],
        [High_BA] = new_calc.[Batting_Average]
FROM    People P
        LEFT JOIN (SELECT playerID, 
                    sum(HR) AS HR_total, 
                    max(CONVERT(decimal(10,4), ISNULL(H * 1.0 / NULLIF(AB,0),0))) AS Batting_Average
                    FROM Batting GROUP BY playerID) new_calc
            ON P.playerID = new_calc.playerID
SELECT playerID, Total_HR, High_BA FROM People WHERE [Total_HR] IS NOT NULL AND [High_BA] IS NOT NULL ORDER BY playerID 

-- 17. You have also been asked to populate a column in the PEOPLE table ( Total_401K column) that contains
-- the total value of the 401K for each player in the Salaries table. Write the SQL that correctly populates
-- the column. This query updates 6,212 rows. Also, include a query that shows the playerid, the player
-- full name and their 401K total from the people table. Only show players that have contributed to their
-- 401Ks. Sort the results by playerid. . This query returns 6,210 rows.

UPDATE P
SET [Total_401K] = total_calc.Total
FROM People P
    LEFT JOIN (SELECT playerID, 
                    sum([401K_Player_Contributions]) AS player_contr, 
                    -- sum([401K_Team_Contributions]) AS team_contr,
                    sum([401K_Player_Contributions]) + sum([401K_Team_Contributions]) AS Total
                FROM Salaries
                WHERE [401K_Player_Contributions] > 0 AND [401K_Player_Contributions] IS NOT NULL
                GROUP BY playerID
            ) total_calc
        ON P.playerID = total_calc.playerID
WHERE player_contr > 0 AND player_contr IS NOT NULL
SELECT playerID, nameGiven + ' (' + nameFirst + ') ' + nameLast AS [Full_Name], [Total_401K]
FROM People WHERE [Total_401K] IS NOT NULL

-- 18. 2021 Fan Cost Index (the amount it costs for a group of four people to attend an MLB game was an
-- average of $256.41. MLB management has asked you to calculate the following using the teamid, name,
-- yearid, attendance and GHomes (# of home games) from teams table:

-- c. The number of extra games it would take to recover the losses (total amount lost / average loss
-- per game
-- d. Per-COVID average attendance (pre-COVID attendance/pre-COVID HGames)
-- e. COVID average attendance (sum of attendance / sum HGames)
-- f. COVID drop in per average game attendance (e minus d)
-- g. % drop in attendance due to cover (e divided by d)

SELECT A_post.teamID, A_post.name, 
    CONVERT(decimal(25,2),(A_post.Attendance_new - A_pre.Attendance_new) * (256.41 / 4)) AS Total_Team_Loss,
    CONVERT(decimal(25,2), ((A_post.Attendance_new - A_pre.Attendance_new)) / [Total_COVID_HGames]) AS [CV_per_Game_$_Loss],
    CEILING(CONVERT(decimal(25,2),(A_pre.Attendance_new - A_post.Attendance_new)) / 
            CONVERT(decimal(25,2), ((A_post.Attendance_new - A_pre.Attendance_new)) / [Total_COVID_HGames])) AS [Games_to_Recover]
FROM 

-- a. The total amount the team lost due to covid (The difference between pre-COVID and COVID
-- Attendance (from the Teams table) multiplied by the per person Fan Cost Index)
    -- (SELECT name, teamID, sum(CAST(attendance AS int)) AS Attendance_new
    --     FROM Teams WHERE yearID in (2020,2021) GROUP BY teamID, name) A_post,
    (SELECT name, teamID, CAST(attendance AS int) AS Attendance_new
        FROM Teams WHERE yearID in (2021)) A_post,
    -- (SELECT teamID, sum(CAST(attendance AS int)) AS Attendance_new
    --     FROM Teams WHERE yearID = 2019 GROUP BY teamID) A_pre,
    (SELECT teamID, CAST(attendance AS int) AS Attendance_new
        FROM Teams WHERE yearID = 2019 ) A_pre,

-- b. The average loss per game (Total amount lost/Total number of COVID HGames)
    (SELECT teamID, sum(CAST(GHome AS int)) AS [Total_COVID_HGames] 
        FROM teams WHERE yearID in (2020,2021) GROUP BY teamID) B
WHERE 
    A_post.teamID = A_pre.teamID AND
    A_post.teamID = B.teamID AND 
    B.teamID = A_pre.teamID
ORDER BY Total_Team_Loss

