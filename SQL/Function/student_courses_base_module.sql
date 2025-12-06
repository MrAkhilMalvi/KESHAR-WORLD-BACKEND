-- FUNCTION: public.student_courses_base_module(character varying, character varying)

-- DROP FUNCTION IF EXISTS public.student_courses_base_module(character varying, character varying);

CREATE OR REPLACE FUNCTION public.student_courses_base_module(
	in_user_id character varying,
	in_course_id character varying)
    RETURNS TABLE(module_id character varying, course_id character varying, module_title character varying, "position" integer, is_access_active boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE 
    v_access_end timestamp;
BEGIN
    -- Check if user purchased the course
    SELECT access_end
    INTO v_access_end
    FROM user_courses uc
    WHERE TRIM(LOWER(uc.user_id)) = TRIM(LOWER(in_user_id))
      AND TRIM(LOWER(uc.course_id)) = TRIM(LOWER(in_course_id))
    ORDER BY uc.access_end DESC
    LIMIT 1;

    -- If active purchase found
    IF v_access_end IS NOT NULL AND v_access_end > NOW() THEN
    BEGIN
        RETURN QUERY
        SELECT 
            m.id AS module_id,
            m.course_id,
            m.module_title,
            m.position,
            TRUE AS is_access_active
        FROM course_modules m
        WHERE TRIM(LOWER(m.course_id)) = TRIM(LOWER(in_course_id))
        ORDER BY m.position;

        RETURN;
    END;
    END IF;

    -- Not purchased OR expired → return modules with FALSE access
    RETURN QUERY
    SELECT 
        m.id AS module_id,
        m.course_id,
        m.module_title,
        m.position,
        FALSE AS is_access_active
    FROM course_modules m
    WHERE TRIM(LOWER(m.course_id)) = TRIM(LOWER(in_course_id))
    ORDER BY m.position;

END;
$BODY$;

ALTER FUNCTION public.student_courses_base_module(character varying, character varying)
    OWNER TO postgres;
