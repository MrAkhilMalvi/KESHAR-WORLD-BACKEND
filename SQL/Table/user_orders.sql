-- Table: public.user_orders

-- DROP TABLE IF EXISTS public.user_orders;

CREATE TABLE IF NOT EXISTS public.user_orders
(
    order_id character varying COLLATE pg_catalog."default" NOT NULL,
    user_id character varying COLLATE pg_catalog."default" NOT NULL,
    payment_intent character varying COLLATE pg_catalog."default",
    subtotal numeric,
    gst_total numeric,
    total_amount numeric,
    products_json jsonb,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT user_orders_pkey PRIMARY KEY (order_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.user_orders
    OWNER to postgres;