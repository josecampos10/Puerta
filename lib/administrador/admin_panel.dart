import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Uint8List? pickedImage;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> imagenes;

Future<void> checkUserRoles() async {
  User? user = FirebaseAuth.instance.currentUser;
  final currentUser = FirebaseAuth.instance.currentUser!;

  if (user != null) {
    // ✅ Refrescar el token antes de usarlo
    await user.getIdToken(true);

    final idTokenResult = await user.getIdTokenResult();
    final claims = idTokenResult.claims;

    if (claims != null) {
      print('👉 Claims: $claims');

      if (claims['superadmin'] == true) {
        print('✅ Usuario con rol: SUPERADMIN');
      } else if (claims['admin'] == true) {
        print('✅ Usuario con rol: ADMIN');
      } else {
        print('⚠️ Usuario sin roles asignados');
      }
    }
  } else {
    print('❌ No hay usuario autenticado');
  }
}

@override
void initState() {
  super.initState();
  checkUserRoles(); // ✅ ya no necesitas usar setState aquí
  imagenes = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email) // 👈 Your document id change accordingly
        .snapshots();
  getProfilePicture();
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.0,
        leading: Text(''),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: Container(
              child: Column(
                children: [
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: imagenes,
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(children: [
                                SpinKitFadingCircle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  size: size.width * 0.055,
                                ),
                              ]);
                            }
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return (data['name']) != null
                                ? Text(
                                    data['name'],
                                    style: TextStyle(
                                        fontSize: size.height * 0.023,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                  )
                                : Text(''); // 👈 your valid data here
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        centerTitle: false,
        //titleTextStyle: ,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/puntos.png'),
                fit: BoxFit.cover,
                colorFilter: (Theme.of(context).colorScheme.tertiary !=
                        Color.fromRGBO(4, 99, 128, 1))
                    ? ColorFilter.mode(
                        const Color.fromARGB(255, 68, 68, 68), BlendMode.color)
                    : ColorFilter.mode(
                        const Color.fromARGB(0, 255, 29, 29), BlendMode.color),
                alignment: Alignment.topCenter,
                scale: 27.0),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.095,
                width: size.height * 0.095,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: Color.fromRGBO(255, 255, 255, 0.174),
                      width: size.height * 0.003,
                    ),
                    shape: BoxShape.circle,
                    image: pickedImage != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.memory(
                              pickedImage!,
                              key: UniqueKey(),
                            ).image)
                        : null),
              ),
              SizedBox(
                width: size.width * 0.03,
              )
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          primary: false,
          reverse: false,
          child: Container(
            decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
            child: Column(
              children: [

              
                
                SizedBox(
                  height: size.height * 0.025,
                ),
                AnimationConfiguration.staggeredGrid(
                  position: 1,
                  columnCount: 1,
                  child: ScaleAnimation(
                    duration: Duration(milliseconds: 300),
                    child: FadeInAnimation(
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.05,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/recursos'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).colorScheme.tertiary,
                                          
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: size.height * 0.18,
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(Icons.edit,
                                                  size: size.height * 0.1,
                                                  color: Theme.of(context).colorScheme.primary,)
                                            ),
                                            Container(
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      120, 118, 68, 255),
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(12),
                                                      bottomLeft:
                                                          Radius.circular(12))),
                                              padding: const EdgeInsets.all(12),
                                              child: Text(
                                                "Editar Recursos",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.height * 0.017,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: size.width * 0.1,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          Navigator.pushNamed(context, '/clases'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).colorScheme.tertiary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: size.height * 0.18,
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(Icons.edit,
                                                  size: size.height * 0.1,
                                                  color: Theme.of(context).colorScheme.primary),
                                            ),
                                            Container(
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(167, 0, 117, 0.549),
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(12),
                                                      bottomLeft:
                                                          Radius.circular(12))),
                                              padding: const EdgeInsets.all(12),
                                              child: Text("Editar Clases",
                                              style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.height * 0.017,
                                                    fontWeight: FontWeight.bold),
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.05,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/publicaciones'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).colorScheme.tertiary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: size.height * 0.18,
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(Icons.post_add,
                                                  size: size.height * 0.1,
                                                  color: Theme.of(context).colorScheme.primary),
                                            ),
                                            Container(
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      151, 255, 165, 47),
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(12),
                                                      bottomLeft:
                                                          Radius.circular(12))),
                                              padding: const EdgeInsets.all(12),
                                              child: Text("Crear Post",
                                              style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.height * 0.017,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: size.width * 0.1,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/usuarios'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).colorScheme.tertiary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: size.height * 0.18,
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(Icons.list_alt,
                                                  size: size.height * 0.1,
                                                  color: Theme.of(context).colorScheme.primary),
                                            ),
                                            Container(
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      136, 14, 151, 44),
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(12),
                                                      bottomLeft:
                                                          Radius.circular(12))),
                                              padding: const EdgeInsets.all(12),
                                              child: Text("Lista de Usuarios",
                                              style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.height * 0.017,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.05,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/control'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).colorScheme.tertiary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: size.height * 0.18,
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(Icons.settings,
                                                  size: size.height * 0.1,
                                                  color: Theme.of(context).colorScheme.primary),
                                            ),
                                            Container(
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      120, 255, 68, 68),
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(12),
                                                      bottomLeft:
                                                          Radius.circular(12))),
                                              padding: const EdgeInsets.all(12),
                                              child: Text("Control",
                                              style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.height * 0.017,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: size.width * 0.1,
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/posts'),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).colorScheme.tertiary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: size.height * 0.18,
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(Icons.local_activity,
                                                  size: size.height * 0.1,
                                                  color: Theme.of(context).colorScheme.primary),
                                            ),
                                            Container(
                                              width: size.width / 2 -
                                                  size.width * 0.05 -
                                                  size.width * 0.05,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      132, 68, 137, 255),
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(12),
                                                      bottomLeft:
                                                          Radius.circular(12))),
                                              padding: const EdgeInsets.all(12),
                                              child: Text("Actividad",
                                              style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.height * 0.017,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser!.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }

}
