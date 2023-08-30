USE Weather
GO

-- 1. In addition to the temperature, you are also very concerned with crime in the area. You’ve searched very hard
-- and have been unable to find data that easily correlates to the temperature data. The best data you can find is
-- the Gun_All_Incidents table that was restored in the Weather Database from the class snapshot. This should
-- contain import a total of 511,141 rows
SELECT * FROM Gun_All_Incidents

-- 2. Using the same methods as you used in Step 4 of the Database Description section, create and populate a
-- geography column to the Gun_All_Incidents table you just created
IF NOT EXISTS(
    SELECT *
    FROM sys.columns
    WHERE Name = N'JIH_Gun_All_Incidents_geolocation'
    AND Object_ID = Object_ID(N'Gun_All_Incidents'))
BEGIN
ALTER TABLE Gun_All_Incidents ADD JIH_Gun_All_Incidents_geolocation Geography NULL
END
go
UPDATE Gun_All_Incidents
    SET [JIH_Gun_All_Incidents_geolocation] = geography::Point (latitude, longitude, 4326)
        where ([latitude] > 0 and latitude <> '') or (latitude is not null and longitude is not null)
GO

-- 3. Using a query with the PIVOT option (see slide 26 of the Chapter 14 - Data Warehouse Presentation 2022
-- Summer in Module 6 – Advanced SQL module of the Canvas course of the last question in Assignment 10 –
-- Chapter 5 Questions) write a query that gives the number of shootings (killed + injured) by state and year. Hint:
-- Remember the years included in the IN section of the PIVOT statement are column names and must be included
-- in brackets)
SELECT *
FROM (SELECT State, DATEPART(yyyy, Date) AS Year, Killed + Injured AS [# of Shootings] FROM Gun_All_Incidents) f
PIVOT (sum([# of Shootings]) for f.Year in ([2015], [2016], [2017], [2018], [2019], [2020], [2021], [2022], [2023])) AS PivotTable
ORDER BY State

-- 4. Modify the query you wrote in #3 to only include the state you chose to move to in Part1 and each city within
-- the state you chose. In the illustration below, I chose Illinois.
-- Also note that by using a pivot statement I can get additional information by filtering the results so show a
-- subset of the data without modifying the query. The example below shows the filtering options by clicking on
-- the arrow in the city column header,
SELECT *
FROM (SELECT State, City, DATEPART(yyyy, Date) AS Year, Killed + Injured AS [# of Shootings] FROM Gun_All_Incidents) f
PIVOT (sum([# of Shootings]) for f.Year in ([2015], [2016], [2017], [2018], [2019], [2020], [2021], [2022], [2023])) AS PivotTable
WHERE State like 'Florida'
ORDER BY State

-- 5. Update the procedure you wrote for Part 2 of the project to also identify the number of crimes within 10 miles
-- (16000 meters) of each site in the state you pass to the stored procedure by year that the crime was committed.
-- Note: you will need consider that there are no columns to join the GunCrimes and AQS_Sites tables together, so
-- you need to create a Cartesian Product and filter data out in the where statement using the following formula
-- (which you’ll need to modify) and the location data from your queries
-- table1.geoLocation.STDistance(table2.geolocation) <=16000 where @h is a geography variable that hold your
-- starting position

IF EXISTS(SELECT 1 FROM sys.procedures 
          WHERE Name = 'JIH_Fall2022_Gun_Crimes_GEO_Distance')
BEGIN
    DROP PROCEDURE [dbo].[JIH_Fall2022_Gun_Crimes_GEO_Distance]
END
go

Create PROCEDURE [dbo].[JIH_Fall2022_Gun_Crimes_GEO_Distance] (
	@longitude float,
	@latitude float,
    @State varchar(max),
	@rownum int
)	
AS
BEGIN
DECLARE @h geography;
SET @h = geography::Point (@latitude, @longitude, 4326);
SELECT TOP (@rownum) 
    Site_Number
    , Local_Site_Name
    , A.Address
    , City_Name
    , State_Name
    , Zip_Code
    , JIH_aqs_geolocation.STDistance(@h) AS Distance_In_Meters
    , A.Latitude
    , A.Longitude
    , (JIH_aqs_geolocation.STDistance(@h) * 0.000621371)/55 AS Hours_of_Travel
    , DATEPART(yyyy, Date) AS Crime_Year
    , sum(Killed + Injured) AS Shooting_Count
FROM AQS_Sites A, Gun_All_Incidents G
WHERE State_Name = @State
    AND A.State_Name = G.State
    AND A.City_Name = G.City 
    AND City_Name NOT like 'Not in a City'
    AND Local_Site_Name IS NOT NULL
    -- AND A.Latitude = G.latitude
    -- AND A.Longitude = G.longitude
    AND A.JIH_aqs_geolocation.STDistance(G.JIH_Gun_All_Incidents_geolocation) <= 16000
    -- AND JIH_aqs_geolocation.STDistance(@h) < 
GROUP BY 
Site_Number
    , Local_Site_Name
    , A.Address
    , City_Name
    , State_Name
    , Zip_Code
    , JIH_aqs_geolocation.STDistance(@h)
    , A.Latitude
    , A.Longitude
    , DATEPART(yyyy, Date)
ORDER BY Local_Site_Name
END
GO


-- 6. Write a query that ranks all the cities in the state you selected from lowest to highest number of GunCrimes.
-- Use your stored procedure to dense rank the cities by the number of shootings in descending order. Note you
-- will need to use a row_num value that returns all the data for the state. See the SQL Server select from stored
-- procedure return table section of this site: SQL Server select from stored procedure (9 Examples) - SQL Server
-- Guides for instructions on how to use a stored procedure in a select query. The following used New Jersey as
-- the state_name
DECLARE @t TABLE(
    Site_Number varchar(255)
    , Local_Site_Name varchar(max)
    , Address varchar(max)
    , City_Name varchar(max)
    , State_Name varchar(max)
    , Zip_Code varchar(max)
    , Distance_In_Meters float
    , Latitude float
    , Longitude float
    , Hours_of_Travel float
    , Crime_Year varchar(255)
    , Shooting_Count int)

insert @t
EXEC [JIH_Fall2022_Gun_Crimes_GEO_Distance]
@latitude = '36.778261',
@longitude = '-119.417932',
@State = 'New Jersey',
@rownum = 100000

SELECT State_Name, City_Name, Shooting_Count, DENSE_RANK() OVER(ORDER BY Shooting_Count DESC) AS gun_rank
FROM @t