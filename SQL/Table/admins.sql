-- Table: public.admins

-- DROP TABLE IF EXISTS public.admins;

CREATE TABLE IF NOT EXISTS public.admins
(
    id integer NOT NULL DEFAULT nextval('admins_id_seq'::regclass),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    email character varying COLLATE pg_catalog."default" NOT NULL,
    mobile character varying COLLATE pg_catalog."default" NOT NULL,
    password character varying COLLATE pg_catalog."default",
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT admins_pkey PRIMARY KEY (id),
    CONSTRAINT admins_email_key UNIQUE (name),
    CONSTRAINT admins_mobile_key UNIQUE (email)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.admins
    OWNER to postgres;