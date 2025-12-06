-- Table: public.user_order_items

-- DROP TABLE IF EXISTS public.user_order_items;

CREATE TABLE IF NOT EXISTS public.user_order_items
(
    id integer NOT NULL DEFAULT nextval('user_order_items_id_seq'::regclass),
    order_id character varying COLLATE pg_catalog."default" NOT NULL,
    product_id character varying COLLATE pg_catalog."default" NOT NULL,
    qty integer NOT NULL,
    price numeric NOT NULL,
    gst_percent numeric NOT NULL,
    gst_amount numeric NOT NULL,
    amount_before_gst numeric NOT NULL,
    amount_with_gst numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT user_order_items_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.user_order_items
    OWNER to postgres;