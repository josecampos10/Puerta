import 'dart:typed_data';

import 'package:animated_icon/animated_icon.dart';
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
import 'package:easy_localization/easy_localization.dart' as ez;

final gridItems = [
'Noticias',
'Clases',
'Servicios'
];

class AdminControl extends StatefulWidget {
  const AdminControl({
    super.key,
  });

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
  late Stream<DocumentSnapshot<Map<String, dynamic>>> imagenes;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> streamfeed;

  int _notificationCountESLpm = 0;
  int _notificationCountGEDpm = 0;
  int _notificationCountCostura = 0;
  int _notificationCountCiudadania = 0;
  int _notificationcountCosmetologia = 0;
  int _notificationcountESLpm2 = 0;

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
    streamfeed = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email) // 👈 Your document id change accordingly
        .snapshots();
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
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //decoration: BoxDecoration(
        //image: DecorationImage(image: AssetImage('assets/img/foto5.jpg'),
        //colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
        // fit: BoxFit.cover
        // ),
        //),

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              /*SizedBox(
                  //padding: EdgeInsets.all(5.0),
                  height: size.height*0.805,
                  width: size.width * 1,
                  child: _buildBody())*/

              //PARTE DE ESTUDIANTES********************************************
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: []);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['ESLpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentESLpm');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLpm')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 1 PM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLpm')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),

                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Estudiante") {
                      if (data['ESLpm2'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentESLpm2');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLpm2')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm2')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 2 PM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm2')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLpm2')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: []);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['ESLam'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentESLam');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLam')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage('assets/img/ESLam.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              155, 100, 13, 158)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 100, 13, 158),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 1 am",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                         Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLam')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: []);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['ESLam2'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentESLam2');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLam2')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam2')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage('assets/img/ESLam.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              155, 100, 13, 158)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 100, 13, 158),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 2 am",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam2')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLam2')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: []);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['ESLchick'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentchick');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLchick')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLchick')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESLchick.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(155, 158, 13, 13)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 158, 13, 13),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "ESL Chick-fil-A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLchick')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLchick')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['GEDpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentGEDpm');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('GEDpm')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDpm')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.school,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "GED PM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDpm')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('GEDpm')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['GEDam'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentGEDam');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('GEDam')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDam')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.school,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "GED AM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDam')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('GEDam')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['costuraAM'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentCosturaAM');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('CosturaAM')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('CosturaAM')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Costuraback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.home_work,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 52, 161, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 52, 161, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Costura",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('CosturaAM')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('CosturaAM')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['ciudadania'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentCiudadania');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('Ciudadania')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Ciudadania')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              153, 116, 40, 122)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 116, 40, 122),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Ciudadanía",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Ciudadania')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('Ciudadania')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['cosmetologia'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentCosmetologia');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('Cosmetologia')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Cosmetologia')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Cosmetologiaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.cut,
                                          size: size.height * 0.1,
                                          color: const Color.fromARGB(
                                              153, 213, 13, 13)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color: const Color.fromARGB(
                                              153, 213, 13, 13),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Cosmetología",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Cosmetologia')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('Cosmetologia')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),

              //PARTE DE ADMIN********************************************
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['ESLpm'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.00,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeESLpm');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLpm')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 1 pm",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLpm')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['ESLpm2'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeESLpm2');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLpm2')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm2')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 2 pm",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm2')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLpm2')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['ESLam'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeESLam');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLam')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage('assets/img/ESLam.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              155, 100, 13, 158)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 100, 13, 158),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 1 am",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLam')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['ESLam2'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeESLam2');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLam2')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam2')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage('assets/img/ESLam.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              155, 100, 13, 158)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 100, 13, 158),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 2 am",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam2')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLam2')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['ESLchick'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profechick');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLchick')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLchick')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESLchick.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 158, 13, 13)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 158, 13, 13),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "ESL Chick-fil-A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLchick')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLchick')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['GEDpm'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeGEDpm');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('GEDpm')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDpm')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "GED PM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDpm')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('GEDpm')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['GEDam'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeGEDam');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('GEDam')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDam')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "GED AM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDam')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('GEDam')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['costuraAM'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeCosturaAM');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('CosturaAM')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('CosturaAM')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Costuraback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.shopping_bag,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 52, 161, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 52, 161, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Costura",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('CosturaAM')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('CosturaAM')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['ciudadania'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeCiudadania');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('Ciudadania')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Ciudadania')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              153, 116, 40, 122)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 116, 40, 122),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Ciudadanía",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Ciudadania')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('Ciudadania')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "admin") {
                      if (data['cosmetologia'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeCosmetologia');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('Cosmetologia')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Cosmetologia')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Cosmetologiaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.cut,
                                          size: size.height * 0.1,
                                          color: const Color.fromARGB(
                                              153, 213, 13, 13)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color: const Color.fromARGB(
                                              153, 213, 13, 13),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Cosmetología",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Cosmetologia')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('Cosmetologia')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'admin') {
                      if (data['feed'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profefeedlapuerta');
                                setState(() {
                                  _notificationcountCosmetologia = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Cosmetologiaback.png'),
                                      colorFilter: ColorFilter.mode(
                                          Color.fromRGBO(4, 99, 128, 1),
                                          BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.message,
                                          size: size.height * 0.1,
                                          color: Color.fromRGBO(4, 99, 128, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(4, 99, 128, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.45,
                                            child: Text(
                                              "La Puerta Feed",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              //PARTE DE VOLUNTARIO********************************************

              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: []);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['ESLpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentESLpm');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLpm')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 1 PM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLpm')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Voluntario") {
                      if (data['ESLpm2'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentESLpm2');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLpm2')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm2')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 2 PM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm2')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLpm2')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: []);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['ESLam'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentESLam');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLam')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage('assets/img/ESLam.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              155, 100, 13, 158)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 100, 13, 158),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 1 AM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLam')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: []);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['ESLam2'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentESLam2');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLam2')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam2')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage('assets/img/ESLam.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              155, 100, 13, 158)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 100, 13, 158),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 2 AM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam2')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLam2')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: []);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['ESLchick'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentchick');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLchick')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLchick')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESLchick.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(155, 158, 13, 13)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 158, 13, 13),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "ESL Chick-fil-A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLchick')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLchick')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['GEDpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentGEDpm');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('GEDpm')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDpm')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.school,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "GED PM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDpm')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('GEDpm')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['GEDam'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentGEDam');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('GEDam')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDam')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.school,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "GED AM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDam')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('GEDam')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['costuraAM'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentCosturaAM');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('CosturaAM')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('CosturaAM')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Costuraback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.home_work,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 52, 161, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 52, 161, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Costura",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('CosturaAM')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('CosturaAM')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['ciudadania'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentCiudadania');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('Ciudadania')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Ciudadania')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              153, 116, 40, 122)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 116, 40, 122),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Ciudadanía",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Ciudadania')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('Ciudadania')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['cosmetologia'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/studentCosmetologia');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('Cosmetologia')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Cosmetologia')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Cosmetologiaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.cut,
                                          size: size.height * 0.1,
                                          color: const Color.fromARGB(
                                              153, 213, 13, 13)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color: const Color.fromARGB(
                                              153, 213, 13, 13),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Cosmetología",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Cosmetologia')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('Cosmetologia')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),

              //PARTE DE STAFF********************************************
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['ESLpm'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.00,
                            ),
                            GestureDetector(
                             onTap: () async {
  Navigator.pushNamed(context, '/profeESLpm');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLpm')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},


                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 1 pm",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLpm')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),


                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['ESLpm2'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeESLpm2');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLpm2')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm2')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 2 pm",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLpm2')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLpm2')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['ESLam'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeESLam');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLam')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage('assets/img/ESLam.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              155, 100, 13, 158)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 100, 13, 158),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 1 am",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLam')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['ESLam2'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeESLam2');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLam2')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam2')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage('assets/img/ESLam.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              155, 100, 13, 158)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 100, 13, 158),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "ESL 2 am",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLam2')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLam2')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['ESLchick'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profechick');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('ESLchick')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLchick')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESLchick.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 158, 13, 13)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 158, 13, 13),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "ESL Chick-fil-A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('ESLchick')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('ESLchick')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['GEDpm'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeGEDpm');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('GEDpm')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDpm')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "GED PM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDpm')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('GEDpm')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['GEDam'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeGEDam');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('GEDam')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDam')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "GED AM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('GEDam')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('GEDam')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['costuraAM'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeCosturaAM');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('CosturaAM')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('CosturaAM')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Costuraback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.shopping_bag,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 52, 161, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 52, 161, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Costura",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('CosturaAM')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('CosturaAM')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['ciudadania'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeCiudadania');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('Ciudadania')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Ciudadania')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              153, 116, 40, 122)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 116, 40, 122),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Ciudadanía",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Ciudadania')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('Ciudadania')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['cosmetologia'] == 'inscrito') {
                        //backgroundMessageHandler(1, 'La Puerta', 'Bienvenido');
                        //NotiService().programarNotificacionesMartesYJueves(horaClase: TimeOfDay(hour: 14, minute: 13), titulo: 'Clase', mensaje: 'Clase pilas');

                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {
  Navigator.pushNamed(context, '/profeCosmetologia');

  try {
    final lastPostSnapshot = await FirebaseFirestore.instance
        .collection('postsState')
        .doc('Cosmetologia')
        .get();

    final lastPostValue = lastPostSnapshot.data()?['lastpost'];

    if (lastPostValue != null) {
      await FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Cosmetologia')
          .set({'lastRead': lastPostValue});
    }

    setState(() {
      _notificationCountESLpm = 0;
    });
  } catch (e) {
    print('❌ Error actualizando estado de lectura: $e');
  }
},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Cosmetologiaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.cut,
                                          size: size.height * 0.1,
                                          color: const Color.fromARGB(
                                              153, 213, 13, 13)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color: const Color.fromARGB(
                                              153, 213, 13, 13),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            width: size.width * 0.0,
                                          )),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Cosmetología",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                          Expanded(
  child: SizedBox(
    width: size.width * 0.0,
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('postsStateUser')
          .doc(currentUser.email)
          .collection('classes')
          .doc('Cosmetologia')
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Container(); // o muestra el ícono por defecto si quieres
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final lastRead = userData['lastRead'];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('postsState')
              .doc('Cosmetologia')
              .snapshots(),
          builder: (context, globalSnapshot) {
            if (!globalSnapshot.hasData || !globalSnapshot.data!.exists) {
              return Container();
            }

            final globalData =
                globalSnapshot.data!.data() as Map<String, dynamic>;
            final lastPost = globalData['lastpost'];

            if (lastPost != lastRead) {
              return Container(
                height: size.height * 0.031,
                child: AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  color: Colors.white,
                  animateIcon: AnimateIcons.bell,
                ),
              );
            }

            return Container(); // ya fue leído
          },
        );
      },
    ),
  ),
),
                                          // Show badge only if there are new notifications
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: streamfeed,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Staff') {
                      if (data['feed'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profefeedlapuerta');
                                setState(() {
                                  _notificationcountCosmetologia = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      colorFilter: ColorFilter.mode(
                                          Color.fromRGBO(4, 99, 128, 1),
                                          BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.message,
                                          size: size.height * 0.1,
                                          color: Color.fromRGBO(4, 99, 128, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(4, 99, 128, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.45,
                                            child: Text(
                                              "La Puerta Feed",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.05,
                                                  color: Colors.white,
                                                  fontFamily: 'Arial'),
                                            ),
                                          ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),

              SizedBox(
                height: size.height * 0.03,
              )
            ],
          ),
        ),
      ),);
  }
}
