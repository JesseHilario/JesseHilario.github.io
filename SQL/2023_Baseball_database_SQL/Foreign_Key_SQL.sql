USE BaseBall_Summer_2023
go

-- Creating Leagues table and inserting distinct lgID from Teams
CREATE TABLE [dbo].[Leagues](
    [lgID] [varchar](25) not null,
    CONSTRAINT LeaguesPK PRIMARY KEY (lgID)
)
GO

INSERT INTO Leagues
    SELECT DISTINCT lgID FROM Teams
GO
select * FROM Leagues



-- Creating Foreign key from teams to TeamsFranchises, Leagues
ALTER TABLE Teams
ADD CONSTRAINT FK_TeamsFranchises_TM FOREIGN KEY (franchID)
    REFERENCES TeamsFranchises (franchID)

ALTER TABLE Teams
ADD CONSTRAINT FK_Leagues_TM FOREIGN KEY (lgID)
    REFERENCES Leagues (lgID)





-- Making the primary key for AllstarFull table
ALTER TABLE AllstarFull
ALTER COLUMN playerID varchar(255) not null;
GO
ALTER TABLE AllstarFull
ALTER COLUMN yearID int not null;
GO
ALTER TABLE AllstarFull
ALTER COLUMN teamID varchar(255) not null;
GO
ALTER TABLE AllstarFull
ALTER COLUMN gameID varchar(255) not null;

-- fix gamid so it can be used as part of the primary key
UPDATE AllstarFull
SET gameID = 'notplayed'
WHERE gameID is NULL

ALTER TABLE AllstarFull
ALTER COLUMN gameID varchar(255) not null;
GO
ALTER TABLE AllstarFull
ALTER COLUMN lgID VARCHAR(25) NOT NULL;
GO

-- must delete duplicate rows first for this to work (line 52-58)
ALTER TABLE AllstarFull
ADD CONSTRAINT AllstarFullPK PRIMARY KEY (yearID, teamID, lgID, playerID, gameID);

SELECT yearID, teamID, lgID, playerID, gameID, COUNT(*)
FROM AllstarFull
GROUP BY yearID, teamID, lgID, playerID, gameID
HAVING COUNT(*) > 1

ALTER TABLE AllstarFull
ADD CONSTRAINT FK_People_ASF FOREIGN KEY (playerID)
    REFERENCES People(playerID)




-- Used this to delete duplicate rows from the table
WITH cte AS
(SELECT yearID, teamID, lgID, playerID, gameID,
                Row_Number() OVER(PARTITION BY yearID, teamID, lgID, playerID, gameID
            ORDER BY playerID) rank
    FROM AllstarFull)
DELETE FROM cte WHERE rank > 1
go

ALTER TABLE AllstarFull
ADD CONSTRAINT AllstarFullPK PRIMARY KEY (yearID, teamID, lgID, playerID, gameID);

ALTER TABLE AllstarFull
ADD CONSTRAINT FK_teams_ASF FOREIGN KEY (yearID, lgID, teamID)
    REFERENCES Teams (yearID, lgID, teamID)
GO


-- The above query gives a conflict between the rows of ASF and Teams
-- The following query finds the rows in ASF not contained in Teams
select distinct a.yearid, a.lgid, a.teamid, t.teamID, t.yearID, t.lgID
from allstarfull a left join teams t 
    on a.yearid = t.yearid
    and a.lgid = t.lgid
    and a.teamid = t.teamid
where t.yearid is null 
    or t.lgid is null 
    OR t.teamid is NULL
order by a.teamid, a.yearid

-- This shows that the missing teamIDs from the last query are not contained in Teams
SELECT teamID, yearID, lgID FROM Teams WHERE teamID in ('mln', 'laa, mil') and yearID = 1961
go
UPDATE AllstarFull
    SET teamID = 'ML4'
    WHERE yearID BETWEEN 1970 AND 1997 AND teamID = 'MIL'

UPDATE AllstarFull
    SET teamID = 'ML1'
    WHERE yearID BETWEEN 1953 AND 1965 AND teamID = 'MLN'

UPDATE AllstarFull
    SET teamID = 'ANA'
    WHERE yearID BETWEEN 1997 AND 2004 AND teamID = 'LAA'

