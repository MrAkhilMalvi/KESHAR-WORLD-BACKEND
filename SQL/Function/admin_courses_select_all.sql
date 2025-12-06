-- FUNCTION: public.admin_courses_select_all()

-- DROP FUNCTION IF EXISTS public.admin_courses_select_all();

CREATE OR REPLACE FUNCTION public.admin_courses_select_all(
	)
    RETURNS TABLE(id character varying, title character varying, price numeric, description text, is_free boolean, instructor character varying, original_price numeric, badge character varying, category character varying, thumbnail_url character varying, created_at timestamp without time zone, updated_at timestamp without time zone) 
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
        c.thumbnail_url,
        c.created_at,
        c.updated_at
    FROM courses c
    ORDER BY c.created_at DESC;
END;
$BODY$;

ALTER FUNCTION public.admin_courses_select_all()
    OWNER TO postgres;
