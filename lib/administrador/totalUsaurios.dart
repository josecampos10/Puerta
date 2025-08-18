import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalUsuariosContainer extends StatefulWidget {
  const TotalUsuariosContainer({super.key});

  @override
  State<TotalUsuariosContainer> createState() =>
      _TotalUsuariosContainerState();
}

class _TotalUsuariosContainerState extends State<TotalUsuariosContainer> {
  int totalUsuarios = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarTotal();
  }

  Future<void> cargarTotal() async {
    final total = await contarUsuariosTotales();
    setState(() {
      totalUsuarios = total;
      isLoading = false;
    });
  }

  Future<int> contarUsuariosTotales() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  isLoading
          ? const CircularProgressIndicator()
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Text(
                  '$totalUsuarios',
                  style: TextStyle(fontSize: 32),
                ),
              ],
            );
    
  }
}