DELETE FROM AllstarFull
WHERE yearID = 2012 AND teamID = 'SLN' and lgID = 'AL'

-- Now we can create the foreign key successfully
ALTER TABLE AllstarFull
ADD CONSTRAINT FK_teams_ASF FOREIGN KEY (yearID, lgID, teamID)
    REFERENCES Teams (yearID, lgID, teamID)
GO




-- create Appearances foreign key
ALTER TABLE Appearances
ADD CONSTRAINT FK_People_AP FOREIGN KEY (playerID)
    REFERENCES People(playerID)

-- Find and delete the row in Appearances not found in People
SELECT A.playerID
FROM Appearances A LEFT JOIN People P ON A.playerID = P.playerID
WHERE P.playerID is null

DELETE FROM Appearances
WHERE playerID in (
    SELECT A.playerID
    FROM Appearances A LEFT JOIN People P ON A.playerID = P.playerID
    WHERE P.playerID is null
)

-- Successfully add Appearances foreign key
ALTER TABLE Appearances
ADD CONSTRAINT FK_People_AP FOREIGN KEY (playerID)
    REFERENCES People(playerID)

ALTER TABLE Appearances
ADD CONSTRAINT FK_Teams_AP FOREIGN KEY (yearID, lgID, teamID)
    REFERENCES Teams(yearID, lgID, teamID)


-- Looking at the Schema Visualization diagram, we can next focus on Homegames
-- Foreign key to teams table
ALTER TABLE HomeGames
ADD CONSTRAINT FK_Teams_HG FOREIGN KEY (yearID, lgID, teamID)
    REFERENCES Teams (yearID, lgID, teamID)

-- Foreign key to Parks
ALTER TABLE HomeGames
ADD CONSTRAINT FK_Parks_HG FOREIGN KEY (parkID)
    REFERENCES Parks (parkID)

-- Conflict between HG and Parks, insert rows into Parks to resolve

SELECT * FROM Parks 
SELECT * FROM HomeGames 

SELECT DISTINCT HG.parkID, P.parkID 
FROM HomeGames HG LEFT JOIN Parks P ON HG.parkID = P.parkID
WHERE P.parkID is null
SELECT * FROM Parks

INSERT INTO Parks
VALUES 
    ('ARL03', NULL, NULL, 'Arlington', 'TX', 'US'),
    ('BUF05', NULL, NULL, 'Buffalo', 'NY', 'US'),
    ('DUN01', NULL, NULL, NULL, NULL, NULL),
    ('DYE01', NULL, NULL, NULL, NULL, NULL)
GO

-- Can now successfully add foreign key to Parks
ALTER TABLE HomeGames
ADD CONSTRAINT FK_Parks_HG FOREIGN KEY (parkID)
    REFERENCES Parks (parkID)


-- We still need AwardsManagers, managers
-- For Managers:
ALTER TABLE Managers
ADD CONSTRAINT PK_People_MNG FOREIGN KEY (playerID)
    REFERENCES People (playerID)

ALTER TABLE Managers
ADD CONSTRAINT FK_Teams_MNG FOREIGN KEY (yearID, lgID, teamID)
    REFERENCES Teams (yearID, lgID, teamID)



-- For AwardsManagers:
ALTER TABLE AwardsManagers
ADD CONSTRAINT FK_Leagues_AMNG FOREIGN KEY (lgID)
    REFERENCES Leagues (lgID)

-- Correcting lgID problem
SELECT DISTINCT AM.lgID, L.lgID
FROM AwardsManagers AM LEFT JOIN Leagues L ON AM.lgID = L.lgID
WHERE L.lgID is null

INSERT INTO Leagues VALUES ('ML')
GO

-- Successfully add AwardsManagers to Leagues Foreign Key:
ALTER TABLE AwardsManagers
ADD CONSTRAINT FK_Leagues_AMNG FOREIGN KEY (lgID)
    REFERENCES Leagues (lgID)

ALTER TABLE AwardsManagers
ADD CONSTRAINT FK_People_AMNG FOREIGN KEY (playerID)
    REFERENCES People (playerID)