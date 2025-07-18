import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:animated_icon/animated_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UsermapHome extends StatefulWidget {
  const UsermapHome({super.key});
  @override
  State<UsermapHome> createState() => _UsermapHomeState();
}

class _UsermapHomeState extends State<UsermapHome> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int _notificationCountESLpm = 0;
  int _notificationCountGEDpm = 0;
  int _notificationCountCostura = 0;
  int _notificationCountCiudadania = 0;
  int _notificationcountCosmetologia = 0;
  int _notificationcountESLpm2 = 0;
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> streamfeed;

  void _listenForNewPostsESLpm() {
    FirebaseFirestore.instance
        .collection('postsESL')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCountESLpm +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  void _listenForNewPostsESLpm2() {
    FirebaseFirestore.instance
        .collection('postsESL')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationcountESLpm2 +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  void _listenForNewPostsGEDpm() {
    FirebaseFirestore.instance
        .collection('postsGED')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCountGEDpm +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  void _listenForNewPostsCostura() {
    FirebaseFirestore.instance
        .collection('postsCostura')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCountCostura +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  void _listenForNewPostsCiudadania() {
    FirebaseFirestore.instance
        .collection('postsCiudadania')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCountCiudadania +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  void _listenForNewPostsCosmetologia() {
    FirebaseFirestore.instance
        .collection('postsCosmetologia')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationcountCosmetologia +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  @override
  void initState() {
    _init();
    _listenForNewPostsESLpm();
    _listenForNewPostsGEDpm();
    _listenForNewPostsCostura();
    _listenForNewPostsCiudadania();
    _listenForNewPostsCosmetologia();
    _listenForNewPostsESLpm2();
    super.initState();
    getProfilePicture();
    streamfeed = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email) // 👈 Your document id change accordingly
        .snapshots();
  }

  _init() {}

  @override
  void dispose() {
    super.dispose();
    _init();
    streamfeed = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email) // 👈 Your document id change accordingly
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        //iconTheme: CupertinoIconThemeData(color: Colors.white,size: size.height*0.035, ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.13,
        leading: Text(''),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.0),
            child: Row(
              children: [
                Text(
                  'Mis clases',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.055,
                      color: Colors.white,
                      fontFamily: ''),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Clases registradas',
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              content: Text(
                                'Si no ve ninguna clase, consulte su inscripción en secretaría',
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Cerrar',
                                      style: TextStyle(
                                          fontFamily: 'Arial',
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
                      color: const Color.fromARGB(137, 255, 255, 255),
                      size: size.height * 0.029,
                    ))
              ],
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

              //PARTE DE PROFESORES********************************************
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == "Profesor") {
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
                    if (data['rol'] == 'Profesor') {
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
