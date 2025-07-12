import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCiudadania extends StatefulWidget {
  const StudentCiudadania({super.key});
  @override
  State<StudentCiudadania> createState() => _StudentCiudadaniaState();
}

class _StudentCiudadaniaState extends State<StudentCiudadania> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  //CollectionReference users = FirebaseFirestore.instance.collection('postsESL');
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot> base;

  @override
  void initState() {
    super.initState();
    getProfilePicture();
    base = FirebaseFirestore.instance
        .collection('postsESL')
        .orderBy('Time', descending: true)
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
                            fontSize: size.height * 0.075,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Clase de Ciudadanía',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.022,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Martes y Jueves',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '5:30 pm - 7:30 pm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: size.height * 0.055,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey))),
                child: TextButton(
                    onPressed: () => Navigator.pushNamed(
                        context, '/studentCiudadania_files'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Icon(Icons.folder_copy_outlined,  color: Theme.of(context).colorScheme.secondary,),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          'Archivos',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: size.height * 0.022,
                            fontFamily: 'Arial',  color: Theme.of(context).colorScheme.secondary,),
                        ),
                      ],
                    )),
              ),
              
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('postsCiudadania')
                            .orderBy('Time', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            final snap = snapshot.data!.docs;
                            return RefreshIndicator(
                              color: Theme.of(context).colorScheme.tertiary,
                              backgroundColor: Colors.white,
                              displacement: 1,
                              strokeWidth: 3,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.533,
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
                                                color:  Theme.of(context).colorScheme.primary,
                                                child: Container(
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(snap[
                                                                        index]
                                                                    ['Image']),
                                                              minRadius:
                                                                  size.height *
                                                                      0.023,
                                                              maxRadius:
                                                                  size.height *
                                                                      0.023,
                                                              backgroundColor:
                                                                  Theme.of(context).colorScheme.tertiary),
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
                                                                        0.019,
                                                                fontFamily:
                                                                    'Arial',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Theme.of(context).colorScheme.secondary
                                                              ),
                                                            ),
                                                          ),
                                                           SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            snap[index]['Time'],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.013,
                                                                fontFamily:
                                                                    'JosefinSans',
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
                                                            width: size.width *
                                                                0.12,
                                                          ),
                                                          Text(
                                                            snap[index]['Date'],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.013,
                                                                fontFamily:
                                                                    'JosefinSans',
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
                                                              linkStyle: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none,
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Arial',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      94,
                                                                      145,
                                                                      255)),
                                                              style: TextStyle(
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
