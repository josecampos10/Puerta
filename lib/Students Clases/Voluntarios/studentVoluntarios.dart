
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

class AppClass {
  final String key;   // Nombre EXACTO en Firestore
  final String label; // Nombre visible en UI
  const AppClass(this.key, this.label);
}

class Studentvoluntarios extends StatefulWidget {
  const Studentvoluntarios({super.key});
  @override
  State<Studentvoluntarios> createState() => _StudentvoluntariosState();
}

class _StudentvoluntariosState extends State<Studentvoluntarios> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usuario =
      FirebaseFirestore.instance.collection('users').doc().snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('Volunteers');
  final controller = TextEditingController();
  final streaming = FirebaseFirestore.instance
      .collection('Volunteers')
      .orderBy('createdAt', descending: true)
      .snapshots();
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot> feedStream;
  late Future<DocumentSnapshot> futureUserDoc;

   // Lista de clases disponibles (puedes reemplazar con una consulta si luego lo deseas)
  final List<AppClass> availableClasses = const [
  AppClass('ESLpm',       'ESL PM 1'),
  AppClass('ESLpm2',      'ESL PM 2'),
  AppClass('ESLam',       'ESL AM 1'),
  AppClass('ESLam2',      'ESL AM 2'),
  AppClass('Corte1',      'Corte y confección 1'),
  AppClass('Corte2',      'Corte y confección 2'),
  AppClass('ESLchick',    'ESL Chick-fil-A'),
  AppClass('ESLclifton',  'ESL Clifton'),
  AppClass('GEDam',       'GED Am - A'),
  AppClass('GEDam2',       'GED Am - B'),
  AppClass('GEDpm',       'GED Pm - A'),
  AppClass('GEDpm2',       'GED Pm - B'),
  AppClass('ciudadania',  'Ciudadanía'),
  AppClass('cosmetologia','Cosmetología'),
  AppClass('costuraAM',   'Costura básica'),
];
  // Stream del documento del usuario para saber qué clases ya tiene inscritas
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> userDocStream;

  Future<void> _toggleClass(String classKey, bool toEnroll) async {
  final userDocRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email);

  try {
    if (toEnroll) {
      await userDocRef.set({classKey: 'inscrito'}, SetOptions(merge: true));
    } else {
      await userDocRef.set({classKey: ''}, SetOptions(merge: true)); // ← vacío
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No se pudo actualizar: $e')),
    );
  }
}


  Widget _classEnrollmentBar(Size size) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userDocStream,
      builder: (context, snapshot) {
        final Map<String, dynamic> userData =
            (snapshot.data?.data() ?? <String, dynamic>{});

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.012,
            horizontal: size.width * 0.005,
          ),
          width: size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size.width * 0.087),
              topRight: Radius.circular(size.width * 0.087),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableClasses.map((c) {
                final bool selected = (userData[c.key] == 'inscrito');
                return Padding(
                  padding: EdgeInsets.only(right: size.width * 0.02),
                  child: ChoiceChip(
                    label: Text(
                      c.label.tr(), 
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    selected: selected,
                    // Colores según estado (gris cuando NO está seleccionada)
                    selectedColor: Theme.of(context).colorScheme.tertiary,
                    backgroundColor: const Color(0xFFBDBDBD), // gris
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                        color: selected
                            ? Theme.of(context).colorScheme.tertiary
                            : const Color(0xFF9E9E9E),
                        width: 1,
                      ),
                    ),
                    onSelected: (val) => _toggleClass(c.key, val), // ← usa key para Firestore
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
    getProfilePicture();
    futureUserDoc =
        FirebaseFirestore.instance.collection('clases').doc('GED').get();

    userDocStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email) // tu estructura guardaba el email como ID
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    getProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        iconTheme: CupertinoIconThemeData(
          color: Colors.white,
          size: size.height * 0.035,
        ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.13,
        //leading:
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.0),
            child: Text(
              ez.tr('Mis clases'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.024,
                  color: Colors.white,
                  fontFamily: ''),
            )),
        centerTitle: false,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/puntos.png'),
              fit: BoxFit.fill,
              colorFilter: (Theme.of(context).colorScheme.tertiary !=
                      Color.fromRGBO(4, 99, 128, 1))
                  ? ColorFilter.mode(
                      const Color.fromARGB(255, 68, 68, 68), BlendMode.color)
                  : ColorFilter.mode(
                      const Color.fromARGB(0, 255, 29, 29), BlendMode.color),
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.065,
                width: size.height * 0.065,
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
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.087),
                topRight: Radius.circular(size.width * 0.087))),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: futureUserDoc,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: size.height * 0.2,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Theme.of(context).colorScheme.tertiary,
                          size: size.width * 0.055,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Container(
                      height: size.height * 0.2,
                      child: Center(child: Text('No hay datos del usuario')),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          filterQuality: FilterQuality.low,
                          image: AssetImage('assets/img/volunteer.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(size.width * 0.087)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Voluntarios'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.06,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  SizedBox(
                    width: size.width*0.03,
                  ),
                  Text('Escoja sus clases:'.tr(), style: TextStyle(
                              fontSize: size.height * 0.018,
                              fontFamily: 'Arial',
                              //fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),)
                ],
              ),

    // ⬇️⬇️ Barra horizontal de clases (NUEVA)
    _classEnrollmentBar(size),

   // SizedBox(height: size.height * 0.01),

              
              Container(
                height: size.height * 0.05,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: const Color.fromARGB(148, 163, 163, 163)))),
                child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/studentvolunteers_files'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Icon(
                          Icons.folder,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          'Archivos'.tr(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              fontFamily: 'Arial',
                              //fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    )),
              ),
              
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: streaming,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(children: [
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SpinKitFadingCircle(
                                color: Theme.of(context).colorScheme.tertiary,
                                size: size.width * 0.1,
                              ),
                            ]);
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return RefreshIndicator(
                                color: Theme.of(context).colorScheme.tertiary,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                onRefresh:
                                    () async {}, // o tu función de refresco
                                child: SizedBox(
                                  height: size.height * 0.345,
                                  child: ListView(
                                    physics:
                                        AlwaysScrollableScrollPhysics(), // necesario para pull-to-refresh
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.05),
                                        child: Center(
                                          child: Text(
                                            'Aún no hay publicaciones'.tr(),
                                            style: TextStyle(
                                              fontSize: size.height * 0.018,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final snap = snapshot.data!.docs;
                            return RefreshIndicator(
                              elevation: 0,
                              color: Theme.of(context).colorScheme.tertiary,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              displacement: 1,
                              strokeWidth: 3,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.417,
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
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        child: ScaleAnimation(
                                          duration: Duration(milliseconds: 300),
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.04)),
                                                elevation: size.height * 0.01,
                                                shadowColor: Colors.black,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                child: Container(
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          alignment: Alignment
                                                              .topRight,
                                                          children: [],
                                                        ),
                                                        Row(children: [
                                                          CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      snap[index]
                                                                          [
                                                                          'Image']),
                                                              minRadius:
                                                                  size.height *
                                                                      0.021,
                                                              maxRadius:
                                                                  size.height *
                                                                      0.021,
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .tertiary),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['Name'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.018,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02),
                                                          Text(
                                                            snap[index]['Time'],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.013,
                                                                fontFamily:
                                                                    'Arial',
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    168,
                                                                    168,
                                                                    168)),
                                                          ),
                                                          
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.12,
                                                            ),
                                                            Text(
                                                              snap[index]
                                                                  ['Date'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.013,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      168,
                                                                      168,
                                                                      168)),
                                                            ),
                                                          ],
                                                        ),
                                                        Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Linkify(
                                                              linkStyle:
                                                                  TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                fontSize:
                                                                    size.height *
                                                                        0.0155,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    94,
                                                                    145,
                                                                    255),
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.0155,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary),
                                                              text: snap[index]
                                                                  ['Comment'],
                                                              onOpen:
                                                                  (link) async {
                                                                if (!await launchUrl(
                                                                    Uri.parse(link
                                                                        .url))) {
                                                                  throw Exception(
                                                                      'Could not launch ${link.url}');
                                                                }
                                                              },
                                                            )),
                                                      ],
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
                            return const SizedBox();
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUsera.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }
}

class FireStoreDataBase {
  final currentUsera = FirebaseAuth.instance.currentUser!;
  String? downloadURL;
  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint('Error - $e');
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child(currentUsera.email.toString())
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }
}
