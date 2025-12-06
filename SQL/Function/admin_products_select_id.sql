-- FUNCTION: public.admin_products_select_id(character varying)

-- DROP FUNCTION IF EXISTS public.admin_products_select_id(character varying);

CREATE OR REPLACE FUNCTION public.admin_products_select_id(
	in_id character varying)
    RETURNS TABLE(title character varying, slug character varying, description text, category character varying, sub_category character varying, price numeric, discount_price numeric, is_free boolean, quantity numeric, thumbnail_url text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        p.title,
        p.slug,
        p.description,
        p.category,
        p.sub_category,
        p.price,
        p.discount_price,
        p.is_free,
        p.quantity,
        p.thumbnail_url
    FROM products p
    WHERE p.id = in_id;
END;
$BODY$;

ALTER FUNCTION public.admin_products_select_id(character varying)
    OWNER TO postgres;
