import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendNotification = functions.firestore
    .document("chat/{chatId}")
    .onCreate(async (snapshot) => {
      const message = snapshot.data();
      let messageText = "";
      let receiver = "";
      if (message) {
        messageText = message.text;
        receiver = message.receiver;
      }

      const tokenSnapshot = await db
          .collection("users")
          .doc(receiver)
          .get();
      const tokenData = tokenSnapshot.data();
      let token = "";
      if (tokenData) {
        token = tokenData.token;
      }

      const notification: admin.messaging.MessagingPayload = {
        notification: {
          title: "Together",
          body: messageText,
        },
      };

      return fcm.sendToDevice(token, notification);
    });
