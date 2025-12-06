import express from "express";
import studentCtrl from "../controllers/student.js";
import auth from "../helpers/auth.js";

const coures = express.Router();



coures.route("/mycourses").get(auth.verifyToken,studentCtrl.student_purchase_Courses)
coures.route("/mycourses/modules").post(auth.verifyToken,studentCtrl.student_purchase_Course_modules);
coures.route("/mycourses/videos").post(auth.verifyToken,studentCtrl.student_purchase_videos)
coures.route("/mycourses/access/videos").post(auth.verifyToken,studentCtrl.student_course_video_access)

export default coures;