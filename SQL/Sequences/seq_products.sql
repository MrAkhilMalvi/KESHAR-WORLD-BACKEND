-- SEQUENCE: public.seq_products

-- DROP SEQUENCE IF EXISTS public.seq_products;

CREATE SEQUENCE IF NOT EXISTS public.seq_products
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.seq_products
    OWNER TO postgres;