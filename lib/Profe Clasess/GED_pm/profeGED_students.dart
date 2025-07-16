import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Profegedstudentspm extends StatefulWidget {
  const Profegedstudentspm({super.key});
  @override
  State<Profegedstudentspm> createState() => _ProfegedstudentspmState();
}

class _ProfegedstudentspmState extends State<Profegedstudentspm> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('postsGED');
  late Future<ListResult> futureFiles;
  PlatformFile? pickedFile;
  List<PlatformFile>? selectedFiles;
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Future<DocumentSnapshot> futureUserDoc;
  late Future<QuerySnapshot> futureUsers;

  Future<void> _refresh() async {
    setState(() {
      futureUsers = FirebaseFirestore.instance
          .collection('users')
          .orderBy('name', descending: false)
          .get();
    });
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result == null) return;
    selectedFiles = result.files;
    setState(() {});
  }

  Future uploadFile() async {
    final path = 'GEDfiles/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

  void selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/GEDfiles').listAll();
    getProfilePicture();
    futureUserDoc =
        FirebaseFirestore.instance.collection('clases').doc('GED').get();
    futureUsers = FirebaseFirestore.instance
        .collection('users')
        .orderBy('name', descending: false)
        .get();
    //selectFile();
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
              'Mis clases',
              style: TextStyle(
                  //fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.055,
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
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          filterQuality: FilterQuality.low,
                          image: AssetImage('assets/img/GEDback.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(size.width * 0.087)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['Name'] ?? 'Nombre clase',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.06,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Subname'] ?? 'Descripción',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.02,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Days'] ?? 'Días',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Time'] ?? 'Horario',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    FutureBuilder<QuerySnapshot>(
                      future: futureUsers,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(children: [
                            SpinKitFadingCircle(
                              color: Theme.of(context).colorScheme.tertiary,
                              size: size.width * 0.05,
                            ),
                          ]);
                        }
                        if (snapshot.hasData) {
                          final snap = snapshot.data!.docs;

// 1. Filtrar solo inscritos
                          final inscritos = snap
                              .where((d) => d['GEDpm'] == 'inscrito')
                              .toList();

// 2. Separar profesores y no-profesores
                          final profesores = inscritos.where((d) {
                            final rol =
                                (d.data() as Map<String, dynamic>)['rol']
                                    ?.toString()
                                    .toLowerCase()
                                    .trim();
                            return rol == 'profesor';
                          }).toList();

                          final otros = inscritos.where((d) {
                            final rol =
                                (d.data() as Map<String, dynamic>)['rol']
                                    ?.toString()
                                    .toLowerCase()
                                    .trim();
                            return rol != 'profesor';
                          }).toList();

// 3. Ordenar ambas listas alfabéticamente por nombre
                          profesores.sort((a, b) => (a['name'] ?? '')
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  (b['name'] ?? '').toString().toLowerCase()));
                          otros.sort((a, b) => (a['name'] ?? '')
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  (b['name'] ?? '').toString().toLowerCase()));

// 4. Combinar: profesores primero
                          final List<DocumentSnapshot> orderedList = [
                            ...profesores,
                            ...otros
                          ];

                          if (orderedList.isEmpty) {
                            return RefreshIndicator(
                              color: Theme.of(context).colorScheme.tertiary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              onRefresh: _refresh,
                              child: ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(height: size.height * 0.15),
                                  Center(
                                    child: Text(
                                      'No hay usuarios inscritos',
                                      style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.tertiary,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            displacement: 1,
                            strokeWidth: 3,
                            onRefresh: _refresh,
                            child: SizedBox(
                              height: size.height * 0.524,
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
                                    shrinkWrap: true,
                                    primary: true,
                                    itemCount: orderedList.length,
                                    cacheExtent: 1000.0,
                                    itemBuilder: (context, index) {
                                      final doc = orderedList[index];

                                      // ── Encabezado ──────────────────────────────────────────────────────
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        child: ScaleAnimation(
                                          duration: Duration(milliseconds: 300),
                                          child: FadeInAnimation(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.width * 0.02)),
                                              elevation: 0,
                                              color: Colors.transparent,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 1,
                                                      color:
                                                          const Color.fromARGB(
                                                              148,
                                                              163,
                                                              163,
                                                              163),
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(
                                                    size.width * 0.03),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    129,
                                                                    168,
                                                                    1)),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.02),
                                                        Text(
                                                          doc['name'] ?? '—',
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.019,
                                                            fontFamily: 'Arial',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(doc['rol'] ?? '—',
                                                        style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.0162,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    129,
                                                                    168,
                                                                    1))),
                                                    Text(doc['email'] ?? '—',
                                                        style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.0162,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    153,
                                                                    153,
                                                                    153))),
                                                    Text(doc['phone'] ?? '—',
                                                        style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.0162,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    153,
                                                                    153,
                                                                    153))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('error');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future downloadFile(Reference ref) async {
    final Directory dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/${ref.name}');
    await ref.writeToFile(file);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${ref.name} descargado')));
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
