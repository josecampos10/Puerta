import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapuerta2/administrador/adminClases_nav.dart';
import 'package:lapuerta2/detalles_class.dart';
import 'package:lapuerta2/detalles_image_slider.dart';
import 'package:lapuerta2/mapa_recursos.dart';

final gridItems = ['Noticias', 'Clases', 'Servicios', 'Recursos'];

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});
  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int selectedIndex = 0;
  late Stream<QuerySnapshot> imageStream;
  late Stream<QuerySnapshot> imageESLstream;
  late Stream<QuerySnapshot> clases;
  late Stream<QuerySnapshot> imageRecursoStream;
  CarouselSliderController carouselController = CarouselSliderController();
  int currentSlideIndex = 0;

  bool _isUploading = false;

  String? _collectionForTab(int index) {
    switch (index) {
      case 0:
        return 'Image_Slider'; // Noticias
      case 2:
        return 'Image_Slider_Recurso'; // Recursos
      // case 1: return 'Image_Slider_ESL';    // <- si quieres activar para ESL
      default:
        return null;
    }
  }

  Future<void> _addImageForCurrentTab() async {
    final collectionName = _collectionForTab(selectedIndex);
    if (collectionName == null) return;

    final picker = ImagePicker();
    try {
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
        imageQuality: 85,
      );
      if (picked == null) return;

      setState(() => _isUploading = true);

      final file = File(picked.path);
      final colRef = FirebaseFirestore.instance.collection(collectionName);
      final docRef = colRef.doc(); // nuevo ID
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('$collectionName/${docRef.id}.jpg');

      await storageRef.putFile(
          file, SettableMetadata(contentType: 'image/jpeg'));
      final downloadUrl = await storageRef.getDownloadURL();

      await docRef.set({
        'Image': downloadUrl,
        'storagePath': storageRef.fullPath,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': currentUser.email,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image added')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add image: $e')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _confirmAndDelete(DocumentSnapshot doc) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete image'),
        content: const Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Delete',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
        ],
      ),
    );

    if (shouldDelete != true) return;

    try {
      // Si guardas la ruta de Storage en el doc, elimínala también:
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final storagePath = data['storagePath'] as String?;
      if (storagePath != null && storagePath.isNotEmpty) {
        await FirebaseStorage.instance.ref(storagePath).delete();
      }

      // Borra el documento de Firestore
      await doc.reference.delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    var firebase = FirebaseFirestore.instance;
    imageStream = firebase.collection("Image_Slider").snapshots();
    imageESLstream = firebase.collection("Image_Slider_ESL").snapshots();
    clases = firebase.collection('clases').snapshots();
    imageRecursoStream =
        firebase.collection("Image_Slider_Recurso").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        height: size.height,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            primary: false,
            reverse: false,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * 0.08),
                      topRight: Radius.circular(size.width * 0.08))),
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
                  //////////////
                  Center(
                    child: Container(
                      width: size.width * 0.92,
                      height: size.height * 0.04,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 12,
                              color: Color.fromRGBO(0, 0, 0, 0),
                            )
                          ],
                          shape: BoxShape.rectangle,
                          color: const Color.fromARGB(0, 255, 255, 255),
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.5)),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.0)),

                      //color: Colors.red,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(size.height * 0.001),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: size.height * 0.04,
                              child: GridView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio:
                                            size.height * 0.00045),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: gridItems.length,
                                cacheExtent: 1000.0,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return AnimationConfiguration.staggeredGrid(
                                    position: 1,
                                    columnCount: 1,
                                    child: ScaleAnimation(
                                      duration: Duration(milliseconds: 400),
                                      child: FadeInAnimation(
                                        child: InkWell(
                                          onTap: () => setState(
                                              () => selectedIndex = position),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.width * 0.03)),
                                            elevation: size.height * 0.9,
                                            //shadowColor: Colors.black26,
                                            color: (selectedIndex == position)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .tertiary
                                                : Color.fromRGBO(
                                                    238, 135, 1, 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        gridItems[position]
                                                            .tr(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.014,
                                                          fontFamily: 'Arial',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              (selectedIndex ==
                                                                      position)
                                                                  ? Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)
                                                                  : Color
                                                                      .fromRGBO(
                                                                          143,
                                                                          143,
                                                                          143,
                                                                          1),
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  
                  SingleChildScrollView(
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        //color: const Color.fromARGB(0, 0, 0, 0),
                      ),
                      height: size.height ,
                      width: double.infinity,
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: imageStream,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(children: [
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  SpinKitFadingCircle(
                                    color: Color.fromRGBO(4, 99, 128, 1),
                                    size: size.height * 0.04,
                                  ),
                                ]);
                              }
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.length > 1 &&
                                  selectedIndex == 0) {
                                    
                                return CarouselSlider.builder(
                                    carouselController: carouselController,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (_, index, __) {
                                      final DocumentSnapshot sliderImage =
                                          snapshot.data!.docs[index];

                                      return Column(
                                        children: [
                                          Stack(
                                            children: [
                                              // Imagen clickeable que navega al detalle
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageDetallesHomeSlider(
                                                                sliderImage:
                                                                    sliderImage),
                                                      ),
                                                    );
                                                  },
                                                  child: Hero(
                                                    // Usa un tag estable (el id del doc es mejor que el snapshot completo)
                                                    tag: sliderImage.id,
                                                    child: SizedBox(
                                                      width: size.width * 0.8,
                                                      child: Image.network(
                                                        sliderImage['Image'],
                                                        filterQuality:
                                                            FilterQuality.low,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          
                                              // Ícono de eliminar sobrepuesto
                                              Positioned(
                                                right: 8,
                                                bottom: 8,
                                                child: Material(
                                                  color: Colors
                                                      .black54, // fondo circular semitransparente
                                                  shape: const CircleBorder(),
                                                  elevation: 2,
                                                  child: InkWell(
                                                    customBorder:
                                                        const CircleBorder(),
                                                    onTap: () async =>
                                                        _confirmAndDelete(
                                                            sliderImage),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(Icons.delete,
                                                          size: 20,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Botón "Add image" mostrado solo cuando aplica la colección
                                          Builder(
                                            builder: (context) {
                                              final canAdd = _collectionForTab(selectedIndex) != null;
                                              if (!canAdd) return const SizedBox.shrink();
                                              return Padding(
                                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      onPressed: _isUploading ? null : _addImageForCurrentTab,
                                                      icon: const Icon(Icons.add_photo_alternate),
                                                      label: Text(_isUploading ? 'Uploading...' : 'Add image'),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                                                        foregroundColor: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    options: CarouselOptions(
                                        aspectRatio: size.height * 0.002,
                                        viewportFraction: size.height * 0.00045,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        autoPlayInterval: Duration(seconds: 10),
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        onPageChanged: (index, _) {
                                          setState(() {
                                            currentSlideIndex = index;
                                          });
                                        }));
                              } else {
                                return Container();
                              }
                            },
                          ),
                          

                          StreamBuilder<QuerySnapshot>(
                            stream: imageESLstream,
                            builder: (_, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.length > 1 &&
                                  selectedIndex == 1) {
                                return SingleChildScrollView(
                                  padding: EdgeInsets.all(size.width * 0.001),
                                  child: Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                          stream: clases,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Column(children: [
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                SpinKitFadingCircle(
                                                  color: Color.fromRGBO(
                                                      4, 99, 128, 1),
                                                  size: size.width * 0.1,
                                                ),
                                              ]);
                                            }
                                            if (snapshot.hasData) {
                                              final snap = snapshot.data!.docs;
                                              return SizedBox(
                                                height: size.height * 0.3,
                                                width: size.width,
                                                child: GridView.builder(
                                                  physics: ScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisSpacing:
                                                              size.width * 0.02,
                                                          crossAxisCount: 1,
                                                          childAspectRatio:
                                                              0.8),
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  itemCount: snap.length,
                                                  cacheExtent: 1000.0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final DocumentSnapshot
                                                        documentSnapshot =
                                                        snapshot
                                                            .data!.docs[index];
                                                    if (snap[index]['Name'] ==
                                                        'ESL Chick-fil-A') {
                                                      return const SizedBox
                                                          .shrink(); // Oculta este item
                                                    }

                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AdminclasesNav()),
  );
                                                        /*Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    DetallesClassHome(
                                                                        documentSnapshot:
                                                                            documentSnapshot)));*/
                                                      },
                                                      child: Card(
                                                        borderOnForeground:
                                                            false,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    size.height *
                                                                        0.03)),
                                                        elevation:
                                                            size.height * 0.5,
                                                        shadowColor:
                                                            Colors.black,
                                                        color: const Color
                                                            .fromRGBO(
                                                            4, 99, 128, 1),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    size.height *
                                                                        0.03),
                                                            image:
                                                                const DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/img/back.png'),
                                                              fit: BoxFit.cover,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .low,
                                                              opacity: 0.4,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Center(
                                                                child: Text(
                                                                  snap[index]
                                                                      ['Name'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        size.height *
                                                                            0.018,
                                                                    fontFamily:
                                                                        'Arial',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          })
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          StreamBuilder<QuerySnapshot>(
  stream: imageRecursoStream,
  builder: (_, snapshot) {
    if (snapshot.hasData &&
        snapshot.data!.docs.length > 1 &&
        selectedIndex == 2) {
      return CarouselSlider.builder(
        carouselController: carouselController,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (_, index, __) {
          final DocumentSnapshot sliderImage = snapshot.data!.docs[index];

          return Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageDetallesHomeSlider(sliderImage: sliderImage),
                          ),
                        );
                      },
                      child: Hero(
                        tag: sliderImage.id, // ✅ usa id para evitar conflictos
                        child: SizedBox(
                          width: size.width * 0.8,
                          child: Image.network(
                            sliderImage['Image'],
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
              
                  // 🔥 Botón de borrar (esquina inferior derecha)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async => _confirmAndDelete(sliderImage),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.delete, size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _addImageForCurrentTab, // usa tu helper
          icon: const Icon(Icons.add_photo_alternate),
          label: Text(_isUploading ? 'Uploading...' : 'Add image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    ),
  ),
                ],
              ),
            ],
          );
        },
        options: CarouselOptions(
          aspectRatio: size.height * 0.0015,
          viewportFraction: size.height * 0.00045,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayInterval: const Duration(seconds: 10),
          autoPlay: true,
          enlargeCenterPage: true,
          onPageChanged: (index, _) {
            setState(() {
              currentSlideIndex = index;
            });
          },
        ),
      );
    } else {
      return const SizedBox.shrink(); // ✅ evita un Container vacío que tape
    }
  },
),

                          ///////RECURSOS MAPA AQUI
                          (selectedIndex == 3)
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MapaPersonalizadoView()),
                                    );
                                  },
                                  child: Container(
                                    child: Container(
                                      height: size.height * 0.3,
                                      width: size.width * 0.95,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/img/location.png'),
                                              fit: BoxFit.cover)),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Mapa de Recursos'.tr(),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      size.height * 0.025),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.06,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Text(''),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
