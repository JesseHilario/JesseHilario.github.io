Use Weather
go
IF NOT EXISTS(
    SELECT *
    FROM sys.columns
    WHERE Name = N'JIH_aqs_geolocation'
    AND Object_ID = Object_ID(N'AQS_Sites'))
BEGIN
ALTER TABLE AQS_Sites ADD JIH_aqs_geolocation Geography NULL
END
go
UPDATE aqs_sites
    SET [JIH_AQS_GeoLocation] = geography::Point (Latitude, Longitude, 4326)
        where ([LATITUDE] > 0 and latitude <> '') or (Latitude is not null and longitude is not null)
GO

-- You are trying to decide where in the US to reside. The most important factor to you is temperature,
-- you hate cold weather. Answer the following questions to help you make your decision. For all
-- problems show all columns included in the examples. Note that the term temperature applies to the
-- average daily temperature unless otherwise stated.

-- 1. Find the minimum, maximum and average of the average temperature column for each state sorted by
-- state name.
SELECT State_Name, MIN(Average_Temp) AS [Minimum Temp], MAX(Average_Temp) AS [Maximum Temp], AVG(Average_Temp) AS [Average Temp]
FROM Temperature T, AQS_Sites A 
WHERE T.State_Code = A.State_Code AND 
    T.County_Code = A.County_Code AND
    T.Site_Num = A.Site_Number
GROUP BY State_Name
ORDER BY State_Name

-- 2. The results from question #2 show issues with the database. Obviously, a temperature of -99 degrees
-- Fahrenheit in Arizona is not an accurate reading as most likely is 135.5 degrees for Delaware. Write a
-- query to count all the suspect temperatures (below -39o and above 105o) and provide the
-- information/columns shown below. Sort your output by State_Name, state_code, County_Code, and
-- Site_Number
SELECT State_Name, T.State_Code, T.County_Code, T.Site_Num, COUNT(*) AS Num_Bad_Entries
FROM Temperature T, AQS_Sites A 
WHERE T.State_Code = A.State_Code AND 
    T.County_Code = A.County_Code AND
    T.Site_Num = A.Site_Number
    AND Average_Temp NOT BETWEEN -39 and 105
GROUP BY State_Name, T.State_Code, T.County_Code, T.Site_Num
ORDER BY State_Name, T.State_Code, T.County_Code, T.Site_Num

-- 3. You decide to dig deeper and identify the actual locations that are providing the suspect temperatures.
-- Modify your query from #2 to also include the Local_Site_Name in the results.
SELECT State_Name, T.State_Code, T.County_Code, T.Site_Num, Local_Site_Name, COUNT(*) AS Num_Bad_Entries
FROM Temperature T, AQS_Sites A 
WHERE T.State_Code = A.State_Code AND 
    T.County_Code = A.County_Code AND
    T.Site_Num = A.Site_Number AND
    Average_Temp NOT BETWEEN -39 and 105
GROUP BY State_Name, T.State_Code, T.County_Code, T.Site_Num, Local_Site_Name
ORDER BY State_Name, T.State_Code, T.County_Code, T.Site_Num

-- 4. You noticed that the average temperatures become questionable below -39 o and above 125 o and that
-- it is unreasonable to have temperatures over 105 o for state codes 30, 29, 37, 26, 18, 38. You also
-- decide that you are only interested in living in the United States, not Canada or the US territories. Any
-- data not in the 50 states or Washington DC should be excluded. You also decide that data without the
-- local_site_name does not add value to your decision making and you want to exclude them as well
-- (local_site_name is null). Create a view that combines the data in the AQS_Sites and Temperature
-- tables. The view should have the appropriate WHERE to exclude the data above. You should use this
-- view for all subsequent queries. My view returned 4,769,346 rows. The view only needs to include the
-- State_code, State_Name, County_Code, Site_Number, City_name, Local_site_name, average_temp
-- and local_date. You also want to improve performance by creating indexes on your VIEW. Make sure
-- you include schema binding in your view for later problems.
-- You want to verify your view is correct, display the count of rows grouped by state_code and
-- State_name. Please do not use a select * since it runs for a long time. 
IF EXISTS (SELECT * FROM sys.views WHERE name = 'Weather_JIH'
AND type = 'v') DROP VIEW Weather_JIH;
go

CREATE VIEW [dbo].[Weather_JIH] WITH SCHEMABINDING AS
    (SELECT A.State_code, State_Name, A.County_Code, A.Site_Number, City_Name, Local_site_name, Average_Temp, Date_Local
    FROM dbo.Temperature T, dbo.AQS_Sites A 
    WHERE T.State_Code = A.State_Code AND 
        T.County_Code = A.County_Code AND
        T.Site_Num = A.Site_Number AND
        Local_site_name IS NOT NULL AND
        A.State_Code not in ('11','66', '72','78','80','CC') AND
        ((Average_Temp BETWEEN -39 AND 125) OR
        (Average_Temp <= 105 AND A.State_Code in ('30','29','37','26','18','38'))))
GO

