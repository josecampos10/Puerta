import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalVoluntariosContainer extends StatefulWidget {
  const TotalVoluntariosContainer({super.key});

  @override
  State<TotalVoluntariosContainer> createState() =>
      _TotalVoluntariosContainerState();
}

class _TotalVoluntariosContainerState
    extends State<TotalVoluntariosContainer> {
  int totalVoluntarios = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarTotal();
  }

  Future<void> cargarTotal() async {
    final total = await contarVoluntarios();
    setState(() {
      totalVoluntarios = total;
      isLoading = false;
    });
  }

  Future<int> contarVoluntarios() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Voluntario')
        .get();

    return querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
          ? const CircularProgressIndicator()
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
               
                Text(
                  '$totalVoluntarios',
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            );
   
  }
}
