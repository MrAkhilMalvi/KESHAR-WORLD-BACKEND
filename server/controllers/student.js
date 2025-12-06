import pgClient from "../../config/db.js";
import httpStatus from "http-status";
import APIError from "../helpers/APIError.js";
import config from "config";
const cloude = config.get("App.cloude");

async function student_purchase_Courses( req , res , next){
  try {
    const id = req.user.id ;
    console.log(req.user.id)
    const result = await pgClient.query("SELECT * FROM student_course_purchase_status($1)", [id]);

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

async function student_purchase_Course_modules( req , res , next){
    try {
          const id = req.user.id ;
          const course_id = req.body.course_id;
      
      const result = await pgClient.query("SELECT * FROM student_courses_base_module($1,$2)", [id,course_id]);
  
      if (!result.rows[0] === 0) {
        return next(new APIError("The coures are not exist", httpStatus.BAD_REQUEST, true,true));
      }

       
        res.json({success:true, result : result.rows  });
      
    } catch (error) {
      next(error);
    }
  }

  async function student_purchase_videos( req , res , next){
    try {
          const id = req.user.id ;
          const course_id = req.body.course_id
          const module_id = req.body.module_id ;
      
      const result = await pgClient.query("SELECT * FROM student_courses_base_videos($1,$2,$3)", [id,course_id,module_id]);
  
      if (!result.rows[0] === 0) {
        return next(new APIError("The coures are not exist", httpStatus.BAD_REQUEST, true,true));
      }
    
    
        res.json({success:true, result : result.rows });
      
    } catch (error) {
      next(error);
    }
  }

  async function student_course_video_access( req,res,next){
    try{
      const id = req.user.id ;
      console.log("user_id",req.body)
    const video_id =req.body.video_id; 
    console.log("video_id",video_id)
    const result = await pgClient.query(
      "SELECT * FROM student_courses_videos_access($1, $2)",
      [id, video_id]
    );

    if (result.rows.length === 0) {
      return next(
        new APIError("No videos found or access denied", httpStatus.BAD_REQUEST, true, true)
      );
    }

    // ✔ Filter only videos where is_access_active = true
    const allowedVideos = result.rows.filter(v => v.is_access_active === true);

    if (allowedVideos.length === 0) {
      return res.json({
        success: false,
        message: "Access expired or not active for this module"
      });
    }
    
    const finalVideos = allowedVideos.map(v => ({
      ...v,
      video_url: `${cloude.PUBLIC_BUCKET_KEY}/${v.video_url}`,
      thumbnail_url: `${cloude.PUBLIC_BUCKET_KEY}/${v.thumbnail_url}`
    }));
//((CURRENT_ AT TIME ZONE 'Asia/Kolkata'::text)
    res.json({
      success: true,
      videos: finalVideos

    });

  } catch (error) {
    next(error);
  }
}

  export default {student_purchase_Courses,student_purchase_Course_modules,student_purchase_videos,student_course_video_access};