import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});
  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
    final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 99, 128, 1),
      appBar: AppBar(
        bottomOpacity: 0.0,
        toolbarHeight: size.width * 0.17,
        leadingWidth: size.width * 0.17,
        leading: Container(
          padding: EdgeInsets.all(size.width * 0.015),
          width: size.width * 0.2,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(0, 240, 195, 195),
            child: Image.asset(
              'assets/img/logo.png',
              fit: BoxFit.scaleDown,
              scale: size.height * 0.008,
              color: Colors.white,
            ),
          ),
        ),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: Text(
              'Centro de Control',
            )),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Color.fromRGBO(4, 99, 128, 1),
        actions: [],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          reverse: false,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
