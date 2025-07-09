import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UsermapHome extends StatefulWidget {
  const UsermapHome({Key? key}) : super(key: key);
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
    super.initState();
    getProfilePicture();
    streamfeed = FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots();
  }

  _init() {}

  @override
  void dispose() {
    super.dispose();
    _init();
streamfeed = FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
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
                      //fontWeight: FontWeight.w500,
                      fontSize: size.width * 0.055,
                      color: Colors.white,
                      fontFamily: ''),
                ),
                IconButton(
                  onPressed: (){
                    showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Clases registradas'),
                                content: Text(
                                    'Si no ve ninguna clase, consulte su inscripción en secretaría'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cerrar',style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                                  
                                ],
                              );
                            });
                  }, 
                  icon: Icon(Icons.info, color: const Color.fromARGB(137, 255, 255, 255), size: size.height*0.029,))
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
                  ? ColorFilter.mode(const Color.fromARGB(255, 68, 68, 68), BlendMode.color)
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
                              onTap: () {
                                Navigator.pushNamed(context, '/studentESLpm');
                                setState(() {
                                  _notificationCountESLpm = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "ESL PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountESLpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                              onTap: () {
                                Navigator.pushNamed(context, '/studentGEDpm');
                                setState(() {
                                  _notificationCountGEDpm = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "GED PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountGEDpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCosturaAM');
                                setState(() {
                                  _notificationCountCostura = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Costura",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCostura >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
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
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Ciudadania",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCosmetologia');
                                setState(() {
                                  _notificationCountCiudadania = 0;
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
                                          Color.fromARGB(153, 122, 77, 40),
                                          BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary,
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
                                          color: const Color.fromARGB(
                                              153, 122, 77, 40)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 122, 77, 40),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.35,
                                            child: Text(
                                              "Cosmetología",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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

              /*TableCalendar(
                focusedDay: DateTime.now(), 
                firstDay: DateTime.utc(2025, 1, 1), 
                lastDay: DateTime.utc(2030,12,31),
                //eventLoader: (day) => _getEventsForDay(day),
                ),*/

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
                              onTap: () {
                                Navigator.pushNamed(context, '/profeESLpm');
                                setState(() {
                                  _notificationCountESLpm = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "ESL PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountESLpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeGEDpm');
                                setState(() {
                                  _notificationCountGEDpm = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "GED PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountGEDpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeCosturaAM');
                                setState(() {
                                  _notificationCountCostura = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Costura",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCostura >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profeCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
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
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Ciudadania",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                      if (data['cosmetologia'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profeCosmetologia');
                                setState(() {
                                  _notificationcountCosmetologia= 0;
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
                                          Color.fromARGB(153, 122, 77, 40),
                                          BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary,
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
                                              153, 122, 77, 40)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 122, 77, 40),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.35,
                                            child: Text(
                                              "Cosmetología",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationcountCosmetologia >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                                  _notificationcountCosmetologia= 0;
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                          color:
                                              Color.fromRGBO(4, 99, 128, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.45,
                                            child: Text(
                                              "La Puerta Feed", textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
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
                    return Text('');
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
                              onTap: () {
                                Navigator.pushNamed(context, '/studentESLpm');
                                setState(() {
                                  _notificationCountESLpm = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "ESL PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountESLpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                              onTap: () {
                                Navigator.pushNamed(context, '/studentGEDpm');
                                setState(() {
                                  _notificationCountGEDpm = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "GED PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountGEDpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCosturaAM');
                                setState(() {
                                  _notificationCountCostura = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Costura",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCostura >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
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
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Ciudadania",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCosmetologia');
                                setState(() {
                                  _notificationCountCiudadania = 0;
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
                                          Color.fromARGB(153, 122, 77, 40),
                                          BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary,
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
                                          color: const Color.fromARGB(
                                              153, 122, 77, 40)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 122, 77, 40),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.35,
                                            child: Text(
                                              "Cosmetología",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.00,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeESLpm');
                                setState(() {
                                  _notificationCountESLpm = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "ESL PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountESLpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeGEDpm');
                                setState(() {
                                  _notificationCountGEDpm = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "GED PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountGEDpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeCosturaAM');
                                setState(() {
                                  _notificationCountCostura = 0;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Costura",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCostura >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profeCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
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
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary,
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
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Ciudadania",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                      if (data['cosmetologia'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCosmetologia');
                                setState(() {
                                  _notificationCountCiudadania = 0;
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
                                          Color.fromARGB(153, 122, 77, 40),
                                          BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary,
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
                                          color: const Color.fromARGB(
                                              153, 122, 77, 40)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 122, 77, 40),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.35,
                                            child: Text(
                                              "Cosmetología",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth: size.width * 0.08,
                                                    minWidth: size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
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
                                  _notificationcountCosmetologia= 0;
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
                                      color: Theme.of(context).colorScheme.primary,
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
                                          color:
                                              Color.fromRGBO(4, 99, 128, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.45,
                                            child: Text(
                                              "La Puerta Feed", textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
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
