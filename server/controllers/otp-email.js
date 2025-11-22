import pgClient from "../../config/db.js";
import config from "config";
import httpStatus from "http-status";
import APIError from "../helpers/APIError.js";
import redisClient from "../../config/redis.mjs";
import sendGrid from "@sendgrid/mail";
let saltRounds = 10;
import bcrypt from 'bcrypt';

//  new version when we using the @sendgrid/mail npm package only
async function SendEmail(req, res, next) {
    try {
      const {  fullname, email } = req.body;
      const redisKey = `signup_${email}`;
  
      const isLoggedIn = await redisClient.get(redisKey);
      if (!isLoggedIn) {
        return next(new APIError("Please login first.", httpStatus.UNAUTHORIZED, true,true));
      }
  
      // Generate OTP
      const otp = await getRandomOTP( email);
  
     // Setup SendGrid
      let sg = sendGrid(config.get("App.sendgrid.api_key"));
  
      // Build request
            makeRequestEmail(
              sg,
              fullname,
              email,
              otp,
              function (request) {
                sg.API(request, function (error, response) {
                  if (response.statusCode == 202) {
                    res.json({
                      success: true,
                      message: "Verification link sent to your email id."
                    });
                  } else {
                    const err = new APIError( "Verification link not sent, Please try again.", httpStatus.INTERNAL_SERVER_ERROR, true, true );
                    next(err);
                  }
                });
              }
            );
    } catch (error) {//"email are not send sucessfull."||
      const err = new APIError( error, httpStatus.OK, true,true);
        return next(err);
    }
  }
  
  function makeRequestEmail(sg, fullname, email, otp, cb) {
    let request = sg.emptyRequest();
    request.body = {
      content: [
        {
          type: "text/html",
          value: " <span> " + fullname + " </span>"
        }
      ],
      from: {
        email: "gsebht@gmail.com",
        name: "GSEB Science (Practical) Hall Ticket"
      },
      headers: {},
      mail_settings: {
        bypass_list_management: {
          enable: true
        },
        sandbox_mode: {
          enable: false
        }
      },
  
      personalizations: [
        {
          substitutions: {
            "%otp%": " " + otp + " "
          },
          to: [
            {
              email: email
            }
          ]
        }
      ],
      template_id: config.get("App.sendgrid.template_id"),
  
      tracking_settings: {
        click_tracking: {
          enable: true,
          enable_text: true
        },
        ganalytics: {
          enable: true,
          utm_campaign: "[NAME OF YOUR REFERRER SOURCE]",
          utm_content: "[USE THIS SPACE TO DIFFERENTIATE YOUR EMAIL FROM ADS]",
          utm_medium: "[NAME OF YOUR MARKETING MEDIUM e.g. email]",
          utm_name: "[NAME OF YOUR CAMPAIGN]",
          utm_term: "[IDENTIFY PAID KEYWORDS HERE]"
        },
        open_tracking: {
          enable: true,
          substitution_tag: "%opentrack"
        }
      }
    };
    request.method = "POST";
    request.path = "/v3/mail/send";
    cb(request);
  }
  
  // new version of send otp function code with new redis
  
  async function SendOTP(req, res, next) {
    try {
      const mobile = req.body.mobile;
 
   if (!mobile) {
        const err = new APIError("Please signup first your mobile number not meet.", httpStatus.OK, true ,true);
        return next(err);
      }
      const redisKey = `signup_${mobile}`;
      const isLoggedIn = await redisClient.get(redisKey);
  
      if (!isLoggedIn) {
        const err = new APIError("Please signup first.", httpStatus.OK, true ,true);
        return next(err);
      }
  
      try {
        const otp = await getRandomOTP(mobile);
  
        const formData = {
          To: parseInt(mobile),
          From: config.get("App.2faSms.senderId")
        };
  
        if (mobile) {
          formData.VAR1 = mobile;
          formData.VAR2 = otp;
          formData.VAR3 = getTimeInIst();
          formData.TemplateName = config.get("App.2faSms.schoolOtpTemplate");
        } else {
          formData.TemplateName = config.get("App.2faSms.boardOtpTemplate");
          formData.VAR1 = otp;
        }
  
        if (!process.env.NODE_ENV || process.env.NODE_ENV === "development") {
          console.log('OTP ==> ' + otp);
          return res.json({
            success: true,
            message: `${otp}, OTP sent to your mobile number ${mobile}.`
          });
        }
  
        // const url =
        //   "https://2factor.in/API/R1/?module=TRANS_SMS" +
        //   "&apikey=" + config.get("App.2faSms.apiKey") +
        //   "&to=" + formData.To +
        //   "&from=" + formData.From +
        //   "&templatename=" + formData.TemplateName +
        //   "&var1=" + formData.VAR1 +
        //   (formData.VAR2 ? "&var2=" + formData.VAR2 : "") +
        //   (formData.VAR3 ? "&var3=" + formData.VAR3 : "");
  
        // const response = await axios.get(url)
  
          if (response.status === 200) {
            return res.json({
              success: true,
              message: ` OTP sent to your mobile number ${mobile}.`,
              otp: otp,
            });
          }
  
          return res.status(500).json({
            success : false
          })
  
      } catch (error) {
        next(error);
      }
  
    } catch (error) {
      next(error);
    }
  }
  
  // new version of code with redis data
  async function getRandomOTP( mobile) {
    const otp = Math.floor(Math.random() * 900000) + 100000;
    const redisKey = `otp_${mobile}`;
  
    try {
      const existing = await redisClient.get(redisKey);
      if (existing) {
        await redisClient.del(redisKey);
      }
  
      await redisClient.set(redisKey, otp.toString()); // store as string
      await redisClient.expire(redisKey, 600); // 10 minutes
  
      return otp;
  
    } catch (error) {
      throw new APIError( "OTP not sent. Please try again.", httpStatus.OK, true, true );
    }
  }
  
  
  /**
   * returns current date/time in IST format
   * @return {[type]} [date time]
   */
  function getTimeInIst() {
    var currentTime = new Date();
    var currentOffset = currentTime.getTimezoneOffset();
    var ISTOffset = 330; // IST offset UTC +5:30
    var ISTTime = new Date(
      currentTime.getTime() + (ISTOffset + currentOffset) * 60000
    );
    return ISTTime.toLocaleString();
  }


  async function getHashPassword(password) {
    try {
        const hash = await bcrypt.hash(password, saltRounds);
        return hash
    } catch (error) {
        throw error;
    }
}

async function comparePassword(userPassword, dbPassword) {
  try {
    console.log("userPassword",userPassword,dbPassword)
      const isMatch = await bcrypt.compare(userPassword, dbPassword);

      if (!isMatch) {
          return false;
      }
      return true;
  } catch (error) {
      throw new APIError(error, httpStatus.UNAUTHORIZED, true, true);
  }

}
  
export default { SendEmail,SendOTP,getHashPassword,comparePassword};