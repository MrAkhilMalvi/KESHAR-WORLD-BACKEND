-- SEQUENCE: public.seq_videos

-- DROP SEQUENCE IF EXISTS public.seq_videos;

CREATE SEQUENCE IF NOT EXISTS public.seq_videos
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.seq_videos
    OWNER TO postgres;