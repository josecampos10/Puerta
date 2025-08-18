import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalProfesoresContainer extends StatefulWidget {
  const TotalProfesoresContainer({super.key});

  @override
  State<TotalProfesoresContainer> createState() =>
      _TotalProfesoresContainerState();
}

class _TotalProfesoresContainerState
    extends State<TotalProfesoresContainer> {
  int totalEstudiantes = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarTotal();
  }

  Future<void> cargarTotal() async {
    final total = await contarEstudiantes();
    setState(() {
      totalEstudiantes = total;
      isLoading = false;
    });
  }

  Future<int> contarEstudiantes() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Profesor')
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
                  '$totalEstudiantes',
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            );
  
  }
}
