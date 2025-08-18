import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalStaffContainer extends StatefulWidget {
  const TotalStaffContainer({super.key});

  @override
  State<TotalStaffContainer> createState() => _TotalStaffContainerState();
}

class _TotalStaffContainerState extends State<TotalStaffContainer> {
  int totalStaff = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarTotal();
  }

  Future<void> cargarTotal() async {
    final total = await contarStaff();
    setState(() {
      totalStaff = total;
      isLoading = false;
    });
  }

  Future<int> contarStaff() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Staff')
        .get();

    return querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Text(
                  '$totalStaff',
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            );
    
  }
}
