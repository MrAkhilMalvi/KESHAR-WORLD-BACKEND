-- FUNCTION: public.admin_login_get_user_by_mobile_no(character varying)

-- DROP FUNCTION IF EXISTS public.admin_login_get_user_by_mobile_no(character varying);

CREATE OR REPLACE FUNCTION public.admin_login_get_user_by_mobile_no(
	in_mobile_no character varying,
	OUT id integer,
	OUT name character varying,
	OUT mobile character varying,
	OUT email character varying)
    RETURNS SETOF record 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE SQL varchar;
 row_count integer;
BEGIN
	--SELECT * FROM login_get_user_by_mobile_no(9033302459)
		
	SQL= 'SELECT id,name,mobile,email
			FROM admins 
		 	WHERE mobile=$1';
	
     RETURN  QUERY EXECUTE SQL USING in_mobile_no;

	 				-- check how many rows were returned
    GET DIAGNOSTICS row_count = ROW_COUNT;

    IF row_count = 0 THEN
        RAISE EXCEPTION 'No records found for the given filters.' USING ERRCODE='22222';
    END IF;
	
END;
$BODY$;

ALTER FUNCTION public.admin_login_get_user_by_mobile_no(character varying)
    OWNER TO postgres;
