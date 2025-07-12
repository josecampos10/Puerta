const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  console.log("✅ context.auth:", context.auth); // 👈 AGREGAR ESTO

  const email = data.email;

  if (!(context.auth &&
      context.auth.token &&
      (context.auth.token.admin === true || context.auth.token.superadmin === true))) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete users."
    );
  }

  try {
    const userRecord = await admin.auth().getUserByEmail(email);
    const uid = userRecord.uid;

    await admin.auth().deleteUser(uid);
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



exports.setAdminRole = functions.https.onCall(async (data, context) => {
  if (!(context.auth && context.auth.token && context.auth.token.superadmin === true)) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only superadmins can assign admin roles."
    );
  }

  const uid = data.uid;

  try {
    await admin.auth().setCustomUserClaims(uid, { admin: true, superadmin: true }); // ✅ AQUÍ
    return { message: `✅ Admin role assigned to UID: ${uid}` };
  } catch (error) {
    console.error("Error assigning admin role:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to assign admin role",
      error
    );
  }
});
