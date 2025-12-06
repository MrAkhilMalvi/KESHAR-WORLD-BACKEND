-- FUNCTION: public.admin_courses_update_module(text, text, integer)

-- DROP FUNCTION IF EXISTS public.admin_courses_update_module(text, text, integer);

CREATE OR REPLACE FUNCTION public.admin_courses_update_module(
	in_id text,
	in_module_title text,
	in_position integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
   updated_rows integer;
BEGIN
    UPDATE course_modules
    SET 
        module_title = in_module_title,
        position      = in_position,
        updated_at    = NOW()
    WHERE id = in_id;

    -- IMPORTANT: Get how many rows were updated
    GET DIAGNOSTICS updated_rows = ROW_COUNT;

    IF updated_rows = 1 THEN
        RETURN TRUE;  -- updated successfully
    ELSE
        RETURN FALSE; -- module not found / not updated
    END IF;
END;
$BODY$;

ALTER FUNCTION public.admin_courses_update_module(text, text, integer)
    OWNER TO postgres;
