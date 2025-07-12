import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfeCiudadaniastudents extends StatefulWidget {
  const ProfeCiudadaniastudents({super.key});
  @override
  State<ProfeCiudadaniastudents> createState() =>
      _ProfeCiudadaniastudentsState();
}

class _ProfeCiudadaniastudentsState extends State<ProfeCiudadaniastudents> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users =
      FirebaseFirestore.instance.collection('postsCiudadania');
  late Future<ListResult> futureFiles;
  PlatformFile? pickedFile;
  List<PlatformFile>? selectedFiles;
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;

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
      backgroundColor:  Theme.of(context).colorScheme.tertiary,
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
        backgroundColor: const Color.fromRGBO(4, 99, 128, 1),
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
                  color: Color.fromRGBO(4, 99, 128, 1),
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
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          filterQuality: FilterQuality.low,
                          image: AssetImage('assets/img/Ciudadaniaback.png'),
                          fit: BoxFit.cover),
                      //color: Color.fromARGB(155, 255, 102, 0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(size.width * 0.087))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ciudadanía',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.06,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Clase de Ciudadanía',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.02,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Martes y Jueves',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '5:30 pm - 7:30 pm',
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
              ),
              
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .orderBy('name', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final snap = snapshot.data!.docs;
                          return RefreshIndicator(
                            color: Theme.of(context).colorScheme.tertiary,
                            backgroundColor: Colors.white,
                            displacement: 1,
                            strokeWidth: 3,
                            onRefresh: () async {},
                            child: SizedBox(
                              height: size.height * 0.589,
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
                                      // DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                                      if (snap[index]['ciudadania'] ==
                                          'inscrito') {
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          child: ScaleAnimation(
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: FadeInAnimation(
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
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color.fromARGB(148, 163, 163, 163)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color:
                                                                Color.fromRGBO(0, 129, 168, 1)
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
                                                                        0.019,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Theme.of(context).colorScheme.secondary,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
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
                                                                          .w700,
                                                                  color: Color.fromRGBO(0, 129, 168, 1),
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
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['email'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color.fromARGB(255, 153, 153, 153)
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
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['phone'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color.fromARGB(255, 153, 153, 153)
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
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }),
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

  Future downloadFile(Reference ref) async {
    final Directory dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/${ref.name}');
    await ref.writeToFile(file);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${ref.name} descargado')));
  }
}
