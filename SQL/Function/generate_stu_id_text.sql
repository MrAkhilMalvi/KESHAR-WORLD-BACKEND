-- FUNCTION: public.generate_stu_id_text()

-- DROP FUNCTION IF EXISTS public.generate_stu_id_text();

CREATE OR REPLACE FUNCTION public.generate_stu_id_text(
	)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    seq_num BIGINT;
BEGIN
    seq_num := nextval('users_id_seq');
    RETURN 'STU' || LPAD(seq_num::text, 6, '0');
END;
$BODY$;

ALTER FUNCTION public.generate_stu_id_text()
    OWNER TO postgres;
