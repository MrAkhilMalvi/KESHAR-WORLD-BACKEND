-- FUNCTION: public.admin_courses_insert_modules(text, text, integer)

-- DROP FUNCTION IF EXISTS public.admin_courses_insert_modules(text, text, integer);

CREATE OR REPLACE FUNCTION public.admin_courses_insert_modules(
	p_course_id text,
	p_module_title text,
	p_position integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id text;
BEGIN
   new_id := generate_table_id('MOD', 'seq_modules');
   
   INSERT INTO course_modules(
        id, course_id, module_title, position, created_at, updated_at
   )
   VALUES (
        new_id,        -- use generated id
        p_course_id,
        p_module_title,
        p_position,
        NOW(),
        NOW()
   );
		
   RETURN new_id;

END;
$BODY$;

ALTER FUNCTION public.admin_courses_insert_modules(text, text, integer)
    OWNER TO postgres;
