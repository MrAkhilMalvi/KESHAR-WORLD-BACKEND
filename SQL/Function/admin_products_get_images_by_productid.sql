-- FUNCTION: public.admin_products_get_images_by_productid(character varying)

-- DROP FUNCTION IF EXISTS public.admin_products_get_images_by_productid(character varying);

CREATE OR REPLACE FUNCTION public.admin_products_get_images_by_productid(
	in_id character varying)
    RETURNS TABLE(id character varying, product_id character varying, image_url character varying, positions integer) 
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
        p.image_url::varchar,
        p.positions
    FROM product_images p
    WHERE p.product_id = in_id
    ORDER BY p.positions ASC;
END;
$BODY$;

ALTER FUNCTION public.admin_products_get_images_by_productid(character varying)
    OWNER TO postgres;
