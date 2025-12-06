-- Table: public.users

-- DROP TABLE IF EXISTS public.users;

CREATE TABLE IF NOT EXISTS public.users
(
    id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    fullname character varying(255) COLLATE pg_catalog."default" NOT NULL,
    email character varying(255) COLLATE pg_catalog."default",
    mobile character varying(30) COLLATE pg_catalog."default",
    password character varying(255) COLLATE pg_catalog."default",
    image_url character varying(255) COLLATE pg_catalog."default",
    created_at timestamp with time zone DEFAULT timezone('Asia/Kolkata'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('Asia/Kolkata'::text, now()),
    google_id character varying(255) COLLATE pg_catalog."default",
    provider character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email),
    CONSTRAINT users_mobile_key UNIQUE (mobile)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;