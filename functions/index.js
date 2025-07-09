const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  const email = data.email;

  // Check if caller is an admin
  if (!(context.auth && context.auth.token && context.auth.token.admin === true)) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete users."
    );
  }

  try {
    // Get the user's UID using their email
    const userRecord = await admin.auth().getUserByEmail(email);
    const uid = userRecord.uid;

    // Delete from Firebase Authentication
    await admin.auth().deleteUser(uid);

    // Delete from Firestore using email as document ID
    await admin.firestore().collection("users").doc(email).delete();

    return { message: `User ${email} deleted successfully.` };
  } catch (error) {
    console.error("Error deleting user:", error);
    throw new functions.https.HttpsError(
      "internal",
      "User deletion failed",
      error
    );
  }
});
