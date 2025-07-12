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
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
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
        'ESLam': '',
        'GEDpm': '',
        'GEDam': '',
        'costuraAM': '',
        'ciudadania': '',
        'cosmetologia': '',
        'feed': '',
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


