-- FUNCTION: public.check_google_id(character varying)

-- DROP FUNCTION IF EXISTS public.check_google_id(character varying);

CREATE OR REPLACE FUNCTION public.check_google_id(
	in_googleid character varying)
    RETURNS TABLE(id character varying, fullname character varying, email character varying, mobile character varying, google_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.fullname,
        u.email,
        u.mobile,
        u.google_id
    FROM users u
    WHERE u.google_id = in_googleid;
END;
$BODY$;

ALTER FUNCTION public.check_google_id(character varying)
    OWNER TO postgres;
