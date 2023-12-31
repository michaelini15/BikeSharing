SELECT *
FROM london_merged;


  --DATA CLEANING--

--Rename columns t1 and t2 to temp_C and temp_C_feels_like

ALTER TABLE london_merged
RENAME COLUMN t1 TO temp_C;

ALTER TABLE london_merged
RENAME COLUMN t2 TO temp_C_feels_like;

--Create two new columns to convert temp_C and temp_C_feels_like to fahrenheit

ALTER TABLE london_merged
ADD COLUMN temp_F INT64;

ALTER TABLE london_merged
ADD COLUMN temp_F_feels_like INT64;

--Fill new temp_F and temp_F_feels_like columns with celcius values converted to fahrenheit

UPDATE london_merged
SET temp_F = ((temp_C * 1.8)+32);

UPDATE london_merged
SET temp_F_feels_like = ((temp_C_feels_like * 1.8)+32);

-------------------------------------------------------------------------------------------------------------

  --EXPLORATORY DATA ANALYSIS--

--Establish how many days are covered

SELECT 
  (COUNT(timestamp)/24) AS Days_Covered
FROM london_merged;

--Check for missing values in key fields

SELECT 
  COUNT(*) AS MissingValues
FROM london_merged
WHERE timestamp_2 IS NULL OR temp_F IS NULL OR temp_F_feels_like IS NULL;

--Check for which timestamp hour slots have the most total rides

SELECT 
  timestamp_2 AS Time,
  Sum(cnt) AS Num_of_Rides
FROM london_merged
GROUP BY Time
ORDER BY Num_of_Rides DESC;

--Get an overview of temperature in fahrenheit

SELECT
  max(temp_F) AS Max_Temp,
  min(temp_F) AS Min_Temp,
  Avg(temp_F) AS Avg_Temp
FROM london_merged;

--Get an overview of wind speed

SELECT
  max(wind_speed) AS Max_Wind,
  min(wind_speed) AS Min_Wind,
  Avg(wind_speed) AS Avg_Wind
FROM london_merged;

-------------------------------------------------------------------------------------------------------------

  --DATA ANALYSIS--

--Check which temperature categories have the most average rides

SELECT
  CASE 
    WHEN temp_F <50 THEN 'Cold'
    WHEN temp_F BETWEEN 50 AND 65 THEN 'Cool'
    WHEN temp_F BETWEEN 65 AND 80 THEN 'Moderate'
    ELSE 'Hot'
  END AS Temp_F_Scale,
  Avg(cnt) AS Average_Rides
FROM london_merged
GROUP BY Temp_F_Scale;

--Check which temperature categories have the most total rides

SELECT
  CASE 
    WHEN temp_F <50 THEN 'Cold'
    WHEN temp_F BETWEEN 50 AND 65 THEN 'Cool'
    WHEN temp_F BETWEEN 65 AND 80 THEN 'Moderate'
    ELSE 'Hot'
  END AS Temp_F_Scale,
  Sum(cnt) AS Total_Rides
FROM london_merged
GROUP BY Temp_F_Scale;

--Check how often each temperature category occurs

SELECT
  CASE 
    WHEN temp_F <50 THEN 'Cold'
    WHEN temp_F BETWEEN 50 AND 65 THEN 'Cool'
    WHEN temp_F BETWEEN 65 AND 80 THEN 'Moderate'
    ELSE 'Hot'
  END AS Temp_F_Scale,
  COUNT(temp_F) AS Total_Accurances
FROM london_merged
GROUP BY Temp_F_Scale;

--Check which wind speed categories have the most total rides

SELECT
  CASE 
    WHEN wind_speed <15 THEN 'Gentle'
    WHEN wind_speed BETWEEN 15 AND 30 THEN 'Moderate'
    ELSE 'Strong'
  END AS Wind_Speed_Scale,
  Sum(cnt) AS Total_Rides
FROM london_merged
GROUP BY Wind_Speed_Scale;

--Check which wind speed categories have the most average rides

SELECT
  CASE 
    WHEN wind_speed <15 THEN 'Gentle'
    WHEN wind_speed BETWEEN 15 AND 30 THEN 'Moderate'
    ELSE 'Strong'
  END AS Wind_Speed_Scale,
  Avg(cnt) AS Average_Rides
FROM london_merged
GROUP BY Wind_Speed_Scale;

--Check how often each wind speed category occurs

SELECT
  CASE 
    WHEN wind_speed <15 THEN 'Gentle'
    WHEN wind_speed BETWEEN 15 AND 30 THEN 'Moderate'
    ELSE 'Strong'
  END AS Wind_Speed_Scale,
  COUNT(wind_speed) AS Total_Accurances
FROM london_merged
GROUP BY Wind_Speed_Scale;