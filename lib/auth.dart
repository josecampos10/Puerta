import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

 Future<void> signInWithEmailAndPassword({
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


  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String rol,
    
  }) async {
    //UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    //User? user = result.user;
    try {
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'phone': 'Sin número',
        'password': password,
        'rol': rol,
        'ESLpm': '',
        'ESLpm2': '',
        'ESLam': '',
        'ESLam2': '',
        'GEDpm': '',
        'GEDam': '',
        'costuraAM': '',
        'ciudadania': '',
        'cosmetologia': '',
        'feed': '',
        'ESLchick': '',
      
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsESL_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsESpm2L_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsESLam_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsESLam2_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsGEDpm_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsGEDam_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsCosturaAM_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsCiudadania_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsCosmetologia_State').doc('State').set({
        'lastpost': '',
      });
      await FirebaseFirestore.instance.collection('users').doc(email).collection('postsESLchick_State').doc('State').set({
        'lastpost': '',
      });

      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .update({'token': await FirebaseMessaging.instance.getToken()});
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: 'Correo o contraseña incorrectos',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      if(e.message.toString() == ''){
        
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}


