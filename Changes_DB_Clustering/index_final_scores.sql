-- DROP TABLE IF EXISTS index_final_scores;
-- CREATE TABLE index_final_scores
-- (
--   geo_id            varchar(50) NOT NULL,
--   publication_year  numeric NOT NULL,
--   city_name	        varchar(50) NOT NULL,
--   OR_O	            numeric,
--   OR_BV	            numeric,
--   OR_MA	            numeric,
--   OR_CWYK	          numeric,
--   OR_YP	            numeric,
--   OR_R	            numeric,
--   OR_L	            numeric,
--   SFR_O	            numeric,
--   SFR_BV	          numeric,
--   SFR_MA	          numeric,
--   SFR_CWYK	        numeric,
--   SFR_YP	          numeric,
--   SFR_R	            numeric,
--   SFR_L	            numeric,
--   MFR_O	            numeric,
--   MFR_BV    	      numeric,
--   MFR_MA      	    numeric,
--   MFR_CWYK    	    numeric,
--   MFR_YP        	  numeric,
--   MFR_R	            numeric,
--   PRIMARY KEY (geo_id, publication_year)
-- );


-- DROP TABLE IF EXISTS public.index_final_scores;

CREATE TABLE IF NOT EXISTS public.index_final_scores
(
    geo_id character varying(50) COLLATE pg_catalog."default",
    publication_year numeric,
    city_name character varying(100) COLLATE pg_catalog."default",
    or_o numeric,
    or_bv numeric,
    or_ma numeric,
    or_cwyk numeric,
    or_yp numeric,
    or_r numeric,
    or_l numeric,
    sfr_o numeric,
    sfr_bv numeric,
    sfr_ma numeric,
    sfr_cwyk numeric,
    sfr_yp numeric,
    sfr_r numeric,
    sfr_l numeric,
    mfr_o numeric,
    mfr_bv numeric,
    mfr_ma numeric,
    mfr_cwyk numeric,
    mfr_yp numeric,
    mfr_r numeric,
    cluster_id integer,
    CONSTRAINT index_final_scores_cluster_id_fkey FOREIGN KEY (cluster_id)
        REFERENCES public.cluster_master (cluster_id)
)






