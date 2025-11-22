import Stripe from "stripe";
const stripe = new Stripe(process.env.STRIPE_SECRET);

export const createCheckoutSession = async (req, res) => {
    try {
        const { user_id, course_id, course_title, price } = req.body;

        const session = await stripe.checkout.sessions.create({
            mode: "payment",

            payment_method_types: [
                "card",       // credit/debit cards + Google Pay
                "upi",        // UPI apps (GPay, PhonePe, Paytm)
                "netbanking", // Indian Net Banking
            ],

            line_items: [
                {
                    price_data: {
                        currency: "inr",
                        product_data: {
                            name: course_title
                        },
                        unit_amount: price * 100  // ₹ → paise
                    },
                    quantity: 1
                }
            ],

            success_url:
                "https://yourwebsite.com/payment-success?session_id={CHECKOUT_SESSION_ID}",
            cancel_url:
                "https://yourwebsite.com/payment-failed",

            metadata: {
                user_id,
                course_id
            }
        });

        return res.json({
            id: session.id,
            url: session.url
        });

    } catch (error) {
        console.error("Stripe Checkout Error:", error.message);
        return res.status(500).json({ error: "Stripe error" });
    }
};
