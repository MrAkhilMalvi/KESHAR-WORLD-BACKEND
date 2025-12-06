-- Table: public.orders

-- DROP TABLE IF EXISTS public.orders;

CREATE TABLE IF NOT EXISTS public.orders
(
    id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    user_id character varying(20) COLLATE pg_catalog."default",
    course_id character varying(20) COLLATE pg_catalog."default",
    amount numeric(10,2),
    status character varying(20) COLLATE pg_catalog."default",
    created_at timestamp without time zone DEFAULT now(),
    payment_id character varying COLLATE pg_catalog."default",
    CONSTRAINT orders_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.orders
    OWNER to postgres;