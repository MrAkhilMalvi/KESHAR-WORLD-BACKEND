import pgClient from "../../config/db.js";
import  otpEmail  from "./otp-email.js";
import redisClient from "../../config/redis.mjs";
import httpStatus from "http-status";
import APIError from "../helpers/APIError.js";
import auth from "../helpers/auth.js";

 const saveClerkUser = async (req, res) => {
  try {
    const {
      clerkUserId,
      name,
      email,
      phone,
      imageUrl,
      role = "user",
      language = "en",
    } = req.body;

    const result = await pgClient.query(
      "SELECT * FROM auth_clerk_user_set($1,$2,$3,$4,$5,$6,$7)",
      [clerkUserId, name, email, phone, imageUrl, role, language]
    );

    return res.status(200).json({
      success: true,
      data: result.rows[0],
    });

  } catch (err) {
    console.error("DB Function Error:", err);
    return res.status(500).json({ error: "Server error" });
  }
};

async function signup( req , res , next){
  try {
    const { fullname, email, mobile, password ,credential_Type} = req.body;
    console.log("req.body",req.body);
    
    const userExists = await pgClient.query("SELECT * FROM check_user_exists ($1,$2)", [email,mobile]);

    if (userExists.rows[0].check_user_exists === true) {
      return next(new APIError("User already exists", httpStatus.BAD_REQUEST, true,true));
    }
      // hash password
      const hashPassword = await otpEmail.getHashPassword(password);

      const tempUser = JSON.stringify({
        fullname,
        email,
        mobile,
        password: hashPassword,
        credential_Type
    });

      if(!credential_Type === "MOBILE"){
      await redisClient.set(`signup_${email}`, tempUser, { EX: 300 });

      }
      await redisClient.set(`signup_${mobile}`, tempUser, { EX: 300 });
      res.json({success:true  });
    
  } catch (error) {
    next(error);
  }
}


//import { hashPassword } from "../helpers/auth.js";
//import  sendOtpEmail  from "./otp-email.js";


// Step 1: Signup & send OTP
// export const signup = async (req, res, next) => {
//   try {
//     const { fullname, email, mobile, password } = req.body;

//     // Check if user already exists
//     const userExists = await pgClient.query("SELECT * FROM users WHERE email=$1", [email]);
//     if (userExists.rows.length) {
//       return next(new APIError("User already exists", httpStatus.BAD_REQUEST, true));
//     }

//     //const hashedPassword = await hashPassword(password);
//     const otp = generateOTP();

//     // Save temp user in OTP table
//     await pgClient.query(
//       "INSERT INTO otp_table(email, otp, expires_at, fullname, mobile, password) VALUES($1,$2,NOW()+INTERVAL '10 MINUTE',$3,$4,$5)",
//       [email, otp, fullname, mobile, hashedPassword]
//     );

//     await sendOtpEmail(email, otp);
//     res.json({ message: "OTP sent to email", email });
//   } catch (err) {
//     next(err);
//   }
// };



async function verifyOtp(req, res, next) {
  try {
    const { email, mobile, otp } = req.body;

    const verify_type = mobile ? mobile : email;

    if (!verify_type) {
      return next(new APIError("Your send data wrong", httpStatus.BAD_REQUEST, true, true));
    }

    const otpKey = `otp_${verify_type}`;
    const redisOtp = await redisClient.get(otpKey);

    console.log("OTP in Redis:", redisOtp);

    // ❌ redisOtp is null → OTP expired or not generated
    if (!redisOtp) {
      return next(new APIError("OTP expired or not found", httpStatus.BAD_REQUEST, true, true));
    }

    // ❌ incorrect comparison before
    // ✔ correct comparison
    // if (redisOtp !== otp) {
    //   return next(new APIError("Invalid OTP", httpStatus.BAD_REQUEST, true, true));
    // }

    // Get signup stored data
    const dataKey = `signup_${verify_type}`;
    const signupDataJson = await redisClient.get(dataKey);

    if (!signupDataJson) {
      return next(new APIError("Signup data expired. Please signup again.", httpStatus.BAD_REQUEST, true, true));
    }

    const signupData = JSON.parse(signupDataJson);

    console.log("Signup Data:", signupData.fullname);

    // TODO: INSERT USER  DATA TO DATABASE 
       const result = await pgClient.query(
      "SELECT * FROM insert_user($1,$2,$3,$4)",
      [signupData.fullname, signupData.email, signupData.mobile, signupData.password]
    );

    if (!result) {
      return next(new APIError("THE DATA INSERT NOT SUCCESS FULL.", httpStatus.BAD_REQUEST, true, true));
    }
    await redisClient.del(otpKey);
    await redisClient.del(dataKey);

     const jwtToken = auth.createToken(result);

    return res.json({
      success: true,
      message: "successfully LOGIN",
      result : result.rows[0],
      token : jwtToken,
    });

  } catch (err) {
    next(err);
  }
}


async function loginUser  (req, res, next) {
  try {
    const { email , mobile, password } = req.body;

if (!email && !mobile) {
  return res.status(400).json({
    status: false,
    message: "Email or Mobile is required",
  });
}

if (!password) {
  return res.status(400).json({
    status: false,
    message: "Password is required",
  });
}

     const emailOrMobile = mobile ? mobile : email;
     console.log("emailOrMobile",emailOrMobile)
    // Step 1: Fetch user from DB
    const result = await pgClient.query("SELECT * FROM auth_user_login($1)", [emailOrMobile]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        status: false,
        message: "User not found",
      });
    }

    const user = result.rows[0];
    console.log("user",user)
    // Step 2: Compare Password
    const isMatch = await otpEmail.comparePassword(password, user.password);
    console.log("match",isMatch)

    if (!isMatch) {
      return res.status(401).json({
        status: false,
        message: "Invalid password",
      });
    }

    // Step 3: Remove password before sending response
    delete user.password;

    return res.status(200).json({
      status: true,
      message: "Login successful",
      data: user,
    });

  } catch (error) {
  console.error("Login Error:", error);

  return res.status(500).json({
    status: false,
    message: error?.message || "Internal server error",
  });
}

};





export default {saveClerkUser,signup,verifyOtp,loginUser};

