// server/server.js
import express from "express";
import session from "express-session";
import passport from "passport";
import cookieParser from "cookie-parser";
import compression from "compression";
import methodOverride from "method-override";
import httpStatus from "http-status";
import expressWinston from "express-winston";
import helmet from "helmet";
import cors from "cors";
import morgan from "morgan";
import redisClient from "../config/redis.mjs";
import winstonInstance from "./winston.js";
import routes from "./routes/index.js";
import { isCelebrateError } from "celebrate";
import APIError from "./helpers/APIError.js";
import stripewebhook from "./controllers/payment.js"
import dotenv from "dotenv";
dotenv.config();
console.log(process.env.DB_HOST);    
const app = express();
const isDev = process.env.NODE_ENV !== "production";

// Stripe webhook must use raw body

/* Logging in dev mode */
if (isDev) {
  app.use(morgan("dev"));
}

/* CORS */
app.use(
  cors({
    origin: [
      "http://localhost:8080",
      "http://192.168.0.67:3003",
      "http://192.168.0.42:8080",
      "http://localhost:5179",
    ],
    credentials: true,
  })
);

/* Trust proxy if deployed (important for secure cookies behind proxies) */
if (!isDev) {
  app.set("trust proxy", 1);
}
// 1️⃣ Stripe webhook should be at top BEFORE any body parser
app.post(
  "api/payment/stripe/webhook",
  express.raw({ type: "application/json" }),
  stripewebhook.stripeWebhook
);
/* Built-in Express body parsing (Express 5) */
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ extended: true }));

/* Cookie Parser */
app.use(cookieParser());

/* Redis Store — support both older connect-redis style and newer exports */
let RedisStore;
try {
  // connectRedis(session) returns a Store constructor for many connect-redis versions
  RedisStore = redisClient(session);
} catch (e) {
  // Fallback: some versions export { RedisStore } — try that
  // eslint-disable-next-line no-underscore-dangle
  RedisStore = redisClient?.RedisStore ?? null;
}

// if (!RedisStore) {
//   console.warn("Warning: RedisStore not detected. Sessions may fail.");
// }

/* Create store instance */
const store = RedisStore
  ? new RedisStore({
      client: redisClient,
      prefix: "sess:",
    })
  : undefined;

/* Session */
app.use(
  session({
    store,
    secret: process.env.SESSION_SECRET || "Lionking9",
    resave: false,
    saveUninitialized: false,
    rolling: true,
    cookie: {
      maxAge: 1000 * 60 * 60, // 1 hour
      secure: !isDev, // true in prod (HTTPS)
      httpOnly: true,
      sameSite: isDev ? "lax" : "none",
    },
  })
);

/* Passport */
app.use(passport.initialize());
app.use(passport.session());

/* Performance + Security */
app.use(compression());
app.use(methodOverride());
app.use(
  helmet({
    frameguard: { action: "deny" },
    contentSecurityPolicy: false, // set a real CSP later
  })
);

/* Mount API routes (make sure routes/index.js exports an Express router) */
app.use("/api", routes);

/* Celebrate Validation Error Handler (must be error-handling middleware signature) */
app.use((err, req, res, next) => {
  if (isCelebrateError(err)) {
    const messages = [];
    for (const [, joiError] of err.details.entries()) {
      messages.push(...joiError.details.map((e) => e.message));
    }
    return next(new APIError(messages.join(". "), 400, true));
  }

  if (!(err instanceof APIError)) {
    return next(new APIError(err.message || "Internal error", err.status || 500, false));
  }

  return next(err);
});

/* 404 Handler — should come after routes */
app.use((req, res, next) => {
  next(new APIError("API not found", httpStatus.NOT_FOUND,true));
});

/* Error logger — logs errors that reach this middleware (works in prod) */
if (!isDev) {
  app.use(
    expressWinston.errorLogger({
      winstonInstance,
      msg:
        "{method:{{req.method}},url:{{req.url}},userId:{{req.user?.id}},userAgent:{{req.headers['user-agent']}},statusCode:{{res.statusCode}},responseTime:{{res.responseTime}}ms,remoteAddress:{{req.ip}}}",
      colorize: true,
    })
  );
}

/* Final Error Handler */
app.use((err, req, res, next) => {
  const status = err.status || 500;
  const payload = {
    success: false,
    message: err.isPublic ? err.message : "Something went wrong. Please try again.",
  };
  if (isDev) payload.stack = err.stack;
  if (err.isDialog) payload.isDialog = true;
  res.status(status).json(payload);
});

export default app;
