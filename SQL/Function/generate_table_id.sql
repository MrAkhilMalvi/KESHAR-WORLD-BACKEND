-- FUNCTION: public.generate_table_id(text, text)

-- DROP FUNCTION IF EXISTS public.generate_table_id(text, text);

CREATE OR REPLACE FUNCTION public.generate_table_id(
	prefix text,
	seq_name text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id TEXT;
  seq_val INT;
BEGIN
  EXECUTE 'SELECT nextval(''' || seq_name || ''')' INTO seq_val;
  new_id := prefix || LPAD(seq_val::text, 6, '0');
  RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.generate_table_id(text, text)
    OWNER TO postgres;
