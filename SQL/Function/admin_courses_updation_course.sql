-- FUNCTION: public.admin_courses_updation_course(character varying, character varying, numeric, character varying, boolean, character varying, numeric, character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_updation_course(character varying, character varying, numeric, character varying, boolean, character varying, numeric, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_updation_course(
	in_id character varying,
	in_title character varying,
	in_price numeric,
	in_description character varying,
	in_is_free boolean,
	in_instructor character varying,
	in_original_price numeric,
	in_badge character varying,
	in_category character varying,
	in_thumbnail_url character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
   updated_rows integer;
BEGIN
    UPDATE courses
    SET 
        title = in_title,
        price = in_price,
        description = in_description,
        is_free = in_is_free,
        instructor = in_instructor,
        original_price = in_original_price,
        badge = in_badge,
        category = in_category,
        thumbnail_url = in_thumbnail_url,
        updated_at = NOW()
    WHERE id = in_id
    RETURNING 1 INTO updated_rows;

    IF updated_rows = 1 THEN
        RETURN TRUE;  -- updated successfully
    ELSE
        RETURN FALSE; -- course not found
    END IF;
END;
$BODY$;

ALTER FUNCTION public.admin_courses_updation_course(character varying, character varying, numeric, character varying, boolean, character varying, numeric, character varying, character varying, character varying)
    OWNER TO postgres;
