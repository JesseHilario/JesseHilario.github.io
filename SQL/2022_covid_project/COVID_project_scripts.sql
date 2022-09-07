-- Select Data we will be using from covid_deaths table

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM project_portfolio.covid_deaths
WHERE continent != '' -- excludes continents in the 'location' column
order by 1,2;


-- Looking at Total Cases vs Total Deaths
-- Shows fatality rate if you contract COVID in the United States

SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS total_death_percentage
, new_cases, new_deaths, (new_deaths/new_cases)*100 AS new_death_percentage	-- Includes percentage for total and new deaths
FROM project_portfolio.covid_deaths
WHERE location REGEXP 'state' AND continent != ''
order by 1,2;


-- Looking at Total Cases vs Population
-- Shows what percentage of population got COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 AS total_infected_percentage
, new_cases, (new_cases/population)*100 AS new_infected_percentage
FROM project_portfolio.covid_deaths
WHERE location REGEXP 'state' AND continent != ''
order by 1,2;


-- Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS highest_infection_count, (MAX(total_cases)/population)*100 AS highest_total_infected_percentage
FROM project_portfolio.covid_deaths
WHERE continent != ''
GROUP BY location, population
ORDER BY highest_total_infected_percentage desc;


-- Showing countries with highest death count per population

SELECT location, MAX(total_deaths) AS total_death_count
FROM project_portfolio.covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY total_death_count desc;


-- Breaking things down by continent using CTE

WITH continent_total_death AS (
SELECT continent, location, MAX(total_deaths) AS total_death_count
FROM project_portfolio.covid_deaths
WHERE continent != ''
GROUP BY location)
SELECT continent, SUM(total_death_count) AS death_count_by_continent
FROM continent_total_death
GROUP BY continent
ORDER BY death_count_by_continent DESC;


-- Global numbers for new cases and new deaths

SELECT date, SUM(new_cases) AS new_cases, SUM(new_deaths) AS new_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS new_death_percentage,
	 SUM(total_cases) AS total_cases, SUM(total_deaths) AS total_deaths, (SUM(total_deaths)/SUM(total_cases))*100 AS total_death_percentage
FROM project_portfolio.covid_deaths
WHERE continent != ''
GROUP BY date
order by 1,2;


-- Looking at new vs rolling vaccinations

SELECT dea.continent, dea.location, dea.date, population, new_vaccinations
, SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations -- cumulative count of vaccines by location over time
FROM project_portfolio.covid_deaths dea
JOIN project_portfolio.covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date	
WHERE dea.continent != ''
ORDER BY 2,3;


-- TEMP TABLE for proportion of population vaccinated

DROP TEMPORARY TABLE IF EXISTS project_portfolio.current_vac_percentage;
CREATE TEMPORARY TABLE project_portfolio.current_vac_percentage (
continent NVARCHAR(50),
location NVARCHAR(50),
date DATE,
population BIGINT,
new_vaccinations INT,
people_vaccinated BIGINT,
people_fully_vaccinated BIGINT,
rolling_vaccinations BIGINT
);

INSERT INTO project_portfolio.current_vac_percentage
SELECT dea.continent, dea.location, dea.date, population, new_vaccinations, people_vaccinated, people_fully_vaccinated
, SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations 
-- commenting out next line to use rolling_vaccinations later
-- , (rolling_vaccinations/population)*100
FROM project_portfolio.covid_deaths dea
JOIN project_portfolio.covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date	
;
SELECT *, (rolling_vaccinations/population)*100 AS percent_vaccinated		-- 
FROM project_portfolio.current_vac_percentage
WHERE continent != '';

-- Create View
DROP VIEW IF EXISTS project_portfolio.rolling_percent_vac;
CREATE VIEW project_portfolio.rolling_percent_vac AS
SELECT *, (rolling_vaccinations/population)*100 AS percent_vaccinated		-- 
FROM project_portfolio.current_vac_percentage
WHERE continent != '';


-- Create CTE for each country's current percent of population vaccinated who are fully vaccinated

