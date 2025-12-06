import pgClient from "../../config/db.js";
import httpStatus from "http-status";
import APIError from "../helpers/APIError.js";



async function getAllProducts( req , res , next){
    try {

      const result = await pgClient.query("SELECT * FROM admin_products_get_all()", []);
  
      if (!result.rows[0] === 0) {
        return next(new APIError("The Products are not exist", httpStatus.BAD_REQUEST, true,true));
      }
       
        res.json({success:true, result : result.rows  });
      
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
  
  export default {getAllProducts};