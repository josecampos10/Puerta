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

class ProfeCosturaAM extends StatefulWidget {
  const ProfeCosturaAM({Key? key}) : super(key: key);
  @override
  State<ProfeCosturaAM> createState() => _ProfeCosturaAMState();
}

class _ProfeCosturaAMState extends State<ProfeCosturaAM> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users =
      FirebaseFirestore.instance.collection('postsCostura');
  final controller = TextEditingController();

  final streaming = FirebaseFirestore.instance
      .collection('postsCostura')
      .orderBy('createdAt', descending: true)
      .snapshots();
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    getProfilePicture();
    //final streaming;
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
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
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
                          image: AssetImage('assets/img/Costuraback.png'),
                          fit: BoxFit.cover),
                      //color: Color.fromARGB(155, 255, 102, 0),
                      borderRadius: BorderRadius.all(Radius.circular(31))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Costura',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.075,
                            fontFamily: 'Coolvetica',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Corte y Confeccion',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.022,
                            fontFamily: 'Coolvetica',
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Miercoles y Viernes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontFamily: 'Coolvetica',
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '10:00 am - 12:00 pm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontFamily: 'Coolvetica',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.email)
                    // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  //final data = snapshot.data!.data();
                  if (snapshot.hasData) {
                    final Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Container(
                      height: size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.primary,
                      child: Container(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: size.width * 0.01),
                            Container(
                              height: size.height * 0.06,
                              width: size.width * 0.98,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 1.0, vertical: 0.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 163, 163, 163),
                                        width: 2),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextField(
                                  //textAlign: TextAlign.,
                                  autofocus: false,
                                  minLines: 1,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  controller: controller,
                                  onChanged: (value) => setState(() {
                                    controller.text = value.toString();
                                  }),
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                                0, 0, 187, 212)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                                0, 0, 187, 212)),
                                      ),
                                      //isCollapsed: true,
                                      hintText: "Mensaje",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return FutureBuilder(
                                                    future: FireStoreDataBase()
                                                        .getData(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError) {
                                                        return const Text(
                                                            'Something went wrong');
                                                      }
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Publicar actividad'),
                                                          content: Text(
                                                              'Estás seguro que quieres publicar esta actividad?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  DateTime
                                                                      date =
                                                                      DateTime
                                                                          .now();
                                                                  String today =
                                                                      '${date.day}/${date.month}/${date.year}';
                                                                  String
                                                                      timetoday =
                                                                      '${date.hour}:${date.minute}';
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'postsCostura')
                                                                      .doc(DateTime(
                                                                              DateTime.now().year,
                                                                              DateTime.now().month,
                                                                              DateTime.now().day,
                                                                              DateTime.now().hour,
                                                                              DateTime.now().minute,
                                                                              DateTime.now().second)
                                                                          .toString())
                                                                      .set({
                                                                    'Name':
                                                                        data['name'] ??
                                                                            "",
                                                                    'Comment':
                                                                        controller
                                                                            .text,
                                                                    'Date':
                                                                        today,
                                                                    'Time':
                                                                        timetoday,
                                                                    'User':
                                                                        'La Puerta',
                                                                    'postUrl':
                                                                        'no imagen',
                                                                    'Image': snapshot
                                                                        .data
                                                                        .toString(),
                                                                    'createdAt':
                                                                        Timestamp
                                                                            .now()
                                                                  });

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  // postImage();

                                                                  controller
                                                                      .clear();
                                                                },
                                                                child: Text(
                                                                    'Aceptar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),))
                                                          ],
                                                        );
                                                      }
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    });
                                              });
                                        },
                                        icon: Icon(
                                          Icons.send,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: size.height * 0.035,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('error');
                  } else {
                    return CircularProgressIndicator(
                      strokeWidth: size.height * 0.0001,
                    );
                  }
                },
              ),
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
                        Navigator.pushNamed(context, '/profeCostura_filesAM'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Icon(
                          Icons.folder_copy_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          'Archivos',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontFamily: 'Coolvetica',
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    )),
              ),
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
                    onPressed: () => Navigator.pushNamed(
                        context, '/studentCostura_students'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Icon(
                          Icons.person_3,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          'Estudiantes',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontFamily: 'Coolvetica',
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
                                height: size.height * 0.408,
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
                                                        Row(children: [
                                                          CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      snap[index]
                                                                          [
                                                                          'Image']),
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
                                                                      'Coolvetica',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary),
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
                                                          Expanded(
                                                              child:
                                                                  SizedBox()), //this is crucial- this keeps icon always at the end
                                                          IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                          Icon(
                                                                        Icons
                                                                            .info,
                                                                        color: Colors
                                                                            .yellow,
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        'Desea eliminar esto?',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary),
                                                                      ),
                                                                      actionsAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              FirebaseFirestore.instance.collection('postsCostura').doc(snapshot.data!.docs[index].id).delete();

                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Aceptar',
                                                                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                                                            )),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.secondary)))
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            icon: Icon(
                                                                Icons.delete,
                                                                size:
                                                                    size.height *
                                                                        0.02),
                                                          )
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
                                                              linkStyle:
                                                                  TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                fontSize:
                                                                    size.height *
                                                                        0.0162,
                                                                fontFamily:
                                                                    'Impact',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    94,
                                                                    145,
                                                                    255),
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Impact',
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
