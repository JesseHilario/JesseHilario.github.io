USE BaseBall_Summer_2023
GO

-- Create and populate a column called UCID_Total_G_Played (where UCID needs to be your
-- UCID) and a column called UCID_Career_Range_Factor in the PEOPLE table.
ALTER TABLE People
    ADD JIH_Total_G_Played int NULL
GO
ALTER TABLE People
    ADD JIH_Career_Range_Factor float NULL


--  Next populate both columns with the appropriate aggregate functions for each player. Total _G_Played is simply the
-- sum of all the G columns for a player in the FIELDING table. Career_Range_Factoris calculated
-- using the following formula: Career_Range_Factor (RF) = 9*sum(PO+A)/(sum(InnOuts)/3). Your
-- SQL will need to adjust the columns and results for any difficulties caused by the column data
-- types. The performance factor indicates if a player helps others on his team play better (RF > 1)
-- or takes away from their performance (RF < 1).
UPDATE People
    SET JIH_Total_G_Played = A.Tot_G
    FROM (SELECT playerID, sum(G) Tot_G
        FROM Fielding 
        GROUP BY playerID) A, People P
    WHERE A.playerID = P.playerID
GO


SELECT InnOuts FROM Fielding ORDER BY InnOuts DESC

UPDATE People
    SET JIH_Career_Range_Factor = B.RF
    FROM (SELECT playerID, ISNULL(9.0 * sum(PO + A) / (NULLIF(sum(CAST(InnOuts AS int)),0)),0) RF
        FROM Fielding
        GROUP BY playerID) B, People P
    WHERE B.playerID = P.playerID
GO

--  The 3rd step is to write a trigger that updates the
-- both of the columns you created in the PEOPLE table whenever there is a row inserted, updated
-- or deleted from the FIELDING table. The trigger name must start with your UCID and the DDL
-- that creates the trigger must also check to see if the trigger exists before creating it.
-- The trigger must use basic math functions (+, -) to adjust UCID_Total_G_Played. You’ll need to
-- use the INSERTED and DELETED tables to get the values to add or subtract. You can use the
-- appropriate aggregate functions and the FIELDING table to adjust/recalculate the
-- UCID_Career_Range_Factor column correctly.
IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'JIH_Fielding'
    )
    DROP TRIGGER JIH_Fielding
GO

CREATE TRIGGER JIH_Fielding
    ON Fielding AFTER INSERT, UPDATE, DELETE
    AS
BEGIN
-- Check to see if UPDATE
    IF exists(SELECT * FROM inserted) AND exists(SELECT * FROM deleted)
    BEGIN
        UPDATE People
            SET JIH_Total_G_Played = (JIH_Total_G_Played - d.G + i.G)
                FROM deleted d, inserted i
                WHERE People.playerID = d.playerID AND People.playerID = i.playerID
        UPDATE People
            SET JIH_Career_Range_Factor = Career_Range.RF
            FROM (SELECT playerID, ISNULL(9.0 * sum(PO + A) / (NULLIF(sum(CAST(InnOuts AS int)),0)),0) RF
                FROM Fielding
                GROUP BY playerID) Career_Range, People P, inserted i
            WHERE Career_Range.playerID = i.playerID AND i.playerID = P.playerID
    END
    -- Check to see if INSERT
    IF exists(SELECT * FROM inserted) AND NOT exists(SELECT * FROM deleted)
    BEGIN
        UPDATE People
            SET JIH_Total_G_Played = (JIH_Total_G_Played + i.G)
                FROM inserted i
                WHERE People.playerID = i.playerID
        UPDATE People
            SET JIH_Career_Range_Factor = Career_Range.RF
            FROM (SELECT playerID, ISNULL(9.0 * sum(PO + A) / (NULLIF(sum(CAST(InnOuts AS int)),0)),0) RF
                FROM Fielding
                GROUP BY playerID) Career_Range, People P, inserted i
            WHERE Career_Range.playerID = i.playerID AND i.playerID = P.playerID
    END
    -- Check to see if DELETE
    IF NOT EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN
        UPDATE People
            SET JIH_Total_G_Played = (JIH_Total_G_Played - d.G)
                FROM deleted d
                WHERE People.playerID = d.playerID
        UPDATE People
            SET JIH_Career_Range_Factor = Career_Range.RF
            FROM (SELECT playerID, ISNULL(9.0 * sum(PO + A) / (NULLIF(sum(CAST(InnOuts AS int)),0)),0) RF
                FROM Fielding
                GROUP BY playerID) Career_Range, People P, deleted D
            WHERE Career_Range.playerID = D.playerID AND D.playerID = P.playerID
    END
END

GO


-- Your answer must also include the queries necessary to verify your trigger works correctly. This
-- would typically include 3 sets of queries. One each for Insert, Delete and Update commands.
-- Each set would have the following pattern. The firsts query would select the columns from the
-- PEOPLE and FIELDING tables.

--  The 2nd query would perform the insert, update or delete function
-- on the FIELDING table.

--  The 3rd query would select the columns from the PEOPLE and FIELDING
-- tables to show that your trigger correctly updated the values changed in the 2nd query. The 3
-- sets needed would be separate queries for insert, update and delete.


-- tests INSERT - I copied the '2014' row for 'werthja01' except for the yearID
SELECT P.playerID, JIH_Total_G_Played, JIH_Career_Range_Factor FROM People P WHERE playerID = 'werthja01'
INSERT INTO Fielding VALUES ('werthja01',2018,1,'WAS','NL','OF',139,'137','3662',247,7,5,1, NULL,NULL,NULL,NULL,NULL)
SELECT P.playerID, JIH_Total_G_Played, JIH_Career_Range_Factor FROM People P WHERE playerID = 'werthja01'



-- tests UPDATE
SELECT P.playerID, JIH_Total_G_Played, JIH_Career_Range_Factor FROM People P WHERE playerID = 'werthja01'
SELECT playerID, yearID, G, PO, A, InnOuts FROM Fielding
    WHERE playerId = 'werthja01' AND yearID = 2018 and teamID = 'WAS'
UPDATE Fielding
    SET G = 300, A = 100
    WHERE playerID = 'werthja01' AND yearID = 2018 AND teamID = 'WAS'
SELECT P.playerID, JIH_Total_G_Played, JIH_Career_Range_Factor FROM People P WHERE playerID = 'werthja01'
SELECT playerID, yearID, G, PO, A, InnOuts FROM Fielding
    WHERE playerId = 'werthja01' AND yearID = 2018 and teamID = 'WAS'



-- tests DELETE
SELECT P.playerID, JIH_Total_G_Played, JIH_Career_Range_Factor FROM People P WHERE playerID = 'werthja01'
SELECT playerID, yearID, G, PO, A, InnOuts FROM Fielding
    WHERE playerID = 'werthja01' AND yearID = 2018 AND teamID = 'WAS'
DELETE FROM Fielding
    WHERE playerID = 'werthja01' AND yearID = 2018 AND teamID = 'WAS' AND stint = 1 AND lgID = 'NL'
SELECT P.playerID, JIH_Total_G_Played, JIH_Career_Range_Factor FROM People P WHERE playerID = 'werthja01'




-- The last part of your submission needs to be the DDL to disable the trigger.

-- The trigger will be 80% of the grade and the queries to test your trigger will be 20% of the grade.
GO
ALTER TABLE Fielding DISABLE TRIGGER JIH_Fielding
GO