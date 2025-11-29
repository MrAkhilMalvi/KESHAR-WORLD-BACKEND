import express from "express";
import couresCtrl from "../controllers/courses.js";
import auth from "../helpers/auth.js";

const coures = express.Router();

coures.route("/allcourses").get(auth.verifyToken,couresCtrl.getAllCourses);//auth.verifyToken,

coures.route("/free_courses").post(couresCtrl.enrollFreeCourse)
coures.route("/mycourses").post(couresCtrl.student_purchase_AllCourses)

export default coures;