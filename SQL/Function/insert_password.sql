-- FUNCTION: public.insert_password(character varying, character varying)

-- DROP FUNCTION IF EXISTS public.insert_password(character varying, character varying);

CREATE OR REPLACE FUNCTION public.insert_password(
	in_password character varying,
	in_user_id character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    user_exists BOOLEAN;
BEGIN
    -- check if user exists
    SELECT EXISTS(
        SELECT 1 FROM users WHERE id = in_user_id
    ) INTO user_exists;

    IF user_exists THEN
        -- update password
        UPDATE users 
        SET password = in_password
        WHERE id = in_user_id;

        RETURN TRUE;  -- password updated
    ELSE
        RETURN FALSE; -- user not found
    END IF;
END;
$BODY$;

ALTER FUNCTION public.insert_password(character varying, character varying)
    OWNER TO postgres;
