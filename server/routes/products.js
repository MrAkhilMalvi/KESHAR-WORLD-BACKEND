import express from "express";
import couresCtrl from "../controllers/products.js";
import auth from "../helpers/auth.js";

const coures = express.Router();

coures.route("/allproduct").get(couresCtrl.getAllProducts);//auth.verifyToken,
coures.route("/get/images").post(couresCtrl.get_products_images);//auth.verifyToken,

export default coures;