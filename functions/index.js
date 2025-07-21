// 📦 Imports para API modular v2
const { defineSecret } = require("firebase-functions/params");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
//const { onCall } = require("firebase-functions/v2/https");
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

// ✅ Define secrets
const PAYPAL_CLIENT_ID = defineSecret("PAYPAL_CLIENT_ID");
const PAYPAL_SECRET = defineSecret("PAYPAL_SECRET");




// ✅ getPaypalCredentials: devuelve las credenciales seguras
exports.getPaypalCredentials = onCall(
  {
    secrets: [PAYPAL_CLIENT_ID, PAYPAL_SECRET],
  },
  (request) => {
    const clientId = PAYPAL_CLIENT_ID.value();
    const secretKey = PAYPAL_SECRET.value();

    console.log("🔑 PAYPAL_CLIENT_ID:", clientId);
    console.log("🔑 PAYPAL_SECRET:", secretKey);

    return {
      clientId,
      secretKey,
    };
  }
);


// ✅ deleteUser: solo admin o superadmin puede eliminar usuarios
// ✅ deleteUser (corregido)
exports.deleteUser = onCall(async (data, context) => {
  const email = data.email;
  console.log("👤 Intentando eliminar usuario:", email);
  console.log("✅ context.auth.token:", context.auth?.token);

  if (
    !context.auth ||
    !context.auth.token ||
    (!context.auth.token.admin && !context.auth.token.superadmin)
  ) {
    console.log("🚫 Permiso denegado para:", context.auth?.token?.email);
    throw new HttpsError(
      "permission-denied",
      "Only admins can delete users."
    );
  }

  try {
    const userRecord = await auth.getUserByEmail(email);
    console.log("🔍 Usuario encontrado:", userRecord.uid);

    const uid = userRecord.uid;
    await auth.deleteUser(uid);
    console.log("🗑️ Usuario eliminado de Authentication");

    await db.collection("users").doc(email).delete();
    console.log("🗑️ Documento en Firestore eliminado");

    const postsSnapshot = await db
      .collection("posts")
      .where("UserEmail", "==", email)
      .get();

    const batch = db.batch();
    postsSnapshot.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();
    console.log("🗑️ Posts eliminados");

    return { message: `User ${email} and their data deleted successfully.` };
  } catch (error) {
    console.error("❌ Error deleting user:", error);

    if (error.code === "auth/user-not-found") {
      throw new HttpsError("not-found", "The user does not exist.");
    }

    throw new HttpsError("internal", "User deletion failed: " + error.message);
  }
});


// ✅ setAdminRole (corregido)
exports.setAdminRole = onCall(async (data, context) => {
  if (!context.auth || !context.auth.token || !context.auth.token.superadmin) {
    throw new HttpsError(
      "permission-denied",
      "Only superadmins can assign roles."
    );
  }

  const uid = data.uid;

  try {
    await auth.setCustomUserClaims(uid, { admin: true, superadmin: true });
    return { message: `✅ Admin role assigned to UID: ${uid}` };
  } catch (error) {
    console.error("Error assigning admin role:", error);
    throw new HttpsError("internal", "Failed to assign admin role: " + error.message);
  }
});

// ✅ sendPostNotification: al crear post, notifica a todos los usuarios con token
// ✅ sendPostNotification: al crear post, notifica a todos los usuarios con token
exports.sendPostNotificationGlobal = onDocumentCreated("posts/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.User ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const token = userData.token;
    if (!token) continue;

    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Actualizar Firestore
    await doc.ref.update({ badgeCount: newBadge });

    const message = {
      token,
      data: {
        title: `${authorName}`,
        body: content.slice(0, 100) + (content.length > 100 ? "…" : ""),
      },
      android: {
        priority: "high",
      },
      apns: {
        headers: { "apns-priority": "10" },
        payload: {
          aps: {
            contentAvailable: true,
            sound: "default",
            badge: newBadge,
          },
        },
      },
    };

    await messaging.send(message);
  }
});



//////////////////CORTE Y CONFECCION 2////////////////////////

exports.sendClassPostNotificationCorte2 = onDocumentCreated("postsCorte2/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.Corte2 === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Obtener y actualizar el badgeCount actual
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Guardar el nuevo badgeCount en Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Crear notificación individual con badge personalizado
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones Corte2 enviadas: ${successCount}/${usersSnap.size}`);
});


//////////////////CORTE Y CONFECCION 1////////////////////////

exports.sendClassPostNotificationCorte1 = onDocumentCreated("postsCorte1/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.Corte1 === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Obtener y actualizar el badgeCount actual
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Guardar el nuevo badgeCount en Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Crear notificación individual con badge personalizado
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones Corte1 enviadas: ${successCount}/${usersSnap.size}`);
});

