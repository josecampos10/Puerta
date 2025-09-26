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

class ProfeCorte2 extends StatefulWidget {
  const ProfeCorte2({super.key});
  @override
  State<ProfeCorte2> createState() => _ProfeCorte2State();
}

class _ProfeCorte2State extends State<ProfeCorte2> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usuario =
      FirebaseFirestore.instance.collection('users').doc().snapshots();

  CollectionReference users =
      FirebaseFirestore.instance.collection('postsCorte2');
  final controller = TextEditingController();

  final streaming = FirebaseFirestore.instance
      .collection('postsCorte2')
      .orderBy('createdAt', descending: true)
      .snapshots();

  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot> feedStream;
  late Future<DocumentSnapshot> futureUserDoc;

  // Imagenes y progreso
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  bool _isPosting = false; // deshabilita botones mientras se sube
  List<double> _uploadProgress = []; // 0..1, alineado con _selectedImages

  // ---- Helpers imágenes ----
  Future<List<String>> _uploadImagesWithProgress(String postId) async {
    final storage = FirebaseStorage.instance;
    final List<String> urls = [];

    for (int i = 0; i < _selectedImages.length; i++) {
      try {
        final XFile file = _selectedImages[i];
        final String fileName =
            '${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = storage.ref().child('class_media/Corte2/$postId/$fileName');

        final bytes = await file.readAsBytes();
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'class': 'Corte2',
            'uploadedBy': currentUser.email ?? '',
            'postId': postId,
          },
        );

        final uploadTask = ref.putData(bytes, metadata);

        // Progreso
        uploadTask.snapshotEvents.listen((TaskSnapshot snap) {
          final total = snap.totalBytes == 0 ? 1 : snap.totalBytes;
          final progress = snap.bytesTransferred / total;
          if (mounted && i < _uploadProgress.length) {
            setState(() => _uploadProgress[i] = progress);
          }
        });

        await uploadTask;
        final url = await ref.getDownloadURL();
        urls.add(url);
      } catch (e) {
        debugPrint('Error subiendo imagen $i: $e');
      }
    }
    return urls;
  }

  void _syncProgressList() {
    if (_uploadProgress.length < _selectedImages.length) {
      _uploadProgress.addAll(
        List<double>.filled(
            _selectedImages.length - _uploadProgress.length, 0.0),
      );
    } else if (_uploadProgress.length > _selectedImages.length) {
      _uploadProgress.removeRange(
          _selectedImages.length, _uploadProgress.length);
    }
  }

  Future<void> _pickImages() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 100,
      );
      if (!mounted) return;
      setState(() {
        _selectedImages = images ?? [];
        _syncProgressList();
      });
    } catch (e) {
      debugPrint('Error pickMultiImage: $e');
    }
  }

  // ---- Ciclo de vida ----
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,
        () => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    getProfilePicture();
    futureUserDoc = FirebaseFirestore.instance
        .collection('clases')
        .doc('Corte y Confección 2')
        .get();
  }

  @override
  void dispose() {
    super.dispose();
    getProfilePicture();
  }

  // ---- UI ----
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final composerH = size.height * 0.06; // altura barra input
    final previewH = size.height * 0.10; // altura preview

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        iconTheme: CupertinoIconThemeData(
          color: Colors.white,
          size: size.height * 0.035,
        ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.09,
        leadingWidth: size.width * 0.13,
        title: Padding(
          padding: EdgeInsets.only(top: size.height * 0.0),
          child: Text(
            ez.tr('Mis clases'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.024,
              color: Colors.white,
              fontFamily: '',
            ),
          ),
        ),
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: '',
          fontWeight: FontWeight.bold,
          fontSize: size.height * 0.023,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/img/puntos.png'),
              fit: BoxFit.fill,
              colorFilter: (Theme.of(context).colorScheme.tertiary !=
                      const Color.fromRGBO(4, 99, 128, 1))
                  ? const ColorFilter.mode(
                      Color.fromARGB(255, 68, 68, 68), BlendMode.color)
                  : const ColorFilter.mode(
                      Color.fromARGB(0, 255, 29, 29), BlendMode.color),
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
                    color: const Color.fromRGBO(255, 255, 255, 0.174),
                    width: size.height * 0.003,
                  ),
                  shape: BoxShape.circle,
                  image: pickedImage != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.memory(pickedImage!).image,
                        )
                      : null,
                ),
              ),
              SizedBox(width: size.width * 0.03),
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // =========================
            // CAPA 1: CONTENIDO + FEED
            // =========================
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.087),
                    topRight: Radius.circular(size.width * 0.087),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    size.width * 0.001,
                    0,
                    size.width * 0.001,
                    composerH +
                        (_selectedImages.isNotEmpty ? (previewH + 8) : 0) +
                        MediaQuery.of(context).viewInsets.bottom +
                        8,
                  ),
                  child: Column(
                    children: [
                      // ---- Cabecera de clase ----
                      FutureBuilder<DocumentSnapshot>(
                        future: futureUserDoc,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: size.height * 0.18,
                              child: Center(
                                child: SpinKitFadingCircle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: size.width * 0.055,
                                ),
                              ),
                            );
                          }
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return SizedBox(
                              height: size.height * 0.18,
                              child: const Center(
                                  child: Text('No hay datos del usuario')),
                            );
                          }

                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: size.width,
                              height: size.height * 0.10,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  filterQuality: FilterQuality.low,
                                  image:
                                      AssetImage('assets/img/Costuraback.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(size.width * 0.087),
                                  topRight: Radius.circular(size.width * 0.087),
                                  bottomLeft:
                                      Radius.circular(size.width * 0.04),
                                  bottomRight:
                                      Radius.circular(size.width * 0.04),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data['Name'.tr()] ?? 'Nombre clase',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.03,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          data['Days'] ?? 'Días',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.017,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          data['Time'] ?? 'Horario',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.017,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: size.width * 0.01,
                                        top: size.height * 0.05,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(context,
                                                    '/profeCorte2_files'),
                                            icon: Icon(Icons.folder,
                                                color: Colors.white,
                                                size: size.height * 0.03),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(context,
                                                    '/profeCorte2_students'),
                                            icon: Icon(Icons.person_3,
                                                color: Colors.white,
                                                size: size.height * 0.03),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // ---- Feed ----
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
                              SizedBox(height: size.height * 0.02),
                              SpinKitFadingCircle(
                                color: Theme.of(context).colorScheme.tertiary,
                                size: size.width * 0.1,
                              ),
                            ]);
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return RefreshIndicator(
                              color: Theme.of(context).colorScheme.tertiary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              elevation: 0,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.595,
                                child: ListView(
                                  physics: AlwaysScrollableScrollPhysics(),
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
                              height: size.height * 0.5955,
                              width: size.width,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: MasonryGridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1),
                                  mainAxisSpacing: 1,
                                  crossAxisSpacing: 1,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: true,
                                  itemCount: snap.length,
                                  cacheExtent: 1000.0,
                                  itemBuilder: (context, index) {
                                    final doc = snap[index];
                                    final Map<String, dynamic> dataMap =
                                        doc.data() as Map<String, dynamic>;
                                    final List<String> images =
                                        (dataMap['images'] as List?)
                                                ?.map((e) => e.toString())
                                                .toList() ??
                                            const [];

                                    // debug
                                    debugPrint(
                                        'Post ${doc.id} -> images: ${images.length}');

                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        child: ScaleAnimation(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.width * 0.04),
                                                ),
                                                elevation: size.height * 0.01,
                                                shadowColor: Colors.black,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      size.width * 0.03),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(snap[
                                                                        index]
                                                                    ['Image']),
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
                                                                    .tertiary,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['User'],
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
                                                                    .secondary,
                                                              ),
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
                                                                  168),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Icon(
                                                                        Icons
                                                                            .info,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            163,
                                                                            59)),
                                                                    content:
                                                                        Text(
                                                                      'Desea eliminar esto?'
                                                                          .tr(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Arial',
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary,
                                                                      ),
                                                                    ),
                                                                    actionsAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('postsCorte2')
                                                                              .doc(snapshot.data!.docs[index].id)
                                                                              .delete();
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  'users')
                                                                              .doc(currentUser
                                                                                  .email)
                                                                              .collection(
                                                                                  'postsCorte2_State')
                                                                              .doc(
                                                                                  'State')
                                                                              .set({
                                                                            'lastpost':
                                                                                ''
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Aceptar'
                                                                              .tr(),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary,
                                                                            fontFamily:
                                                                                'Arial',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(),
                                                                        child:
                                                                            Text(
                                                                          'Cancelar'
                                                                              .tr(),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.secondary,
                                                                            fontFamily:
                                                                                'Arial',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(
                                                                Icons.delete,
                                                                size:
                                                                    size.height *
                                                                        0.02),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.12),
                                                          Text(
                                                            snap[index]['Date'],
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
                                                                  168),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Linkify(
                                                          linkStyle: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontSize:
                                                                size.height *
                                                                    0.0155,
                                                            fontFamily: 'Arial',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                94, 145, 255),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.0155,
                                                            fontFamily: 'Arial',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                          text: snap[index]
                                                              ['Comment'],
                                                          onOpen: (link) async {
                                                            if (!await launchUrl(
                                                                Uri.parse(link
                                                                    .url))) {
                                                              throw Exception(
                                                                  'Could not launch ${link.url}');
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      if (images
                                                          .isNotEmpty) ...[
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      size.width *
                                                                          0.03),
                                                          child: SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.30,
                                                            child: images
                                                                        .length ==
                                                                    1
                                                                // ===== 1 sola imagen =====
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        PageRouteBuilder(
                                                                          transitionDuration:
                                                                              const Duration(milliseconds: 500),
                                                                          reverseTransitionDuration:
                                                                              const Duration(milliseconds: 500),
                                                                          pageBuilder: (_, __, ___) =>
                                                                              ImageDetallesHome(
                                                                            images:
                                                                                images, // 👈 pásale todas
                                                                            initialIndex:
                                                                                0,
                                                                            documentSnapshot:
                                                                                doc, // 👈 abre en la tocada (0 en este caso)
                                                                            // si tu detalle espera otros campos, pásalos aquí
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Hero(
                                                                      tag:
                                                                          'post_${doc.id}_img_0', // opcional, para animación
                                                                      child: Image
                                                                          .network(
                                                                        images
                                                                            .first,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  )
                                                                // ===== Varias imágenes (carrusel) =====
                                                                : PageView
                                                                    .builder(
                                                                    itemCount:
                                                                        images
                                                                            .length,
                                                                    controller: PageController(
                                                                        viewportFraction:
                                                                            0.95),
                                                                    itemBuilder:
                                                                        (_, idx) {
                                                                      final url =
                                                                          images[
                                                                              idx];
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                6),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              PageRouteBuilder(
                                                                                transitionDuration: const Duration(milliseconds: 500),
                                                                                reverseTransitionDuration: const Duration(milliseconds: 500),
                                                                                pageBuilder: (_, __, ___) => ImageDetallesHome(
                                                                                  images: images, // 👈 lista completa
                                                                                  initialIndex: idx, documentSnapshot: doc, // 👈 abre en la tocada
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Hero(
                                                                            tag:
                                                                                'post_${doc.id}_img_$idx', // opcional, animación
                                                                            child:
                                                                                Image.network(
                                                                              url,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // =========================
            // CAPA 2: PREVIEW FLOTANTE
            // =========================
            if (_selectedImages.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom:
                    composerH + MediaQuery.of(context).viewInsets.bottom + 8,
                child: SafeArea(
                  top: false,
                  child: Container(
                    height: previewH,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FutureBuilder<Uint8List>(
                                future: _selectedImages[i].readAsBytes(),
                                builder: (context, snap) {
                                  if (!snap.hasData) {
                                    return SizedBox(
                                      width: previewH,
                                      height: previewH,
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                  return Image.memory(
                                    snap.data!,
                                    width: previewH,
                                    height: previewH,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.cancel, size: 18),
                                onPressed: _isPosting
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedImages.removeAt(i);
                                          _syncProgressList();
                                        });
                                      },
                              ),
                            ),
                            if (_isPosting)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  child: LinearProgressIndicator(
                                    value: (_uploadProgress.length > i
                                            ? _uploadProgress[i]
                                            : 0.0)
                                        .clamp(0.0, 1.0),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

            // =========================
            // CAPA 3: COMPOSER ABAJO
            // =========================
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.email)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(height: composerH);
                      }
                      final Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Container(
                        color: Theme.of(context).colorScheme.tertiary,
                        height: composerH,
                        width: size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: composerH * 0.85,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 163, 163, 163),
                                    width: 2,
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextField(
                                  controller: controller,
                                  onTapOutside: (event) {
                                      print('onTapOutside');
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                  decoration: InputDecoration(
                                    hintText: "mensaje...".tr(),
                                    border: InputBorder.none,
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed:
                                              _isPosting ? null : _pickImages,
                                          icon: Icon(
                                            Icons.photo_library_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          tooltip: 'Adjuntar imágenes',
                                        ),
                                        IconButton(
                                          onPressed: _isPosting
                                              ? null
                                              : () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return FutureBuilder(
                                                        future:
                                                            FireStoreDataBase()
                                                                .getData(),
                                                        builder: (context,
                                                            snapUser) {
                                                          if (snapUser
                                                              .hasError) {
                                                            return const Text(
                                                                'Something went wrong');
                                                          }
                                                          if (snapUser
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                'Publicar mensaje'
                                                                    .tr(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary,
                                                                ),
                                                              ),
                                                              content: Text(
                                                                'Estás seguro que quieres publicar este mensaje?'
                                                                    .tr(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary,
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (controller
                                                                            .text
                                                                            .trim()
                                                                            .isEmpty &&
                                                                        _selectedImages
                                                                            .isEmpty) {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      return;
                                                                    }

                                                                    setState(() =>
                                                                        _isPosting =
                                                                            true);

                                                                    final now =
                                                                        DateTime
                                                                            .now();
                                                                    final String
                                                                        postId =
                                                                        now.toIso8601String();
                                                                    final String
                                                                        today =
                                                                        '${now.day}/${now.month}/${now.year}';
                                                                    final String
                                                                        timetoday =
                                                                        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                                                                    try {
                                                                      List<String>
                                                                          imageUrls =
                                                                          [];
                                                                      if (_selectedImages
                                                                          .isNotEmpty) {
                                                                        imageUrls =
                                                                            await _uploadImagesWithProgress(postId);
                                                                      }

                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'postsCorte2')
                                                                          .doc(
                                                                              postId)
                                                                          .set({
                                                                        'User':
                                                                            data['name'] ??
                                                                                "",
                                                                        'Comment': controller
                                                                            .text
                                                                            .trim(),
                                                                        'Date':
                                                                            today,
                                                                        'Time':
                                                                            timetoday,
                                                                        // 'User': 'La Puerta',
                                                                        'postUrl': imageUrls.isNotEmpty
                                                                            ? imageUrls.first
                                                                            : 'no imagen',
                                                                        'images':
                                                                            imageUrls,
                                                                        'imageCount':
                                                                            imageUrls.length,
                                                                        'storagePath':
                                                                            'class_media/Corte2/$postId/',
                                                                        'Image': snapUser
                                                                            .data
                                                                            .toString(),
                                                                        'createdAt':
                                                                            Timestamp.now(),
                                                                      });

                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'postsState')
                                                                          .doc(
                                                                              'Corte2')
                                                                          .set({
                                                                        'lastpost':
                                                                            postId
                                                                      });

                                                                      if (!mounted)
                                                                        return;
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      controller
                                                                          .clear();
                                                                      setState(
                                                                          () {
                                                                        _selectedImages
                                                                            .clear();
                                                                        _uploadProgress
                                                                            .clear();
                                                                        _isPosting =
                                                                            false;
                                                                      });
                                                                    } catch (e) {
                                                                      debugPrint(
                                                                          'Error publicando: $e');
                                                                      if (!mounted)
                                                                        return;
                                                                      setState(() =>
                                                                          _isPosting =
                                                                              false);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    'Aceptar'
                                                                        .tr(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: Text(
                                                                    'Cancelar'
                                                                        .tr(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                    ),
                                                                  ),
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
                                          icon: Icon(
                                            Icons.send,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          tooltip: 'Publicar',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
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
      debugPrint('Profile Picture could not be found');
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