SELECT State_code, State_Name, COUNT(*) AS num_days FROM Weather_JIH
    GROUP BY State_code, State_name


-- 5. Now that you’ve created your view, you want to create an index on the view (not the underlying
-- AQS_Sites and Temperature tables). If you click the button and execute the query
-- you wrote for #4, you will see something like the execution plan below.
-- You’ve heard that creating indexes can speed up queries. Create an index for your view (not the
-- underlying tables). You are required to create a single index with the unique and clustered
-- parameters and the index will be on the State_Code, County_Code, Site_Number, average_temp, and
-- Date_Local columns. DO NOT create the index on the tables, the index must be created on the VIEW.
-- There are 270,511 duplicate rows that you must delete before you can create a unique index. Use the
-- Rownumber parameter from the Advanced Aggregates you learned in Chapter 5 and the appropriate
-- partition statement, delete any row where the row number was greater than 1. (Remember the problem
-- in the Chapter 5 SQL assignment?) You must delete the rows from the Temperature table, you are not
-- able to delete them using the VIEW because all the required columns from the Temperature table are
-- not available.

-- -- SQL for Fixing error: Column 'State_code' in table 'Weather_JIH' is of a type that is invalid for use as a key column in an index.
-- ALTER TABLE AQS_Sites
-- ALTER COLUMN 
--     State_Code varchar(255) not null;
-- GO
-- ALTER TABLE AQS_Sites
-- ALTER COLUMN 
--     County_Code varchar(255) not null;
-- GO
-- ALTER TABLE AQS_Sites
-- ALTER COLUMN 
--     Site_Number varchar(255) not null;
-- GO

-- ALTER TABLE Temperature
-- ALTER COLUMN 
--     State_Code varchar(255) not null;
-- GO
-- ALTER TABLE Temperature
-- ALTER COLUMN 
--     County_Code varchar(255) not null;
-- GO
-- ALTER TABLE Temperature
-- ALTER COLUMN 
--     Site_Num varchar(255) not null;
-- GO
GO
WITH cte AS
(SELECT Row_Number() OVER (PARTITION BY State_code, County_Code, Site_Num, Average_Temp, Date_Local ORDER BY State_Code) rank,
        State_code, County_Code, Site_Num, Average_Temp, Date_Local
        FROM Temperature
        WHERE state_code like '02' AND county_code like '090' and site_num like '0034' and date_local like '2011-06-25')
DELETE FROM cte WHERE rank > 1
GO
DROP INDEX IF EXISTS Weather_JIH_Index ON Weather_JIH
GO
CREATE UNIQUE CLUSTERED INDEX Weather_JIH_Index ON Weather_JIH (state_code, county_code, site_number, average_temp, date_local);
go

DROP INDEX IF EXISTS Weather_JIH_Index ON Weather_JIH
GO
CREATE UNIQUE CLUSTERED INDEX Weather_JIH_Index ON Weather_JIH (state_code, county_code, site_number, average_temp, date_local);
GO


-- 6. Using the SQL RANK statement, rank the states by Average Temperature
SELECT *, Rank() OVER(ORDER BY [Average Temp] DESC) State_rank
FROM (SELECT State_Name, MIN(Average_Temp) AS [Minimum Temp], MAX(Average_Temp) AS [Maximum Temp], AVG(Average_Temp) AS [Average Temp]
    FROM Weather_JIH
    GROUP BY State_Name
    ) e


-- 7. You’ve decided that you want to see the ranking of each high temperatures for each city in each state
-- to see if that helps you decide where to live. Write a query that ranks (using the rank function) the
-- states by averages temperature and then ranks the cities in each state. The ranking of the cities should
-- restart at 1 when the query returns a new state. You also want to only show results for the 10 states
-- and the 4 cities within each state with the highest average temperatures.
-- Note: you will need to use multiple nested queries to get the State and City rankings, join them together
-- and then apply a where clause to limit the state ranks shown
SELECT State_rank, City_Avg.State_Name, State_City_rank, City_Name, [Average City Temp] AS [Average Temp]
FROM (
    SELECT *, Rank() OVER(ORDER BY [Average State Temp] DESC) State_rank
    FROM (SELECT State_Name, MIN(Average_Temp) AS [Minimum Temp], MAX(Average_Temp) AS [Maximum Temp], AVG(Average_Temp) AS [Average State Temp]
        FROM Weather_JIH
        GROUP BY State_Name
        ) e
    ) State_Avg,
    (
    SELECT *, Rank() OVER(PARTITION BY STATE_NAME ORDER BY [Average City Temp] DESC) State_City_rank
    FROM (SELECT State_Name, City_Name, MIN(Average_Temp) AS [Minimum Temp], MAX(Average_Temp) AS [Maximum Temp], AVG(Average_Temp) AS [Average City Temp]
        FROM Weather_JIH
        GROUP BY State_Name, City_Name
        ) e
    ) City_Avg
WHERE City_Avg.State_Name = State_Avg.State_Name AND State_City_rank <= 4
ORDER BY State_rank, State_City_rank



