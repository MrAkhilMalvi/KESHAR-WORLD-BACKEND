-- Table: public.product_images

-- DROP TABLE IF EXISTS public.product_images;

CREATE TABLE IF NOT EXISTS public.product_images
(
    id character varying COLLATE pg_catalog."default" NOT NULL,
    product_id character varying COLLATE pg_catalog."default",
    image_url text COLLATE pg_catalog."default" NOT NULL,
    positions integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'Asia/Kolkata'::text),
    CONSTRAINT product_images_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product_images
    OWNER to postgres;