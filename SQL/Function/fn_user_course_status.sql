-- FUNCTION: public.fn_user_course_status(character varying)

-- DROP FUNCTION IF EXISTS public.fn_user_course_status(character varying);

CREATE OR REPLACE FUNCTION public.fn_user_course_status(
	_user_id character varying)
    RETURNS TABLE(course_id character varying, title character varying, price numeric, instructor character varying, oldprice numeric, badge character varying, category character varying, is_free boolean, is_purchased boolean, order_status character varying, access_start timestamp without time zone, access_end timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        c.id AS course_id,          -- 1
        c.title,                    -- 2
        c.price,                    -- 3
        c.instructor,               -- 4  ✔ CORRECT NOW
        c.original_price AS oldPrice,  -- 5
        c.badge,                    -- 6
        c.category,                 -- 7
        c.is_free,                  -- 8  ✔ moved here
        CASE 
            WHEN uc.id IS NOT NULL THEN TRUE
            ELSE FALSE
        END AS is_purchased,        -- 9
        COALESCE(o.status, 'not purchased') AS order_status, -- 10
        uc.access_start,            -- 11
        uc.access_end               -- 12
    FROM courses c

    LEFT JOIN LATERAL (
        SELECT *
        FROM orders
        WHERE orders.user_id = _user_id
          AND orders.course_id = c.id
        ORDER BY id DESC
        LIMIT 1
    ) o ON TRUE

    LEFT JOIN LATERAL (
        SELECT *
        FROM user_courses
        WHERE user_courses.user_id = _user_id
          AND user_courses.course_id = c.id
        ORDER BY access_end DESC
        LIMIT 1
    ) uc ON TRUE

    ORDER BY c.id;
END;
$BODY$;

ALTER FUNCTION public.fn_user_course_status(character varying)
    OWNER TO postgres;
