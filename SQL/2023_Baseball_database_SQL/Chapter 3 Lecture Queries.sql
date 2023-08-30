use BaseBall_Summer_2023;
go
---Basic Select Clause
---1 Select all columns from the PEOPLE table
SELECT *
FROM People

--- Select secific columns
--- 2 Select playerid, nameFirst, NameLast and the finalGame from the PEOPLE table
SELECT playerid, nameFirst, NameLast, finalGame
FROM People

--- Distinct Function - ELiminates duplicates from the query results
--- 3 Select all the playerids from the BATTING table
SELECT playerid
FROM Batting

--- 4 Select all the playerids from the BATTING table eliminating duplicates
SELECT DISTINCT playerid
FROM Batting

--- Calculations in the SELECT statement
--- 5 Select the playerid and salary for each row in the SALARIES table
SELECT playerid, salary
FROM Salaries

--- 6 Convert the results from the SALARIES table to show monthly salary
SELECT playerid, salary, (salary / 12)
FROM Salaries

--- 7 Rename the results in #6 to name the calculated monthly salary
--- Monthly_Salary
SELECT playerid, salary, (salary / 12) AS Monthly_Salary
FROM Salaries

--- 8 Rename the results in #7 to name the calculated monthly salary
--- to be the words Monthly Salary
SELECT playerid, salary, (salary / 12) AS [Monthly Salary]
FROM Salaries

--- 9 Format the results in #8 so the results show dollars and cents
SELECT playerid, salary, format(salary / 12,'c') AS [Monthly Salary]
FROM Salaries

--- 10 Change the query above to only show salaries over $200,000.00
SELECT playerid, salary, format(salary / 12,'c') AS [Monthly Salary]
FROM Salaries
WHERE salary > 200000

--- 11 Change the query in #8 to not show null salaries
SELECT playerid, salary, (salary / 12) AS [Monthly Salary]
FROM Salaries

