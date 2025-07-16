// 📦 Imports para API modular v2
const { onCall } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

// 🚀 Inicialización de Firebase Admin
initializeApp();
const auth = getAuth();
const db = getFirestore();
const messaging = getMessaging();

// ✅ deleteUser: solo admin o superadmin puede eliminar usuarios
exports.deleteUser = onCall(async (data, context) => {
  console.log("✅ context.auth:", context.auth);

  const email = data.email;

  if (
    !context.auth ||
    !context.auth.token ||
    (!context.auth.token.admin && !context.auth.token.superadmin)
  ) {
    throw new Error("permission-denied: Only admins can delete users.");
  }

  try {
    const userRecord = await auth.getUserByEmail(email);
    const uid = userRecord.uid;

    await auth.deleteUser(uid);
    await db.collection("users").doc(email).delete();

    return { message: `User ${email} deleted successfully.` };
  } catch (error) {
    console.error("Error deleting user:", error);
    throw new Error("internal: User deletion failed");
  }
});

// ✅ setAdminRole: solo superadmin puede asignar roles
exports.setAdminRole = onCall(async (data, context) => {
  if (
    !context.auth ||
    !context.auth.token ||
    !context.auth.token.superadmin
  ) {
    throw new Error("permission-denied: Only superadmins can assign roles.");
  }

  const uid = data.uid;

  try {
    await auth.setCustomUserClaims(uid, { admin: true, superadmin: true });
    return { message: `✅ Admin role assigned to UID: ${uid}` };
  } catch (error) {
    console.error("Error assigning admin role:", error);
    throw new Error("internal: Failed to assign admin role");
  }
});

// ✅ sendPostNotification: al crear post, notifica a todos los usuarios con token
// ✅ sendPostNotification: al crear post, notifica a todos los usuarios con token
exports.sendPostNotification = onDocumentCreated("posts/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.User ?? "La Puerta";

  const usersSnap = await db.collection("users").get();
  const tokens = usersSnap.docs
    .map(doc => doc.data().token)
    .filter(Boolean);

  if (tokens.length === 0) {
    console.log("❌ No hay tokens disponibles para enviar la notificación.");
    return;
  }

  const message = {
    tokens,
    data: {
      title: `${authorName}`,
      body: content.slice(0, 100) + (content.length > 100 ? "…" : ""),
    },
    android: {
      priority: "high",
    },
    apns: {
      headers: {
        "apns-priority": "10",
      },
      payload: {
        aps: {
          contentAvailable: true,
          sound: "default",
        },
      },
    },
  };

  try {
    const response = await messaging.sendEachForMulticast(message);
    console.log(`✅ Notificaciones enviadas: ${response.successCount}/${tokens.length}`);
    return response;
  } catch (err) {
    console.error("❌ Error al enviar notificaciones:", err);
    return;
  }
});








