-- SEQUENCE: public.seq_orders

-- DROP SEQUENCE IF EXISTS public.seq_orders;

CREATE SEQUENCE IF NOT EXISTS public.seq_orders
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.seq_orders
    OWNER TO postgres;