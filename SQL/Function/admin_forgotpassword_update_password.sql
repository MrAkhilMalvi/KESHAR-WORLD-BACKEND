-- FUNCTION: public.admin_forgotpassword_update_password(character varying, character varying)

-- DROP FUNCTION IF EXISTS public.admin_forgotpassword_update_password(character varying, character varying);

CREATE OR REPLACE FUNCTION public.admin_forgotpassword_update_password(
	in_mobile_no character varying,
	in_password character varying)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    user_row RECORD;
BEGIN
    SELECT id INTO user_row
    FROM admins
    WHERE mobile = in_mobile_no;

    IF user_row IS NULL THEN
        RAISE EXCEPTION 'Wrong Mobile No.' USING ERRCODE = '22222';
    END IF;

    UPDATE admins 
    SET password = in_password
    WHERE id = user_row.id;

END;
$BODY$;

ALTER FUNCTION public.admin_forgotpassword_update_password(character varying, character varying)
    OWNER TO postgres;
