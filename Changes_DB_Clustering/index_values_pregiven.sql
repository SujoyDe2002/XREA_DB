-- DROP TABLE IF EXISTS public.index_values_pregiven;

CREATE TABLE IF NOT EXISTS public.index_values_pregiven
(
    geographic_area_name character varying(100) COLLATE pg_catalog."default",
    best_value_index numeric,
    cwyk_index numeric,
    retiree_index numeric,
    yp_index numeric,
    "timestamp" time without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cluster_id integer,
    geo_id character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT index_values_pregiven_cluster_id_fkey FOREIGN KEY (cluster_id)
        REFERENCES public.cluster_master (cluster_id)
)