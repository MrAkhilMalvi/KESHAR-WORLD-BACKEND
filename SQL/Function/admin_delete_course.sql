-- FUNCTION: public.admin_delete_course(character varying)

-- DROP FUNCTION IF EXISTS public.admin_delete_course(character varying);

CREATE OR REPLACE FUNCTION public.admin_delete_course(
	in_course_id character varying)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE 
    v_module record;
BEGIN
    -- delete all videos inside each module
    FOR v_module IN SELECT id FROM course_modules WHERE course_id = in_course_id LOOP
        DELETE FROM videos WHERE module_id = v_module.id;
    END LOOP;

    -- delete all modules
    DELETE FROM course_modules WHERE course_id = in_course_id;

    -- delete the course
    DELETE FROM courses WHERE id = in_course_id;

    RETURN json_build_object('success', true, 'message', 'Course Deleted');
END;
$BODY$;

ALTER FUNCTION public.admin_delete_course(character varying)
    OWNER TO postgres;
