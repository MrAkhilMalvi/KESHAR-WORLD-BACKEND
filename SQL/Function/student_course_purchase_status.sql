-- FUNCTION: public.student_course_purchase_status(character varying)

-- DROP FUNCTION IF EXISTS public.student_course_purchase_status(character varying);

CREATE OR REPLACE FUNCTION public.student_course_purchase_status(
	in_user_id character varying)
    RETURNS TABLE(id character varying, title character varying, price numeric, description text, is_free boolean, instructor character varying, original_price numeric, badge character varying, category character varying, thumbnail_url character varying, order_status character varying, access_start timestamp without time zone, access_end timestamp without time zone, is_access_active boolean) 
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

        COALESCE(o.status, 'not purchased') AS order_status,
        uc.access_start,
        uc.access_end,

        (uc.access_end > NOW()) AS is_access_active
        
    FROM user_courses uc
    INNER JOIN courses c ON c.id = uc.course_id
    
    LEFT JOIN LATERAL (
        SELECT *
        FROM orders
        WHERE user_id = in_user_id
          AND course_id = c.id
        ORDER BY id DESC
        LIMIT 1
    ) o ON TRUE

    WHERE uc.user_id = in_user_id   -- ONLY purchased courses
    ORDER BY uc.access_end DESC;

END;
$BODY$;

ALTER FUNCTION public.student_course_purchase_status(character varying)
    OWNER TO postgres;
