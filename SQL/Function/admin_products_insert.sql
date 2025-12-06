-- FUNCTION: public.admin_products_insert(character varying, character varying, text, character varying, character varying, numeric, numeric, boolean, numeric, character varying)

-- DROP FUNCTION IF EXISTS public.admin_products_insert(character varying, character varying, text, character varying, character varying, numeric, numeric, boolean, numeric, character varying);

CREATE OR REPLACE FUNCTION public.admin_products_insert(
	in_title character varying,
	in_slug character varying,
	in_description text,
	in_category character varying,
	in_sub_category character varying,
	in_price numeric,
	in_discount_price numeric,
	in_is_free boolean,
	in_qty numeric,
	in_language character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    new_id character varying;
BEGIN
    new_id := generate_table_id('PRO','seq_products');

    INSERT INTO products (
        id, title, slug, description, category, sub_category,
        price, discount_price, is_free,quantity,
         language ,create_at
    )
    VALUES (
        new_id, in_title, in_slug, in_description, in_category, in_sub_category,
        in_price, in_discount_price, in_is_free,in_qty,
         in_language ,(NOW() AT TIME ZONE 'Asia/Kolkata')
    );

    RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.admin_products_insert(character varying, character varying, text, character varying, character varying, numeric, numeric, boolean, numeric, character varying)
    OWNER TO postgres;
