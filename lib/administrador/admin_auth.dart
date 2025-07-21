import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

User? get currentUser => _firebaseAuth.currentUser;

Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

Future<void> adminsignInWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    // 1. Iniciar sesión
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    final userEmail = user?.email;

    if (userEmail == null) {
      debugPrint('❌ No se pudo obtener el email del usuario autenticado.');
      return;
    }

    // 2. Solicitar permisos de notificación en iOS
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. Obtener el token FCM
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      debugPrint('❌ El token FCM es null, no se actualizará en Firestore.');
      return;
    }

    // 4. Guardar el token en Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .update({'token': fcmToken});

    debugPrint('✅ Token actualizado en Firestore: $fcmToken');

  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(
      msg: 'Correo o contraseña incorrectos',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
    debugPrint('⚠️ FirebaseAuthException: ${e.message}');
  } catch (e) {
    debugPrint('⚠️ Error general al iniciar sesión: $e');
  }
    
}

Future<void> admincreateUserWithEmailAndPassword({
  required String name,
  required String email,
  required String password,
}) async {
  //UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  //User? user = result.user;

  
  await FirebaseFirestore.instance.collection('users').doc(email).set({
    'name': name,
    'email': email,
    'password': password
  });
  await _firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: password
  );
  
}

Future<void> signOut() async {
  await _firebaseAuth.signOut();
}

}