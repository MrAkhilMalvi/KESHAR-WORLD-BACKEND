-- FUNCTION: public.insert_user(character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.insert_user(character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.insert_user(
	in_fullname character varying,
	in_email character varying,
	in_mobile character varying,
	in_password character varying,
	in_google_id character varying)
    RETURNS TABLE(user_id character varying, user_name text, user_email text, user_mobile text, user_crated_at timestamp with time zone, user_google_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
  

    -- Insert user with generated ID
    INSERT INTO users(id, fullname, email, mobile, password,google_id)
    VALUES (generate_stu_id_text(), in_fullname, in_email, in_mobile, in_password,in_google_id)
    RETURNING 
        id,
        fullname,
        email,
        mobile,
        created_at,
		google_id
    INTO 
        user_id,
        user_name,
        user_email,
        user_mobile,
        user_crated_at,
		user_google_id;

    RETURN NEXT;
END;
$BODY$;

ALTER FUNCTION public.insert_user(character varying, character varying, character varying, character varying, character varying)
    OWNER TO postgres;
