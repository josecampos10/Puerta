import 'dart:math';
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
import 'package:image_picker/image_picker.dart';
import 'package:lapuerta2/administrador/image_storage_methods.dart';
import 'package:lapuerta2/administrador/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class feedLaPuerta extends StatefulWidget {
  const feedLaPuerta({Key? key}) : super(key: key);
  @override
  State<feedLaPuerta> createState() => _feedLaPuertaState();
}

class _feedLaPuertaState extends State<feedLaPuerta> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usuario =
      FirebaseFirestore.instance.collection('users').doc().snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('postsESL');
  final controller = TextEditingController();
  final streaming = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .snapshots();
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot> feedStream;
  final TextEditingController controllerdes = TextEditingController();
  late Stream<DocumentSnapshot<Map<String, dynamic>>> imagenes;

  bool _isLoading = false;
  Uint8List? _file;

  void postImage(user, unnombre) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await ImageStoreMethods()
          .uploadPost(controllerdes.text, _file!, user, unnombre);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackbar('Publicado', context);
        clearImage();
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackbar(res, context);
      }
    } catch (err) {
      showSnackbar(err.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _imageSelect(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Seleccionar'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Usa la cámara'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Desde la galería'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getProfilePicture();
    var feed = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('Time', descending: true)
        .snapshots();
    feedStream = feed;
    imagenes = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUsera.email) // 👈 Your document id change accordingly
        .snapshots();
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
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: imagenes,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          SpinKitFadingCircle(
                            color: Theme.of(context).colorScheme.tertiary,
                            size: size.width * 0.055,
                          )
                        ],
                      );
                    }
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.03,
                        ),
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
                                        key: UniqueKey(),
                                      ).image)
                                  : null),
                        ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        Text(
                          data['name'],
                          style: TextStyle(
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Publicar en la ventana principal'),
                                      content: Text(
                                          'Esta publicación se mostrará en el ventana principal de La Puerta App. Si desea eliminar una publicación realizada anteriormente póngase en contacto con la oficina de La Puerta'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Cerrar',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.info,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: size.height * 0.029,
                            ))
                      ],
                    );
                  }),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(0)),
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: controllerdes,
                  onChanged: (value) => setState(() {
                    controllerdes.text = value.toString();
                  }),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(0, 0, 0, 0), width: 0.0)),
                    labelText: 'Que desea escribir...',
                    prefixIcon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    labelStyle: TextStyle(fontSize: 14, fontFamily: 'Impact'),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  SizedBox(
                    width: size.width * 0.10,
                    child: IconButton(
                        onPressed: () => _imageSelect(context),
                        icon: Image(
                          image: AssetImage('assets/img/iconphoto.png'),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: imagenes,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(children: [
                        SpinKitFadingCircle(
                          color: Theme.of(context).colorScheme.tertiary,
                          size: size.width * 0.055,
                        ),
                      ]);
                    }
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return _file == null
                        ? StreamBuilder<QuerySnapshot>(
                            stream: feedStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    SpinKitFadingCircle(
                                      color: Color.fromRGBO(4, 99, 128, 1),
                                      size: size.width * 0.1,
                                    )
                                  ],
                                );
                              }
                              if (snapshot.hasData) {
                                final sanp = snapshot.data!.docs;
                                return Center(
                                  child: Column(
                                    children: [
                                      FutureBuilder(
                                          future: FireStoreDataBase().getData(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return const Text(
                                                  'Something went wrong');
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return Container(
                                                height: size.height * 0.06,
                                                width: size.width * 0.5,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (controllerdes.text ==
                                                        '') {
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Publicar actividad'),
                                                              content: Text(
                                                                  'Estás seguro que quieres publicar esta actividad?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      DateTime
                                                                          date =
                                                                          DateTime
                                                                              .now();
                                                                      String
                                                                          today =
                                                                          '${date.day}/${date.month}/${date.year}';
                                                                      String
                                                                          timetoday =
                                                                          '${date.hour}:${date.minute}';
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'posts')
                                                                          .doc(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second)
                                                                              .toString())
                                                                          .set({
                                                                        'Comment':
                                                                            controllerdes.text,
                                                                        'Date':
                                                                            today,
                                                                        'Time':
                                                                            timetoday,
                                                                        'User':
                                                                            data['name'],
                                                                        'postUrl':
                                                                            'no imagen',
                                                                        'Image': snapshot
                                                                            .data
                                                                            .toString(),
                                                                        'createdAt':
                                                                            Timestamp.now()
                                                                      });

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      // postImage();

                                                                      controllerdes
                                                                          .clear();
                                                                    },
                                                                    child: Text(
                                                                      'Aceptar',
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary),
                                                                    )),
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
                                                    }
                                                    if (controllerdes
                                                        .text.isEmpty) {
                                                      return;
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          backgroundColor:
                                                              Color
                                                                  .fromRGBO(
                                                                      4,
                                                                      99,
                                                                      128,
                                                                      1),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical:
                                                                      10)),
                                                  child: Text(
                                                    'Siguiente',
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize:
                                                            size.width * 0.044,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              );
                                            }
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            })
                        : Center(
                            child: Column(
                              children: [
                                FutureBuilder(
                                    future: FireStoreDataBase().getData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Something went wrong');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Column(children: [
                                          Container(
                                            height: size.height * 0.35,
                                            width: size.height,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    0, 158, 158, 158),
                                                border: Border.all(
                                                  color: Color.fromRGBO(
                                                      4, 99, 128, 0),
                                                  width: size.height * 0.0,
                                                ),
                                                //shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: Image.memory(
                                                      _file!,
                                                    ).image)),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (controllerdes.text == '') {
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Publicar actividad'),
                                                        content: Text(
                                                            'Estás seguro que quieres publicar esta actividad?'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                DateTime date =
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
                                                                        'posts')
                                                                    .doc(DateTime(
                                                                            DateTime.now().year,
                                                                            DateTime.now().month,
                                                                            DateTime.now().day,
                                                                            DateTime.now().hour,
                                                                            DateTime.now().minute,
                                                                            DateTime.now().second)
                                                                        .toString())
                                                                    .update({
                                                                  /*'Comment': controllerdes.text,
                                          'Date': today,
                                          'Time': timetoday,
                                          'User': 'La Puerta',
                                          'postUrl': 'no image',*/
                                                                  'Image': snapshot
                                                                      .data
                                                                      .toString(),
                                                                });

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                postImage(
                                                                    snapshot
                                                                        .data
                                                                        .toString(),
                                                                    data[
                                                                        'name']);

                                                                controllerdes
                                                                    .clear();
                                                              },
                                                              child: Text(
                                                                  'Aceptar',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary))),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Cancelar',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary)))
                                                        ],
                                                      );
                                                    });
                                              }
                                              if (controllerdes.text.isEmpty) {
                                                return;
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor: Color.fromRGBO(
                                                    4, 99, 128, 1),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 10)),
                                            child: Text(
                                              'Siguiente',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: size.width * 0.044,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ]);
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }),
                              ],
                            ),
                          );
                  }
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
