-- FUNCTION: public.admin_courses_select(character varying)

-- DROP FUNCTION IF EXISTS public.admin_courses_select(character varying);

CREATE OR REPLACE FUNCTION public.admin_courses_select(
	in_id character varying)
    RETURNS TABLE(id character varying, title character varying, price numeric, description text, is_free boolean, instructor character varying, original_price numeric, badge character varying, category character varying, thumbnail character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        c.id,
        c.title,
        c.price,
        c.description,
        c.is_free,
        c.instructor,
        c.original_price,
        c.badge,
        c.category,
        c.thumbnail_url as thumbnail
    FROM courses c
    WHERE c.id = in_id;
END;
$BODY$;

ALTER FUNCTION public.admin_courses_select(character varying)
    OWNER TO postgres;
