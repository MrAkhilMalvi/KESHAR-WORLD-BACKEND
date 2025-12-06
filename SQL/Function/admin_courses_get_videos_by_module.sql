-- FUNCTION: public.admin_courses_get_videos_by_module(character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_get_videos_by_module(character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_get_videos_by_module(
	in_module_id character varying)
    RETURNS TABLE(video_id character varying, title character varying, url text, video_duration integer, video_description text, videos_position integer, thumbnail character varying, create_at timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT
        id AS video_id,
        video_title AS title,
        video_url AS url,
        duration AS video_duration,
        description AS video_description,   -- FIXED
        position AS videos_position,
		thumbnail_url as thumbnail,
        created_at AS create_at
    FROM videos
    WHERE module_id = in_module_id
    ORDER BY position;
END;
$BODY$;

ALTER FUNCTION public.admin_courses_get_videos_by_module(character varying)
    OWNER TO postgres;
