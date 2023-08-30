use BaseBall_Summer_2023;
go
-- 1. Using the Pitching table, write a query that select 
-- the playerid, teamid, Wins (W), Loss (L) and Earned Run Average (ERA) 
-- for every player (Slide 15). This query should return 50,402 rows.
SELECT playerID, teamID, W, L, ERA
FROM Pitching

-- 2. Modify the query you wrote in #1 to be sorted by era in descending 
-- order (Slide 34). This query should return 50,402 rows.
SELECT playerID, teamID, W, L, ERA
FROM Pitching
ORDER BY ERA DESC

-- 3. You decide you want to know the name of every team and the park they played in. Using the TEAMS
-- table write a query that returns the team name (name) and the park name (park) sorted by the Park in
-- descending order. Your query should return only 1 row for each team name and park combination (Slide
-- 16 Distinct ). This query should return 322 rows.
SELECT DISTINCT name, park, teamID
FROM Teams
ORDER BY park DESC

-- 4. A friend is wonder how many bases a player “touches” in a given year. Write a query using the BATTING
-- that calculates the bases touched for each player and team they played for each year they played. You
-- can calculate this by multiplying B2 *2, B3*3 and HR *4 and then adding all these calculated values to
-- the values in BB and H. (Slide 17) Rename the calculated column Total_Bases_Touched. Your output
-- should include the playerid and yearid and teamid in addition to the Totlal_Bases_Touched column. This
-- query should return 112,184 rows.
SELECT playerID, yearID, teamID, (B2*2 + B3*3 + HR *4 + BB + H) AS Total_Bases_Touched
FROM Batting
ORDER BY yearID, playerID

-- 5. Since we are in the New York area, we’re interested in the NY Yankees and their rivals the Boston Red
-- Sox. Modify the query you wrote for #4 by adding a where statement (Slide 22) that only select the 2 NY
-- teams, the Yankees and the Red Soxs (Teamid equals NYA or BOS) so that only the information for these
-- teams is returned. Your results must be sorted by Total_Bases_Touched in descending order then by
-- the playerid in ascending order. This query should return 9,209 rows.
SELECT playerID, yearID, teamID, (B2*2 + B3*3 + HR *4 + BB + H) AS Total_Bases_Touched
FROM Batting
WHERE teamID IN ('NYA', 'BOS')
ORDER BY Total_Bases_Touched DESC, yearID

-- 6. Your curious how a player’s “bases touched “compares to the teams for a given year. You do this by
-- adding the Teams table to the query (Slide 24) and calculating a Teams_Bases_Touched columns using
-- the same formula for the H, HR, BB, B2 and B3 columns in the teams table. You also want to know the
-- percentage of the teams touched bases each payer was responsible for. Calculated the Touched_%
-- column and use the FORMAT statement for show the results as a % and with commas (Slide 20 and 29).
-- Only select the same 2 teams, the Yankees and the Red Sox (Teamid equals NYA or BOS). Write your
-- query with a FROM statement that uses the format FROM BATTING, TEAMS. The FROM parameter
-- should be in the format FROM table1, table2 and the join parameters need to be in the WHERE
-- parameter. Your results should be sorted by Touched_% in descending order then by playerid in
-- ascending order. Your query should return 9,209 rows.
SELECT playerID, B.yearID, B.teamID, 
    (B.B2*2 + B.B3*3 + B.HR *4 + B.BB + B.H) AS Total_Bases_Touched,
    (T.B2*2 + T.B3*3 + T.HR *4 + T.BB + T.H) AS Teams_Total_Bases_Touched,
    format((B.B2*2 + B.B3*3 + B.HR *4 + B.BB + B.H) *1.0 / (T.B2*2 + T.B3*3 + T.HR *4 + T.BB + T.H) *1.0, 'P') AS [Touched_%]
FROM Batting B, Teams T
WHERE B.teamID IN ('NYA', 'BOS') AND B.teamID = T.teamID AND B.yearID = T.yearID
ORDER BY [Touched_%] DESC, playerID

-- 7. Rewrite the query in #6 using a JOIN parameter in the FROM statement. The results will be the same.
SELECT playerID, B.yearID, B.teamID, 
    (B.B2*2 + B.B3*3 + B.HR *4 + B.BB + B.H) AS Total_Bases_Touched,
    (T.B2*2 + T.B3*3 + T.HR *4 + T.BB + T.H) AS Teams_Total_Bases_Touched,
    format((B.B2*2 + B.B3*3 + B.HR *4 + B.BB + B.H) *1.0 / (T.B2*2 + T.B3*3 + T.HR *4 + T.BB + T.H) *1.0, 'P') AS [Touched_%]
FROM Batting B JOIN Teams T ON B.teamID = T.teamID AND B.yearID = T.yearID
WHERE B.teamID IN ('NYA', 'BOS') 
ORDER BY [Touched_%] DESC, playerID

