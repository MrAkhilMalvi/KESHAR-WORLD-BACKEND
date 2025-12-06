import express from "express";
import loginRoutes from "./login.js";
import otpRoutes from "./otp-email.js";
import googleRoutes from "./google.js";
import coursesRoutes from "./courses.js";
import paymentRoutes from "./payment.js";
import studentRoutes from "./studemt.js";
const router = express.Router();

router.get("/health-check", (req, res) => res.send("OK"));
router.use('/auth', loginRoutes);
router.use('/otp-email', otpRoutes);
router.use("/auth", googleRoutes);  
router.use("/courses", coursesRoutes);  
router.use("/google", googleRoutes);
router.use('/payment',paymentRoutes)
router.use('/student',studentRoutes)

export  default router;
