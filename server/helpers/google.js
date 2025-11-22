import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import pgClient from "../../config/db.js";
import dotenv from "dotenv";
dotenv.config();

passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_ID,
      clientSecret: process.env.GOOGLE_SECRET,
      callbackURL: `${process.env.BACKEND_URL}/api/auth/google/callback`,
    }, verifys
  )
);
async function verifys(accessToken, refreshToken, profile, done) {
  try {
    const googleId = profile.id;
    const email = profile.emails?.[0]?.value || null;
    const name = profile.displayName;
 
    // Step 1: Check if Google user exists
    const checkRes = await pgClient.query(
      "SELECT * FROM check_google_id($1)",
      [googleId]
    );

    let user = checkRes.rows[0];

    if (!user) {
      console.log("NEW GOOGLE USER → Inserting via insert_user()");

      const createRes = await pgClient.query(
        "SELECT * FROM insert_user($1, $2, $3, $4, $5)",
        [name, email, null, null, googleId]
      );

      user = createRes.rows[0];
    } else {
      console.log("GOOGLE USER FOUND → Logging in...");
    }

    return done(null, user);

  } catch (err) {
    console.error("GOOGLE STRATEGY ERROR:", err);
    return done(err, null);
  }
}



export default passport;