WITH cur_pop_vac AS (
SELECT location, date, population, MAX(rolling_vaccinations) AS rolling_vac, MAX(people_vaccinated) AS people_vac, MAX(people_fully_vaccinated) AS people_fully_vac
, (MAX(people_vaccinated)/population)*100 AS percent_vac, (MAX(people_fully_vaccinated)/population)*100 AS percent_fully_vac
FROM project_portfolio.current_vac_percentage
WHERE continent != ''
GROUP BY location)
SELECT *, (percent_fully_vac/percent_vac)*100 AS percent_fully_vac_vs_not		
-- used above because percent_fully_vac inexplicably reaches over 100%
FROM cur_pop_vac
ORDER BY percent_fully_vac_vs_not DESC;

DROP TEMPORARY TABLE project_portfolio.current_vac_percentage;


-- Creating Views to store data for later visualizations

-- View for comparing incomes

DROP VIEW IF EXISTS project_portfolio.income_level_comparison;
Create View project_portfolio.income_level_comparison AS  
SELECT dea.location, population, MAX(total_cases) AS total_cases, MAX(total_deaths) AS total_deaths, MAX(total_vaccinations) AS total_vac
, MAX(people_fully_vaccinated) AS people_fully_vac, (MAX(total_deaths)/population)*100 AS total_death_percentage
, (MAX(people_fully_vaccinated)/population)*100 AS fully_vac_percentage
FROM project_portfolio.covid_deaths dea
JOIN project_portfolio.covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date	
WHERE dea.location LIKE '%income%'
GROUP BY dea.location
ORDER BY total_death_percentage DESC;


-- View for death rate

DROP VIEW IF EXISTS project_portfolio.death_rate;
Create View project_portfolio.death_rate AS  
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS total_death_percentage,
	new_cases, new_deaths, (new_deaths/new_cases)*100 AS new_death_percentage
FROM project_portfolio.covid_deaths
WHERE continent != ''
order by 1,2;


-- View for infection rate

DROP VIEW IF EXISTS project_portfolio.infection_rate;
Create View project_portfolio.infection_rate AS  
SELECT location, date, population, total_cases, (total_cases/population)*100 AS total_infected_percentage
, new_cases, (new_cases/population)*100 AS new_infected_percentage
FROM project_portfolio.covid_deaths
WHERE continent != ''
order by 1,2;


-- View for highest death count by country

DROP VIEW IF EXISTS project_portfolio.country_death_count;
Create View project_portfolio.country_death_count AS  
SELECT location, MAX(total_deaths) AS total_death_count
FROM project_portfolio.covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY total_death_count desc;


-- View for highest death count by continent

DROP VIEW IF EXISTS project_portfolio.continent_death_count;
Create View project_portfolio.continent_death_count AS  
WITH continent_total_death AS (
SELECT continent, location, MAX(total_deaths) AS total_death_count
FROM project_portfolio.covid_deaths
WHERE continent != ''
GROUP BY location)
SELECT continent, SUM(total_death_count) AS death_count_by_continent
FROM continent_total_death
GROUP BY continent
ORDER BY death_count_by_continent DESC;


-- View for new cases and new deaths globally

DROP VIEW IF EXISTS project_portfolio.global_deaths_and_cases;
Create View project_portfolio.global_deaths_and_cases AS  
SELECT date, SUM(new_cases) AS new_cases, SUM(new_deaths) AS new_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS new_death_percentage,
	 SUM(total_cases) AS total_cases, SUM(total_deaths) AS total_deaths, (SUM(total_deaths)/SUM(total_cases))*100 AS total_death_percentage
FROM project_portfolio.covid_deaths
WHERE continent != ''
GROUP BY date
order by 1;


-- Looking at new vs rolling vaccinations

DROP VIEW IF EXISTS project_portfolio.rolling_vaccinations;
Create View project_portfolio.rolling_vaccinations AS  
SELECT dea.continent, dea.location, dea.date, population, new_vaccinations
, SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations -- cumulative count of vaccines by location over time
FROM project_portfolio.covid_deaths dea
JOIN project_portfolio.covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date	
WHERE dea.continent != ''
ORDER BY 2,3;