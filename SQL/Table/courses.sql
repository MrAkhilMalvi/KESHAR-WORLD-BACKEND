-- Table: public.courses

-- DROP TABLE IF EXISTS public.courses;

CREATE TABLE IF NOT EXISTS public.courses
(
    id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    title character varying(255) COLLATE pg_catalog."default",
    price numeric(10,2),
    description text COLLATE pg_catalog."default",
    is_free boolean,
    instructor character varying COLLATE pg_catalog."default",
    original_price numeric(10,2),
    badge character varying COLLATE pg_catalog."default",
    category character varying COLLATE pg_catalog."default",
    thumbnail_url character varying COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    course_time integer DEFAULT 12,
    CONSTRAINT courses_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.courses
    OWNER to postgres;