import express from "express";
import loginCtrl from "../controllers/login.js";

//import auth from "../helpers/auth.js";

const login = express.Router();

login.route("/createUser").post(loginCtrl.saveClerkUser);

// Public routes
login.route("/signup").post(loginCtrl.signup);

login.route("/verifyOtp").post(loginCtrl.verifyOtp);
login.route("/signin").post(loginCtrl.loginUser);
//login.post("/verify-otp", verifyOtp);
//login.post("/login", login);


// Protected route example
// login.get("/profile", auth.verifyToken, (req, res) => {
//   res.json({ message: "You are authenticated", userId: req.user.id });
// });

export default login;
