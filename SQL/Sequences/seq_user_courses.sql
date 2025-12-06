-- SEQUENCE: public.seq_user_courses

-- DROP SEQUENCE IF EXISTS public.seq_user_courses;

CREATE SEQUENCE IF NOT EXISTS public.seq_user_courses
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.seq_user_courses
    OWNER TO postgres;