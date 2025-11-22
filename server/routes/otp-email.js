import express from "express";
import otpCtrl from "../controllers/otp-email.js";


const otp = express.Router();

otp.route("/SendEmail").post(otpCtrl.SendEmail);

otp.route("/SendOTP").post(otpCtrl.SendOTP);



export default otp;