USE BaseBall_Summer_2023;
GO

CREATE VIEW JIH_Player_Summary AS
    WITH 
        B AS (
            SELECT playerID, 
                count(yearID) AS num_years,
                count(DISTINCT teamID) AS num_teams,
                sum(HR) AS runs,
                CONVERT(decimal(10,4), ISNULL(sum(H) * 1.0 / NULLIF(sum(AB),0),0)) AS career_ba,
                max(yearID) AS last_appear
            FROM Batting
            GROUP BY playerID
        ),
        Sa AS (
            SELECT playerID, sum(salary) AS [tot_sal], avg(salary) AS avg_sal, 
                min(salary) AS min_salary, max(salary) AS max_salary
            FROM Salaries
            GROUP BY playerID
        ),
        Pi AS (
            SELECT playerID, sum(W) AS tot_win, sum(SO) AS tot_so, 
                CONVERT(decimal(10,4), ISNULL((sum(SO) + sum(BB)) / NULLIF(sum(IPouts/3.0),0),0)) AS car_pfr,
                sum(G) AS total_games_played, sum(GS) AS total_games_started
            FROM Pitching
            GROUP BY playerID
        )
    SELECT 
        Pe.playerID,
        nameFirst + ' (' + nameGiven + ') ' + nameLast AS fullname,
        Total_401k,
        B.num_years, num_teams, runs, career_ba, last_appear,
        Sa.tot_sal, avg_sal, min_salary, max_salary, (max_salary - min_salary)/((max_salary)) AS perc_increase,
        Pi.tot_win, tot_so, car_pfr, total_games_played, total_games_started,
        (SELECT count(awardID) FROM AwardsPlayers AP WHERE AP.playerID = Pe.playerID GROUP BY AP.playerID) + 
        (SELECT count(awardID) FROM AwardsSharePlayers ASP WHERE ASP.playerID = Pe.playerID GROUP BY ASP.playerID) AS tot_award_play,
        (SELECT count(awardID) FROM AwardsManagers AM WHERE AM.playerID = Pe.playerID GROUP BY AM.playerID) + 
        (SELECT count(awardID) FROM AwardsShareManagers ASM WHERE ASM.playerID = Pe.playerID GROUP BY ASM.playerID) AS tot_award_man,
        (SELECT min(yearID) FROM HallOfFame HOF WHERE HOF.playerID = Pe.playerID GROUP BY HOF.playerID) AS year_inducted,
        (SELECT count(yearID) FROM HallOfFame HOF2 WHERE HOF2.playerID = Pe.playerID GROUP BY HOF2.playerID) AS nominated_count,
        'inducted' = 
            CASE
                WHEN Pe.playerID in (SELECT playerID FROM HallOfFame WHERE inducted = 'Y') THEN 'Y'
                ELSE 'N'
            END
    FROM People Pe
        LEFT JOIN B ON Pe.playerID = B.playerID
        LEFT JOIN Sa ON Pe.playerID = Sa.playerID
        LEFT JOIN Pi ON Pe.playerID = Pi.playerID
GO


SELECT * FROM JIH_Player_Summary ORDER BY playerID


SELECT 
    count(*) AS Total_rows, 
    avg(num_years) AS avg_num_years_played, 
    avg(avg_sal) AS Average_salary, 
    avg(career_ba) AS avg_career_BA,
    avg(car_pfr) AS avg_career_pfr
FROM JIH_Player_Summary 
WHERE playerID LIKE 'a%' OR playerID LIKE 'A%'
