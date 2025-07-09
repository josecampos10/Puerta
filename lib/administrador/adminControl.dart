import 'dart:typed_data';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapuerta2/administrador/image_storage_methods.dart';
import 'package:lapuerta2/administrador/utils.dart';
import 'package:lapuerta2/detalles_image_slider.dart';

final gridItems = [
  'Noticias',
  'Clases',
  'Servicios',
];

class AdminControl extends StatefulWidget {
  const AdminControl({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminControl> createState() => _AdminControlState();
}

class _AdminControlState extends State<AdminControl> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  int documents = 0;
  late Stream<QuerySnapshot> feedStream;
  int currentSlideIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();
  int selectedIndex = 0;
  late Stream<QuerySnapshot> imageRecursoStream;
  late Stream<QuerySnapshot> imageESLstream;
  late Stream<QuerySnapshot> imageStream;
  Uint8List? pickedImage;
  bool _isLoading = false;
  Uint8List? _file;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> imagenes;
  final currentUsera = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    var firebase = FirebaseFirestore.instance;
    imageRecursoStream =
        firebase.collection("Image_Slider_Recurso").snapshots();
    var feed = FirebaseFirestore.instance.collection('users').snapshots();
    feedStream = feed;
    imageESLstream = firebase.collection("Image_Slider_ESL").snapshots();
    imageStream = firebase.collection("Image_Slider").snapshots();
    imagenes = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUsera.email) // 👈 Your document id change accordingly
        .snapshots();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

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
        showSnackbar('Posted', context);
        clearImage();
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
  void dispose() {
    super.dispose();

    var feed = FirebaseFirestore.instance.collection('users').snapshots();
    feedStream = feed;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Control',
          style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        toolbarHeight: size.height * 0.09,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        height: size.height * 0.93,
        width: size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: false,
          child: Column(children: [
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
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
                            bottom: BorderSide(color: Colors.grey, width: 0.5)),
                        borderRadius: BorderRadius.circular(size.width * 0.0)),

                    //color: Colors.red,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(size.width * 0.001),
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
                                      childAspectRatio: size.width * 0.0008),
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
                                              : Color.fromRGBO(238, 135, 1, 0),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                size.width * 0.0),
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
                                                      SizedBox(
                                                        width: size.width * 0.0,
                                                      ),
                                                      Text(
                                                        gridItems[position],
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.017,
                                                          fontFamily:
                                                              'Coolvetica',
                                                          fontWeight:
                                                              FontWeight.w500,
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
                    height: size.height * 0.14,
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
                                  size: size.width * 0.1,
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
                                    DocumentSnapshot sliderImage =
                                        snapshot.data!.docs[index];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageDetallesHomeSlider(
                                                          sliderImage:
                                                              sliderImage)));
                                        },
                                        child: Hero(
                                          tag: sliderImage,
                                          child: Container(
                                            width: size.width * 0.85,
                                            // height: size.height * 0.2,
                                            child: Image.network(
                                              sliderImage['Image'],
                                              filterQuality: FilterQuality.low,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                      aspectRatio: size.height * 0.0045,
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
                              return CarouselSlider.builder(
                                  carouselController: carouselController,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (_, index, __) {
                                    DocumentSnapshot sliderImage =
                                        snapshot.data!.docs[index];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageDetallesHomeSlider(
                                                          sliderImage:
                                                              sliderImage)));
                                        },
                                        child: Hero(
                                          tag: sliderImage,
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                width: size.width * 0.8,
                                                child: Image.network(
                                                  sliderImage['Image'],
                                                  filterQuality:
                                                      FilterQuality.low,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        height:
                                                            size.height * 0.05,
                                                        child: Container(
                                                          
                                                          
                                                          child: CircleAvatar(
                                                            radius: 18,
                                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                                              child: IconButton(
                                                                onPressed: (){},
                                                                icon: Icon(Icons.delete, size: size.height*0.025,color: Theme.of(context).colorScheme.secondary,)
                                                                  )),
                                                        )),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                      aspectRatio: size.height * 0.0045,
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
                          stream: imageRecursoStream,
                          builder: (_, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.docs.length > 1 &&
                                selectedIndex == 2) {
                              return CarouselSlider.builder(
                                  carouselController: carouselController,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (_, index, __) {
                                    DocumentSnapshot sliderImage =
                                        snapshot.data!.docs[index];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageDetallesHomeSlider(
                                                          sliderImage:
                                                              sliderImage)));
                                        },
                                        child: Hero(
                                          tag: sliderImage,
                                          child: Container(
                                            width: size.width * 0.8,
                                            child: Image.network(
                                              sliderImage['Image'],
                                              filterQuality: FilterQuality.low,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                      aspectRatio: size.height * 0.0045,
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

                        

                      ],
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
                    Text('Subir imagen a: ')
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
                          ? Container()
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
                                                      builder: (BuildContext
                                                          context) {
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
                                                                        color: Theme.of(context)
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
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary)))
                                                          ],
                                                        );
                                                      });
                                                }
                                                if (controllerdes
                                                    .text.isEmpty) {
                                                  return;
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          4, 99, 128, 1),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10)),
                                              child: Text(
                                                'Siguiente',
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontSize:
                                                        size.width * 0.044,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: feedStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          SpinKitFadingCircle(
                            color: Color.fromRGBO(4, 99, 128, 1),
                            size: size.width * 0.1,
                          ),
                        ]);
                      }
                      if (snapshot.hasData) {
                        final snap = snapshot.data!.docs;

                        return Container(
                          height: 150,
                          width: 150,
                          child: PieChart(PieChartData(sections: [
                            PieChartSectionData(
                                value: 10,
                                title: 'casa',
                                color: Colors.green,
                                radius: 70),
                            PieChartSectionData(value: 80)
                          ])),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                Container(
                  height: 150,
                  width: 150,
                  child: PieChart(PieChartData(sections: [
                    PieChartSectionData(
                        value: 10,
                        title: 'casa',
                        color: Colors.green,
                        radius: 70),
                    PieChartSectionData(value: 80)
                  ])),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
