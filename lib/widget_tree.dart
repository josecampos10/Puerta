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
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // Si no está autenticado, ir al login
        if (user == null) {
          return const LoginNow();
        }

        // ⚠️ Aquí hacemos la doble validación:
        return FutureBuilder(
          future: _verifyUser(user),
          builder: (context, snapshotVerify) {
            if (snapshotVerify.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshotVerify.hasError || snapshotVerify.data == false) {
              return const LoginNow();
            }

            // ✅ Usuario válido y con documento
            return user.email != 'info@lapuertawaco.com'
                ? const Mainwrapper()
                : const LoginNow(); // o reemplaza por otro widget admin
          },
        );
      },
    );
  }

  /// ✅ Verifica que el usuario siga existiendo en Auth y Firestore
  Future<bool> _verifyUser(User user) async {
    try {
      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      // 🔒 Si ya no existe en Auth (fue borrado por admin)
      if (refreshedUser == null) {
        await FirebaseAuth.instance.signOut();
        return false;
      }

      // 🔍 Ahora verificamos Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(refreshedUser.email)
          .get();

      if (!doc.exists) {
        await FirebaseAuth.instance.signOut();
        return false;
      }

      return true;
    } catch (e) {
      print("❌ Error verificando usuario: $e");
      await FirebaseAuth.instance.signOut();
      return false;
    }
  }
}





/*if (snapshotDoc.hasData && snapshotDoc.data!.exists) {
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
              }*/



