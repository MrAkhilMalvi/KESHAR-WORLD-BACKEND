import pgClient from "../../config/db.js";
import  otpEmail  from "./otp-email.js";
import redisClient from "../../config/redis.mjs";
import httpStatus from "http-status";
import APIError from "../helpers/APIError.js";
import config from "config";
const cloude = config.get("App.cloude");


async function getAllCourses( req , res , next){
    try {
          const id = req.user.id ;
      
      const result = await pgClient.query("SELECT * FROM student_course_status ($1)", [id]);
  
      if (!result.rows[0] === 0) {
        return next(new APIError("The coures are not exist", httpStatus.BAD_REQUEST, true,true));
      }
      const finalData = result.rows.map(course => {
        return {
            ...course,
            thumbnail_url: course.thumbnail_url 
                ? `${cloude.PUBLIC_BUCKET_KEY}/${course.thumbnail_url}` 
                : null
        };
    });

        res.json({success:true, result :finalData  });
      
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

        const result = await pgClient.query("SELECT * FROM user_purchase_course($1,$2,$3,$4)",
            [user_id, course_id,null,null]
        );

        res.json({ success: true, message: result.rows[0] });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
}

async function student_purchase_AllCourses( req , res , next){
  try {
        const id = req.user.id ;
    
    const result = await pgClient.query("SELECT * FROM student_course_status($1)", [id]);

    if (!result.rows[0] === 0) {
      return next(new APIError("The coures are not exist", httpStatus.BAD_REQUEST, true,true));
    }
     
      res.json({success:true, result : result.rows  });
    
  } catch (error) {
    next(error);
  }
}
  export default {getAllCourses,enrollFreeCourse,student_purchase_AllCourses};