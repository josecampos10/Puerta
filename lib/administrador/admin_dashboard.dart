import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lapuerta2/administrador/ClasesPIe.dart';
import 'package:lapuerta2/administrador/RolesPIe.dart';
import 'package:lapuerta2/administrador/TotalVoluntarios.dart';
import 'package:lapuerta2/administrador/adminPosts.dart';

import 'package:lapuerta2/administrador/contarEstudiantes.dart';
import 'package:lapuerta2/administrador/contarProfesores.dart';
import 'package:lapuerta2/administrador/totalStaff.dart';

import 'package:lapuerta2/administrador/totalUsaurios.dart';
import 'package:lapuerta2/main.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Uint8List? pickedImage;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> imagenes;
  bool isEnglish = false;
  late Stream<QuerySnapshot> feedStream;
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> futurePosts;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchControllervoluntarios =
      TextEditingController();
  final TextEditingController _searchControllerprofesores =
      TextEditingController();
  final TextEditingController _searchControllerrestudiante =
      TextEditingController();
  String searchQuery = '';
  String searchQueryvoluntarios = '';
  String searchQueryprofe = '';
  String searchQueryestudiante = '';
  late Stream<QuerySnapshot> _staffStream;
  late Stream<QuerySnapshot> _voluntarioStream;
  late Stream<QuerySnapshot> _estudianteStream;
  late Stream<QuerySnapshot> _profeStream;
  //late Future<Widget> _myFutureWidget;
  late Future<Map<String, int>> _myFutureWidget;
  late Future<List<Map<String, dynamic>>> _usuariosFuture;

  Future<List<Map<String, dynamic>>> obtenerUltimosUsuarios() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

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

  Color _getColorForRole(String role) {
    switch (role) {
      case 'Estudiantes':
        return const Color.fromARGB(255, 33, 149, 243); // Azul
      case 'Voluntarios':
        return const Color.fromARGB(255, 255, 153, 0); // Naranja
      case 'Staff':
        return const Color.fromARGB(255, 76, 175, 79); // Verde
      case 'Profesores':
        return const Color.fromARGB(255, 175, 76, 102); // Rosado
      default:
        return Colors.grey;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      obtenerPostsOrdenados() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs;
  }

  Future<void> _refresh() async {
    setState(() {
      futurePosts =
          obtenerPostsOrdenados(); // Cambia tu variable de estado aquí
    });
  }

  Future<Map<String, int>> obtenerConteoRoles() async {
    final firestore = FirebaseFirestore.instance;

    final estudiantes = await firestore
        .collection('users')
        .where('rol', isEqualTo: 'Estudiante')
        .get();
    final voluntarios = await firestore
        .collection('users')
        .where('rol', isEqualTo: 'Voluntario')
        .get();
    final staff = await firestore
        .collection('users')
        .where('rol', isEqualTo: 'Staff')
        .get();
    final profesores = await firestore
        .collection('users')
        .where('rol', isEqualTo: 'Profesor')
        .get();

    return {
      'Estudiantes': estudiantes.docs.length,
      'Voluntarios': voluntarios.docs.length,
      'Staff': staff.docs.length,
      'Profesores': profesores.docs.length,
    };
  }

  Future<Map<String, int>> obtenerClases() async {
    final firestore = FirebaseFirestore.instance;

    final estudiantes = await firestore
        .collection('users')
        .where('ESLpm', isEqualTo: 'inscrito')
        .get();
    final voluntarios = await firestore
        .collection('users')
        .where('ESLpm2', isEqualTo: 'inscrito')
        .get();
    final staff = await firestore
        .collection('users')
        .where('ESLam', isEqualTo: 'inscritp')
        .get();
    final profesores = await firestore
        .collection('users')
        .where('ESLam3', isEqualTo: 'inscrito')
        .get();

    return {
      'ESLpm 1': estudiantes.docs.length,
      'ESLpm 2': voluntarios.docs.length,
      'ESLam 1': staff.docs.length,
      'ESLam 2': profesores.docs.length,
    };
  }

  Future<void> loadUserLanguagePreference() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get();

    final data = doc.data();
    final isSpanish = data?['spanish'] == 'true'; // viene como string

    setState(() {
      isEnglish = !isSpanish; // true = inglés activo
    });

    context.setLocale(Locale(isEnglish ? 'en' : 'es'));
  }

  @override
  void initState() {
    super.initState();
    checkUserRoles(); // ✅ ya no necesitas usar setState aquí
    var feed = FirebaseFirestore.instance
        .collection('users')
        .orderBy('Time', descending: true)
        .snapshots();
    feedStream = feed;
    imagenes = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email) // 👈 Your document id change accordingly
        .snapshots();
    getProfilePicture();
    loadUserLanguagePreference();

    _staffStream = FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Staff')
        .snapshots();
    _voluntarioStream = FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Voluntario')
        .snapshots();
    _estudianteStream = FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Estudiante')
        .snapshots();
    _profeStream = FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Profesor')
        .snapshots();
    _myFutureWidget = obtenerConteoRoles();
    _usuariosFuture = obtenerUltimosUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var isEnglish = context.locale.languageCode == 'en';
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      resizeToAvoidBottomInset: true,
      body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          height: size.height * 1,
          width: size.width,
          //color: Color.fromRGBO(255, 255, 255, 1),
          child: SingleChildScrollView(
              //physics: NeverScrollableScrollPhysics(),
              primary: false,
              reverse: true,
              child: AnimationConfiguration.staggeredGrid(
                position: 1,
                columnCount: 1,
                child: ScaleAnimation(
                  duration: Duration(milliseconds: 300),
                  child: FadeInAnimation(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(size.width * 0.08),
                                topRight: Radius.circular(size.width * 0.08))),
                        child: Column(children: [
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20))),
                                alignment: Alignment.center,
                                width: size.width * 0.18,
                                height: size.height * 0.055,
                                child: Text(
                                  'Panel de control',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height * 0.02,
                                      color: Colors.white),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                width: size.width * 0.1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ES',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.015,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.00,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.045,
                                      child: Transform.scale(
                                        scale: 0.8,
                                        child: Switch(
                                          trackOutlineColor: WidgetStateProperty
                                              .resolveWith<Color?>(
                                                  (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.disabled)) {
                                              return Colors.transparent;
                                            }
                                            return Colors
                                                .transparent; // Use the default color.
                                          }),
                                          thumbColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                                  (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.disabled)) {
                                              return Colors.orange
                                                  .withOpacity(.48);
                                            }
                                            return Theme.of(context)
                                                .colorScheme
                                                .tertiary;
                                          }),
                                          inactiveThumbColor: Colors.white,
                                          activeTrackColor: Colors.white,
                                          //activeTrackColor: const Color.fromARGB(0, 255, 255, 255),
                                          activeColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          inactiveTrackColor:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          value: isEnglish,
                                          onChanged: (value) async {
                                            bool activo = value;
                                            if (activo == true) {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(currentUser.email)
                                                  .update({'spanish': 'false'});
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(currentUser.email)
                                                  .update({'spanish': 'true'});
                                            }
                                            setState(() {
                                              isEnglish = value;
                                            });

                                            context.setLocale(
                                                Locale(value ? 'en' : 'es'));
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.0,
                                    ),
                                    Text(
                                      'EN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.015,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: size.width,
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Card(
                                    color:
                                        const Color.fromARGB(31, 180, 180, 180),
                                    elevation: 5,
                                    margin: const EdgeInsets.all(16),
                                    child: Container(
                                      height: size.height * 0.1,
                                      width: size.width * 0.14,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withAlpha(150)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              Icon(Icons.people),
                                              Text('Usuarios')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              //TotalUsuariosContainer(),
                                              TotalUsuariosContainer()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color:
                                        const Color.fromARGB(31, 180, 180, 180),
                                    elevation: 5,
                                    margin: const EdgeInsets.all(16),
                                    child: Container(
                                      height: size.height * 0.1,
                                      width: size.width * 0.14,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withAlpha(150)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              Icon(Icons.people),
                                              Text('Estudiantes')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              //TotalUsuariosContainer(),
                                              TotalEstudiantesContainer()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color:
                                        const Color.fromARGB(31, 180, 180, 180),
                                    elevation: 5,
                                    margin: const EdgeInsets.all(16),
                                    child: Container(
                                      height: size.height * 0.1,
                                      width: size.width * 0.14,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withAlpha(150)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              Icon(Icons.people),
                                              Text('Voluntarios')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              TotalVoluntariosContainer()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color:
                                        const Color.fromARGB(31, 180, 180, 180),
                                    elevation: 5,
                                    margin: const EdgeInsets.all(16),
                                    child: Container(
                                      height: size.height * 0.1,
                                      width: size.width * 0.14,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withAlpha(150)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              Icon(Icons.people),
                                              Text('Staff')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              TotalStaffContainer()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color:
                                        const Color.fromARGB(31, 180, 180, 180),
                                    elevation: 5,
                                    margin: const EdgeInsets.all(16),
                                    child: Container(
                                      height: size.height * 0.1,
                                      width: size.width * 0.14,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withAlpha(150)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              Icon(Icons.people),
                                              Text('Profesores')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              TotalProfesoresContainer()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  FutureBuilder<Map<String, int>>(
                                    future: _myFutureWidget,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final data = snapshot.data!;
                                        return Container(
                                          width: size.width * 0.33,
                                          height: size.height * 0.26,
                                          alignment: Alignment.center,
                                          child: Card(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withAlpha(150),
                                            elevation: 5,
                                            //margin: const EdgeInsets.all(15),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Row(
                                                children: [
                                                  // Pie chart a la izquierda
                                                  Center(
                                                    child: SizedBox(
                                                      height: size.height * 0.3,
                                                      width: size.width * 0.15,
                                                      child: RolesPieChart(
                                                          data: data),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 24),
                                                  // Leyenda a la derecha
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: data.entries
                                                        .map((entry) {
                                                      final color =
                                                          _getColorForRole(
                                                              entry.key);
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4.0),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 12,
                                                              height: 12,
                                                              color: color,
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              '${entry.key}: ${entry.value}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: size
                                                                          .height *
                                                                      0.014),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(width: size.width*0.01,),
                              Column(
                                children: [
                                  SizedBox(
                                   width: size.width * 0.27,
                                          height: size.height * 0.26,
                                    child: Card(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withAlpha(150),
                                      elevation: 5,
                                  
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(size.height * 0.01),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Últimos registrados",
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.015,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              //SizedBox(height: size.height*0.00),
                                              FutureBuilder<
                                                  List<Map<String, dynamic>>>(
                                                future: _usuariosFuture,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        "Error: ${snapshot.error}");
                                                  } else if (!snapshot
                                                          .hasData ||
                                                      snapshot.data!.isEmpty) {
                                                    return Text(
                                                        "No hay usuarios registrados.");
                                                  }

                                                  final usuarios =
                                                      snapshot.data!;
                                                  return Column(
                                                    children:
                                                        usuarios.map((user) {
                                                      final name =
                                                          user['name'] ??
                                                              'Sin nombre';
                                                      final email =
                                                          user['email'] ??
                                                              'Sin email';
                                                      Timestamp? createdAt =
                                                          user['createdAt'];
                                                      final fecha = createdAt !=
                                                              null
                                                          ? DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(createdAt
                                                                  .toDate())
                                                          : 'Fecha desconocida';

                                                      return SizedBox(
                                                        height:
                                                            size.height * 0.041,
                                                        child: ListTile(
                                                          dense: true,
                                                          leading: Icon(
                                                            Icons.person,
                                                            size: size.height *
                                                                0.02,
                                                          ),
                                                          titleTextStyle: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.014,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          title: Row(
                                                            children: [
                                                              Text(name),
                                                            ],
                                                          ),
                                                          subtitle: Row(
                                                            children: [
                                                              Text('$fecha'),
                                                            ],
                                                          ),
                                                          subtitleTextStyle: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.00,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary
                                                                  .withAlpha(
                                                                      160),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          isThreeLine: true,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                              ,Container(
                                width: size.width * 0.23,
                                    height: size.height * 0.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: size.height*0.015,),
                                    SizedBox(
                                      width: size.width*0.2,
                                      height: size.height*0.055,
                                      child: GestureDetector(
                                        onTap: () =>
                                      Navigator.pushNamed(context, '/publicaciones'),
                                        child: Card(
                                          elevation: 5,
                                          color: Theme.of(context).colorScheme.tertiary,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: size.width*0.005,),
                                                  Icon(Icons.edit, color: Colors.white,),
                                                  SizedBox(width: size.width*0.01,),
                                                  Text('Escribir publicación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height*0.01,),
                                    SizedBox(
                                      width: size.width*0.2,
                                      height: size.height*0.055,
                                      child: GestureDetector(
                                        onTap: (){
                                           Navigator.pushNamed(context, '/noticias');
                                        },
                                        child: Card(
                                          elevation: 5,
                                          color: Theme.of(context).colorScheme.tertiary,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: size.width*0.005,),
                                                  Icon(Icons.image, color: Colors.white,),
                                                  SizedBox(width: size.width*0.01,),
                                                  Text('Publicar en noticias', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.015,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.05,
                                        width: size.width * 0.205,
                                        child: Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          elevation: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Staff',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.016),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Container(
                                        width: size.width * 0.195,
                                        height: size.height * 0.05,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha(15),
                                        ),
                                        child: TextField(
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            hintText: 'Buscar',
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            suffixIcon: _searchController
                                                    .text.isNotEmpty
                                                ? IconButton(
                                                    icon:
                                                        const Icon(Icons.clear),
                                                    onPressed: () {
                                                      _searchController.clear();
                                                      FocusScope.of(context)
                                                          .unfocus(); // Oculta el teclado
                                                      setState(() {
                                                        searchQuery = '';
                                                      });
                                                    },
                                                  )
                                                : null,
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQuery = value.toLowerCase();
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.376,
                                        width: size.width * 0.215,
                                        child: StreamBuilder(
                                          stream: _staffStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return const Center(
                                                  child: Text(
                                                      'No hay usuarios con rol Staff'));
                                            }

                                            final allUsers =
                                                snapshot.data!.docs;
                                            final filteredUsers =
                                                allUsers.where((doc) {
                                              final name = (doc['name'] ?? '')
                                                  .toString()
                                                  .toLowerCase();
                                              return name.contains(searchQuery);
                                            }).toList();

                                            filteredUsers.sort((a, b) {
                                              final nameA = ((a.data() as Map<
                                                          String,
                                                          dynamic>?)?['name'] ??
                                                      '')
                                                  .toString()
                                                  .toLowerCase();
                                              final nameB = ((b.data() as Map<
                                                          String,
                                                          dynamic>?)?['name'] ??
                                                      '')
                                                  .toString()
                                                  .toLowerCase();

                                              return nameA.compareTo(nameB);
                                            });

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: filteredUsers.length,
                                              itemBuilder: (context, index) {
                                                final userData =
                                                    filteredUsers[index].data()!
                                                        as Map<String, dynamic>;

                                                return Card(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withAlpha(150),
                                                  child: ListTile(
                                                    leading:
                                                        FutureBuilder<String>(
                                                      future: FirebaseStorage
                                                          .instance
                                                          .ref(
                                                              '${userData['email']}')
                                                          .getDownloadURL(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircleAvatar(
                                                            radius: 25,
                                                            child:
                                                                CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2),
                                                          );
                                                        } else if (snapshot
                                                                .hasError ||
                                                            !snapshot.hasData) {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            child: Icon(
                                                                Icons.person,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiary),
                                                          );
                                                        } else {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    snapshot
                                                                        .data!),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    title: Text(
                                                      userData['name'] ??
                                                          'Nombre no disponible',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              size.height *
                                                                  0.016),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${userData['rol'] ?? 'Desconocido'}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  size.height *
                                                                      0.012),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.05,
                                        width: size.width * 0.205,
                                        child: Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          elevation: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Voluntarios',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.016),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Container(
                                        width: size.width * 0.195,
                                        height: size.height * 0.05,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha(15),
                                        ),
                                        child: TextField(
                                          controller:
                                              _searchControllervoluntarios,
                                          decoration: InputDecoration(
                                            hintText: 'Buscar',
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            suffixIcon:
                                                _searchControllervoluntarios
                                                        .text.isNotEmpty
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            Icons.clear),
                                                        onPressed: () {
                                                          _searchControllervoluntarios
                                                              .clear();
                                                          FocusScope.of(context)
                                                              .unfocus(); // Oculta el teclado
                                                          setState(() {
                                                            searchQueryvoluntarios =
                                                                '';
                                                          });
                                                        },
                                                      )
                                                    : null,
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQueryvoluntarios =
                                                  value.toLowerCase();
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.375,
                                        width: size.width * 0.215,
                                        child: StreamBuilder(
                                          stream: _voluntarioStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return const Center(
                                                  child: Text(
                                                      'No hay usuarios con rol Estudiantes'));
                                            }

                                            final allUsers =
                                                snapshot.data!.docs;
                                            final filteredUsers =
                                                allUsers.where((doc) {
                                              final name = (doc['name'] ?? '')
                                                  .toString()
                                                  .toLowerCase();
                                              return name.contains(
                                                  searchQueryvoluntarios);
                                            }).toList();

                                            filteredUsers.sort((a, b) {
                                              final nameA = ((a.data() as Map<
                                                          String,
                                                          dynamic>?)?['name'] ??
                                                      '')
                                                  .toString()
                                                  .toLowerCase();
                                              final nameB = ((b.data() as Map<
                                                          String,
                                                          dynamic>?)?['name'] ??
                                                      '')
                                                  .toString()
                                                  .toLowerCase();

                                              return nameA.compareTo(nameB);
                                            });

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: filteredUsers.length,
                                              itemBuilder: (context, index) {
                                                final userData =
                                                    filteredUsers[index].data()!
                                                        as Map<String, dynamic>;

                                                return Card(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withAlpha(150),
                                                  child: ListTile(
                                                    leading:
                                                        FutureBuilder<String>(
                                                      future: FirebaseStorage
                                                          .instance
                                                          .ref(
                                                              '${userData['email']}')
                                                          .getDownloadURL(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircleAvatar(
                                                            radius: 25,
                                                            child:
                                                                CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2),
                                                          );
                                                        } else if (snapshot
                                                                .hasError ||
                                                            !snapshot.hasData) {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            child: Icon(
                                                                Icons.person,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiary),
                                                          );
                                                        } else {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    snapshot
                                                                        .data!),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    title: Text(
                                                      userData['name'] ??
                                                          'Nombre no disponible',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              size.height *
                                                                  0.016),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${userData['rol'] ?? 'Desconocido'}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  size.height *
                                                                      0.012),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.05,
                                        width: size.width * 0.205,
                                        child: Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          elevation: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Estudiantes',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.016),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Container(
                                        width: size.width * 0.195,
                                        height: size.height * 0.05,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha(15),
                                        ),
                                        child: TextField(
                                          controller:
                                              _searchControllerrestudiante,
                                          decoration: InputDecoration(
                                            hintText: 'Buscar',
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            suffixIcon:
                                                _searchControllerrestudiante
                                                        .text.isNotEmpty
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            Icons.clear),
                                                        onPressed: () {
                                                          _searchControllerrestudiante
                                                              .clear();
                                                          FocusScope.of(context)
                                                              .unfocus(); // Oculta el teclado
                                                          setState(() {
                                                            searchQueryestudiante =
                                                                '';
                                                          });
                                                        },
                                                      )
                                                    : null,
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQueryestudiante =
                                                  value.toLowerCase();
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.375,
                                        width: size.width * 0.215,
                                        child: StreamBuilder(
                                          stream: _estudianteStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return const Center(
                                                  child: Text(
                                                      'No hay usuarios con rol Estudiantes'));
                                            }

                                            final allUsers =
                                                snapshot.data!.docs;
                                            final filteredUsers =
                                                allUsers.where((doc) {
                                              final name = (doc['name'] ?? '')
                                                  .toString()
                                                  .toLowerCase();
                                              return name.contains(
                                                  searchQueryestudiante);
                                            }).toList();

                                            filteredUsers.sort((a, b) {
                                              final nameA = ((a.data() as Map<
                                                          String,
                                                          dynamic>?)?['name'] ??
                                                      '')
                                                  .toString()
                                                  .toLowerCase();
                                              final nameB = ((b.data() as Map<
                                                          String,
                                                          dynamic>?)?['name'] ??
                                                      '')
                                                  .toString()
                                                  .toLowerCase();

                                              return nameA.compareTo(nameB);
                                            });

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: filteredUsers.length,
                                              itemBuilder: (context, index) {
                                                final userData =
                                                    filteredUsers[index].data()!
                                                        as Map<String, dynamic>;

                                                return Card(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withAlpha(150),
                                                  child: ListTile(
                                                    leading:
                                                        FutureBuilder<String>(
                                                      future: FirebaseStorage
                                                          .instance
                                                          .ref(
                                                              '${userData['email']}')
                                                          .getDownloadURL(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircleAvatar(
                                                            radius: 25,
                                                            child:
                                                                CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2),
                                                          );
                                                        } else if (snapshot
                                                                .hasError ||
                                                            !snapshot.hasData) {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            child: Icon(
                                                                Icons.person,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiary),
                                                          );
                                                        } else {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    snapshot
                                                                        .data!),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    title: Text(
                                                      userData['name'] ??
                                                          'Nombre no disponible',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              size.height *
                                                                  0.016),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          userData['email'] ??
                                                              'Correo no disponible',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  size.height *
                                                                      0.013),
                                                        ),
                                                        Text(
                                                          '${userData['rol'] ?? 'Desconocido'}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  size.height *
                                                                      0.013),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.05,
                                        width: size.width * 0.205,
                                        child: Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          elevation: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Profesores',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.016),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Container(
                                        width: size.width * 0.195,
                                        height: size.height * 0.05,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha(15),
                                        ),
                                        child: TextField(
                                          controller:
                                              _searchControllerprofesores,
                                          decoration: InputDecoration(
                                            hintText: 'Buscar',
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            suffixIcon:
                                                _searchControllerprofesores
                                                        .text.isNotEmpty
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            Icons.clear),
                                                        onPressed: () {
                                                          _searchControllerprofesores
                                                              .clear();
                                                          FocusScope.of(context)
                                                              .unfocus(); // Oculta el teclado
                                                          setState(() {
                                                            searchQueryprofe =
                                                                '';
                                                          });
                                                        },
                                                      )
                                                    : null,
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQueryprofe =
                                                  value.toLowerCase();
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.375,
                                        width: size.width * 0.215,
                                        child: StreamBuilder(
                                          stream: _profeStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return const Center(
                                                  child: Text('Sin usuarios'));
                                            }

                                            final allUsers =
                                                snapshot.data!.docs;
                                            final filteredUsers =
                                                allUsers.where((doc) {
                                              final name = (doc['name'] ?? '')
                                                  .toString()
                                                  .toLowerCase();
                                              return name
                                                  .contains(searchQueryprofe);
                                            }).toList();

                                            filteredUsers.sort((a, b) {
                                              final nameA = ((a.data() as Map<
                                                          String,
                                                          dynamic>?)?['name'] ??
                                                      '')
                                                  .toString()
                                                  .toLowerCase();
                                              final nameB = ((b.data() as Map<
                                                          String,
                                                          dynamic>?)?['name'] ??
                                                      '')
                                                  .toString()
                                                  .toLowerCase();

                                              return nameA.compareTo(nameB);
                                            });

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: filteredUsers.length,
                                              itemBuilder: (context, index) {
                                                final userData =
                                                    filteredUsers[index].data()!
                                                        as Map<String, dynamic>;

                                                return Card(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withAlpha(150),
                                                  child: ListTile(
                                                    leading:
                                                        FutureBuilder<String>(
                                                      future: FirebaseStorage
                                                          .instance
                                                          .ref(
                                                              '${userData['email']}')
                                                          .getDownloadURL(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircleAvatar(
                                                            radius: 25,
                                                            child:
                                                                CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2),
                                                          );
                                                        } else if (snapshot
                                                                .hasError ||
                                                            !snapshot.hasData) {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            child: Icon(
                                                                Icons.person,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiary),
                                                          );
                                                        } else {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    snapshot
                                                                        .data!),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    title: Text(
                                                      userData['name'] ??
                                                          'Nombre no disponible',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              size.height *
                                                                  0.016),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          userData['email'] ??
                                                              'Correo no disponible',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  size.height *
                                                                      0.013),
                                                        ),
                                                        Text(
                                                          '${userData['rol'] ?? 'Desconocido'}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  size.height *
                                                                      0.013),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              //SizedBox(height: size.height*0.05,)
                            ],
                          )
                        ])),
                  ),
                ),
              ))),
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
