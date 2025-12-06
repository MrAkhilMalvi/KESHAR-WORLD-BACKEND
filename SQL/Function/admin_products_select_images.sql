-- FUNCTION: public.admin_products_select_images(character varying)

-- DROP FUNCTION IF EXISTS public.admin_products_select_images(character varying);

CREATE OR REPLACE FUNCTION public.admin_products_select_images(
	in_id character varying)
    RETURNS TABLE(id character varying, product_id character varying, image_url text, positions integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.product_id,
        p.image_url,
        p.positions
    FROM product_images p
    WHERE p.id = in_id; -- <— FIXED
END;
$BODY$;

ALTER FUNCTION public.admin_products_select_images(character varying)
    OWNER TO postgres;
