-- FUNCTION: public.admin_login_get_password_by_mobile_no(character varying)

-- DROP FUNCTION IF EXISTS public.admin_login_get_password_by_mobile_no(character varying);

CREATE OR REPLACE FUNCTION public.admin_login_get_password_by_mobile_no(
	in_mobile_no character varying,
	OUT password text)
    RETURNS SETOF text 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE SQL varchar;
DECLARE user_row record;

BEGIN
	--SELECT * FROM login_get_password_by_mobile_no(955899328);
	
	SQL= 'SELECT password from admins where mobile= $1';
     EXECUTE SQL INTO user_row USING in_mobile_no;
	
     IF user_row IS NULL THEN
		RAISE EXCEPTION 'Wrong Mobile Number.' USING ERRCODE='22222';
     END IF;

     RETURN  QUERY EXECUTE 'select (' || quote_literal(user_row.password) || ')::text as password';
      
END;
$BODY$;

ALTER FUNCTION public.admin_login_get_password_by_mobile_no(character varying)
    OWNER TO postgres;
