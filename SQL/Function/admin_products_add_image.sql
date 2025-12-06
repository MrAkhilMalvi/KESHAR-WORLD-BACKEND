-- FUNCTION: public.admin_products_add_image(character varying, text, integer)

-- DROP FUNCTION IF EXISTS public.admin_products_add_image(character varying, text, integer);

CREATE OR REPLACE FUNCTION public.admin_products_add_image(
	in_product_id character varying,
	in_image_url text,
	in_positions integer DEFAULT 1)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE 
    new_id character varying;   
BEGIN
    -- Generate sequential number
    new_id := generate_table_id('IMG', 'seq_product_images');
  
    -- Insert into table
    INSERT INTO public.product_images(id, product_id, image_url, positions)
    VALUES (new_id, in_product_id, in_image_url, in_positions);

    RETURN new_id;
END;
$BODY$;

ALTER FUNCTION public.admin_products_add_image(character varying, text, integer)
    OWNER TO postgres;
