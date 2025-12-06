-- FUNCTION: public.fn_add_course(text, numeric, text, boolean)

-- DROP FUNCTION IF EXISTS public.fn_add_course(text, numeric, text, boolean);

CREATE OR REPLACE FUNCTION public.fn_add_course(
	_title text,
	_price numeric,
	_description text,
	_is_free boolean)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id TEXT;
BEGIN
  new_id := generate_table_id('CRS', 'seq_courses');

  INSERT INTO courses(id,title,price,description,is_free)
  VALUES(new_id,_title,_price,_description,_is_free);

  RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.fn_add_course(text, numeric, text, boolean)
    OWNER TO postgres;
