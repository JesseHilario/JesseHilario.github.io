USE BaseBall_Summer_2023
GO
SELECT * FROM Teams
-- 1. Add 2 columns to the PEOPLE table. The columns should be UCID_Career_EqA and
-- UCID_Date_Last_Update. As always, the UCID should be replaced with your actual UCID. Make
-- sure to include IF statements so the script can be run more than once. Also replace UCID with
-- your ID. An example of the column names would be sp245_Career_EqA
IF NOT EXISTS(SELECT *
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'People'
        AND COLUMN_NAME = 'JIH_Career_EqA')
    BEGIN
        alter table People
        add JIH_Career_EqA float NULL,
        JIH_Date_Last_Update date NULL
    END;
go

-- 2. Creates a stored procedure containing an update cursor that contains the playerid and the sum
-- of the player’s Equivalent Average calculated using the BATTING .

IF EXISTS(SELECT 1 FROM sys.procedures 
          WHERE Name = 'JIH_Equivalent_Average')
BEGIN
    DROP PROCEDURE [dbo].[JIH_Equivalent_Average]
END
go

CREATE PROCEDURE [dbo].[JIH_Equivalent_Average] 
-- (
--     -- @playerID nvarchar(255),
--     -- @yearID int,
--     -- @rownum int
-- )
AS
BEGIN
SET nocount ON
DECLARE 
    @today date,
    @msg varchar(255),
    @updateCount bigint,
    -- @YearID varchar(50),
    -- @teamID varchar(50),
    -- @lgID varchar(50),
    @playerID varchar(50),
    @STOP int,
    @ERROR int

-- set today
SET @today = CONVERT(date, getdate())
SELECT @msg = CAST(@today AS nvarchar(30))
RAISERROR(@msg, 0, 1)
SELECT @msg = 'Transaction Update Command Start Time - ' + (CAST(CONVERT(varchar,GETDATE(),108) AS nvarchar(30)))
RAISERROR(@msg, 0, 1) WITH NOWAIT

-- initialize update count
SET @updateCount = 0
SET @stop = 0

-- declare cursor
DECLARE updatecursor CURSOR STATIC FOR
    SELECT People.playerID
        -- , sum(ISNULL((H + (H + 2*B2 + 3*b3 + 4*HR + BB) + (1.5*(BB + HBP)) + SB + SH + SF) / 
        -- NULLIF((AB + BB + HBP + SH + SF + CS + (SB/3)),0),0)) Equivalent_Average
    FROM People, Batting
    WHERE People.playerID = Batting.playerID
        AND (JIH_Date_Last_Update <> @today OR JIH_Date_Last_Update is NULL)
    -- GROUP BY People.playerID;
    SELECT @@CURSOR_ROWS as 'Number of Cursor Rows After Declare'
    SELECT @msg = 'Declare Cursor Complete Time - ' + (CAST(CONVERT(varchar,GETDATE(),108) AS nvarchar(30)))
    RAISERROR(@msg, 0, 1) WITH NOWAIT

