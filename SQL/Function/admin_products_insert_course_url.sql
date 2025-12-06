-- FUNCTION: public.admin_products_insert_course_url(character varying, text)

-- DROP FUNCTION IF EXISTS public.admin_products_insert_course_url(character varying, text);

CREATE OR REPLACE FUNCTION public.admin_products_insert_course_url(
	in_id character varying,
	in_thumbnail_url text)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    updated_rows INTEGER;
BEGIN
    UPDATE products
    SET thumbnail_url = in_thumbnail_url
    WHERE id = in_id
    RETURNING 1 INTO updated_rows;

    IF updated_rows = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END;
$BODY$;

ALTER FUNCTION public.admin_products_insert_course_url(character varying, text)
    OWNER TO postgres;
