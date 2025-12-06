-- FUNCTION: public.fn_purchase_course(character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.fn_purchase_course(character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.fn_purchase_course(
	_user_id character varying,
	_course_id character varying,
	_payment_status character varying)
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
    -- Get course info
    SELECT price, is_free
    INTO v_course_price, v_is_free
    FROM courses
    WHERE id = _course_id;

    IF v_course_price IS NULL THEN
        RETURN 'Course not found';
    END IF;

    -- Check existing access
    SELECT access_end
    INTO v_existing_end
    FROM user_courses
    WHERE user_id = _user_id
      AND course_id = _course_id
    ORDER BY access_end DESC
    LIMIT 1;

    -- Rule 4: Already active, don't allow repurchase
    IF v_existing_end IS NOT NULL AND v_existing_end > NOW() THEN
        RETURN 'You already have access to this course until ' || v_existing_end;
    END IF;

    -----------------------------------------------------------------
    -- CASE 1: FREE COURSE (auto access)
    -----------------------------------------------------------------
    IF v_is_free = TRUE THEN
        v_order_id := 'ORD' || LPAD(nextval('seq_orders')::CHARACTER VARYING, 6, '0');

        INSERT INTO orders(id, user_id, course_id, amount, status)
        VALUES (v_order_id, _user_id, _course_id, 0, 'success');

        v_user_course_id := 'UCR' || LPAD(nextval('seq_user_courses')::CHARACTER VARYING, 6, '0');

        INSERT INTO user_courses(id, user_id, course_id, access_start, access_end)
        VALUES (
            v_user_course_id,
            _user_id,
            _course_id,
            NOW(),
            NOW() + INTERVAL '365 days'
        );

        RETURN 'Free course access granted';
    END IF;

    -----------------------------------------------------------------
    -- CASE 2: PAID COURSE
    -----------------------------------------------------------------

    -- Create order
    v_order_id := 'ORD' || LPAD(nextval('seq_orders')::CHARACTER VARYING, 6, '0');

    INSERT INTO orders(id, user_id, course_id, amount, status)
    VALUES (
        v_order_id,
        _user_id,
        _course_id,
        v_course_price,
        _payment_status
    );

    -- If payment failed or pending → No access
    IF _payment_status <> 'success' THEN
        RETURN 'Order created but payment pending/failed';
    END IF;

    -- Payment success → Give access
    v_user_course_id := 'UCR' || LPAD(nextval('seq_user_courses')::CHARACTER VARYING, 6, '0');

    INSERT INTO user_courses(id, user_id, course_id, access_start, access_end)
    VALUES (
        v_user_course_id,
        _user_id,
        _course_id,
        NOW(),
        NOW() + INTERVAL '365 days'
    );

    RETURN 'Purchase successful. Access granted.';
END;
$BODY$;

ALTER FUNCTION public.fn_purchase_course(character varying, character varying, character varying)
    OWNER TO postgres;
