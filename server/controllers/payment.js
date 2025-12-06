import Stripe from "stripe";
import pgClient from "../../config/db.js";
import { v4 as uuidv4 } from "uuid";

const stripe = new Stripe(process.env.STRIPE_SECRET);

// Create Checkout Session
async function createCheckoutSession(req, res) {
    try {
        const { purchase_type, user_id } = req.body;

        let line_items = [];
        let metadata = { purchase_type, user_id };

        // -------------------------------
        // COURSE PURCHASE
        // -------------------------------
        if (purchase_type === "course") {
            const { course_id, course_title, price } = req.body;

            line_items.push({
                price_data: {
                    currency: "inr",
                    product_data: { name: course_title },
                    unit_amount: price * 100
                },
                quantity: 1
            });

            metadata.course_id = course_id;
        }

        // -------------------------------
        // PRODUCT PURCHASE (MULTIPLE ITEMS)
        // -------------------------------
        if (purchase_type === "product") {
            const { items } = req.body; // array of products

            items.forEach((item, index) => {
                line_items.push({
                    price_data: {
                        currency: "inr",
                        product_data: { name: item.name },
                        unit_amount: item.price * 100
                    },
                    quantity: item.qty
                });

                // pass each product id dynamically
                metadata[`product_${index}`] = item.id;
                metadata[`qty_${index}`] = item.qty;
            });

            metadata.item_count = items.length;
        }

        const session = await stripe.checkout.sessions.create({
            mode: "payment",
            payment_method_types: ["card"],
            line_items,
            success_url: `${process.env.CLIENT_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
            cancel_url: `${process.env.CLIENT_URL}/cancel`,
            metadata
        });

        res.json({ id: session.id, url: session.url });

    } catch (error) {
        console.error(error.message);
        res.status(500).json({ error: "Stripe error" });
    }
}


// Stripe Webhook
// async function stripeWebhook(req, res) {
//     const sig = req.headers["stripe-signature"];
//     let event;

//     try {
//         event = stripe.webhooks.constructEvent(
//             req.body,
//             sig,
//             process.env.STRIPE_WEBHOOK_SECRET
//         );
//     } catch (err) {
//         return res.status(400).send(`Webhook Error: ${err.message}`);
//     }

//     if (event.type === "checkout.session.completed") {
//         const session = event.data.object;
//         const meta = session.metadata;

//         const purchaseType = meta.purchase_type;
//         const userId = meta.user_id;

//         // ----------------------------
//         // PROCESS COURSE PURCHASE
//         // ----------------------------
//         if (purchaseType === "course") {
//             const courseId = meta.course_id;

//             await pgClient.query(
//                 "SELECT * FROM user_purchase_course ($1,$2,$3,$4)",
//                 [userId, courseId, session.payment_intent, session.payment_status]
//             );

//             console.log("Course purchase done successfully");
//         }

//         // ----------------------------
//         // PROCESS PRODUCT PURCHASE
//         // ----------------------------
//         if (purchaseType === "product") {
//             const itemCount = parseInt(meta.item_count);

//             for (let i = 0; i < itemCount; i++) {
//                 const productId = meta[`product_${i}`];
//                 const qty = meta[`qty_${i}`];

//                 await pgClient.query(
//                     "SELECT * FROM user_purchase_product ($1,$2,$3,$4,$5)",
//                     [userId, productId, qty, session.payment_intent, session.payment_status]
//                 );
//             }

//             console.log("Product purchase saved successfully");
//         }
//     }

//     res.json({ received: true });
// }




async function stripeWebhook(req, res) {
    const sig = req.headers["stripe-signature"];
    let event;

    try {
        event = stripe.webhooks.constructEvent(
            req.body,
            sig,
            process.env.STRIPE_WEBHOOK_SECRET
        );
    } catch (err) {
        return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    if (event.type === "checkout.session.completed") {
        const session = event.data.object;
        const meta = session.metadata;

        const purchaseType = meta.purchase_type;
        const userId = meta.user_id;

        // --------------------------------------
        // COURSE PURCHASE
        // --------------------------------------
        if (purchaseType === "course") {
            await pgClient.query(
                "SELECT * FROM user_purchase_course ($1,$2,$3,$4)",
                [
                    userId,
                    meta.course_id,
                    session.payment_intent,
                    session.payment_status
                ]
            );
            return res.json({ received: true });
        }

        // --------------------------------------
        // PRODUCT PURCHASE WITH GST
        // --------------------------------------
        if (purchaseType === "product") {

            const itemCount = Number(meta.item_count);
            const order_id = uuidv4();

            let subtotal = 0;
            let gst_total = 0;
            let products = [];

            for (let i = 0; i < itemCount; i++) {

                let productId = meta[`product_${i}`];
                let qty = Number(meta[`qty_${i}`]);

                const { rows } = await pgClient.query(
                    "SELECT * FROM student_payment_gst_details($1,$2)",
                    [productId, qty]
                );

                if (!rows.length) continue;

                const {
                    price,
                    gst_percent,
                    amount_before_gst,
                    gst_amount,
                    amount_with_gst
                } = rows[0];

                subtotal += Number(amount_before_gst);
                gst_total += Number(gst_amount);

                products.push({
                    id: productId,
                    qty,
                    price,
                    gst_percent,
                    amount_before_gst,
                    gst_amount,
                    amount_with_gst
                });

                await pgClient.query(
                    "SELECT student_product_order_item_insert($1,$2,$3,$4,$5,$6,$7,$8)",
                    [
                        order_id,
                        productId,
                        qty,
                        price,
                        gst_percent,
                        amount_before_gst,
                        gst_amount,
                        amount_with_gst
                    ]
                );
            }

            const total_amount = subtotal + gst_total;

            await pgClient.query(
                "SELECT student_product_order_insert($1,$2,$3,$4,$5,$6,$7)",
                [
                    order_id,
                    userId,
                    session.payment_intent,
                    subtotal,
                    gst_total,
                    total_amount,
                    JSON.stringify(products)
                ]
            );

            console.log("Product order with GST saved successfully");

            return res.json({ received: true });
        }
    }

    return res.json({ received: true });
}

export default {createCheckoutSession,stripeWebhook};