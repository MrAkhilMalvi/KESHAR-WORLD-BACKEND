-- FUNCTION: public.admin_products_delete(character varying)

-- DROP FUNCTION IF EXISTS public.admin_products_delete(character varying);

CREATE OR REPLACE FUNCTION public.admin_products_delete(
	in_id character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    DELETE FROM products
    WHERE id = in_id;

    IF NOT FOUND THEN
        RETURN FALSE; -- No row deleted
    END IF;

    RETURN TRUE; -- Successfully deleted
END;
$BODY$;

ALTER FUNCTION public.admin_products_delete(character varying)
    OWNER TO postgres;
