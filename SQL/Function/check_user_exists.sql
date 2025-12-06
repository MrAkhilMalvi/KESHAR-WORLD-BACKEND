-- FUNCTION: public.check_user_exists(character varying, character varying)

-- DROP FUNCTION IF EXISTS public.check_user_exists(character varying, character varying);

CREATE OR REPLACE FUNCTION public.check_user_exists(
	p_email character varying,
	p_mobile character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    exists_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO exists_count
    FROM users
    WHERE email = p_email 
       OR mobile = p_mobile;

    IF exists_count > 0 THEN
        RETURN TRUE;   -- user exists
    ELSE
        RETURN FALSE;  -- user not exists
    END IF;
END;
$BODY$;

ALTER FUNCTION public.check_user_exists(character varying, character varying)
    OWNER TO postgres;
