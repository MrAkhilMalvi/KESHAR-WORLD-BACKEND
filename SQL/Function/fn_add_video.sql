-- FUNCTION: public.fn_add_video(text, text, text, integer)

-- DROP FUNCTION IF EXISTS public.fn_add_video(text, text, text, integer);

CREATE OR REPLACE FUNCTION public.fn_add_video(
	_module_id text,
	_video_title text,
	_video_url text,
	_duration integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id TEXT;
BEGIN
  new_id := generate_table_id('VID', 'seq_videos');

  INSERT INTO videos(id,module_id,video_title,video_url,duration)
  VALUES(new_id,_module_id,_video_title,_video_url,_duration);

  RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.fn_add_video(text, text, text, integer)
    OWNER TO postgres;
