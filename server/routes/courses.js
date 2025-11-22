import express from "express";
import couresCtrl from "../controllers/courses.js";
import auth from "../helpers/auth.js";

const coures = express.Router();

coures.route("/allcoures").get(auth.verifyToken,couresCtrl.getAllCourses);




export default coures;