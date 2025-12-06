-- FUNCTION: public.fn_activate_user_course(text, text, integer)

-- DROP FUNCTION IF EXISTS public.fn_activate_user_course(text, text, integer);

CREATE OR REPLACE FUNCTION public.fn_activate_user_course(
	_user_id text,
	_course_id text,
	_days integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id TEXT;
BEGIN
  new_id := generate_table_id('UCR', 'seq_user_courses');

  INSERT INTO user_courses(id,user_id,course_id,access_start,access_end)
  VALUES(new_id,_user_id,_course_id,NOW(), NOW() + (_days || ' days')::interval);

  RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.fn_activate_user_course(text, text, integer)
    OWNER TO postgres;
