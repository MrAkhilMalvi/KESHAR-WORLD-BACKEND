-- FUNCTION: public.admin_courses_insert_videos(character varying, character varying, character varying, integer, character varying, integer, character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_insert_videos(character varying, character varying, character varying, integer, character varying, integer, character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_insert_videos(
	in_module_id character varying,
	in_title character varying,
	in_url character varying,
	in_duration integer,
	in_description character varying,
	in_position integer,
	in_thumbnail_url character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id text;
BEGIN
   new_id := generate_table_id('VID', 'seq_videos');
   
        INSERT INTO videos(
            id, module_id, video_title, video_url, duration, 
            description, position , thumbnail_url, created_at, updated_at
        )
        VALUES (
            new_id, in_module_id, in_title, in_url, in_duration,
            in_description, in_position, in_thumbnail_url, NOW(), NOW()
        );
		
      RETURN new_id;

END;
$BODY$;

ALTER FUNCTION public.admin_courses_insert_videos(character varying, character varying, character varying, integer, character varying, integer, character varying)
    OWNER TO postgres;
