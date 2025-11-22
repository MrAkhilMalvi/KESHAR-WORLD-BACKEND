import pgClient from "../../config/db.js";
import  otpEmail  from "./otp-email.js";
import redisClient from "../../config/redis.mjs";
import httpStatus from "http-status";
import APIError from "../helpers/APIError.js";



async function getAllCourses( req , res , next){
    try {
          const id = req.user.id ;
      
      const result = await pgClient.query("SELECT * FROM fn_user_course_status ($1)", [id]);
  
      if (!result.rows[0] === 0) {
        return next(new APIError("The coures are not exist", httpStatus.BAD_REQUEST, true,true));
      }
       
        res.json({success:true, result : result.rows  });
      
    } catch (error) {
      next(error);
    }
  }


   async function enrollFreeCourse(req, res) {
    try {
        const { user_id, course_id } = req.body;

        // Check if course is free
        const course = await pgClient.query(
            "SELECT is_free FROM courses WHERE id=$1",
            [course_id]
        );

        if (!course.rows[0].is_free) {
            return res.status(400).json({ error: "Course is NOT free!" });
        }

        await pgClient.query(
            `INSERT INTO user_courses (user_id, course_id, access_end)
             VALUES ($1, $2, NULL)
             ON CONFLICT (user_id, course_id) DO NOTHING`,
            [user_id, course_id]
        );

        res.json({ success: true, message: "Free course enrolled!" });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
}

  export default {getAllCourses,enrollFreeCourse};