-- FUNCTION: public.user_password_status(character varying)

-- DROP FUNCTION IF EXISTS public.user_password_status(character varying);

CREATE OR REPLACE FUNCTION public.user_password_status(
	in_user_id character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    result BOOLEAN;
BEGIN
    SELECT (password IS NOT NULL)
    INTO result
    FROM users
    WHERE id = in_user_id;

    RETURN result;
END;
$BODY$;

ALTER FUNCTION public.user_password_status(character varying)
    OWNER TO postgres;
