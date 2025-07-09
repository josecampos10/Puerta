import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

User? get currentUser => _firebaseAuth.currentUser;

Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

Future<void> adminsignInWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password
    );
    
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