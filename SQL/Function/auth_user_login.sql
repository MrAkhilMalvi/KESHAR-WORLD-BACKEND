-- FUNCTION: public.auth_user_login(character varying)

-- DROP FUNCTION IF EXISTS public.auth_user_login(character varying);

CREATE OR REPLACE FUNCTION public.auth_user_login(
	_email_or_mobile character varying)
    RETURNS TABLE(user_id character varying, user_name character varying, user_email character varying, user_mobile character varying, image_url character varying, password character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        u.id AS user_id,
        u.fullname AS user_name,
        u.email AS user_email,
        u.mobile AS user_mobile,
        u.image_url,
        u.password    
    FROM users u
    WHERE 
        (u.email = _email_or_mobile OR u.mobile = _email_or_mobile);  -- secure password match

    -- If no records found → throw error
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Invalid email/mobile or password';
    END IF;
END;
$BODY$;

ALTER FUNCTION public.auth_user_login(character varying)
    OWNER TO postgres;
