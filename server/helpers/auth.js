import jwt from "jsonwebtoken";
import httpStatus from "http-status";
import config from "config";
import APIError from "../helpers/APIError.js";

// const jwtSecret = config.get("App.config.jwtSecret");


// ----------------------------
// Create Token (EXPORT THIS)
// ----------------------------
  function createToken (result)  {
  return jwt.sign({
        id: result.user_id,
        name: result.user_name,
        email: result.user_email,
        mobileno: result.user_mobile,
        google_id :result.user_google_id
  }, // jwtSecret,     // PRODUCTION
    process.env.JWT_SECRET ,
    // || config.get("App.config.jwtSecret"),
    { expiresIn: "7d" }
  );
};

// ----------------------------
// Verify Token Middleware
// ----------------------------
 function verifyToken (req, res, next) {
  let token =
    req.header("x-auth-token") ||
    req.headers.authorization?.split(" ")[1];

  if (!token) {
    return next(new APIError("No token provided", httpStatus.UNAUTHORIZED, true, true));
  }

  jwt.verify(
    token,
    process.env.JWT_SECRET ,
    // || config.get("App.config.jwtSecret"),
    (err, decoded) => {
      if (err) {
        return next(
          new APIError("You are not authorized. Please login first.",
            httpStatus.UNAUTHORIZED,
            true,
            true
          )
        );
      }
      req.user = decoded;
      next();
    }
  );
};

export default {verifyToken,createToken};