-- open cursor
OPEN updatecursor
        SELECT @@CURSOR_ROWS as 'Number of Cursor Rows'
    FETCH NEXT FROM updatecursor INTO @playerID
    WHILE @@FETCH_STATUS = 0 AND @STOP = 0
        BEGIN
            -- Begin transaction for the first record
            IF @updateCount = 0
                BEGIN
                    SELECT @msg = 'Begin Transaction At Record - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
                        ' At - ' + (CAST(CONVERT(varchar,GETDATE(),108) AS nvarchar(30)))
                    RAISERROR(@msg, 0, 1) WITH NOWAIT
                    BEGIN TRANSACTION
                END
            SELECT @msg = 'UPDATE People for key = ' + @playerID
            RAISERROR(@msg, 0, 1) WITH NOWAIT

            UPDATE People
                SET JIH_Date_Last_Update = @today
                    WHERE @playerID = playerID;

            UPDATE People
                SET JIH_Career_EqA = JIH_Career_EqA + ISNULL((H + (H + 2*B2 + 3*b3 + 4*HR + BB) + (1.5*(BB + HBP)) + SB + SH + SF) / 
        NULLIF((AB + BB + HBP + SH + SF + CS + (SB/3)),0),0)
                    FROM Batting
                    WHERE @playerID = People.playerID;
                    -- GROUP BY @playerID;
            SET @updateCount = @updateCount + 1

            -- Abend at Record 17543
            IF @updateCount = 17543
                BEGIN
                    SET @STOP = 1
                END
            
            -- commit every 1000 records and start a new transaction
            IF @updateCount % 1000 = 0
                BEGIN
                    SELECT @msg = 'COMMIT TRANSACTION - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
                        ' At - ' + (CAST(CONVERT(varchar,GETDATE(),108) AS nvarchar(30)))
                    RAISERROR(@msg, 0, 1) WITH NOWAIT
                    
                    -- done with the previous group, we need the next
                    SELECT @msg = 'END OLD TRANSACTION AT RECORD - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
                        ' At - ' + (CAST(CONVERT(varchar,GETDATE(),108) AS nvarchar(30)))
                    RAISERROR(@msg, 0, 1) WITH NOWAIT

                    COMMIT TRANSACTION
                    BEGIN TRANSACTION
                END
            FETCH NEXT FROM updatecursor INTO @PlayerID
        END
    IF @STOP <> 1
        BEGIN
            -- COMMIT FINAL WHEN TO THE END
            SELECT @msg = 'Final Commit Transaction For Record - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
                        ' At - ' + (CAST(CONVERT(varchar,GETDATE(),108) AS nvarchar(30)))
            RAISERROR(@msg, 0, 1)

            COMMIT TRANSACTION
        END
    IF @STOP = 1
        BEGIN
            -- rollback to last COMMIT
            SELECT @msg = 'Rollback Started For Transaction At Record - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
                        ' At - ' + (CAST(CONVERT(varchar,GETDATE(),108) AS nvarchar(30)))
            RAISERROR(@msg, 0, 1)

            ROLLBACK TRANSACTION
        END
CLOSE updatecursor
DEALLOCATE updatecursor
SELECT @msg = 'Transaction Update Commant End Time at Record - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + 
        ' At - ' + (CAST(CONVERT(varchar,GETDATE(),108) AS nvarchar(30)))
RAISERROR(@msg, 0, 1) 
SET NOCOUNT OFF;
SELECT COUNT(JIH_Date_Last_Update) AS 'COUNT_Cursor_Dates', SUM(JIH_Career_EqA) AS 'Sum_Cursor_Counter' FROM People
END

GO
EXEC JIH_Equivalent_Average

SELECT * FROM People

-- Equivalent Average (EqA) is a baseball metric invented by Clay Davenport and intended to express the production of
-- hitters in a context independent of park and league effects.[1] It represents a hitter's
-- productivity using the same scale as batting average. Thus, a hitter with an EqA over .300 is
-- a very good hitter, while a hitter with an EqA of .220 or below is poor. An EqA of .260 is
-- defined as league average.The formula for the Equivalent Average is

-- Another version of the formula is
-- Equivalent Average = (Hits + Total Bases + (1.5 x (Walks + Hit by Pitch)) + Stolen Bases + Sacrifice
-- Hits + Sacrifice Flies) ÷ (At Bats + Walks + Hit by Pitch + Sacrifice Hits + Sacrifice Flies + Caught
-- Stealing + (Stolen Bases ÷ 3))
-- From the Battinging table, use the following columns:
-- Hits = H
-- Total Bases = H + 2*B2 + 3*b3 + 4*HR + BB
-- Walks = BB
-- At Bats = AB
-- Hit By Pitcher = HBP
-- Sacrifice Hits = SH
-- Sacrifice = SF
-- Caught Stealing = CS
-- Stolen Bases = SB



