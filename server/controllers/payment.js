import Stripe from "stripe";
import pgClient from "../../config/db.js";

const stripe = new Stripe(process.env.STRIPE_SECRET);

// Create Checkout Session
 async function createCheckoutSession(req, res) {
    try {
        const { user_id, course_id, course_title, price } = req.body;

        const session = await stripe.checkout.sessions.create({
            mode: "payment",
            payment_method_types: ["card"], 

            line_items: [{
                price_data: {
                    currency: "inr",
                    product_data: { name: course_title },
                    unit_amount: price * 100
                },
                quantity: 1
            }],

            success_url: `${process.env.CLIENT_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
            cancel_url: `${process.env.CLIENT_URL}/cancel`,

            metadata: { user_id, course_id }
        });

        return res.json({ id: session.id, url: session.url });

    } catch (error) {
        console.error(error.message);
        return res.status(500).json({ error: "Stripe error" });
    }
}

// Stripe Webhook
 async function stripeWebhook(req, res) {
    const sig = req.headers["stripe-signature"];

    let event;

    try {
        event = stripe.webhooks.constructEvent(
            req.body,   // RAW BODY
            sig,
            process.env.STRIPE_WEBHOOK_SECRET
        );
    } catch (err) {
        console.log("Webhook Error:", err.message);
        return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    if (event.type === "checkout.session.completed") {
        const session = event.data.object;

        const userId = session.metadata.user_id;
        const courseId = session.metadata.course_id;

        const result = await pgClient.query("SELECT * FROM user_purchase_course ($1,$2,$3,$4)",
            [userId,courseId, session.payment_intent,session.payment_status]);

        // // create order
        // await pgClient.query(
        //     `INSERT INTO orders (user_id, course_id, payment_id, amount, status)
        //      VALUES ($1, $2, $3, $4, $5)`,
        //     [
        //         userId,
        //         courseId,
        //         session.payment_intent,
        //         session.amount_total ,
        //         "success"
        //     ]
        // );

        // // give access for 1 year
        // await pgClient.query(
        //     `INSERT INTO user_courses (user_id, course_id, access_end)
        //      VALUES ($1, $2, NOW() + INTERVAL '365 days')
        //      ON CONFLICT (user_id, course_id)
        //      DO UPDATE SET access_end = EXCLUDED.access_end`,
        //     [userId, courseId]
        // );

        console.log("Payment success → access given!");
    }

    res.json({ received: true });
}


export default {createCheckoutSession,stripeWebhook};