-- FUNCTION: public.student_product_order_insert(character varying, character varying, character varying, numeric, numeric, numeric, jsonb)

-- DROP FUNCTION IF EXISTS public.student_product_order_insert(character varying, character varying, character varying, numeric, numeric, numeric, jsonb);

CREATE OR REPLACE FUNCTION public.student_product_order_insert(
	in_order_id character varying,
	in_user_id character varying,
	in_payment_intent character varying,
	in_subtotal numeric,
	in_gst_total numeric,
	in_total_amount numeric,
	in_products_json jsonb)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    INSERT INTO user_orders(
        order_id, user_id, payment_intent,
        subtotal, gst_total, total_amount,
        products_json
    )
    VALUES (
        in_order_id, in_user_id, in_payment_intent,
        in_subtotal, in_gst_total, in_total_amount,
        in_products_json
    );
END;
$BODY$;

ALTER FUNCTION public.student_product_order_insert(character varying, character varying, character varying, numeric, numeric, numeric, jsonb)
    OWNER TO postgres;
