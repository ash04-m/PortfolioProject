select *
from portfolio_project.dbo.CovidDeaths
where location= 'world'
order by 2


-- looking total cases vs population
-- show what percentage people got covid
select location, date,total_cases,total_deaths, population, (total_cases/population) as covid_cases
from portfolio_project.dbo.CovidDeaths
where location= 'india'
order by 1,2

-- looking at the countries with highest infection rste compared to population
select location, population,max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as HighestPercentPopulationInfected
from portfolio_project.dbo.CovidDeaths 
group by location, population
order by HighestPercentPopulationInfected desc

--showing country with highest death count
select location,max(cast(total_deaths as int)) as totaldeathcount
from portfolio_project.dbo.CovidDeaths 
where continent is  null
group by location
order by totaldeathcount desc

--Global numbers
select sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,( SUM(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from portfolio_project.dbo.CovidDeaths  
where continent is not null
order by 1 desc

--Looking at total population vs vaccinations 
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as people_vaccinated,
  --(people_vaccinated/dea.population)*100 as
  from portfolio_project.dbo.CovidDeaths dea
  join  portfolio_project.dbo.CovidVaccinations vac
  on dea.location= vac.location
  and dea.date= vac.date
  where dea.continent is not null
  order by 2,3

  -- Use CTE
    With PopvsVac (Continent, location, date, population, newly_vaccinated, people_vaccinated)
	as 
	( 
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as people_vaccinated
  --(people_vaccinated/dea.population)*100 
  from portfolio_project.dbo.CovidDeaths dea
  join  portfolio_project.dbo.CovidVaccinations vac
  on dea.location= vac.location
  and dea.date= vac.date
  where dea.continent is not null
  )
  select *, (people_vaccinated/population)*100
  from PopvsVac

  --Using Temp Table

  DROP TABLE if exists #Population_Vaccinated
  CREATE TABLE #Population_Vaccinated
  (continent nvarchar (100),
  location nvarchar(100),
  Date datetime,
  population int,
  newly_vaccinated int,
  people_vaccinated int)
  insert into #Population_Vaccinated
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as people_vaccinated
  --(people_vaccinated/dea.population)*100 
  from portfolio_project.dbo.CovidDeaths dea
  join  portfolio_project.dbo.CovidVaccinations vac
  on dea.location= vac.location
  and dea.date= vac.date
  where dea.continent is not null

  select*, (people_vaccinated/population)*100
  from #Population_Vaccinated


  --Create Views

  
  Create view PercentagePopulationVaccinated as
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as people_vaccinated
  --(people_vaccinated/dea.population)*100 
  from portfolio_project.dbo.CovidDeaths dea
  join  portfolio_project.dbo.CovidVaccinations vac
  on dea.location= vac.location
  and dea.date= vac.date
  where dea.continent is not null
  

  select *
  from PercentagePopulationVaccinated
  
  select continent, sum(cast(total_deaths as int))
  from portfolio_project.dbo.CovidDeaths
  group by continent
  order by continent





 
 


