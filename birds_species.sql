-- ══════════════════════════════════════════════════════════════
-- Bird Species Observation Analysis — SQL Queries
-- Database: birds_project | Table: bird_observations
-- ══════════════════════════════════════════════════════════════

-- ── SECTION 1: DATA EXPLORATION ──────────────────────────────

-- 1.1 Total observations and habitat split
use birds_project;
SELECT 
    Habitat,
    COUNT(*) AS Total_Observations,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bird_observations), 2) AS Percentage
FROM bird_observations
GROUP BY Habitat;

-- 1.2 Total unique species overall and per habitat
SELECT 
    Habitat,
    COUNT(DISTINCT Scientific_Name) AS Unique_Species
FROM bird_observations
GROUP BY Habitat;

-- 1.3 Column-level overview
SELECT 
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Common_Name) AS Unique_Species,
    COUNT(DISTINCT Observer) AS Total_Observers,
    COUNT(DISTINCT Source_Sheet) AS Admin_Units,
    MIN(Date) AS Earliest_Date,
    MAX(Date) AS Latest_Date
FROM bird_observations;


-- ── SECTION 2: SPECIES ANALYSIS ──────────────────────────────

-- 2.1 Top 10 most observed species
SELECT 
    Common_Name,
    Scientific_Name,
    COUNT(*) AS Observations
FROM bird_observations
GROUP BY Common_Name, Scientific_Name
ORDER BY Observations DESC
LIMIT 10;

-- 2.2 Top 5 species per habitat
SELECT Habitat, Common_Name, Observations
FROM (
    SELECT 
        Habitat,
        Common_Name,
        COUNT(*) AS Observations,
        ROW_NUMBER() OVER (PARTITION BY Habitat ORDER BY COUNT(*) DESC) AS rnk
    FROM bird_observations
    GROUP BY Habitat, Common_Name
) ranked
WHERE rnk <= 5;

-- 2.3 Species observed in BOTH habitats
SELECT 
    Scientific_Name,
    Common_Name,
    COUNT(DISTINCT Habitat) AS Habitat_Count
FROM bird_observations
GROUP BY Scientific_Name, Common_Name
HAVING Habitat_Count = 2
ORDER BY Common_Name;

-- 2.4 Species exclusive to Forest only (faster version)
SELECT DISTINCT 
    f.Scientific_Name, 
    f.Common_Name
FROM bird_observations f
LEFT JOIN bird_observations g 
    ON f.Scientific_Name = g.Scientific_Name 
    AND g.Habitat = 'Grassland'
WHERE f.Habitat = 'Forest'
  AND g.Scientific_Name IS NULL
ORDER BY f.Common_Name;

-- 2.5 Species exclusive to Grassland only (faster version)
SELECT DISTINCT 
    g.Scientific_Name, 
    g.Common_Name
FROM bird_observations g
LEFT JOIN bird_observations f 
    ON g.Scientific_Name = f.Scientific_Name 
    AND f.Habitat = 'Forest'
WHERE g.Habitat = 'Grassland'
  AND f.Scientific_Name IS NULL
ORDER BY g.Common_Name;


-- ── SECTION 3: TEMPORAL ANALYSIS ─────────────────────────────

-- 3.1 Observations by month
SELECT 
    Month_Name,
    Month,
    COUNT(*) AS Observations
FROM bird_observations
GROUP BY Month_Name, Month
ORDER BY Month;

-- 3.2 Observations by season and habitat
SELECT 
    Season,
    Habitat,
    COUNT(*) AS Observations
FROM bird_observations
GROUP BY Season, Habitat
ORDER BY Season, Habitat;

-- 3.3 Peak observation month per admin unit
SELECT Source_Sheet AS Admin_Unit, Month_Name, Observations
FROM (
    SELECT 
        Source_Sheet,
        Month_Name,
        Month,
        COUNT(*) AS Observations,
        ROW_NUMBER() OVER (PARTITION BY Source_Sheet ORDER BY COUNT(*) DESC) AS rnk
    FROM bird_observations
    GROUP BY Source_Sheet, Month_Name, Month
) ranked
WHERE rnk = 1
ORDER BY Observations DESC;


-- ── SECTION 4: ENVIRONMENTAL ANALYSIS ────────────────────────

-- 4.1 Average temperature and humidity by habitat
SELECT 
    Habitat,
    ROUND(AVG(Temperature), 2) AS Avg_Temperature,
    ROUND(AVG(Humidity), 2)    AS Avg_Humidity,
    ROUND(MIN(Temperature), 2) AS Min_Temp,
    ROUND(MAX(Temperature), 2) AS Max_Temp
FROM bird_observations
GROUP BY Habitat;

-- 4.2 Observation count by sky condition
SELECT 
    Sky,
    COUNT(*) AS Observations,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bird_observations), 2) AS Percentage
