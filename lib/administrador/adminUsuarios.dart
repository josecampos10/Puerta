import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lapuerta2/administrador/admin_detalles_users.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:lapuerta2/main.dart';

final gridItems = [
  'Todos',
  'Estudiantes',
  'Profesores',
  'Staff',
  'Voluntarios'
];

class AdminUsuarios extends StatefulWidget {
  const AdminUsuarios({
    super.key,
  });

  @override
  State<AdminUsuarios> createState() => _AdminUsuariosState();
}

class _AdminUsuariosState extends State<AdminUsuarios> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final user = FirebaseAuth.instance.customAuthDomain;
  int selectedIndex = 0;

Future<void> deleteUserByEmail(String email) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('❌ Usuario no autenticado');
      return;
    }

    // 🔁 Refrescar token
    await user.getIdToken(true);

    final callable = FirebaseFunctions.instance.httpsCallable('deleteUser');
    print('✅ Llamando deleteUser como: ${user.email}');

    final result = await callable.call({'email': email});

    if (result.data != null && result.data['message'] != null) {
      print(result.data['message']);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(result.data['message'])),
      );
    }
  } on FirebaseFunctionsException catch (e) {
    print('🔥 FirebaseFunctionsException: ${e.code} - ${e.message}');
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(content: Text('❌ ${e.message}')),
    );
  } catch (e) {
    print('❌ Error inesperado: $e');
  }
}




Future<void> checkIfUserIsAdmin() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final idTokenResult = await user.getIdTokenResult();
    final claims = idTokenResult.claims;

    if (claims != null && claims['admin'] == true) {
      print('✅ El usuario es admin.');
    } else {
      print('❌ El usuario NO es admin.');
    }
  }
}



Future<void> checkUserRoles() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final idTokenResult = await user.getIdTokenResult(); // sin .getIdToken(true)
    final claims = idTokenResult.claims;

    print('👉 Claims: $claims');
    if (claims?['superadmin'] == true) {
      print('✅ Usuario con rol: SUPERADMIN');
    } else if (claims?['admin'] == true) {
      print('✅ Usuario con rol: ADMIN');
    } else {
      print('⚠️ Usuario sin roles asignados');
    }
  }
}


