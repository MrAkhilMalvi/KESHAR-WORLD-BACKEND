import express from "express";
import paymentCtrl from "../controllers/payment.js";

const payment = express.Router();


// Create Checkout
payment.post("/create-checkout-session", paymentCtrl.createCheckoutSession);

// Webhook (RAW BODY REQUIRED)
payment.route("/stripe/webhook").post(express.raw({ type: "application/json" }),paymentCtrl.stripeWebhook);


export default payment;
