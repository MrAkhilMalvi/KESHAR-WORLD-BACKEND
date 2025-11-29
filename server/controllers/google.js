import pgClient from "../../config/db.js";

import auth from "../helpers/auth.js";
import otpEmail from "./otp-email.js";

async function setPassword(req, res, next) {
  try {
    const { password } = req.body;
    const userId = req.user.id;

    if (!password) {
      return res
        .status(400)
        .json({ success: false, message: "Password required" });
    }

    const hashed = await otpEmail.getHashPassword(password);

    const result = await pgClient.query(
      "select * from insert_password($1,$2)",
      [hashed, userId]
    );

    if (!result.rows[0].insert_password === true) {
      res
        .status(500)
        .json({ success: false, message: "Error setting password" });
    }

    res.json({ success: true, message: "Password updated successfully" });
  } catch (err) {
    console.log("SET-PASSWORD ERROR:", err);
    res.status(500).json({ success: false, message: "Error setting password" });
  }
}

async function getPassword(req, res, next) {
  console.log("this is get password");

  try {
    const userId = req.user.id;

    const result = await pgClient.query(
      "select * from user_password_status($1)",
      [userId]
    );

    const userData = await pgClient.query("select * from get_user_data($1)", [
      userId,
    ]);

    res.json({
      success: true,
      password_status: result.rows[0],
      data: userData.rows[0],
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function callback(req, res, next) {
  try {
    const user = req.user; // This comes from Google Strategy

    const data = {
      user_id: user.id,
      user_name: user.name,
      user_email: user.email,
      user_mobile: user.mobile,
      user_google_id: user.google_id,
    };
    const token = auth.createToken(data);

    // Redirect to frontend
    res.redirect(`${process.env.CLIENT_URL}/auth-success?token=${token}`);
  } catch (error) {
    next(error);
  }
}

export default { setPassword, callback, getPassword };