-- 8. Using the PEOPLE table, write a query lists the playerid, the first, last and given names for all players that
-- use their initials as their first name (Hint: nameFirst or namegiven contains at least 1 period(.)(See slide
-- 32). Examples would be Thomas J. ( Tom ) Doran and David Jonathan ( J. D. ) Drew. Hint: nameFirst or
-- namegiven contains at least 1 period(.). Also, concatenate the nameGiven, nameFirst and nameLast into
-- an additional single column called Full Name putting the nameFirst in parenthesis. For example: James
-- (Jim) Markulic (Slide 35) and their batting average for each year. Batting Average is calculated using
-- H/AB from the batting table. The batting_average needs to be formatted with 4 digits behind the
-- decimal point (research Convert to decimal using Google). Only select the Boston Red Sox and the NY
-- Yankees (teamids BOS and NYA) . Do not include null batting averages and the query returned 84 rows.
-- If you use a nullif in the batting average calculation, your query will return slightly different row counts
-- (105 rows). See slides 25 to 33 for help on joining multiple tables.
SELECT P.playerID, CONCAT(nameGiven, ' (', nameFirst, ') ', nameLast) AS [Full_Name], teamID, B.yearID, CONVERT(decimal(10,4), H * 1.0 /AB) AS Batting_Average
FROM People P,  Batting B
WHERE (nameFirst LIKE '%.%' OR nameGiven LIKE '%.%') AND 
    P.playerID = B.playerID AND 
    teamID in ('BOS', 'NYA') AND
    AB > 0
ORDER BY yearID

-- 9. Using a Between clause in the where statement (Slide 38) to return the same data as #8, but only where
-- the batting averages that are between .2 and .4999 (including equal to the 2 values). The are to be
-- sorted by batting_average in descending order and then playerid and yearid in ascending order. Your
-- query should return 48 rows
SELECT P.playerID, CONCAT(nameGiven, ' (', nameFirst, ') ', nameLast) AS [Full_Name], teamID, B.yearID, CONVERT(decimal(10,4), H * 1.0 /AB) AS Batting_Average
FROM People P,  Batting B
WHERE (nameFirst LIKE '%.%' OR nameGiven LIKE '%.%') AND 
    P.playerID = B.playerID AND 
    teamID in ('BOS', 'NYA') AND
    AB > 0 AND
    CONVERT(decimal(10,4), H * 1.0 /AB) BETWEEN .2 AND .4999
ORDER BY Batting_Average DESC, playerID, yearID

-- 10. Now you decide to pull all the information you’ve developed together. Write a query that shows the
-- player’s Total_bases_touched from question #5, the batting_averages from #9 (between .2and .4999)
-- and the player’s name as formatted in #8. Continue to only include players with initial in their name. You
-- also want to add the teamid and the team’s batting average for the year. Include all teams, not just NYA
-- and BOS. The teams batting average should be calculated using the columns with the same names, but
-- from the TEAMS table. As a final piece of information, calculate the percentage of the team’s batting
-- average by dividing the player’s batting average by the team’s batting average. Also replace the Teamid
-- with the team name in your ourput. Note, a percentage over 100% indicates the player is better than
-- the average batter on the team. Additionally, rename the tables to only use the first letter of the table
-- so you can use that the select and where statement (ex: FROM TEAMS T). This saves a considerable
-- amount of typing and makes the query easier to read. Order the results by batting average in
-- descending order then playerid and yearid id ascending order. Also, eliminate any results where the
-- player has an AB less than 50. Your query should return 1,632 rows.

SELECT 
    P.playerID, 
    CONCAT(nameGiven, ' (', nameFirst, ') ', nameLast) AS [Full_Name], 
    B.yearID, 
    name AS [Team Name],
    (B.B2*2 + B.B3*3 + B.HR *4 + B.BB + B.H) AS Total_Bases_Touched,
    CONVERT(decimal(10,4), B.H * 1.0 /B.AB) AS [Batting Average],
    CONVERT(decimal(10,4), T.H * 1.0 /T.AB) AS [Team Batting BA],
    format(CONVERT(decimal(10,4), B.H * 1.0 /B.AB) / CONVERT(decimal(10,4), T.H * 1.0 /T.AB), 'P') AS [% of Team Average]
FROM People P,  Batting B, Teams T
WHERE 
    (nameFirst LIKE '%.%' OR nameGiven LIKE '%.%') AND 
    P.playerID = B.playerID AND 
    B.teamID = T.teamID AND 
    B.yearID = T.yearID AND
    B.AB > 50 AND
    CONVERT(decimal(10,4), B.H * 1.0 /B.AB) BETWEEN .2 AND .4999
ORDER BY [Batting Average] DESC, playerID, yearID


SELECT playerID, B.yearID, B.teamID, 
    (B.B2*2 + B.B3*3 + B.HR *4 + B.BB + B.H) AS Total_Bases_Touched,
    (T.B2*2 + T.B3*3 + T.HR *4 + T.BB + T.H) AS Teams_Total_Bases_Touched,
    format((B.B2*2 + B.B3*3 + B.HR *4 + B.BB + B.H) *1.0 / (T.B2*2 + T.B3*3 + T.HR *4 + T.BB + T.H) *1.0, 'P') AS [Touched_%]
FROM Batting B, Teams T
WHERE B.teamID IN ('NYA', 'BOS') AND B.teamID = T.teamID AND B.yearID = T.yearID
ORDER BY [Touched_%] DESC, playerID