-- FUNCTION: public.fn_create_order(text, text, numeric, character varying)

-- DROP FUNCTION IF EXISTS public.fn_create_order(text, text, numeric, character varying);

CREATE OR REPLACE FUNCTION public.fn_create_order(
	in_user_id text,
	in_course_id text,
	in_amount numeric,
	in_payment_id character varying)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id TEXT;
BEGIN
  new_id := generate_table_id('ORD', 'seq_orders');

  INSERT INTO orders(id,user_id,course_id,amount,status,payment_id)
  VALUES(new_id,in_user_id,in_course_id,in_amount,status,in_payment_id);

  RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.fn_create_order(text, text, numeric, character varying)
    OWNER TO postgres;
