-- FUNCTION: public.admin_dashboard_count()

-- DROP FUNCTION IF EXISTS public.admin_dashboard_count();

CREATE OR REPLACE FUNCTION public.admin_dashboard_count(
	)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    result JSON;

    total_students INT;
    total_courses INT;
    total_modules INT;
    total_videos INT;

    most_purchase_course_name VARCHAR;
    most_purchase_course_price NUMERIC;
    most_purchase_course_user_count INT;
    avg_purchase_price NUMERIC;

    total_free_courses INT;
    total_paid_courses INT;

    total_free_purchase INT;
    total_paid_purchase INT;

BEGIN
    -- 1. Total Students
    SELECT COUNT(*) INTO total_students FROM users;

    -- 2. Total Courses
    SELECT COUNT(*) INTO total_courses FROM courses;

    -- 3. Total Modules
    SELECT COUNT(*) INTO total_modules FROM course_modules;

    -- 4. Total Videos
    SELECT COUNT(*) INTO total_videos FROM videos;

    -- 5. Most Purchased Course (using orders table)
    SELECT 
        c.title,
        c.price,
        COUNT(od.user_id) AS user_count
    INTO 
        most_purchase_course_name,
        most_purchase_course_price,
        most_purchase_course_user_count
    FROM orders od
    JOIN courses c ON od.course_id = c.id
    WHERE od.status = 'success'
    GROUP BY c.id
    ORDER BY COUNT(od.user_id) DESC
    LIMIT 1;

    -- 6. Average purchase price (paid only)
    SELECT 
        COALESCE(AVG(od.amount), 0)
    INTO avg_purchase_price
    FROM orders od
    JOIN courses c ON od.course_id = c.id
    WHERE c.is_free = false
    AND od.status = 'success';

    -- 7. Total free + paid courses
    SELECT
        COUNT(*) FILTER (WHERE is_free = true),
        COUNT(*) FILTER (WHERE is_free = false)
    INTO total_free_courses, total_paid_courses
    FROM courses;

-- 8. Total free-course purchases & paid-course purchases
    SELECT 
        COUNT(*) FILTER (WHERE c.is_free = true),
        COUNT(*) FILTER (WHERE c.is_free = false)
    INTO 
		total_free_purchase,
		total_paid_purchase
    FROM user_courses uc
    JOIN courses c ON uc.course_id = c.id;

    -- Build JSON Output
    result := json_build_object(
        'total_students', total_students,
        'total_courses', total_courses,
        'total_modules', total_modules,
        'total_videos', total_videos,

        'most_purchased_course', json_build_object(
            'name', most_purchase_course_name,
            'price', most_purchase_course_price,
            'purchase_user_count', most_purchase_course_user_count
        ),

        'average_purchase_price', avg_purchase_price,
        'total_free_courses', total_free_courses,
        'total_paid_courses', total_paid_courses,
        'total_free_course_purchases', total_free_purchase,
        'total_paid_course_purchases', total_paid_purchase
    );

    RETURN result;
END;
$BODY$;

ALTER FUNCTION public.admin_dashboard_count()
    OWNER TO postgres;
