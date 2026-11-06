-- Viajes en taxi en Chicago (Zuber) - Proyecto de Bootcamp, TripleTen (Sprint 8)
-- Mis soluciones a los ejercicios SQL del proyecto (PostgreSQL), resueltos en la plataforma de TripleTen.
-- Tablas: trips, cabs, neighborhoods, weather_records

-- 1. Número de viajes por empresa de taxis el 15 y 16 de noviembre de 2017,
--    de mayor a menor. Resultado exportado como data/project_sql_result_01.csv
SELECT
    cabs.company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM cabs
INNER JOIN trips ON trips.cab_id = cabs.cab_id
WHERE CAST(trips.start_ts AS date) BETWEEN '2017-11-15' AND '2017-11-16'
GROUP BY cabs.company_name
ORDER BY trips_amount DESC;

-- 2. Viajes del 1 al 7 de noviembre de 2017 de las empresas cuyo nombre
--    incluye "Yellow" o "Blue".
SELECT
    cabs.company_name AS company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM cabs
INNER JOIN trips ON trips.cab_id = cabs.cab_id
WHERE CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07'
    AND (cabs.company_name LIKE '%Yellow%' OR cabs.company_name LIKE '%Blue%')
GROUP BY cabs.company_name;

-- 3. Viajes del 1 al 7 de noviembre de 2017 de las dos empresas líderes
--    (Flash Cab y Taxi Affiliation Services), con el resto agrupado como "Other".
SELECT
    CASE
        WHEN cabs.company_name = 'Flash Cab' THEN 'Flash Cab'
        WHEN cabs.company_name = 'Taxi Affiliation Services' THEN 'Taxi Affiliation Services'
        ELSE 'Other'
    END AS company,
    COUNT(trips.trip_id) AS trips_amount
FROM cabs
INNER JOIN trips ON trips.cab_id = cabs.cab_id
WHERE CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07'
GROUP BY company
ORDER BY trips_amount DESC;

-- 4. Identificadores de los barrios Loop y O'Hare.
SELECT
    neighborhood_id,
    name
FROM neighborhoods
WHERE name LIKE '%Hare' OR name = 'Loop';

-- 5. Clasificación de cada hora según el clima: "Bad" si hubo lluvia o tormenta,
--    "Good" en otro caso.
SELECT
    ts,
    CASE
        WHEN description LIKE '%rain%' OR description LIKE '%storm%' THEN 'Bad'
        ELSE 'Good'
    END AS weather_conditions
FROM weather_records;

-- 6. Viajes en sábado del Loop (id 50) a O'Hare (id 63), con el clima a la hora
--    de inicio y la duración. Solo viajes con registro de clima.
--    Resultado exportado como data/project_sql_result_07.csv
SELECT
    trips.start_ts,
    CASE
        WHEN weather_records.description LIKE '%rain%'
          OR weather_records.description LIKE '%storm%' THEN 'Bad'
        ELSE 'Good'
    END AS weather_conditions,
    trips.duration_seconds
FROM trips
INNER JOIN weather_records ON weather_records.ts = trips.start_ts
WHERE trips.pickup_location_id = 50
    AND trips.dropoff_location_id = 63
    AND EXTRACT(DOW FROM trips.start_ts) = 6
ORDER BY trips.trip_id;
