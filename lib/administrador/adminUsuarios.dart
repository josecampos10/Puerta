import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
  'Todos'.tr(),
  'Estudiantes'.tr(),
  'Profesores'.tr(),
  'Staff'.tr(),
  'Voluntarios'.tr()
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
  TextEditingController _searchController = TextEditingController();
  String searchText = '';

  String selectedClass = 'Todos';
  final List<String> classOptions = [
    'Todos',
    'ESLpm',
    'ESLpm2',
    'ESLam',
    'ESLam2',
    'GEDpm',
    'GEDam',
    'ciudadania',
    'cosmetologia',
    'costuraAM',
    'Corte1',
    'Corte2',
    'ESLclifton',
    'ESLchick'
  ];

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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final idTokenResult = await user.getIdTokenResult(true);
    final claims = idTokenResult.claims ?? {};

    if (claims['superadmin'] == true) {
      print('✅ El usuario es SUPERADMIN.');
    } else if (claims['admin'] == true) {
      print('✅ El usuario es ADMIN.');
    } else {
      print('❌ El usuario NO es admin.');
    }
  }

  Future<void> checkUserRoles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idTokenResult =
          await user.getIdTokenResult(); // sin .getIdToken(true)
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
    checkUserRoles();
    _searchController.addListener(() {
      // No usamos setState aquí para evitar recarga excesiva
      searchText = _searchController.text.toLowerCase();
    }); // ✅ ya no necesitas usar setState aquí
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: false,
          child: Column(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        alignment: Alignment.center,
                        width: size.width * 0.18,
                        height: size.height * 0.055,
                        child: Text(
                          'Control de usuarios',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.02,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.07,
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: size.height * 0.00035),
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
                                          size.height * 0.1)),
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
                                                gridItems[position].tr(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: size.height * 0.017,
                                                  fontFamily: 'Arial',
                                                  fontWeight: FontWeight.bold,
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: size.height * 0.06,
              width: size.width * 0.9,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(30),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                cursorColor: Theme.of(context).colorScheme.secondary,
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Buscar por nombre',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              FocusScope.of(context)
                                  .unfocus(); // Oculta el teclado
                              setState(() {}); // Actualiza la UI
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: InputBorder.none),
                onChanged: (_) {
                  setState(() {});
                },
              ),
            ),
            if (selectedIndex == 1)
  Container(
    height: 45,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: classOptions.length,
      separatorBuilder: (context, index) => SizedBox(width: 8),
      itemBuilder: (context, index) {
        final clase = classOptions[index];
        final isSelected = selectedClass == clase;
        return ChoiceChip(
          label: Text(
            clase,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.white38,
            ),
          ),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              selectedClass = clase;
            });
          },
          elevation: 5,
          checkmarkColor: Colors.white,
          side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          selectedColor: Theme.of(context).colorScheme.tertiary,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      },
    ),
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
                      final filteredSnap = snap.where((doc) {
                        final name =
                            doc['name']?.toString().toLowerCase() ?? '';
                        return name.contains(searchText);
                      }).toList();
filteredSnap.sort((a, b) {
  final nameA = (a.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  final nameB = (b.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  return nameA.compareTo(nameB);
});

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.732,
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
                                itemCount: filteredSnap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //  snapshot.data!.docs[index];
                                  final documentSnapshot = filteredSnap[index];
                                  final userData = documentSnapshot.data()
                                      as Map<String, dynamic>;
                                  //DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                                  if (userData['rol'] == 'Voluntario') {
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
                                                                        'Cancelar'
                                                                            .tr(),
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
                                                                0.03,
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
                                                              userData[
                                                                      'name'] ??
                                                                  'Sin nombre',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.02,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                      0.035,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'rol'] ??
                                                                    'Sin nombre',
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
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.035,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'email'] ??
                                                                    'Sin nombre',
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
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
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
                      final filteredSnap = snap.where((doc) {
                        final name =
                            doc['name']?.toString().toLowerCase() ?? '';
                        return name.contains(searchText);
                      }).toList();
filteredSnap.sort((a, b) {
  final nameA = (a.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  final nameB = (b.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  return nameA.compareTo(nameB);
});

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.732,
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
                                itemCount: filteredSnap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //  snapshot.data!.docs[index];
                                  final documentSnapshot = filteredSnap[index];
                                  final userData = documentSnapshot.data()
                                      as Map<String, dynamic>;
                                  //DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                                  if (userData['rol'] == 'Staff') {
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
                                                                        'Cancelar'
                                                                            .tr(),
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
                                                                0.03,
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
                                                              userData[
                                                                      'name'] ??
                                                                  'Sin nombre',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.02,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                      0.035,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'rol'] ??
                                                                    'Sin nombre',
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
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.035,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'email'] ??
                                                                    'Sin nombre',
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
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
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
                      final filteredSnap = snap.where((doc) {
                        final name =
                            doc['name']?.toString().toLowerCase() ?? '';
                        return name.contains(searchText);
                      }).toList();
