-- SEQUENCE: public.seq_modules

-- DROP SEQUENCE IF EXISTS public.seq_modules;

CREATE SEQUENCE IF NOT EXISTS public.seq_modules
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.seq_modules
    OWNER TO postgres;