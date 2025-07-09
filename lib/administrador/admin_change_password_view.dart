import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminchangePasswordView extends StatefulWidget {
  const AdminchangePasswordView({super.key});

  @override
  State<AdminchangePasswordView> createState() => _AdminchangePasswordViewState();
}

class _AdminchangePasswordViewState extends State<AdminchangePasswordView> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controllerName = TextEditingController();
  final GlobalKey scrollKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
        backgroundColor: Color.fromRGBO(4, 99, 128, 1),
        appBar: AppBar(
          bottomOpacity: 0.0,
          toolbarHeight: size.width * 0.17,
          leadingWidth: size.width * 0.17,
          leading: Container(
            padding: EdgeInsets.all(6),
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
                'Perfil',
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
            child: Column(
              children: [
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  key: scrollKey,
                  reverse: false,
                  primary: true,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Text(
                        'Cambiar contraseña',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5),
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Container(
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 5.0,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                          backgroundImage:
                              ExactAssetImage('assets/img/lock.png'),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Column(
                        children: [
                          Center(
                            child: Container(
                              width: size.width - 40,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: Offset(-4, 4),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: size.height * 0.01,
                                child: TextField(
                                  controller: _controllerName,
                                  onChanged: (value) => setState(() {
                                    _controllerName.text = value.toString();
                                  }),
                                  decoration: InputDecoration(
                                      hintText: 'Cambiar contraseña',
                                      hintStyle:
                                          TextStyle(color: Colors.black45),
                                      suffixIcon: Icon(Icons.edit),
                                      contentPadding:
                                          EdgeInsets.only(left: 20, top: 12),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        width: size.height * 0.35,
                        height: size.height * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Cambiar Contraseña'),
                                    content: Text(
                                        'Está seguro que desea cambiar su contraseña?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(currentUser.email)
                                                .update({
                                              'password': _controllerName.text
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Aceptar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),))
                                    ],
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(4, 99, 128, 1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 10)),
                          child: Text(
                            'Confirmar',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: size.width * 0.037),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'ir atrás',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: size.width * 0.04),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    
  }
}
