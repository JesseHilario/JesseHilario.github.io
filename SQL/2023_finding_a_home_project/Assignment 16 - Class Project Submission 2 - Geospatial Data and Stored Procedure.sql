Use Weather
go

-- Write a stored procedure that will use has the latitude and longitude of where you are moving from (you
-- will enter this data) and the state you are moving to as input parameters and returns all the cities in that
-- state that are in the database and the distance between that city and where you are moving from.
-- Provide the SQL to create the geospatial column and populate it as the first part of your answer. The
-- second requirement for Part 4 is to create the stored procedure and execute the stored procedure for
-- from a spreadsheet (see question 2 below for information about the spreadsheet). The stored
-- procedure has the following requirements:
-- a. The name of the stored procedure must be UCID_Fall2022_Calc_GEO_Distance

IF EXISTS(SELECT 1 FROM sys.procedures 
          WHERE Name = 'JIH_Fall2022_Calc_GEO_Distance')
BEGIN
    DROP PROCEDURE [dbo].[JIH_Fall2022_Calc_GEO_Distance]
END
go

Create PROCEDURE [dbo].[JIH_Fall2022_Calc_GEO_Distance] (

-- b. The stored procedure must have the following variables:
-- i. @longitude – This will contain the longitude of the starting location
-- ii. @latitude – this contains the latitude of the starting location
-- iii. @State – this contains the state name to get the data for
-- iv. @rownum – this contains the number of rows the stored procedure will return
	@longitude float,
	@latitude float,
    @State varchar(max),
	@rownum int
)	
AS
BEGIN

-- c. The logic in the stored procedure must do the following:
-- i. Select the site number, Local_Site_Name, Address, City_Name, State_Name,
-- Zip_Code, Distance_In_Meters, Latitude, Longitude and Hours_of_Travel. If the
-- Local_Site_Name is null, generate a value for the column by concatenating the
-- Site_Number and City_Name
-- ii. Distance_In_Meters must be calculated using the following equation:
-- geoLocation.STDistance(@h) where @h is a geography variable calculated from the
-- latitude and longitude of the starting location.
DECLARE @h geography;
SET @h = geography::Point (@latitude, @longitude, 4326);

-- iii. Hours_of_Travel must be calculated using the following formula
-- (geoLocation.STDistance(@h) * *0.000621371)/55 (Assume you’ll be traveling at
-- the legal speed limit)
SELECT TOP (@rownum) 
    Site_Number
    , Local_Site_Name
    , Address
    , City_Name
    , State_Name
    , Zip_Code
    , JIH_aqs_geolocation.STDistance(@h) AS Distance_In_Meters
    , Latitude
    , Longitude
    , (JIH_aqs_geolocation.STDistance(@h) * 0.000621371)/55 AS Hours_of_Travel
FROM AQS_Sites
WHERE State_Name = @State

-- d. The DDL that creates the stored procedure must:
-- i. check to see if the procedure exists and delete prior versions
-- ii. include 2 exec statements for UCID_Summer2023_Calc_GEO_Distance at the end
-- that runs the stored procedure with different variable values
END
GO

EXEC [JIH_Fall2022_Calc_GEO_Distance]
@latitude = '36.778261',
@longitude = '-119.417932',
@State = 'Florida',
@rownum = 30
GO

EXEC [JIH_Fall2022_Calc_GEO_Distance]
@latitude = '40.735657',
@longitude = '-74.172367',
@State = 'California',
@rownum = 50
GO