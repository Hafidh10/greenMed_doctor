const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Triggers a push notification whenever a new health check is submitted.
 */
exports.notifyOnNewHealthCheck = functions.firestore
    .document("health_checks/{healthCheckId}")
    .onCreate(async (snap) => {
      const healthCheck = snap.data();

      const payload = {
        notification: {
          title: "New Health Check Submitted",
          body: "A new check from patient " + healthCheck.userId +
                " is ready for review.",
          sound: "default",
        },
        topic: "new_health_checks",
      };

      try {
        await admin.messaging().send(payload);
        console.log("Successfully sent notification.");
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });
