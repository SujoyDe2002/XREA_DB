CREATE TABLE IF NOT EXISTS public.race_ethnicity
(
    geo_id character varying(50) COLLATE pg_catalog."default" NOT NULL,
    publication_year numeric NOT NULL,
    white_alone numeric,
    black_or_aa_alone numeric,
    american_indian_alaskan_alone numeric,
    asian_alone numeric,
    hawaiian_pacific_islander_alone numeric,
    hispanic_latino numeric,
    "timestamp" timestamp without time zone NOT NULL,
    CONSTRAINT race_ethnicity_pkey PRIMARY KEY (geo_id, publication_year)
)