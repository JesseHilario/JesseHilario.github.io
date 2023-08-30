USE BaseBall_Summer_2023
GO

IF OBJECT_ID (N'dbo.calculateOBP', N'FN') IS NOT NULL
    DROP FUNCTION calculateOBP;
GO

CREATE FUNCTION dbo.calculateOBP(@ThingID varchar(255))
RETURNS float
AS
BEGIN
    DECLARE @ret float;

    SET @ret = (
        SELECT 
            ISNULL((sum(B.H)+sum(B.BB)+sum(CAST(B.HBP AS int))) * 1.0 / NULLIF(sum(B.AB),0),0)
            -- (sum(H) + sum(BB) + sum(CAST(HBP AS int))) / sum(AB)
        FROM Batting B
        WHERE 
            B.playerID = @ThingID
        -- GROUP BY B.playerID
    );
        IF (@ret IS NULL)
        SET @ret = 0;
RETURN (@ret);
END;
GO 


-- First test query
Select playerID, nameFirst + ' ( ' + nameGiven + ' ) ' + nameLast AS fullname, dbo.calculateOBP(playerID) AS Career_OBP
from People
GROUP BY playerID, nameFirst, nameGiven, nameLast
GO


-- Second test query
WITH Players AS
(
    Select playerID, nameFirst + ' ( ' + nameGiven + ' ) ' + nameLast AS fullname, dbo.calculateOBP(playerID) AS Career_OBP
    from People
    GROUP BY playerID, nameFirst, nameGiven, nameLast
)
SELECT teamID, avg(Career_OBP) AS Team_OBP
FROM Batting B LEFT JOIN Players P ON B.playerID = P.playerID
GROUP BY teamID
ORDER BY avg(Career_OBP) DESC