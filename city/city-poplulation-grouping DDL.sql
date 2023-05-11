Drop table city_population_grouping if exists;

CREATE TABLE city_population_grouping AS 
  SELECT city_master.geo_id, city_master.state_name, city_master.city_name, 
  city_master.total_population,
  		CASE
            WHEN city_master.total_population >= 0 and city_master.total_population <= 49999 THEN '0 to 49,999'
			WHEN city_master.total_population >= 50000 and city_master.total_population <= 99999 THEN '50,000-99,999'
			WHEN city_master.total_population >= 100000 and city_master.total_population <= 249999 THEN '100,000-249,999'
			WHEN city_master.total_population >= 250000 and city_master.total_population <= 999999 THEN '250,000-999,999'
            ELSE '1,000,000+'
   		END AS population_group
  FROM city_master
  WHERE publication_year=2021