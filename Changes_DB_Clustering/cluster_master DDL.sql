-- DROP TABLE IF EXISTS public.cluster_master;

CREATE TABLE IF NOT EXISTS public.cluster_master
(
    cluster_id integer NOT NULL,
    cluster_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    cluster_desc character varying(1000) COLLATE pg_catalog."default",
    cluster_icon bytea,
    cluster_centroid_bv numeric,
    cluster_centroid_cwyk numeric,
    cluster_centroid_retiree numeric,
    cluster_centroid_yp numeric,
    cluster_centroid_or_residential numeric,
    cluster_centroid_ma numeric,
    cluster_centroid_luxury numeric,
    "timestamp" time without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT cluster_master_pkey PRIMARY KEY (cluster_id)
)