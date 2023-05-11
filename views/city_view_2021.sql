drop view if exists city_view_2021;

create view city_view_2021
as
SELECT
  c.state_name,
  c.city_name,
  c.publication_year                                                            AS YEAR,
  c.total_population,
  pg.pop_growth                                                                 AS ten_year_pop_growth_rate,
  (p.total_male_65_and_66   
    + p.total_male_67_to_69     + p.total_male_70_to_74 
    + p.total_male_75_to_79     + p.total_male_80_to_84
    + p.total_male_85_and_over
    + p.total_female_65_and_66  + p.total_female_67_to_69
    + p.total_female_70_to_74   + p.total_female_75_to_79
    + p.total_female_80_to_84   + p.total_female_85_and_over)
        / c.total_population                                                    AS "65_and_over_rate",
  (p.total_male_55_to_59 
    + p.total_male_60_and_61    + p.total_male_62_to_64 
    + p.total_female_55_to_59   + p.total_female_60_and_61
    + p.total_female_62_to_64)
        / c.total_population                                                    AS "55_to_64_rate",
  (p.total_male_45_to_49 + p.total_male_50_to_54
    + p.total_female_45_to_49 + p.total_female_50_to_54)
        / c.total_population                                                    AS "45_to_54_rate",
  (p.total_male_35_to_39 + p.total_male_40_to_44
    + p.total_female_35_to_39 + p.total_female_40_to_44)
        / c.total_population                                                    AS "35_to_44_rate",
  (p.total_male_25_to_29 + p.total_male_30_to_34
    + p.total_female_25_to_29 + p.total_female_30_to_34)
        / c.total_population                                                    AS "25_to_34_rate",
  (p.total_male_18_and_19 + p.total_male_20 
    + p.total_male_21 + p.total_male_22_to_24
    + p.total_female_18_and_19 + p.total_female_20
    + p.total_female_21 + p.total_female_22_to_24)
        / c.total_population                                                    AS "18_to_24_rate",
  (p.total_male_under_5 + p.total_male_5_to_9
    + p.total_male_10_to_14 + p.total_male_15_to_17
    + p.total_female_under_5 + p.total_female_5_to_9
    + p.total_female_10_to_14 + p.total_female_15_to_17)
        / c.total_population                                                    AS under_18_rate,
  (p.total_male_under_5 + p.total_female_under_5)
      / c.total_population                                                      AS under_5_rate,
  mi.median_household_income                                                    AS median_income,
  mh.median_home_value                                                          AS median_home_value,
  r.median_contract_rent     * 12::NUMERIC                                      AS yearly_median_rent,
  hc.monthly_ownership_cost  * 12::NUMERIC                                      AS yearly_median_homeowner_cost,
  mh.median_home_value       / mi.median_household_income                       AS home_p_to_income,
  mi.median_household_income / (r.median_contract_rent * 12::NUMERIC)           AS income_to_rent,
  e.unemployed_civilian_labor_force / e.total_civilian_labor_force              AS unemployment_rate,
  pt.poverty_rate                                                               AS poverty_rate,
  ed.hs_graduation_rate                                                         AS hs_graduation_rate,
  ed.bs_graduation_rate                                                         AS bs_graduation_rate,
  a.public_school                                                               AS public_schools,
  a.public_school                                                               AS private_schools,
  a.public_hs                                                                   AS public_hs,
  a.private_hs                                                                  AS private_hs, 
  at.aggregate_travel_time 
    / (e.employed_civilian_labor_force - tr.worked_from_home)                   AS commute_time,
  a.coli,
  a.crime_rate,
  now()                                                                         AS time_stamp
FROM
  city_master c
