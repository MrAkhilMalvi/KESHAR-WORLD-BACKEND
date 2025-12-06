-- FUNCTION: public.admin_courses_insert_course(character varying, numeric, character varying, boolean, character varying, numeric, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_insert_course(character varying, numeric, character varying, boolean, character varying, numeric, character varying, character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_insert_course(
	in_title character varying,
	in_price numeric,
	in_description character varying,
	in_is_free boolean,
	in_instructor character varying,
	in_original_price numeric,
	in_badge character varying,
	in_category character varying)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id character varying;
BEGIN
   new_id := generate_table_id('CRS', 'seq_courses');
   
   INSERT INTO courses(
        id, title, price, description, is_free, 
        instructor, original_price, badge, category, 
         created_at, updated_at
    )
    VALUES (
        new_id, in_title, in_price, in_description, in_is_free,
        in_instructor, in_original_price, in_badge, in_category,
		NOW(), NOW()
    );
		
    RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.admin_courses_insert_course(character varying, numeric, character varying, boolean, character varying, numeric, character varying, character varying)
    OWNER TO postgres;
