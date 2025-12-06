-- Table: public.products

-- DROP TABLE IF EXISTS public.products;

CREATE TABLE IF NOT EXISTS public.products
(
    id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    title character varying COLLATE pg_catalog."default",
    slug character varying COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    category character varying COLLATE pg_catalog."default",
    sub_category character varying COLLATE pg_catalog."default",
    price numeric(10,2),
    discount_price numeric(10,2),
    is_free boolean DEFAULT false,
    quantity numeric DEFAULT 1.00,
    thumbnail_url text COLLATE pg_catalog."default",
    language character varying COLLATE pg_catalog."default",
    create_at timestamp without time zone,
    update_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'Asia/Kolkata'::text),
    gst_percent numeric DEFAULT 18,
    CONSTRAINT products_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.products
    OWNER to postgres;