filteredSnap.sort((a, b) {
  final nameA = (a.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  final nameB = (b.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  return nameA.compareTo(nameB);
});

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.732,
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
                                itemCount: filteredSnap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //  snapshot.data!.docs[index];
                                  final documentSnapshot = filteredSnap[index];
                                  final userData = documentSnapshot.data()
                                      as Map<String, dynamic>;
                                  //DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                                  if (userData['rol'] == 'Profesor') {
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
                                                                        'Cancelar'
                                                                            .tr(),
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
                                                                0.03,
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
                                                              userData[
                                                                      'name'] ??
                                                                  'Sin nombre',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.02,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                      0.035,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'rol'] ??
                                                                    'Sin nombre',
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
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.035,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'email'] ??
                                                                    'Sin nombre',
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
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
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
                     final filteredSnap = snap.where((doc) {
  final userData = doc.data() as Map<String, dynamic>;
  final name = userData['name']?.toString().toLowerCase() ?? '';

  final isInSelectedClass = selectedClass == 'Todos' ||
      (userData[selectedClass]?.toString().toLowerCase() == 'inscrito');

  return name.contains(searchText) && isInSelectedClass;
}).toList();
filteredSnap.sort((a, b) {
  final nameA = (a.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  final nameB = (b.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  return nameA.compareTo(nameB);
});



                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.69,
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
                                itemCount: filteredSnap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //  snapshot.data!.docs[index];
                                  final documentSnapshot = filteredSnap[index];
                                  final userData = documentSnapshot.data()
                                      as Map<String, dynamic>;
                                  //DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                                  if (userData['rol'] == 'Estudiante') {
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
                                                                        'Cancelar'
                                                                            .tr(),
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
                                                                0.03,
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
                                                              userData[
                                                                      'name'] ??
                                                                  'Sin nombre',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.02,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                      0.035,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'rol'] ??
                                                                    'Sin nombre',
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
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.035,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'email'] ??
                                                                    'Sin nombre',
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
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
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
                      final filteredSnap = snap.where((doc) {
                        final name =
                            doc['name']?.toString().toLowerCase() ?? '';
                        return name.contains(searchText);
                      }).toList();
                      filteredSnap.sort((a, b) {
  final nameA = (a.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  final nameB = (b.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
  return nameA.compareTo(nameB);
});

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: Column(
                          children: [
                            // Buscador

                            SizedBox(
                              height: size.height * 0.732,
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
                                  itemCount: filteredSnap.length,
                                  cacheExtent: 1000.0,
                                  itemBuilder: (context, index) {
                                    // final DocumentSnapshot documentSnapshot =
                                    //  snapshot.data!.docs[index];
                                    final documentSnapshot =
                                        filteredSnap[index];
                                    final userData = documentSnapshot.data()
                                        as Map<String, dynamic>;
                                    //DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
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
                                                                      () async {
                                                                    final userEmailToDelete =
                                                                        snap[index]
                                                                            [
                                                                            'email'];

                                                                    // 1️⃣ Eliminar los posts del usuario
                                                                    try {
                                                                      final querySnapshot = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'posts')
                                                                          .where(
                                                                              'UserEmail',
                                                                              isEqualTo: userEmailToDelete)
                                                                          .get();

                                                                      if (querySnapshot
                                                                          .docs
                                                                          .isNotEmpty) {
                                                                        for (final doc
                                                                            in querySnapshot.docs) {
                                                                          await doc
                                                                              .reference
                                                                              .delete();
                                                                        }
                                                                        print(
                                                                            '✅ Posts eliminados.');
                                                                      } else {
                                                                        print(
                                                                            'ℹ️ No se encontraron posts.');
                                                                      }
                                                                    } catch (e) {
                                                                      print(
                                                                          '❌ Error al eliminar posts: $e');
                                                                    }

                                                                    // 2️⃣ Eliminar imagen de perfil
                                                                    try {
                                                                      await FirebaseStorage
                                                                          .instance
                                                                          .ref(
                                                                              userEmailToDelete)
                                                                          .delete();
                                                                      print(
                                                                          '✅ Imagen de perfil eliminada.');
                                                                    } catch (e) {
                                                                      print(
                                                                          '⚠️ No se encontró imagen de perfil o error al eliminar: $e');
                                                                    }

                                                                    // 3️⃣ Eliminar documento del usuario en 'users'
                                                                    try {
                                                                      final userDocRef = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'users')
                                                                          .doc(
                                                                              userEmailToDelete);

                                                                      final userDoc =
                                                                          await userDocRef
                                                                              .get();

                                                                      if (userDoc
                                                                          .exists) {
                                                                        await userDocRef
                                                                            .delete();

                                                                        // 🔁 Verificamos que se haya eliminado correctamente
                                                                        final checkDoc =
                                                                            await userDocRef.get();
                                                                        if (!checkDoc
                                                                            .exists) {
                                                                          print(
                                                                              '✅ Documento del usuario eliminado exitosamente.');
                                                                        } else {
                                                                          print(
                                                                              '⚠️ Falló la eliminación del documento.');
                                                                        }
                                                                      } else {
                                                                        print(
                                                                            'ℹ️ El documento del usuario no existe.');
                                                                      }
                                                                    } catch (e) {
                                                                      print(
                                                                          '❌ Error al eliminar documento del usuario: $e');
                                                                    }

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      'Aceptar',
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary)),
                                                                ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancelar'
                                                                            .tr(),
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
                                                                0.03,
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
                                                              userData[
                                                                      'name'] ??
                                                                  'Sin nombre',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.02,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                      0.04,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'rol'] ??
                                                                    'Sin nombre',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.016,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.04,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                userData[
                                                                        'email'] ??
                                                                    'Sin nombre',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.016,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withAlpha(
                                                                          150),
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
                          ],
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
