-- FUNCTION: public.student_product_order_item_insert(character varying, character varying, integer, numeric, numeric, numeric, numeric, numeric)

-- DROP FUNCTION IF EXISTS public.student_product_order_item_insert(character varying, character varying, integer, numeric, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION public.student_product_order_item_insert(
	in_order_id character varying,
	in_product_id character varying,
	in_qty integer,
	in_price numeric,
	in_gst_percent numeric,
	in_gst_amount numeric,
	in_amount_before_gst numeric,
	in_amount_with_gst numeric)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    INSERT INTO user_order_items(
        order_id, product_id, qty, price,
        gst_percent, gst_amount,
        amount_before_gst, amount_with_gst
    )
    VALUES (
        in_order_id, in_product_id, in_qty, in_price,
        in_gst_percent, in_gst_amount,
        in_amount_before_gst, in_amount_with_gst
    );
END;
$BODY$;

ALTER FUNCTION public.student_product_order_item_insert(character varying, character varying, integer, numeric, numeric, numeric, numeric, numeric)
    OWNER TO postgres;