@override
void initState() {
  super.initState();
  checkUserRoles(); // ✅ ya no necesitas usar setState aquí
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Usuarios',
          style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        toolbarHeight: size.height * 0.09,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        height: size.height * 0.93,
        width: size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/foto4.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),*/
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: false,
          child: Column(children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.001),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.045,
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: size.width * 0.00079),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: gridItems.length,
                      cacheExtent: 1000.0,
                      itemBuilder: (BuildContext context, int position) {
                        return AnimationConfiguration.staggeredGrid(
                          position: 1,
                          columnCount: 1,
                          child: ScaleAnimation(
                            duration: Duration(milliseconds: 400),
                            child: FadeInAnimation(
                              child: InkWell(
                                onTap: () =>
                                    setState(() => selectedIndex = position),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.03)),
                                  elevation: size.height * 0.5,
                                  //shadowColor: Colors.black26,
                                  color: (selectedIndex == position)
                                      ? Color.fromRGBO(231, 155, 56, 1)
                                      : Color.fromRGBO(238, 135, 1, 0),
                                  child: Padding(
                                    padding: EdgeInsets.all(size.width * 0.01),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.0,
                                              ),
                                              Text(
                                                gridItems[position],
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: size.height * 0.017,
                                                  fontFamily: 'Arial',
                                                  fontWeight: FontWeight.normal,
                                                  color: (selectedIndex ==
                                                          position)
                                                      ? Color.fromRGBO(
                                                          255, 255, 255, 1)
                                                      : Color.fromRGBO(
                                                          143, 143, 143, 1),
                                                ),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SpinKitFadingCircle(
                          color: Color.fromRGBO(2, 116, 151, 1),
                          size: size.width * 0.1,
                        ),
                      ]);
                    }
                    if (snapshot.hasData && selectedIndex == 4) {
                      final snap = snapshot.data!.docs;

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: MasonryGridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1),
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 1,
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: true,
                                itemCount: snap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //  snapshot.data!.docs[index];
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['rol'] == 'Voluntario') {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      child: ScaleAnimation(
                                        duration: Duration(milliseconds: 300),
                                        child: FadeInAnimation(
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                                motion: StretchMotion(),
                                                children: [
                                                  SlidableAction(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    onPressed: (context) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                'Eliminar usuario',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .secondary),
                                                              ),
                                                              content: Text(
                                                                  'Estás seguro que desea eliminar este usuario?',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary)),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Aceptar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary))),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancelar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary)))
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete,
                                                    label: 'borrar',
                                                  )
                                                ]),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetallesHome(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02)),
                                                elevation: size.height * 0.0,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  211,
                                                                  211,
                                                                  211)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.01),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.018,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['rol'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      172,
                                                                      172,
                                                                      172),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData && selectedIndex == 3) {
                      final snap = snapshot.data!.docs;

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: MasonryGridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1),
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 1,
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: true,
                                itemCount: snap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //  snapshot.data!.docs[index];
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['rol'] == 'Staff') {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      child: ScaleAnimation(
                                        duration: Duration(milliseconds: 300),
                                        child: FadeInAnimation(
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                                motion: StretchMotion(),
                                                children: [
                                                  SlidableAction(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    onPressed: (context) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Eliminar usuario'),
                                                              content: Text(
                                                                  'Estás seguro que quieres eliminar este usuario?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Aceptar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary))),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancelar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary)))
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete,
                                                    label: 'borrar',
                                                  )
                                                ]),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetallesHome(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02)),
                                                elevation: size.height * 0.0,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  211,
                                                                  211,
                                                                  211)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.01),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.018,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['rol'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      172,
                                                                      172,
                                                                      172),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData && selectedIndex == 2) {
                      final snap = snapshot.data!.docs;

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: MasonryGridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1),
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 1,
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: true,
                                itemCount: snap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //  snapshot.data!.docs[index];
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['rol'] == 'Profesor') {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      child: ScaleAnimation(
                                        duration: Duration(milliseconds: 300),
                                        child: FadeInAnimation(
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                                motion: StretchMotion(),
                                                children: [
                                                  SlidableAction(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    onPressed: (context) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Eliminar usuario'),
                                                              content: Text(
                                                                  'Estás seguro que quieres eliminar este usuario?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Aceptar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary))),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancelar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary)))
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete,
                                                    label: 'borrar',
                                                  )
                                                ]),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetallesHome(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02)),
                                                elevation: size.height * 0.0,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  211,
                                                                  211,
                                                                  211)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.01),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.018,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['rol'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      172,
                                                                      172,
                                                                      172),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData && selectedIndex == 1) {
                      final snap = snapshot.data!.docs;

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: MasonryGridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1),
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 1,
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: true,
                                itemCount: snap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //  snapshot.data!.docs[index];
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['rol'] == 'Estudiante') {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      child: ScaleAnimation(
                                        duration: Duration(milliseconds: 300),
                                        child: FadeInAnimation(
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                                motion: StretchMotion(),
                                                children: [
                                                  SlidableAction(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    onPressed: (context) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Eliminar usuario'),
                                                              content: Text(
                                                                  'Estás seguro que quieres eliminar este usuario?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Aceptar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary))),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancelar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary)))
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete,
                                                    label: 'borrar',
                                                  )
                                                ]),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetallesHome(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02)),
                                                elevation: size.height * 0.0,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  127,
                                                                  211,
                                                                  211,
                                                                  211)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.01),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.018,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['rol'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      172,
                                                                      172,
                                                                      172),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData && selectedIndex == 0) {
                      final snap = snapshot.data!.docs;
                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: MasonryGridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1),
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: true,
                              itemCount: snap.length,
                              cacheExtent: 1000.0,
                              itemBuilder: (context, index) {
                                // final DocumentSnapshot documentSnapshot =
                                //  snapshot.data!.docs[index];
                                DocumentSnapshot documentSnapshot =
                                    snapshot.data!.docs[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: ScaleAnimation(
                                    duration: Duration(milliseconds: 300),
                                    child: FadeInAnimation(
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                            motion: StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                onPressed: (context) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Eliminar usuario'),
                                                          content: Text(
                                                              'Estás seguro que quieres eliminar este usuario?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () async {
                                                                  //delete user info in the database
                                                                  /*FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(snap[
                                                                              index]
                                                                          [
                                                                          'email'])
                                                                      .delete();*/

                                                                  //delete user
                                                                  //deleteUserByEmail(snap[index]['email'].toString());
                                                                  //currentUser.delete();
                                                                  /*FirebaseAuth
                                                                      .instance
                                                                      .signOut();*/
                                                                  //(FirebaseStorage.instance.ref().child(currentUser.email.toString()).g)
                                                                 FirebaseStorage
                                                                      .instance
                                                                      .ref()
                                                                      .child(snap[index]['email'])
                                                                      .delete();
                                                                  Navigator.of(context).pop();

  // 🔁 Refrescar token y esperar propagación
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await user.getIdToken(true);
    await Future.delayed(Duration(seconds: 1)); // <- DALE TIEMPO
  }

  await checkUserRoles(); // Esto solo imprime, pero asegura que el token ya está propagado

  await deleteUserByEmail(snap[index]['email']);
                                                                },
                                                                child: Text(
                                                                    'Aceptar',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary))),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                      checkIfUserIsAdmin();
                                                                },
                                                                child: Text(
                                                                    'Cancelar',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary)))
                                                          ],
                                                        );
                                                      });
                                                },
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete,
                                                label: 'borrar',
                                              )
                                            ]),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminDetallesHome(
                                                            documentSnapshot:
                                                                documentSnapshot)));
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.width * 0.02)),
                                            elevation: size.height * 0.0,
                                            shadowColor: Colors.black,
                                            color: Color.fromRGBO(
                                                219, 219, 219, 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: const Color
                                                              .fromARGB(127,
                                                              211, 211, 211)))),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    size.width * 0.01),
                                                child: Column(
                                                  children: [
                                                    Row(children: [
                                                      Icon(
                                                        Icons.person_3,
                                                        size:
                                                            size.height * 0.02,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.02,
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          snap[index]['name'],
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.018,
                                                            fontFamily:
                                                                'Arial',
                                                            fontWeight:
                                                                FontWeight.normal,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.02,
                                                      ),
                                                    ]),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: size.width *
                                                              0.065,
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            snap[index]['rol'],
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.0162,
                                                              fontFamily:
                                                                  'Arial',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  172,
                                                                  172,
                                                                  172),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
            )
          ]),
        ),
      ),
    );
  }
}