LEFT JOIN
  (
    SELECT
      pop_growth.geo_id,
      pop_growth.pop_growth
    FROM
      (
      WITH
        pop_21 AS
        (
          SELECT
            city_master.geo_id,
            city_master.total_population          AS population_2021,
            city_master.publication_year
          FROM
            city_master
          WHERE
            city_master.publication_year = 2021::NUMERIC
        )
        ,
        pop_11 AS
        (
          SELECT
            city_master.geo_id,
            city_master.total_population          AS population_2011,
            city_master.publication_year
          FROM
            city_master
          WHERE
            city_master.publication_year   = 2011::NUMERIC
          AND city_master.total_population > 0::   NUMERIC
        )
      SELECT
        pop_21.geo_id,
        pop_21.population_2021,
        pop_11.population_2011,
        (pop_21.population_2021 - pop_11.population_2011) /
        pop_11.population_2011                      AS pop_growth
      FROM
        pop_21
      JOIN pop_11
      ON
        pop_21.geo_id::text = pop_11.geo_id::text
      )
      pop_growth
  )
  pg
ON
  c.geo_id::text = pg.geo_id::text
LEFT JOIN population_age_sex p
ON
  c.geo_id::text       = p.geo_id::text
AND c.publication_year = p.publication_year
LEFT JOIN median_income mi
ON
  c.geo_id::text       = mi.geo_id::text
AND c.publication_year = mi.publication_year
LEFT JOIN median_home_value mh
ON
  c.geo_id::text       = mh.geo_id::text
AND c.publication_year = mh.publication_year
LEFT JOIN median_rent r
ON
  c.geo_id::text       = r.geo_id::text
AND c.publication_year = r.publication_year
LEFT JOIN home_ownership_cost hc
ON
  c.geo_id::text       = hc.geo_id::text
AND c.publication_year = hc.publication_year
LEFT JOIN employment e
ON
  c.geo_id::text       = e.geo_id::text
AND c.publication_year = e.publication_year
LEFT JOIN poverty pt
ON
  c.geo_id::text       = pt.geo_id::text
AND c.publication_year = pt.publication_year
LEFT JOIN education ed
ON
  c.geo_id::text       = ed.geo_id::text
AND c.publication_year = ed.publication_year
LEFT JOIN aggregate_travel_time at
ON
  c.geo_id::text       = at.geo_id::text
AND c.publication_year = at.publication_year
LEFT JOIN means_of_transportation tr
ON
  c.geo_id::text       = tr.geo_id::text
AND c.publication_year = tr.publication_year
LEFT JOIN additional_features a
ON
  c.geo_id::text       = a.geo_id::text
AND c.publication_year = a.publication_year
WHERE
  c.publication_year = 2021::NUMERIC
AND
  (
    c.total_population IS NULL
  OR c.total_population > 0::NUMERIC
  )
AND
  (
    mi.median_household_income IS NULL
  OR mi.median_household_income > 0::NUMERIC
  )
AND
  (
    mh.median_home_value  IS NULL
  OR mh.median_home_value >= 0::NUMERIC
  )
AND
  (
    r.median_contract_rent IS NULL
  OR r.median_contract_rent > 0::NUMERIC
  )
AND
  (
    hc.monthly_ownership_cost  IS NULL
  OR hc.monthly_ownership_cost >= 0::NUMERIC
  )
AND
  (
    e.unemployed_civilian_labor_force  IS NULL
  OR e.unemployed_civilian_labor_force >= 0::NUMERIC
  )
AND
  (
    e.total_in_labor_force IS NULL
  OR e.total_in_labor_force > 0::NUMERIC
  )
AND
  (
    pt.poverty_rate  IS NULL
  OR pt.poverty_rate >= 0::NUMERIC
  )
AND
  (
    ed.hs_graduation_rate  IS NULL
  OR ed.hs_graduation_rate >= 0::NUMERIC
  )
AND
  (
    ed.bs_graduation_rate  IS NULL
  OR ed.bs_graduation_rate >= 0::NUMERIC
  )
AND
  (
    at.aggregate_travel_time  IS NULL
  OR at.aggregate_travel_time >= 0::NUMERIC
  )
AND
  (
    tr.worked_from_home  IS NULL
  OR tr.worked_from_home >= 0::NUMERIC
  );
  