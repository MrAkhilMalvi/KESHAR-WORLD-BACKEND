-- FUNCTION: public.admin_courses_select_video(character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_select_video(character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_select_video(
	in_id character varying)
    RETURNS TABLE(id character varying, module_id character varying, video_title character varying, video_url text, duration integer, description text, positions integer, thumbnail_url character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
    v.id ,
    v.module_id ,
    v.video_title ,
    v.video_url ,
	v.duration ,
	v.description  ,
	v.position as positions ,
	v.thumbnail_url 
    FROM videos v
    WHERE v.id = in_id; -- <— FIXED
END;
$BODY$;

ALTER FUNCTION public.admin_courses_select_video(character varying)
    OWNER TO postgres;
