-- Table: public.course_modules

-- DROP TABLE IF EXISTS public.course_modules;

CREATE TABLE IF NOT EXISTS public.course_modules
(
    id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    course_id character varying(20) COLLATE pg_catalog."default",
    module_title character varying(255) COLLATE pg_catalog."default",
    "position" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT course_modules_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.course_modules
    OWNER to postgres;