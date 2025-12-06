-- FUNCTION: public.admin_courses_insert_course_url(character varying, character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_insert_course_url(character varying, character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_insert_course_url(
	in_id character varying,
	in_thumbnail_url character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    updated_rows INTEGER;
BEGIN
    UPDATE courses
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

ALTER FUNCTION public.admin_courses_insert_course_url(character varying, character varying)
    OWNER TO postgres;
