-- FUNCTION: public.admin_courses_get_modules_by_course(character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_get_modules_by_course(character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_get_modules_by_course(
	in_course_id character varying)
    RETURNS TABLE(module_id character varying, title character varying, module_position integer, create_at timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT
        id,
        module_title as title,
        position AS module_position,
        created_at AS create_at
    FROM course_modules
    WHERE course_id = in_course_id
    ORDER BY position;
END;
$BODY$;

ALTER FUNCTION public.admin_courses_get_modules_by_course(character varying)
    OWNER TO postgres;
