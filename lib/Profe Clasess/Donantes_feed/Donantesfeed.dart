import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:lapuerta2/detalles_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

class Donantesfeed extends StatefulWidget {
  const Donantesfeed({super.key});
  @override
  State<Donantesfeed> createState() => _DonantesfeedState();
}

class _DonantesfeedState extends State<Donantesfeed> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usuario =
      FirebaseFirestore.instance.collection('users').doc().snapshots();

  CollectionReference users =
      FirebaseFirestore.instance.collection('postsDonante');
  final controller = TextEditingController();
  final streaming = FirebaseFirestore.instance
      .collection('postsDonante')
      .orderBy('createdAt', descending: true)
      .snapshots();
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot> feedStream;
  late Future<DocumentSnapshot> futureUserDoc;

  // Estado para imagen y progreso
  File? _pickedImage;
  double? _uploadProgress;

// Elegir imagen de galería
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? xfile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (xfile != null) {
        setState(() {
          _pickedImage = File(xfile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
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
        FirebaseFirestore.instance.collection('clases').doc('esl 1').get();

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
                                  Text(
                                    'Donantes'.tr(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                },
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
                      child: SizedBox(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * 0.06,
                              width: size.width * 0.86,
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
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    textSelectionTheme: TextSelectionThemeData(
                                      selectionColor: Colors.blue.withOpacity(
                                          0.4), // visible highlight
                                      selectionHandleColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  child: TextField(
                                    contextMenuBuilder: (BuildContext context,
                                        EditableTextState editableTextState) {
                                      return AdaptiveTextSelectionToolbar
                                          .buttonItems(
                                        anchors: editableTextState
                                            .contextMenuAnchors,
                                        buttonItems: [
                                          ContextMenuButtonItem(
                                            onPressed: () {
                                              editableTextState.copySelection(
                                                  SelectionChangedCause
                                                      .toolbar);
                                            },
                                            type: ContextMenuButtonType.copy,
                                          ),
                                          ContextMenuButtonItem(
                                            onPressed: () {
                                              editableTextState.cutSelection(
                                                  SelectionChangedCause
                                                      .toolbar);
                                            },
                                            type: ContextMenuButtonType.cut,
                                          ),
                                          ContextMenuButtonItem(
                                            onPressed: () {
                                              editableTextState.pasteText(
                                                  SelectionChangedCause
                                                      .toolbar);
                                            },
                                            type: ContextMenuButtonType.paste,
                                          ),
                                          ContextMenuButtonItem(
                                            onPressed: () {
                                              editableTextState.selectAll(
                                                  SelectionChangedCause
                                                      .toolbar);
                                            },
                                            type:
                                                ContextMenuButtonType.selectAll,
                                          ),
                                        ],
                                      );
                                    },
                                    enableInteractiveSelection: true,
                                    //ocusNode: FocusScope.of(context).unfocus(),
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    // specialTextSpanBuilder: MySpecialTextSpanBuilder(),
                                    //textAlign: TextAlign.,
                                    onTapOutside: (event) {
                                      print('onTapOutside');
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    style: TextStyle(
                                        fontFamily: 'Arial',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    autofocus: false,
                                    minLines: 1,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    controller: controller,
                                    onChanged: (value) => setState(() {
                                      //controller.text = value.toString();
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
                                      hintText: "mensaje...".tr(),
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Arial'),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Botón adjuntar
                                          IconButton(
                                            tooltip: 'Adjuntar imagen',
                                            onPressed: _pickImage,
                                            icon: Icon(Icons.image_outlined,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          ),

                                          // Botón enviar (el que ya tenías)
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return FutureBuilder(
                                                    future: FireStoreDataBase()
                                                        .getData(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError)
                                                        return const Text(
                                                            'Something went wrong');
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Publicar mensaje'
                                                                  .tr(),
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary)),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '¿Estás seguro que quieres publicar este mensaje?'.tr()
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary)),
                                                              const SizedBox(
                                                                  height: 12),
                                                              if (_pickedImage !=
                                                                  null)
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image.file(
                                                                      _pickedImage!,
                                                                      height:
                                                                          120,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              if (_uploadProgress !=
                                                                  null) ...[
                                                                const SizedBox(
                                                                    height: 12),
                                                                LinearProgressIndicator(
                                                                    value:
                                                                        _uploadProgress),
                                                              ],
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                // <- Aquí va el código del envío actualizado del paso 2
                                                                DateTime now =
                                                                    DateTime
                                                                        .now();
                                                                String today =
                                                                    '${now.day}/${now.month}/${now.year}';
                                                                String
                                                                    timetoday =
                                                                    '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
                                                                String postId =
                                                                    now.toIso8601String();

                                                                String
                                                                    postImageUrl =
                                                                    'no imagen';

                                                                try {
                                                                  if (_pickedImage !=
                                                                      null) {
                                                                    final ref = FirebaseStorage
                                                                        .instance
                                                                        .ref()
                                                                        .child(
                                                                            'postsDonante/$postId.jpg');
                                                                    final uploadTask =
                                                                        ref.putFile(
                                                                      _pickedImage!,
                                                                      SettableMetadata(
                                                                          contentType:
                                                                              'image/jpeg'),
                                                                    );

                                                                    uploadTask
                                                                        .snapshotEvents
                                                                        .listen((TaskSnapshot
                                                                            snapshot) {
                                                                      setState(
                                                                          () {
                                                                        _uploadProgress = snapshot.bytesTransferred /
                                                                            (snapshot.totalBytes == 0
                                                                                ? 1
                                                                                : snapshot.totalBytes);
                                                                      });
                                                                    });

                                                                    final snap =
                                                                        await uploadTask;
                                                                    postImageUrl =
                                                                        await snap
                                                                            .ref
                                                                            .getDownloadURL();
                                                                  }

                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'postsDonante')
                                                                      .doc(
                                                                          postId)
                                                                      .set({
                                                                    'Name':
                                                                        data['name'] ??
                                                                            "",
                                                                    'Comment':
                                                                        controller
                                                                            .text
                                                                            .trim(),
                                                                    'Date':
                                                                        today,
                                                                    'Time':
                                                                        timetoday,
                                                                    'User':
                                                                        'La Puerta',
                                                                    'postUrl':
                                                                        postImageUrl,
                                                                    'Image': snapshot
                                                                        .data
                                                                        .toString(),
                                                                    'createdAt':
                                                                        Timestamp
                                                                            .now(),
                                                                  });

                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'postsState')
                                                                      .doc(
                                                                          'Donante')
                                                                      .set({
                                                                    'lastpost':
                                                                        postId
                                                                  });

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  controller
                                                                      .clear();
                                                                  setState(() {
                                                                    _pickedImage =
                                                                        null;
                                                                    _uploadProgress =
                                                                        null;
                                                                  });
                                                                } catch (e) {
                                                                  debugPrint(
                                                                      'Error al publicar: $e');
                                                                }
                                                              },
                                                              child: Text(
                                                                  'Aceptar'
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary)),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                              child: Text(
                                                                  'Cancelar'
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary)),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.send,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                size: size.height * 0.035),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
              if (_pickedImage != null) ...[
                SizedBox(height: size.height * 0.01),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Image.file(
                        _pickedImage!,
                        height: size.height * 0.1,
                        width: size.width * 0.3,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _pickedImage = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

              /*Container(
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
                        Navigator.pushNamed(context, '/profeESLpm_files'),
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
              ),*/
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
                        Navigator.pushNamed(context, '/profeDonanteStudents'),
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
                          'Donantes'.tr(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              fontFamily: 'Arial',
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
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                onRefresh:
                                    () async {}, // o tu función de refresco
                                child: SizedBox(
                                  height: size.height * 0.535,
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              displacement: 1,
                              strokeWidth: 3,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.475,
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
                                        final DocumentSnapshot doc = snapshot.data!.docs[index];
  final String heroTag = doc.id; // 👈 tag estable
  final String imageUrl = (doc['postUrl'] ?? '').toString();
  final bool hasImage = imageUrl.isNotEmpty && imageUrl != 'no imagen';


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
                                                                      title: Icon(
                                                                          Icons
                                                                              .info,
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              255,
                                                                              163,
                                                                              59)),
                                                                      content:
                                                                          Text(
                                                                        'Desea eliminar esto?'
                                                                            .tr(),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Arial',
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
                                                                              FirebaseFirestore.instance.collection('postsDonante').doc(snapshot.data!.docs[index].id).delete();
                                                                              FirebaseFirestore.instance.collection('users').doc(currentUser.email).collection('postsDonante_State').doc('State').set({
                                                                                'lastpost': ''
                                                                              });
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Aceptar'.tr(),
                                                                              style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontFamily: 'Arial'),
                                                                            )),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text('Cancelar'.tr(), style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontFamily: 'Arial')))
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
                                                            SizedBox(height: size.height*0.01,),
                                                        snap[index]['postUrl'] !=
                                                                  'no imagen'
                                                              ? GestureDetector(
                                                                  onTap: hasImage
        ? () {
            Navigator.of(context, rootNavigator: true).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 350),
                reverseTransitionDuration: const Duration(milliseconds: 350),
                pageBuilder: (_, __, ___) =>
                    ImageDetallesHome(documentSnapshot: doc), // 👈 sigues pasando el DocumentSnapshot
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            );
          }
        : null,
                                                                  child: Hero(
                                                                    tag:
                                                                        heroTag,
                                                                    flightShuttleBuilder:
                                                                        (
                                                                      flightContext,
                                                                      animation,
                                                                      flightDirection,
                                                                      fromHeroContext,
                                                                      toHeroContext,
                                                                    ) {
                                                                      return FadeTransition(
                                                                        opacity:
                                                                            animation.drive(Tween(begin: 1.0, end: size.height).chain(CurveTween(curve: Curves.easeInOut))),
                                                                        child: toHeroContext
                                                                            .widget,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height: size
                                                                              .height *
                                                                          0.35,
                                                                      width: size
                                                                          .height,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            0,
                                                                            158,
                                                                            158,
                                                                            158),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        border:
                                                                            Border.all(
                                                                          color: Color.fromRGBO(
                                                                              4,
                                                                              99,
                                                                              128,
                                                                              0),
                                                                          width:
                                                                              size.height * 0.0,
                                                                        ),
                                                                        //shape: BoxShape.circle,
                                                                        image:
                                                                            DecorationImage(
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          image:
                                                                              CachedNetworkImageProvider(
                                                                            snap[index]['postUrl']!,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox(
                                                                  height:
                                                                      size.height *
                                                                          0.0,
                                                                  width: size
                                                                      .height,
                                                                )
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
