-- FUNCTION: public.admin_delete_video(character varying)

-- DROP FUNCTION IF EXISTS public.admin_delete_video(character varying);

CREATE OR REPLACE FUNCTION public.admin_delete_video(
	in_video_id character varying)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    DELETE FROM videos WHERE id = in_video_id;

    RETURN json_build_object('success', true, 'message', 'Video Deleted');
END;
$BODY$;

ALTER FUNCTION public.admin_delete_video(character varying)
    OWNER TO postgres;
