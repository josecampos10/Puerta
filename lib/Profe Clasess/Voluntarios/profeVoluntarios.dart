
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
import 'package:image_picker/image_picker.dart'; // 👈 NUEVO
import 'package:lapuerta2/detalles_image.dart';   // 👈 Para zoom/carrusel
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

class Volunteers extends StatefulWidget {
  const Volunteers({super.key});
  @override
  State<Volunteers> createState() => _VolunteersState();
}

class _VolunteersState extends State<Volunteers> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usuario =
      FirebaseFirestore.instance.collection('users').doc().snapshots();

  final CollectionReference users =
      FirebaseFirestore.instance.collection('Volunteers');

  final controller = TextEditingController();

  final streaming = FirebaseFirestore.instance
      .collection('Volunteers')
      .orderBy('createdAt', descending: true)
      .snapshots();

  // ---- Avatar / clase ----
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Future<DocumentSnapshot> futureUserDoc;

  // ---- Imágenes & progreso (como ProfeCorte2) ----
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  bool _isPosting = false;
  List<double> _uploadProgress = [];

  void _syncProgressList() {
    if (_uploadProgress.length < _selectedImages.length) {
      _uploadProgress.addAll(
        List<double>.filled(_selectedImages.length - _uploadProgress.length, 0),
      );
    } else if (_uploadProgress.length > _selectedImages.length) {
      _uploadProgress.removeRange(_selectedImages.length, _uploadProgress.length);
    }
  }

  Future<void> _pickImages() async {
    try {
      final images = await _picker.pickMultiImage(imageQuality: 100);
      if (!mounted) return;
      setState(() {
        _selectedImages = images ?? [];
        _syncProgressList();
      });
    } catch (e) {
      debugPrint('pickMultiImage error: $e');
    }
  }

  Future<List<String>> _uploadImagesWithProgress(String postId) async {
    final storage = FirebaseStorage.instance;
    final List<String> urls = [];
    for (int i = 0; i < _selectedImages.length; i++) {
      try {
        final file = _selectedImages[i];
        final name = '${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = storage.ref('class_media/Volunteers/$postId/$name');
        final bytes = await file.readAsBytes();

        final uploadTask = ref.putData(
          bytes,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {
              'class': 'Volunteers',
              'uploadedBy': currentUser.email ?? '',
              'postId': postId,
            },
          ),
        );

        uploadTask.snapshotEvents.listen((s) {
          final total = s.totalBytes == 0 ? 1 : s.totalBytes;
          final p = s.bytesTransferred / total;
          if (mounted && i < _uploadProgress.length) {
            setState(() => _uploadProgress[i] = p);
          }
        });

        await uploadTask;
        urls.add(await ref.getDownloadURL());
      } catch (e) {
        debugPrint('Error subiendo img $i: $e');
      }
    }
    return urls;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
    getProfilePicture();
    // Si tienes doc específico para Voluntarios, cámbialo aquí
    futureUserDoc =
        FirebaseFirestore.instance.collection('clases').doc('GED').get();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final composerH = size.height * 0.06;
    final previewH = size.height * 0.10;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        iconTheme: CupertinoIconThemeData(
          color: Colors.white,
          size: size.height * 0.035,
        ),
        toolbarHeight: size.height * 0.09,
        leadingWidth: size.width * 0.13,
        title: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Text(
            ez.tr('Mis clases'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.024,
              color: Colors.white,
            ),
          ),
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // ============ CONTENIDO + FEED ============
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
                  physics: const NeverScrollableScrollPhysics(),
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
                      // ---- Header clase + acciones ----
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
                              snapshot.data!.data() as Map<String, dynamic>?;

                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: size.width,
                              height: size.height * 0.10,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  filterQuality: FilterQuality.low,
                                  image: AssetImage('assets/img/volunteer.png'),
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
                                          'Voluntarios'.tr(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.03,
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
                                            onPressed: () => Navigator.pushNamed(
                                                context,
                                                '/profeVolunteers_files'),
                                            icon: Icon(Icons.folder,
                                                color: Colors.white,
                                                size: size.height * 0.03),
                                          ),
                                          IconButton(
                                            onPressed: () => Navigator.pushNamed(
                                                context,
                                                '/profeVolunteers_students'),
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
                        builder: (context, snapshot) {
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
                                  physics: const AlwaysScrollableScrollPhysics(),
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
                                    crossAxisCount: 1,
                                  ),
                                  mainAxisSpacing: 1,
                                  crossAxisSpacing: 1,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: snap.length,
                                  itemBuilder: (context, index) {
                                    final doc = snap[index];
                                    final dataMap =
                                        doc.data() as Map<String, dynamic>;
                                    final List<String> images =
                                        (dataMap['images'] as List?)
                                                ?.map((e) => e.toString())
                                                .toList() ??
                                            const [];

                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      child: ScaleAnimation(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: FadeInAnimation(
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                dataMap['Image']
                                                                    .toString()),
                                                        minRadius: size.height *
                                                            0.021,
                                                        maxRadius: size.height *
                                                            0.021,
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .tertiary,
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.02),
                                                      Text(
                                                        dataMap['Name']
                                                                ?.toString() ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.018,
                                                          fontFamily: 'Arial',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.02),
                                                      Text(
                                                        dataMap['Time']
                                                                ?.toString() ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.013,
                                                          fontFamily: 'Arial',
                                                          color: const Color
                                                              .fromARGB(255,
                                                              168, 168, 168),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (dialogContext) {
                                                                return AlertDialog(
                                                              title: const Icon(
                                                                Icons.info,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        163,
                                                                        59),
                                                              ),
                                                              content: Text(
                                                                'Desea eliminar esto?'
                                                                    .tr(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Arial',
                                                                  color: Theme.of(
                                                                          context)
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
                                                                        .collection(
                                                                            'Volunteers')
                                                                        .doc(snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id)
                                                                        .delete();
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(currentUser
                                                                            .email)
                                                                        .collection(
                                                                            'postsVolunteers_State')
                                                                        .doc(
                                                                            'State')
                                                                        .set({
                                                                      'lastpost':
                                                                          ''
                                                                    });
                                                                    Navigator.of(
                                                                            dialogContext)
                                                                        .pop();
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
                                                                      fontFamily:
                                                                          'Arial',
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
                                                                      fontFamily:
                                                                          'Arial',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                            }
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          size:
                                                              size.height * 0.02,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.004),
                                                  Text(
                                                    dataMap['Date']
                                                            ?.toString() ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontFamily: 'Arial',
                                                      color: const Color
                                                          .fromARGB(255, 168,
                                                          168, 168),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.006),
                                                  Linkify(
                                                    linkStyle: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: size.height *
                                                          0.0155,
                                                      fontFamily: 'Arial',
                                                      color: const Color
                                                          .fromARGB(255, 94,
                                                          145, 255),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.0155,
                                                      fontFamily: 'Arial',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                    text: dataMap['Comment']
                                                            ?.toString() ??
                                                        '',
                                                    onOpen: (link) async {
                                                      if (!await launchUrl(
                                                          Uri.parse(link.url))) {
                                                        throw Exception(
                                                            'Could not launch ${link.url}');
                                                      }
                                                    },
                                                  ),
                                                  if (images.isNotEmpty) ...[
                                                    SizedBox(
                                                        height: size.height *
                                                            0.01),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              size.width *
                                                                  0.03),
                                                      child: SizedBox(
                                                        height:
                                                            size.height * 0.30,
                                                        child: images.length ==
                                                                1
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    PageRouteBuilder(
                                                                      transitionDuration:
                                                                          const Duration(
                                                                              milliseconds: 500),
                                                                      reverseTransitionDuration:
                                                                          const Duration(
                                                                              milliseconds:
                                                                                  500),
                                                                      pageBuilder: (_,
                                                                              __,
                                                                              ___) =>
                                                                          ImageDetallesHome(
                                                                        images:
                                                                            images,
                                                                        initialIndex:
                                                                            0,
                                                                        documentSnapshot:
                                                                            doc,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Hero(
                                                                  tag:
                                                                      'vol_post_${doc.id}_img_0',
                                                                  child: Image
                                                                      .network(
                                                                    images
                                                                        .first,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              )
                                                            : PageView.builder(
                                                                itemCount: images
                                                                    .length,
                                                                controller:
                                                                    PageController(
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
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          PageRouteBuilder(
                                                                            transitionDuration:
                                                                                const Duration(milliseconds: 500),
                                                                            reverseTransitionDuration:
                                                                                const Duration(milliseconds: 500),
                                                                            pageBuilder: (_,
                                                                                    __,
                                                                                    ___) =>
                                                                                ImageDetallesHome(
                                                                              images: images,
                                                                              initialIndex: idx,
                                                                              documentSnapshot: doc,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Hero(
                                                                        tag:
                                                                            'vol_post_${doc.id}_img_$idx',
                                                                        child: Image
                                                                            .network(
                                                                          url,
                                                                          fit: BoxFit
                                                                              .cover,
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
                                    );
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

            // ======== PREVIEW FLOTANTE DE IMÁGENES ========
            if (_selectedImages.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom:
                    composerH + MediaQuery.of(context).viewInsets.bottom + 8,
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: previewH,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                          child:
                                              CircularProgressIndicator()),
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

            // ======== COMPOSER ABAJO ========
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
                  child: StreamBuilder<
                      DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(height: composerH);
                      }
                      final Map<String, dynamic> userData =
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
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    textSelectionTheme:
                                        TextSelectionThemeData(
                                      selectionColor: Colors.blue
                                          .withOpacity(0.4),
                                      selectionHandleColor:
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  child: TextField(
                                    onTapOutside: (_) => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    minLines: 1,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: "mensaje...".tr(),
                                      border: InputBorder.none,
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: _isPosting
                                                ? null
                                                : _pickImages,
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
                                                      builder: (_) =>
                                                          FutureBuilder(
                                                        future:
                                                            FireStoreDataBase()
                                                                .getData(),
                                                        builder: (context, snap) {
                                                          if (snap.hasError) {
                                                            return const Text(
                                                                'Something went wrong');
                                                          }
                                                          if (snap
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
                                                                    final postId =
                                                                        now.toIso8601String();
                                                                    final today =
                                                                        '${now.day}/${now.month}/${now.year}';
                                                                    final timetoday =
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
                                                                              'Volunteers')
                                                                          .doc(
                                                                              postId)
                                                                          .set({
                                                                        'Name': userData[
                                                                                'name'] ??
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
                                                                        'postUrl': imageUrls
                                                                                .isNotEmpty
                                                                            ? imageUrls
                                                                                .first
                                                                            : 'no imagen',
                                                                        'images':
                                                                            imageUrls,
                                                                        'imageCount':
                                                                            imageUrls.length,
                                                                        'storagePath':
                                                                            'class_media/Volunteers/$postId/',
                                                                        'Image': snap
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
                                                                              'Volunteers')
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
                                                      ),
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

