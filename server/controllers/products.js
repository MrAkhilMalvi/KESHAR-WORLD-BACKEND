import pgClient from "../../config/db.js";
import httpStatus from "http-status";
import APIError from "../helpers/APIError.js";
import config from "config";
const cloude = config.get("App.cloude");


async function getAllProducts( req , res , next){
    try {

      const result = await pgClient.query("SELECT * FROM admin_products_get_all()", []);
  
      if (!result.rows[0] === 0) {
        return next(new APIError("The Products are not exist", httpStatus.BAD_REQUEST, true,true));
      }

      const finalData = result.rows.map(product => {
        return {
            ...product,
            thumbnail_url: product.thumbnail_url 
                ? `${cloude.PUBLIC_BUCKET_KEY}/${product.thumbnail_url}` 
                : null
        };
    });
       
        res.json({success:true, result : finalData  });
      
    } catch (error) {
      next(error);
    }
  }

  async function get_products_images(req, res, next) {

    try {
           const{ product_id} = req.body ;
        const result = await pgClient.query('SELECT * FROM admin_products_get_images_by_productid($1)',[product_id]);
  
        const finalData = result.rows.map(product => {
            return {
                ...product,
                image_url: product.image_url 
                    ? `${cloude.PUBLIC_BUCKET_KEY}/${product.image_url}` 
                    : null
            };
        });

  
        return res.send({ success: true, result: finalData })
    } catch (error) {
        next(error);
    }
  }

  async function getSelectedProducts(req, res, next) {
    try {
      const { products } = req.body;  // array of product IDs
  
      if (!products || products.length === 0) {
        return next(new APIError("No products selected", 400, true, true));
      }
  
      const result = await pgClient.query(
        "SELECT * FROM admin_products_get_selected($1)", 
        [products]
      );
  
      // Calculate grand total
      let grandTotal = 0;
      result.rows.forEach(item => {
        grandTotal += Number(item.total);
      });
  
      res.json({
        success: true,
        items: result.rows,
        grand_total: grandTotal
      });
  
    } catch (error) {
      next(error);
    }
  }
  
  export default {getAllProducts,get_products_images};