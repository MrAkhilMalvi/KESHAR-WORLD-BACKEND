import pgClient from "../../config/db.js";
import  otpEmail  from "./otp-email.js";
import redisClient from "../../config/redis.mjs";
import httpStatus from "http-status";
import APIError from "../helpers/APIError.js";



async function getAllCourses( req , res , next){
    try {
          const id = req.user.id;
      
      const result = await pgClient.query("SELECT * FROM fn_user_course_status ($1)", [id]);
  
      if (!result.rows[0] > 0) {
        return next(new APIError("The coures are not exist", httpStatus.BAD_REQUEST, true,true));
      }
       
        res.json({success:true, result : result.rows  });
      
    } catch (error) {
      next(error);
    }
  }

  export default {getAllCourses};