--- 12 Using a WHERE clause, show the playerid, namelast, nameFirst and salary
using the PEOPLE and SALARIES tables
--- Why am I getting multiple entries for each player?
--- 13 Rewrite the query in #12 using a JOIN statement
--- 14 Write a query that calaculates a players batting average (H/AB). Your
results need to show the playerid, nameFirst, NameLast,
--- H, AB and Batting Average using the PEOPLE and BATTING table. There should
be a row for each year the player played
--- also fix why the batting average is always 0. Also discuss nullif and
ISnull
--- 15 Batting Average is usually shown as a 4 decimal point number. Correct the
query in #14 so the results show correctly
Convert(decimal(5,4),(H*.1/AB)) as [Batting Average]
--- 16 in addition the in information in #15, show the players salary for the same
year as the batting average
--- String Operations --- Starts on Slide 31
--- 17 Find the players who use initials as their first name. Your results should
show the pleyerid, nameFirst, NameGiven and NameLast
--- 18 Find the players who use last name starts with Mc. Your results should show
the pleyerid, nameFirst, NameGiven and NameLast
--- 19 Find the players who use last name ends with a w. Your results should show
the pleyerid, nameFirst, NameGiven and NameLast
--- show only the first 5
--- 20 Change the query in #19 to show the name in the format GivenName (firstname)
lastname and rename the combined column as Full Name
--- 21 Change the query in #20 to show nameLast, nameFirst. Note the , must be part
of the result set
--- 22 Change the query in #20 to be sorted by last name (ascending then descending
)
--- Where Clause --- page 37 in presentation
---23 write a query that shows the player Full Name, the team name, ball park,
batting average and salary for each year thay played. Only show
--- players that have salary information
---24 Find all players and the years that they had a Batting Average between .3000
and .4000 using a between parameter
--- 25 Find all players and the years where their batting average was
between .3000 and .4000 and their salary was between 1 and 2 million dollars
GO
--- Set Operations UNION, INTERSECT and EXCEPT
--- 26 find all players that played for the NY Yankees (teamid = NYA in 2008 and
2010) using the BATTING table
INTERSECT
--- 27 find all players that played for the NY Yankees (teamid = NYA in 2008 or
2010) using the BATTING table
UNION
--- 28 find all players that played for the NY Yankees (teamid = NYA in 2008 and
never played for the Boston Red Sox (teamid = BOS) using the BATTING table
EXCEPT
--- 29 Find all the playerid in the salary table that have a null salary
--- 30 Calculate the average salary for all baseball players
--- 31 Calculate the average salary by dividing the sum of salaries by the count
of playerids
--- 32 Calculate the average number of home runs (HR) by team from the batting
table sorted by teamid
--- 33 Calculate the average number of home runs (HR), Max number of home runs,
and the averages number of
--- hits (H) and strike outs (SO) by team from the batting table sorted by
teamid
--- 34 Now show the same inforation for each player on any team in the AL in 1990.
You should show the playerid and the teamid
--- 35 Now show the same information for all players in the AL in any year who has
a average number of hits
--- greater that 100. Use a HAVING cluase in the where parameter
--- NESTED Subqueries --- Page 52
--- 36 Using the query in #35, show the average number of home by players, the
average number of home rungs by team and
--- calculate the difference the players average and the teams average
--- Page 56
--- 37 Using and IN clause in the WHERE statment, list all the players and teamid
in 2010 that are playing for a team
--- that existed in 1900 using the BATTING table. order your results by teamid
and playerid
--- 38 write the same query to just show the number of players on each team in 2010
--- 39 Find the average Salary for players, the average salary for the team they
played for
--- and the difference between the 2 averages
--- Slide 67
--- 40 Using the PEOPLE and AWARDSPLAYERS tables, write a query that uses an IN
statement
--- and a subquery to identify all the players that received awards. There
should be
--- no duplicates in the results. Your results should have the playerid,
nameFirst and
--- nameLast of the players and be sorted by last name
go
--- 41 Rewrite the query from 39 using a WITH clase instead of subqueries
--- 39 Find the average Salary for players, the average salary for the team they
played for
--- and the difference between the 2 averages
--- Slide 78 Scalar Subqueries
--- 42 Write a query that shows the playerid, full name and the number of teams
they played for.
--- Answer using an aggregate function and then rewrite it using a scalar subquery
--- Aggregate
-- Discuss order difference
go
--- Slide 81
--- Create a copy of the SALARIES table
CREATE TABLE TSalaries(
[yearID] [int] NULL,
[teamID] [varchar](255) NULL,
[lgID] [varchar](255) NULL,
[playerID] [varchar](255) NULL,
[salary] [money] NULL
) ON [PRIMARY]
GO
--- insert the rescords from the salaries table into the tsalaries table
insert into tsalaries
select * from salaries
select * from tsalaries
--- delete all records from tsalaries
delete from tsalaries
--- delete all records where the salary is null from tsalaries
delete from tsalaries
where salary is null
--- Update every salary in TSalaries by .03%
update tsalaries
set salary = salary*1.03
--- Slide 86
--- CASE statement (similiar to IF)
--- Update the salary by .05 if the salary is greater than 1 million else update it
by .1
update tSalaries
set salary = case
when salary <= 1000000 then salary * 1.05
else salary * 1.03
end
--- Add a column to the PEOPLE table for the players average salary and populate
the new column
IF NOT EXISTS(
SELECT *
FROM sys.columns
WHERE Name = N'Avg_Salary'
AND Object_ID = Object_ID(N'PEOPLE'))
BEGIN
ALTER TABLE PEOPLE ADD avg_Salary money NULL
END
go
--- populate the column
update PEOPLE
set avg_Salary = asal
from (select playerid, avg(Salary) as asal
from salaries
group by playerid) A, people
where people.playerid = a.playerid
select playerID, format(avg_salary,'C') as [Avg Salary] from people where
avg_salary is not null