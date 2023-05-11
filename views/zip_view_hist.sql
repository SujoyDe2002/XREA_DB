 SELECT zip.zip_code,
    zip.geographic_area_name,
    zip.publication_year AS year,
    zip.total_population,
    (p.total_male_65_and_66 + p.total_male_67_to_69 + p.total_male_70_to_74 + p.total_male_75_to_79 + p.total_male_80_to_84 + p.total_male_85_and_over + p.total_female_65_and_66 + p.total_female_67_to_69 + p.total_female_70_to_74 + p.total_female_75_to_79 + p.total_female_80_to_84 + p.total_female_85_and_over) / zip.total_population AS "65_and_over_rate",
    (p.total_male_55_to_59 + p.total_male_60_and_61 + p.total_male_62_to_64 + p.total_female_55_to_59 + p.total_female_60_and_61 + p.total_female_62_to_64) / zip.total_population AS "55_to_64_rate",
    (p.total_male_45_to_49 + p.total_male_50_to_54 + p.total_female_45_to_49 + p.total_female_50_to_54) / zip.total_population AS "45_to_54_rate",
    (p.total_male_35_to_39 + p.total_male_40_to_44 + p.total_female_35_to_39 + p.total_female_40_to_44) / zip.total_population AS "35_to_44_rate",
    (p.total_male_25_to_29 + p.total_male_30_to_34 + p.total_female_25_to_29 + p.total_female_30_to_34) / zip.total_population AS "25_to_34_rate",
    (p.total_male_18_and_19 + p.total_male_20 + p.total_male_21 + p.total_male_22_to_24 + p.total_female_18_and_19 + p.total_female_20 + p.total_female_21 + p.total_female_22_to_24) / zip.total_population AS "18_to_24_rate",
    (p.total_male_under_5 + p.total_male_5_to_9 + p.total_male_10_to_14 + p.total_male_15_to_17 + p.total_female_under_5 + p.total_female_5_to_9 + p.total_female_10_to_14 + p.total_female_15_to_17) / zip.total_population AS under_18_rate,
    (p.total_male_under_5 + p.total_female_under_5) / zip.total_population AS under_5_rate,
    mi.median_household_income AS median_income,
    mh.median_home_value,
    r.median_contract_rent * 12::numeric AS yearly_median_rent,
    hc.monthly_ownership_cost * 12::numeric AS yearly_median_homeowner_cost,
    mh.median_home_value / mi.median_household_income AS home_p_to_income,
    mi.median_household_income / (r.median_contract_rent * 12::numeric) AS income_to_rent,
    e.unemployed_civilian_labor_force / e.total_civilian_labor_force AS unemployment_rate,
    pt.poverty_rate,
    ed.hs_graduation_rate,
    ed.bs_graduation_rate,
    a.public_school AS public_schools,
    a.public_school AS private_schools,
    a.public_hs,
    a.private_hs,
    at.aggregate_travel_time / (e.employed_civilian_labor_force - tr.worked_from_home) AS commute_time,
    a.coli,
    a.crime_rate,
    now() AS time_stamp
   FROM zip_master zip
     LEFT JOIN zip_population_age_sex p ON zip.geo_id::text = p.geo_id::text AND zip.publication_year = p.publication_year
     LEFT JOIN zip_median_income mi ON zip.geo_id::text = mi.geo_id::text AND zip.publication_year = mi.publication_year
     LEFT JOIN zip_median_home_value mh ON zip.geo_id::text = mh.geo_id::text AND zip.publication_year = mh.publication_year
     LEFT JOIN zip_median_rent r ON zip.geo_id::text = r.geo_id::text AND zip.publication_year = r.publication_year
     LEFT JOIN zip_home_ownership_cost hc ON zip.geo_id::text = hc.geo_id::text AND zip.publication_year = hc.publication_year
     LEFT JOIN zip_employment e ON zip.geo_id::text = e.geo_id::text AND zip.publication_year = e.publication_year
     LEFT JOIN zip_poverty pt ON zip.geo_id::text = pt.geo_id::text AND zip.publication_year = pt.publication_year
     LEFT JOIN zip_education ed ON zip.geo_id::text = ed.geo_id::text AND zip.publication_year = ed.publication_year
     LEFT JOIN zip_aggregate_travel_time at ON zip.geo_id::text = at.geo_id::text AND zip.publication_year = at.publication_year
     LEFT JOIN means_of_transportation tr ON zip.geo_id::text = tr.geo_id::text AND zip.publication_year = tr.publication_year
     LEFT JOIN additional_features a ON zip.geo_id::text = a.geo_id::text AND zip.publication_year = a.publication_year
  WHERE (zip.total_population IS NULL OR zip.total_population > 0::numeric) AND (mi.median_household_income IS NULL OR mi.median_household_income > 0::numeric) AND (mh.median_home_value IS NULL OR mh.median_home_value >= 0::numeric) AND (r.median_contract_rent IS NULL OR r.median_contract_rent > 0::numeric) AND (hc.monthly_ownership_cost IS NULL OR hc.monthly_ownership_cost >= 0::numeric) AND (e.unemployed_civilian_labor_force IS NULL OR e.unemployed_civilian_labor_force >= 0::numeric) AND (e.total_in_labor_force IS NULL OR e.total_in_labor_force > 0::numeric) AND (pt.poverty_rate IS NULL OR pt.poverty_rate >= 0::numeric) AND (ed.hs_graduation_rate IS NULL OR ed.hs_graduation_rate >= 0::numeric) AND (ed.bs_graduation_rate IS NULL OR ed.bs_graduation_rate >= 0::numeric) AND (at.aggregate_travel_time IS NULL OR at.aggregate_travel_time >= 0::numeric) AND (tr.worked_from_home IS NULL OR tr.worked_from_home >= 0::numeric);