-- FUNCTION: public.get_user_data(character varying)

-- DROP FUNCTION IF EXISTS public.get_user_data(character varying);

CREATE OR REPLACE FUNCTION public.get_user_data(
	in_id character varying)
    RETURNS TABLE(id character varying, fullname character varying, email character varying, mobile character varying, created_at timestamp with time zone, google_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT u.id, u.fullname, u.email, u.mobile, u.created_at, u.google_id
    FROM users u
    WHERE u.id = in_id
    ORDER BY u.created_at DESC;
END;
$BODY$;

ALTER FUNCTION public.get_user_data(character varying)
    OWNER TO postgres;
