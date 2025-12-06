-- SEQUENCE: public.seq_product_images

-- DROP SEQUENCE IF EXISTS public.seq_product_images;

CREATE SEQUENCE IF NOT EXISTS public.seq_product_images
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.seq_product_images
    OWNER TO postgres;