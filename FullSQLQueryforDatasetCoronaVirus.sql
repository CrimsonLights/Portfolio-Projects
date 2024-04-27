-- Testing both tables
SELECT
	* 
FROM
	ProjectPortfolio..CovidDeaths 
ORDER BY
	3,
	4 SELECT
	* 
FROM
	ProjectPortfolio..CovidVaccinations 
ORDER BY
	3,
	4 
	-- Data to be used
SELECT
	location,
	DATE,
	total_cases,
	new_cases,
	total_deaths,
	population 
FROM
	ProjectPortfolio..CovidDeaths 
ORDER BY
	1,
	2 
	-- Total case vs total death
SELECT
	location,
	DATE,
	total_cases,
	total_deaths,
	( total_deaths / total_cases ) * 100 AS Deathrate 
FROM
	ProjectPortfolio..CovidDeaths 
WHERE
	location LIKE 'Egypt' 
ORDER BY
	1,
	2
	
	 -- Total case vs population
SELECT
	location,
	DATE,
	total_cases,
	population,
	( total_cases / population ) * 100 AS InfectionRate 
FROM
	ProjectPortfolio..CovidDeaths 
WHERE
	location LIKE 'Egypt' 
ORDER BY
	1,
	2 
	
	
	-- High infection vs population
SELECT
	location,
	population,
	max( total_cases ) AS HighestInfection,
	max( total_cases / population ) * 100 AS InfectionRate 
FROM
	ProjectPortfolio..CovidDeaths 
GROUP BY
	location,
	population 
ORDER BY
	InfectionRate DESC --S how Countries WITH Highest Death count per population SELECT
	location,
	MAX( cast( total_deaths AS INT )/ population )* 100 AS Deathperpopulation 
FROM
	ProjectPortfolio..CovidDeaths 
WHERE
	continent IS NOT NULL 
	AND total_deaths IS NOT NULL 
GROUP BY
	location 
ORDER BY
	Deathperpopulation DESC --S how Continent WITH Highest Death count per population SELECT
	location,
	MAX(
	cast( total_deaths AS INT )) AS Deathperpopulation 
FROM
	ProjectPortfolio..CovidDeaths 
WHERE
	continent IS NULL 
	AND total_deaths IS NOT NULL 
GROUP BY
	location 
ORDER BY
	Deathperpopulation DESC 
	
	-- Total Number
SELECT
	max( total_cases ) AS totalinfected,
	MAX(
	cast( total_deaths AS INT )) AS Death 
FROM
	ProjectPortfolio..CovidDeaths 
WHERE
	continent IS NULL 
	AND total_deaths IS NOT NULL 
	
	-- Total Number + Death rate percentage, TEST by me to try not using recalc.
SELECT
	--t id.Death,
	totalinfected,
	Death,
	( Death / totalinfected ) * 100 AS DeathPerc 
FROM
	(
	SELECT
		MAX( total_cases ) AS totalinfected,
		MAX(
		CAST( total_deaths AS INT )) AS Death 
	FROM
		ProjectPortfolio..CovidDeaths 
	WHERE
		continent IS NULL 
		AND total_deaths IS NOT NULL 
	) AS tid --w here tid.Death > 1 
	
	-- Testing Joining both tables
SELECT
	* 
FROM
	ProjectPortfolio..CovidDeaths dea
	JOIN ProjectPortfolio..CovidVaccinations vac ON dea.location = vac.location 
	AND dea.DATE = vac.DATE 
	
	-- Total Population  vs vaccinations  With rolling values
SELECT
	rollingpplvac,
	rvp.population,
	rvp.location,
	rvp.DATE,
	( rollingpplvac / rvp.population ) * 100 AS rollingvacperc 
FROM
	(
	SELECT
		dea.continent,
		dea.location,
		dea.DATE,
		dea.population,
		vac.new_vaccinations,
		sum(
		CONVERT ( INT, vac.new_vaccinations )) OVER ( PARTITION BY dea.location ORDER BY dea.DATE ) AS rollingpplvac 
	FROM
		ProjectPortfolio..CovidDeaths dea
		JOIN ProjectPortfolio..CovidVaccinations vac ON dea.location = vac.location 
		AND dea.DATE = vac.DATE 
	WHERE
		dea.continent IS NOT NULL 
		AND dea.location LIKE 'Canada' 
	AND vac.new_vaccinations IS NOT NULL 
	) AS rvp