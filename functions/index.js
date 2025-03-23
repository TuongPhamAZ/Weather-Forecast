const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();
const db = admin.firestore();

const transporter = nodemailer.createTransport({
    service: "Gmail",
    auth: { user: "personalschedulemanager@gmail.com", pass: "myocgxvnvsdybuhr" }
});

exports.sendConfirmation = functions.https.onRequest(async (req, res) => {
    const { email } = req.body;
    const confirmLink = `https://your-frontend-url/confirm-email?email=${email}`;

    await transporter.sendMail({
        from: "personalschedulemanager@gmail.com",
        to: email,
        subject: "Confirm Your Subscription",
        html: `<p>Click <a href="${confirmLink}">here</a> to confirm your subscription.</p>`
    });

    res.send({ message: "Confirmation email sent" });
});

exports.sendDailyWeather = functions.pubsub.schedule("every 24 hours").onRun(async () => {
    const subscribers = await db.collection("subscribers").where("confirmed", "==", true).get();

    for (const doc of subscribers.docs) {
        const email = doc.data().email;
        await transporter.sendMail({
            from: "personalschedulemanager@gmail.com",
            to: email,
            subject: "Your Daily Weather Forecast",
            html: `<p>Today's forecast: Sunny, 25°C.</p>`
        });
    }
});
