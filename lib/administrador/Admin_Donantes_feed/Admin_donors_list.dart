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
import 'package:easy_localization/easy_localization.dart' as ez;

class AdminDonorslist extends StatefulWidget {
  const AdminDonorslist({super.key});
  @override
  State<AdminDonorslist> createState() => AdminDonorslistState();
}

class AdminDonorslistState extends State<AdminDonorslist> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('postsDonante');
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
    final path = 'ESLfiles/${pickedFile!.name}';
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
    futureFiles = FirebaseStorage.instance.ref('/ESLfiles').listAll();
    getProfilePicture();
    futureUserDoc =
        FirebaseFirestore.instance.collection('clases').doc('esl 1').get();
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
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                    height: size.height * 0.04,
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
                          'Control de noticias',
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
                      height: size.height * 0.12,
                      width: size.width * 0.98,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('assets/img/coop.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // 👉 Imagen superior derecha
                          Positioned(
                            top: 0,
                            right: size.width * 0.04,
                            child: Image.asset('assets/img/handson.png',
                                width: size.width *
                                    0.28 // ajusta el tamaño según tu diseño
                                ),
                          ),

                          // 👉 Nombre desde Firebase
                          Positioned(
                            top: size.height * 0.05,
                            left: size.width * 0.04,
                            child: Column(
                              children: [
                                Text('Donantes'.tr(), style: TextStyle(color: Colors.white, fontSize: size.height*0.02, fontWeight: FontWeight.bold),)
                              ],
                            )
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

  return RefreshIndicator(
    elevation: 0,
    color: Theme.of(context).colorScheme.tertiary,
    backgroundColor: Theme.of(context).colorScheme.primary,
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
              SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemCount: snap.length,
          cacheExtent: 1000.0,
          itemBuilder: (context, index) {
            final doc = snap[index];
            if(doc['rol'] == 'Donante'){
            return AnimationConfiguration.staggeredList(
              position: index,
              child: ScaleAnimation(
                duration: Duration(milliseconds: 300),
                child: FadeInAnimation(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    elevation: 0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: const Color.fromARGB(148, 163, 163, 163),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(size.width * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_3,
                                  size: size.height * 0.02,
                                  color: Color.fromRGBO(0, 129, 168, 1)),
                              SizedBox(width: size.width * 0.02),
                              Text(
                                doc['name'] ?? '—',
                                style: TextStyle(
                                  fontSize: size.height * 0.019,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            doc['rol'] ?? '—',
                            style: TextStyle(
                              fontSize: size.height * 0.0162,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 129, 168, 1),
                            ),
                          ),
                          Text(
                            doc['email'] ?? '—',
                            style: TextStyle(
                              fontSize: size.height * 0.0162,
                              color: Color.fromARGB(255, 153, 153, 153),
                            ),
                          ),
                          Text(
                            doc['phone'] ?? '—',
                            style: TextStyle(
                              fontSize: size.height * 0.0162,
                              color: Color.fromARGB(255, 153, 153, 153),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
          },
        ),
      ),
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
