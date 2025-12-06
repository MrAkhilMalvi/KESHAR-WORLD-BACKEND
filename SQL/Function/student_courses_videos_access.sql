-- FUNCTION: public.student_courses_videos_access(character varying, character varying)

-- DROP FUNCTION IF EXISTS public.student_courses_videos_access(character varying, character varying);

CREATE OR REPLACE FUNCTION public.student_courses_videos_access(
	in_user_id character varying,
	in_video_id character varying)
    RETURNS TABLE(video_id character varying, module_id character varying, course_id_out character varying, video_title character varying, video_url character varying, duration integer, description text, "position" integer, thumbnail_url character varying, is_access_active boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    v_module_id varchar;
    v_course_id varchar;
    v_access_end timestamp;
BEGIN
    ---------------------------------------------------------------------
    -- 1️⃣ GET MODULE + COURSE FROM VIDEO ID
    ---------------------------------------------------------------------
    SELECT v.module_id, m.course_id
    INTO v_module_id, v_course_id
    FROM videos v
    JOIN course_modules m ON m.id = v.module_id
    WHERE v.id = in_video_id
    LIMIT 1;

    IF v_module_id IS NULL THEN
        -- ❌ Invalid video
        RETURN;
    END IF;

    ---------------------------------------------------------------------
    -- 2️⃣ CHECK USER HAS PURCHASED THIS COURSE
    ---------------------------------------------------------------------
    SELECT access_end
    INTO v_access_end
    FROM user_courses uc
    WHERE uc.user_id = in_user_id
      AND uc.course_id = v_course_id
    ORDER BY uc.access_end DESC
    LIMIT 1;

    IF v_access_end IS NULL OR v_access_end < NOW() THEN
        -- ❌ No active access
        RETURN;
    END IF;

    ---------------------------------------------------------------------
    -- 3️⃣ ACCESS IS ACTIVE → RETURN VIDEO DETAILS
    ---------------------------------------------------------------------
    RETURN QUERY
    SELECT 
        v.id AS video_id,
        v.module_id,
        v_course_id,       -- ⬅ This maps into course_id_out
        v.video_title,
        v.video_url::varchar,
        v.duration,
        v.description,
        v.position,
		v.thumbnail_url,
        TRUE AS is_access_active
    FROM videos v
    WHERE v.id = in_video_id;

END;
$BODY$;

ALTER FUNCTION public.student_courses_videos_access(character varying, character varying)
    OWNER TO postgres;