-- 8. You notice in the results that sites with Not in a City as the City Name are include but do not provide
-- you useful information. Exclude these sites from all future answers. You can do this by either adding it
-- to the where clause in the remaining queries or updating the view you created in #4. Include the SQL
-- for #7 with the revised answer. Notice Florida now only has 3 rows.
SELECT State_rank, City_Avg.State_Name, State_City_rank, City_Name, [Average City Temp] AS [Average Temp]
FROM (
    SELECT *, Rank() OVER(ORDER BY [Average State Temp] DESC) State_rank
    FROM (SELECT State_Name, MIN(Average_Temp) AS [Minimum Temp], MAX(Average_Temp) AS [Maximum Temp], AVG(Average_Temp) AS [Average State Temp]
        FROM Weather_JIH
        GROUP BY State_Name
        ) e
    ) State_Avg,
    (
    SELECT *, Rank() OVER(PARTITION BY STATE_NAME ORDER BY [Average City Temp] DESC) State_City_rank
    FROM (SELECT State_Name, City_Name, MIN(Average_Temp) AS [Minimum Temp], MAX(Average_Temp) AS [Maximum Temp], AVG(Average_Temp) AS [Average City Temp]
        FROM Weather_JIH
        WHERE City_Name NOT like 'Not in a City'
        GROUP BY State_Name, City_Name
        ) e
    ) City_Avg
WHERE City_Avg.State_Name = State_Avg.State_Name AND State_City_rank <= 4
ORDER BY State_rank, State_City_rank



-- 9. You decide you like the monthly average temperature to be at least 70 degrees. Write a query that
-- returns the states and cities that meets this condition, the number of months where the average is
-- above 70, the number of days in the database where the days are about 70 and calculate the average
-- monthly temperature by month.
-- Hint, use the datepart function to identify the month for your calculations.
SELECT days.State_Name, days.City_Name, [# of Months], [# of Day in Average], [Average Temp]
FROM (
        SELECT State_Name, City_Name, COUNT(*) AS [# of Day in Average], AVG(average_temp) AS [Average Temp]
        FROM Weather_JIH
        WHERE city_Name NOT like 'Not in a City'
        GROUP BY State_Name, City_Name
        HAVING AVG(average_temp) > 70
    ) days 
    LEFT JOIN
    (
    SELECT State_Name, City_Name, COUNT(*) AS [# of Months]
    FROM (
        SELECT State_Name, City_Name, DATEPART(mm, Date_Local) AS Month
        FROM Weather_JIH
        WHERE city_Name NOT like 'Not in a City'
        GROUP BY State_Name, City_Name, DATEPART(mm, Date_Local)
        -- HAVING AVG(average_temp) > 70
        ) months
    GROUP BY State_Name, City_Name
    ) months
    ON days. State_Name = months.State_Name AND days.City_Name = months.City_Name
ORDER BY State_Name, City_Name



-- 10. You assume that the temperatures follow a normal distribution and that the majority of the temperatures
-- will fall within the 40% to 60% range of the cumulative distribution. Using the CUME_DIST function,
-- show the temperatures for the cities having an average temperature of at least 70 degree. Only show
-- the first temperature and the last temperature that fall within the 40% and 60% range s that fall within
-- the range. Hint: use min and max in the top select statement.
SELECT State_Name, City_Name, MIN(Average_Temp) AS [40 Percentile Temp], MAX(Average_Temp) AS [60 Percentile Temp]
FROM (
    SELECT State_Name, City_Name, Average_Temp, CUME_DIST() OVER(PARTITION BY State_Name, City_Name ORDER BY Average_Temp) Dist
    FROM Weather_JIH
    ) e
WHERE City_Name NOT like 'Not in a City' AND Dist BETWEEN .4 AND .6
GROUP BY State_Name, City_Name
HAVING AVG(Average_Temp) > 70
ORDER BY State_Name, City_Name



-- 11. You remember from your statistics classes that to get a smoother distribution of the temperatures and
-- eliminate the small daily changes that you should use a moving average instead of the actual
-- temperatures. Using the windowing within a ranking function to create a 4 day moving average (3
-- previous, 1 after), calculate the moving average for each day of the year for Mission Texas,
-- Hint: You will need to datepart to get the day of the year for your moving average. You moving average
-- should use the 3 days prior and 3 days after for the moving average.

-- SELECT State_Name, City_Name, [Day of the Year], 
--     AVG([Avg Temp]) OVER(ORDER BY State_Name, City_Name, [Day of the Year] ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING) AS [Rolling_Avg_Temp]
-- FROM (
    SELECT State_Name, City_Name, DATEPART(dayofyear, Date_Local) AS [Day of the Year], AVG(Average_Temp) [Avg Temp]
    FROM Weather_JIH
    WHERE City_Name like 'Mission' AND State_Name like 'Texas'
    GROUP BY State_Name, City_Name, DATEPART(dayofyear, Date_Local)
--     ) e
-- GROUP BY State_Name, City_Name, [Day of the Year], [Avg Temp]
-- ORDER BY [Day of the Year]