-- 3. The SQL created in #2, write a stored procedure that:
-- a. Updates the new columns in the PEOPLE table when UCID_Date_Last_Update is not
-- equal to the current date (handled in the WHERE clause of the DECLARE CURSOR)
-- b. updates the UCID_Career_EqA with the column from the cursor and set
-- UCID_Date_Last_Update to the current date. (the CURSOR only needs to contain the
-- playerid and EqA value)
-- c. Selects the system variable @@Cursor_Rows after you fetch the first CURSOR row so
-- you can see how many rows are in the cursor. (The value isn’t available until the 1st row
-- is fetched)
-- d. Turns off the individual rows update counter by specifying SET NOCOUNT ON at the
-- beginning of the Cursor processing. (This eliminates the 1 row update message form
-- appearing)
-- e. Writes the date and time as well as the # of records updated with the date and time for
-- every 1,000 records updated (This shows the operator that the CURSOR is making
-- progress and not experiencing a deadlock condition)
-- f. Closes and deallocates the cursor as the last step in the script.
-- g. Note: Microsoft has changed SQL Server so that PRINT statements do not show until the
-- stored procedure ends. You must not use a RAISERROR statement shown in the outline
-- below)
-- 4. Include a query to be run after the Cursor processing is complete that selects the playerid,
-- UCID_Career_EqA and UCID_Date_Last_Update from the PEOPLE table
-- 5. Run the script created for steps #2 and #3 a second time and see what happens. Think of why
-- you got these results when you run the script a second time.
-- 6. Your submission should be a single .sql file that contains:
-- a. the SQL to define and, if necessary, populate the columns
-- b. the SQL that creates the stored procedure containing the cursor script
-- c. the EXEC statements to run the stored procedure (there should be 2. 1 to run the cursor
-- script and aa second one to show nothing happens if it is run twice)
-- The typical outline for a CURSOR is:
-- Create Procedure yourprocedurename as ---creates stored procedure
-- Begin
-- set nocount on --- turn off row count messages
-- Declare @today date --- creates a variable for the date
-- Set @today = convert(date, getdate()) --- populates the date variable. Note you also need to declare any other
-- variables required
-- select @msg = --- start message
-- RAISERROR(@msg, 0, 1) WITH NOWAIT --- write start message to results
-- DECLARE cursorname CURSOR STATIC FOR --- declares cursor and populates it with the
-- results of the select statement on the next line
-- SELECT --- select statement to populate the cursor
-- FROM
-- WHERE --- include check for date in this WHERE statement
-- set @updateCount = 0 --- sets variable for the counter to 0
-- OPEN cursorname --- opens the cursor
-- select @msg = --- cursor opened at message
-- RAISERROR(@msg, 0, 1) WITH NOWAIT
-- FETCH NEXT FROM cursorname INTO --- retrieves a row from the CURSOR and places the
-- data in the variables you defined
-- select @msg = --- write number of rows in the CURSOR to the results
-- tab using the @@CURSOR_ROWS
-- RAISERROR(@msg, 0, 1) WITH NOWAIT
-- WHILE @@fetch_status = 0 --- create a “While Loop” to process the cursor rows
-- one at a time
-- BEGIN --- begin statement for while loop
-- Update --- update statement that updates the PEOPLE table with the
-- data in the variables from the FETCH
-- set
-- IF @updateCount % 1000 = 0 --- checks to see if # of rows divided by 1000 has a remainder
-- of 0
-- BEGIN
-- select @msg = --- processing status message if remainder = 0 (every 1000
-- records)
-- RAISERROR(@msg, 0, 1) WITH NOWAIT
-- END
-- FETCH NEXT FROM cursorname INTO --- gets next cursor row and stores the values in variables
-- END --- end of the WHILE loop. Causes process to go back
-- to the WHILE status check
-- CLOSE cursorname --- close cursor
-- DEALLOCATE cursorname --- Deallocates (deletes the cursor). Note
-- that you can omit this statement if there as subsequent need for the same cusror
-- select @msg = --- Script finished message
-- RAISERROR(@msg, 0, 1) WITH NOWAIT
-- END --- end statement for the create procedure
-- If your CURSOR runs to the end but does not provide the desired results, you must reset the column you created to
-- show a prior date. The following SQL accomplishes that
-- Update People
-- Set JM234_Last_Update = convert(date, getdate()-1); --- Updates the column you creates eo have yesterday’s date