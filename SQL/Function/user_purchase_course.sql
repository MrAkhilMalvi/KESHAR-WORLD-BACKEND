-- FUNCTION: public.user_purchase_course(character varying, character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.user_purchase_course(character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.user_purchase_course(
	in_user_id character varying,
	in_course_id character varying,
	in_payment_id character varying,
	in_payment_status character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    v_course_price NUMERIC;
    v_is_free BOOLEAN;
    v_existing_end TIMESTAMP;
    v_order_id CHARACTER VARYING;
    v_user_course_id CHARACTER VARYING;
BEGIN
    -- Fetch course info
    SELECT price, is_free
    INTO v_course_price, v_is_free
    FROM courses
    WHERE id = in_course_id;

    IF v_course_price IS NULL THEN
        RETURN 'Course not found';
    END IF;

    -- If user already has active access, block repurchase
    SELECT access_end
    INTO v_existing_end
    FROM user_courses
    WHERE user_id = in_user_id
      AND course_id = in_course_id
    ORDER BY access_end DESC
    LIMIT 1;

    IF v_existing_end IS NOT NULL AND v_existing_end > NOW() THEN
        RETURN 'You already have access until ' || v_existing_end;
    END IF;

    -----------------------------------------------------------------
    -- CASE 1: FREE COURSE → Only insert into user_courses
    -----------------------------------------------------------------
    IF v_is_free = TRUE THEN
        -- v_user_course_id := 'UCR' || LPAD(nextval('seq_user_courses')::VARCHAR, 6, '0');
         v_user_course_id  := generate_table_id('UCR', 'seq_user_courses');
		 
        INSERT INTO user_courses(id, user_id, course_id, access_start, access_end)
        VALUES (
            v_user_course_id,
            in_user_id,
            in_course_id,
            NOW(),
            NOW() + INTERVAL '365 days'
        );

        RETURN 'Free course access granted';
    END IF;

    -----------------------------------------------------------------
    -- CASE 2: PAID COURSE → Insert in orders ALWAYS
    -----------------------------------------------------------------
    -- v_order_id := 'ORD' || LPAD(nextval('seq_orders')::VARCHAR, 6, '0');
        v_order_id  := generate_table_id('ORD', 'seq_orders');
		
    INSERT INTO orders(id, user_id, course_id, payment_id, amount, status)
    VALUES (
        v_order_id,
        in_user_id,
        in_course_id,
        in_payment_id,
        v_course_price,
        in_payment_status
    );

    -- If payment failed or pending → DO NOT give access
    IF in_payment_status <> 'paid' THEN
        RETURN 'Order created, payment pending or failed';
    END IF;

    -----------------------------------------------------------------
    -- Payment success → insert into user_courses
    -----------------------------------------------------------------
    -- v_user_course_id := 'UCR' || LPAD(nextval('seq_user_courses')::VARCHAR, 6, '0');
      v_user_course_id  := generate_table_id('UCR', 'seq_user_courses');
	  
    INSERT INTO user_courses(id, user_id, course_id, access_start, access_end)
    VALUES (
        v_user_course_id,
        in_user_id,
        in_course_id,
        NOW(),
        NOW() + INTERVAL '365 days'
    );

    RETURN 'Purchase successful and access granted';
END;
$BODY$;

ALTER FUNCTION public.user_purchase_course(character varying, character varying, character varying, character varying)
    OWNER TO postgres;
