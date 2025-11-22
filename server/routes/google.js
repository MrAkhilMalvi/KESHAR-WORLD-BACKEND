import express from "express";
import passport from "../helpers/google.js";
import  auth  from "../helpers/auth.js";
import  googleCtrl  from "../controllers/google.js";
import pgClient from "../../config/db.js";

const google = express.Router();

google.get("/google", passport.authenticate("google", { scope: ["profile", "email"] }));

google.get("/google/callback",passport.authenticate("google", { session: false }),googleCtrl.callback);

google.post("/set-password", googleCtrl.setPassword);


export default google;
