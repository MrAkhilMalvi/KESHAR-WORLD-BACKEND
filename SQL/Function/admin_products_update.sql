-- FUNCTION: public.admin_products_update(character varying, character varying, character varying, text, character varying, character varying, numeric, numeric, boolean, text, character varying)

-- DROP FUNCTION IF EXISTS public.admin_products_update(character varying, character varying, character varying, text, character varying, character varying, numeric, numeric, boolean, text, character varying);

CREATE OR REPLACE FUNCTION public.admin_products_update(
	in_id character varying,
	in_title character varying,
	in_slug character varying,
	in_description text,
	in_category character varying,
	in_sub_category character varying,
	in_price numeric,
	in_discount_price numeric,
	in_is_free boolean,
	in_thumbnail_url text,
	in_language character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    UPDATE products
    SET 
        title = in_title,
        slug = in_slug,
        description = in_description,
        category = in_category,
        sub_category = in_sub_category,
        price = in_price,
        discount_price = in_discount_price,
        is_free = in_is_free,
        thumbnail_url = in_thumbnail_url,
        language = in_language
    WHERE id = in_id;

    IF NOT FOUND THEN
        RETURN FALSE; -- No row updated
    END IF;

    RETURN TRUE; -- Successfully updated
END;
$BODY$;

ALTER FUNCTION public.admin_products_update(character varying, character varying, character varying, text, character varying, character varying, numeric, numeric, boolean, text, character varying)
    OWNER TO postgres;