FROM bird_observations
GROUP BY Sky
ORDER BY Observations DESC;

-- 4.3 Observation count by disturbance level
SELECT 
    Disturbance,
    COUNT(*) AS Observations
FROM bird_observations
GROUP BY Disturbance
ORDER BY Observations DESC;

-- 4.4 Average temperature by month (seasonal warmth pattern)
SELECT 
    Month_Name,
    Month,
    ROUND(AVG(Temperature), 2) AS Avg_Temp,
    ROUND(AVG(Humidity), 2)    AS Avg_Humidity
FROM bird_observations
GROUP BY Month_Name, Month
ORDER BY Month;


-- ── SECTION 5: BEHAVIOR & IDENTIFICATION ─────────────────────

-- 5.1 ID method distribution
SELECT 
    ID_Method,
    COUNT(*) AS Observations,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bird_observations), 2) AS Percentage
FROM bird_observations
GROUP BY ID_Method
ORDER BY Observations DESC;

-- 5.2 Flyover frequency by habitat
SELECT 
    Habitat,
    Flyover_Observed,
    COUNT(*) AS Count
FROM bird_observations
GROUP BY Habitat, Flyover_Observed
ORDER BY Habitat;

-- 5.3 Distance distribution
SELECT 
    Distance,
    COUNT(*) AS Observations
FROM bird_observations
GROUP BY Distance
ORDER BY Observations DESC;

-- 5.4 Sex ratio overall
SELECT 
    Sex,
    COUNT(*) AS Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bird_observations), 2) AS Percentage
FROM bird_observations
GROUP BY Sex
ORDER BY Count DESC;


-- ── SECTION 6: SPATIAL ANALYSIS ──────────────────────────────

-- 6.1 Observations per admin unit
SELECT 
    Source_Sheet AS Admin_Unit,
    Habitat,
    COUNT(*) AS Observations
FROM bird_observations
GROUP BY Source_Sheet, Habitat
ORDER BY Source_Sheet;

-- 6.2 Biodiversity hotspots — most unique species per admin unit
SELECT 
    Source_Sheet AS Admin_Unit,
    COUNT(DISTINCT Scientific_Name) AS Unique_Species,
    COUNT(*) AS Total_Observations
FROM bird_observations
GROUP BY Source_Sheet
ORDER BY Unique_Species DESC;

-- 6.3 Most species-rich plots
SELECT 
    Plot_Name,
    Habitat,
    COUNT(DISTINCT Scientific_Name) AS Unique_Species,
    COUNT(*) AS Observations
FROM bird_observations
GROUP BY Plot_Name, Habitat
ORDER BY Unique_Species DESC
LIMIT 15;


-- ── SECTION 7: OBSERVER ANALYSIS ─────────────────────────────

-- 7.1 Top 10 observers by observation count
SELECT 
    Observer,
    COUNT(*) AS Observations,
    COUNT(DISTINCT Scientific_Name) AS Unique_Species_Recorded
FROM bird_observations
GROUP BY Observer
ORDER BY Observations DESC
LIMIT 10;

-- 7.2 Observer coverage — which admin units each observer covered
SELECT 
    Observer,
    COUNT(DISTINCT Source_Sheet) AS Admin_Units_Covered,
    COUNT(DISTINCT Habitat) AS Habitats_Covered
FROM bird_observations
GROUP BY Observer
ORDER BY Admin_Units_Covered DESC
LIMIT 10;


-- ── SECTION 8: CONSERVATION INSIGHTS ─────────────────────────

-- 8.1 Watchlist species count by habitat
-- (adjust 'True' below if your values differ e.g. '1', 'YES')
SELECT 
    Habitat,
    COUNT(DISTINCT Common_Name) AS Watchlist_Species
FROM bird_observations
WHERE PIF_Watchlist_Status = 'True'
GROUP BY Habitat;

-- 8.2 Most observed watchlist species
SELECT 
    Common_Name,
    Scientific_Name,
    Habitat,
    COUNT(*) AS Observations
FROM bird_observations
WHERE PIF_Watchlist_Status = 'True'
GROUP BY Common_Name, Scientific_Name, Habitat
ORDER BY Observations DESC
LIMIT 10;

-- 8.3 Regional stewardship priority species per habitat
SELECT 
    Habitat,
    COUNT(DISTINCT Common_Name) AS Priority_Species
FROM bird_observations
WHERE Regional_Stewardship_Status = 'True'
GROUP BY Habitat;

-- 8.4 Species that are BOTH on watchlist AND stewardship priority
SELECT DISTINCT
    Common_Name,
    Scientific_Name,
    Habitat
FROM bird_observations
WHERE PIF_Watchlist_Status = 'True'
  AND Regional_Stewardship_Status = 'True'
ORDER BY Common_Name;