//////////////////ESL Clifton////////////////////////

exports.sendClassPostNotificationESLclifton = onDocumentCreated("postsESLclifton/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.ESLclifton === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Obtener y actualizar el badgeCount actual
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Guardar el nuevo badgeCount en Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Crear notificación individual con badge personalizado
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones ESLclifton enviadas: ${successCount}/${usersSnap.size}`);
});

//////////////////ESL PM////////////////////////

exports.sendClassPostNotification = onDocumentCreated("postsESL/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.ESLpm === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Obtener y actualizar el badgeCount actual
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Guardar el nuevo badgeCount en Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Crear notificación individual con badge personalizado
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones ESLpm enviadas: ${successCount}/${usersSnap.size}`);
});



/////////////////ESL PM2//////////////////////

exports.sendClassPostNotificationESLpm2 = onDocumentCreated("postsESLpm2/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.ESLpm2 === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Obtener el valor actual del badge
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Actualizar el badge en Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Enviar notificación individualizada
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones ESLpm2 enviadas: ${successCount}/${usersSnap.size}`);
});



/////////////////ESL AM//////////////////////

exports.sendClassPostNotificationESLam = onDocumentCreated("postsESLam/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.ESLam === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Obtener y actualizar el contador actual
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Guardar en Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Enviar notificación con badge personalizado
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones ESLam enviadas: ${successCount}/${usersSnap.size}`);
});



/////////////////ESL AM2//////////////////////

exports.sendClassPostNotificationESLam2 = onDocumentCreated("postsESLam2/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.ESLam2 === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Obtener el badge actual
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Actualizar Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Enviar notificación personalizada
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones ESLam2 enviadas: ${successCount}/${usersSnap.size}`);
});



//////////////////GED PM//////////////////////

exports.sendClassPostNotificationGED = onDocumentCreated("postsGED/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.GEDpm === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Obtener el badge actual
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Actualizar Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Enviar notificación con badge individual
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones GED enviadas: ${successCount}/${usersSnap.size}`);
});



//////////////////GED AM/////////////////////

exports.sendClassPostNotificationGEDam = onDocumentCreated("postsGEDam/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.GEDam === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    // 🔢 Leer el contador actual y aumentarlo
    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    // 📝 Guardar el nuevo badge en Firestore
    await doc.ref.update({ badgeCount: newBadge });

    // 🔔 Crear y enviar notificación individual
    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones GEDam enviadas: ${successCount}/${usersSnap.size}`);
});



//////////////////CHICK/////////////////////

exports.sendClassPostNotificationChick = onDocumentCreated("postschick/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.ESLchick === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    await doc.ref.update({ badgeCount: newBadge });

    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones ESLchick enviadas: ${successCount}/${usersSnap.size}`);
});



//////////////////CIUDADANIA/////////////////////

exports.sendClassPostNotificationCiudadania = onDocumentCreated("postsCiudadania/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.ciudadania === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    await doc.ref.update({ badgeCount: newBadge });

    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones Ciudadanía enviadas: ${successCount}/${usersSnap.size}`);
});



//////////////////COSTURA AM/////////////////////

exports.sendClassPostNotificationCostura = onDocumentCreated("postsCostura/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.costuraAM === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    await doc.ref.update({ badgeCount: newBadge });

    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones Costura enviadas: ${successCount}/${usersSnap.size}`);
});



//////////////////COSMETOLOGIA/////////////////////

exports.sendClassPostNotificationCosmetologia = onDocumentCreated("postsCosmetologia/{postId}", async (event) => {
  const post = event.data?.data();
  if (!post) return;

  const content = post.Comment ?? "";
  const authorName = post.Name ?? "La Puerta";

  const usersSnap = await db.collection("users").get();

  let successCount = 0;

  for (const doc of usersSnap.docs) {
    const userData = doc.data();
    const isEnrolled = userData.cosmetologia === "inscrito";
    const token = userData.token;

    if (!isEnrolled || !token) continue;

    const currentBadge = userData.badgeCount ?? 0;
    const newBadge = currentBadge + 1;

    await doc.ref.update({ badgeCount: newBadge });

    const message = {
      token,
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
            badge: newBadge,
          },
        },
      },
    };

    try {
      await messaging.send(message);
      successCount++;
    } catch (err) {
      console.error(`❌ Error al enviar a ${doc.id}:`, err);
    }
  }

  console.log(`✅ Notificaciones Cosmetología enviadas: ${successCount}/${usersSnap.size}`);
});



















