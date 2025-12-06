-- FUNCTION: public.admin_courses_update_videos(character varying, character varying, text, integer, text, integer, character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_update_videos(character varying, character varying, text, integer, text, integer, character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_update_videos(
	in_id character varying,
	in_title character varying,
	in_url text,
	in_duration integer,
	in_description text,
	in_position integer,
	in_thumbnail_url character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    updated_count INT;
BEGIN
    UPDATE videos
    SET 
        video_title   = in_title,
        video_url     = in_url,
        duration      = in_duration,
        description   = in_description,
        position      = in_position,
		thumbnail_url = in_thumbnail_url,
        updated_at  = NOW()
    WHERE id = in_id;

    GET DIAGNOSTICS updated_count = ROW_COUNT;

    IF updated_count > 0 THEN
        RETURN TRUE;   -- Video updated
    ELSE
        RETURN FALSE;  -- No video found with given ID
    END IF;
END;
$BODY$;

ALTER FUNCTION public.admin_courses_update_videos(character varying, character varying, text, integer, text, integer, character varying)
    OWNER TO postgres;
