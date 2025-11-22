import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import pgClient from "../../config/db.js";
import dotenv from "dotenv";
dotenv.config();

// /**
//  * Generate next student ID like:
//  * STU000001 → STU000002 → STU000003
//  */
// async function generateStudentId() {
//   const result = await pgClient.query(
//     "SELECT id FROM users ORDER BY id DESC LIMIT 1"
//   );

//   if (!result.rows.length) {
//     return "STU000001";
//   }

//   const lastId = result.rows[0].id; // "STU000012"
//   const lastNum = parseInt(lastId.replace("STU", ""), 10) + 1;
//   return "STU" + String(lastNum).padStart(6, "0");
// }

// passport.use(
//   new GoogleStrategy(
//     {
//       clientID: process.env.GOOGLE_ID,
//       clientSecret: process.env.GOOGLE_SECRET,
//       callbackURL: `${process.env.BACKEND_URL}/api/auth/google/callback`,
//     },

//     async (accessToken, refreshToken, profile, done) => {
//       try {
//         // Check if user already exists
//         let userRes = await pgClient.query(
//           "SELECT * FROM users WHERE google_id=$1",
//           [profile.id]
//         );

//         let user;

//         if (!userRes.rows.length) {
//           console.log("NEW GOOGLE USER → Creating entry...");

//           const newId = await generateStudentId(); // Generate STUxxxxx

//           // Insert user
//           user = await pgClient.query(
//             `INSERT INTO users(id, fullname, email, google_id, provider)
//              VALUES($1, $2, $3, $4, 'google')
//              RETURNING *`,
//             [
//               newId,
//               profile.displayName,
//               profile.emails?.[0]?.value || null,
//               profile.id,
//             ]
//           );

//           user = user.rows[0];
//         } else {
//           console.log("GOOGLE USER FOUND → Logging in...");
//           user = userRes.rows[0];
//         }

//         return done(null, user);
//       } catch (err) {
//         console.error("GOOGLE STRATEGY ERROR:", err);
//         return done(err, null);
//       }
//     }
//   )
// );

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
    console.log("name",name)
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
