-- FUNCTION: public.admin_products_get_all(integer, integer)

-- DROP FUNCTION IF EXISTS public.admin_products_get_all(integer, integer);

CREATE OR REPLACE FUNCTION public.admin_products_get_all(
	in_limit integer DEFAULT 20,
	in_offset integer DEFAULT 0)
    RETURNS TABLE(id character varying, title character varying, slug character varying, description text, category character varying, sub_category character varying, price numeric, discount_price numeric, is_free boolean, quantity numeric, thumbnail_url text, language character varying, create_at timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.title,
        p.slug,
        p.description,
        p.category,
        p.sub_category,
        p.price,
        p.discount_price,
        p.is_free,
        p.quantity,
        p.thumbnail_url,
        p.language,
        p.create_at
    FROM products p
    ORDER BY p.create_at DESC
    LIMIT in_limit
    OFFSET in_offset;
END;
$BODY$;

ALTER FUNCTION public.admin_products_get_all(integer, integer)
    OWNER TO postgres;
