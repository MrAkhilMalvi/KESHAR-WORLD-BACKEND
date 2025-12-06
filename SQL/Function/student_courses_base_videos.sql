-- FUNCTION: public.student_courses_base_videos(character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.student_courses_base_videos(character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.student_courses_base_videos(
	in_user_id character varying,
	in_course_id character varying,
	in_module_id character varying)
    RETURNS TABLE(video_id character varying, module_id character varying, video_title character varying, video_url character varying, duration integer, description text, "position" integer, thumbnail_url character varying, is_access_active boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE 
    v_access_end timestamp;
    v_valid_module boolean := FALSE;
BEGIN
    ---------------------------------------------------------------------
    -- 1️⃣ CHECK IF USER PURCHASED THIS COURSE
    ---------------------------------------------------------------------
    SELECT access_end
    INTO v_access_end
    FROM user_courses
    WHERE user_id = in_user_id
      AND course_id = in_course_id
    ORDER BY access_end DESC
    LIMIT 1;

    IF v_access_end IS NULL OR v_access_end < NOW() THEN
        -- ❌ No access, return nothing
        RETURN;
    END IF;

    ---------------------------------------------------------------------
    -- 2️⃣ CHECK MODULE BELONGS TO THIS PURCHASED COURSE
    ---------------------------------------------------------------------
    SELECT TRUE
    INTO v_valid_module
    FROM course_modules
    WHERE id = in_module_id
      AND course_id = in_course_id
    LIMIT 1;

    IF NOT v_valid_module THEN
        -- ❌ Wrong module – return nothing
        RETURN;
    END IF;

    ---------------------------------------------------------------------
    -- 3️⃣ USER HAS ACCESS + MODULE BELONGS TO COURSE → SHOW VIDEOS
    ---------------------------------------------------------------------
    RETURN QUERY
    SELECT 
        v.id AS video_id,
        v.module_id,
        v.video_title,
        v.video_url::varchar,
        v.duration,
        v.description,
        v.position,
		v.thumbnail_url ,
        TRUE
    FROM videos v
    WHERE v.module_id = in_module_id
    ORDER BY v.position;

END;
$BODY$;

ALTER FUNCTION public.student_courses_base_videos(character varying, character varying, character varying)
    OWNER TO postgres;
