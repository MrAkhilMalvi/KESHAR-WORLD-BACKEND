-- Table: public.user_courses

-- DROP TABLE IF EXISTS public.user_courses;

CREATE TABLE IF NOT EXISTS public.user_courses
(
    id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    user_id character varying(20) COLLATE pg_catalog."default",
    course_id character varying(20) COLLATE pg_catalog."default",
    access_start timestamp without time zone,
    access_end timestamp without time zone,
    CONSTRAINT user_courses_pkey PRIMARY KEY (id),
    CONSTRAINT user_courses_user_id_course_id_key UNIQUE (user_id, course_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.user_courses
    OWNER to postgres;