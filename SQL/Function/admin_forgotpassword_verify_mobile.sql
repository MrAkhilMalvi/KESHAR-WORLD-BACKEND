-- FUNCTION: public.admin_forgotpassword_verify_mobile(character varying)

-- DROP FUNCTION IF EXISTS public.admin_forgotpassword_verify_mobile(character varying);

CREATE OR REPLACE FUNCTION public.admin_forgotpassword_verify_mobile(
	in_mobile character varying)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    user_row RECORD;
BEGIN
    -- Execute safe dynamic SQL using parameter binding
    EXECUTE 'SELECT id FROM admins WHERE mobile = $1'
        INTO user_row
        USING in_mobile;

    -- If no user found
    IF user_row IS NULL THEN
        RAISE EXCEPTION 'Wrong Mobile Number'
            USING ERRCODE = '22222';
    END IF;

    -- If found → do nothing (function returns void)
END;
$BODY$;

ALTER FUNCTION public.admin_forgotpassword_verify_mobile(character varying)
    OWNER TO postgres;
