-- FUNCTION: public.fn_add_module(text, text)

-- DROP FUNCTION IF EXISTS public.fn_add_module(text, text);

CREATE OR REPLACE FUNCTION public.fn_add_module(
	_course_id text,
	_module_title text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id TEXT;
BEGIN
  new_id := generate_table_id('MODS', 'seq_modules');

  INSERT INTO course_modules(id,course_id,module_title)
  VALUES(new_id,_course_id,_module_title);

  RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.fn_add_module(text, text)
    OWNER TO postgres;
