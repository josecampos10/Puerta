import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapuerta2/loginCheck.dart';
import 'package:lapuerta2/mainwrapper.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final authStream = FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.tertiary, // Evita pantalla negra
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user != null) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.email)
                .get(),
            builder: (context, snapshotDoc) {
              if (snapshotDoc.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshotDoc.hasData && snapshotDoc.data!.exists) {
                // Usuario válido
                if (user.email != 'admin@lapuertawaco.com') {
                  return const Mainwrapper();
                } else {
                  return const LoginNow(); // Puedes cambiar si admin va a otro lugar
                }
              } else {
                // 🔐 Usuario sin documento en Firestore: cerrar sesión
                FirebaseAuth.instance.signOut();
                return const LoginNow();
              }
            },
          );
        } else {
          return const LoginNow(); // No autenticado
        }
      },
    );
  }
}



