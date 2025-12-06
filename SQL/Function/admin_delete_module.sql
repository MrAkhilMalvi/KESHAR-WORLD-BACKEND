-- FUNCTION: public.admin_delete_module(character varying)

-- DROP FUNCTION IF EXISTS public.admin_delete_module(character varying);

CREATE OR REPLACE FUNCTION public.admin_delete_module(
	in_module_id character varying)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    DELETE FROM videos WHERE module_id = in_module_id;
    DELETE FROM course_modules WHERE id = in_module_id;

    RETURN json_build_object('success', true, 'message', 'Module Deleted');
END;
$BODY$;

ALTER FUNCTION public.admin_delete_module(character varying)
    OWNER TO postgres;
