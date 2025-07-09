import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lapuerta2/UserhomePrincipal.dart';
import 'package:lapuerta2/mainwrapper.dart';

// ignore: must_be_immutable
class Notifications extends StatefulWidget {
  Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  CollectionReference users = FirebaseFirestore.instance.collection('posts');
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot> feedStream;

  @override
  void initState() {
    users;
    super.initState();
    getProfilePicture();
    var feed = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
    feedStream = feed;
  }

  @override
  void dispose() {
    users;
    super.dispose();
    getProfilePicture();
    var feed = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
    feedStream = feed;
  }

  @override
  Widget build(BuildContext context) {
    //CollectionReference users = FirebaseFirestore.instance.collection('posts');
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        //iconTheme: CupertinoIconThemeData(color: Colors.white,size: size.height*0.035, ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.13,
        leading: Text(''),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.0),
            child: Text(
              'Notificaciones',
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
        // color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(size.width * 0.001),
          //physics: NeverScrollableScrollPhysics(),
          primary: false,
          reverse: false,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  Text(
                    'Recientes',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: size.height * 0.021,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: feedStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                            return RefreshIndicator(
                              color: Color.fromRGBO(3, 69, 88, 1),
                              edgeOffset: 1.0,
                              backgroundColor: Colors.white,
                              displacement: 0.0,
                              strokeWidth: 3.0,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.73,
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
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Mainwrapper(),
                                                    ));
                                              },
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
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        minHeight:
                                                            size.height * 0.01,
                                                        maxHeight:
                                                            size.height * 0.09),
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
                                                                  NetworkImage(snap[
                                                                          index]
                                                                      [
                                                                      'Image']),
                                                              minRadius:
                                                                  size.height *
                                                                      0.018,
                                                              maxRadius:
                                                                  size.height *
                                                                      0.018,
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      36,
                                                                      94,
                                                                      64,
                                                                      112),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['User'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.019,
                                                                  fontFamily:
                                                                      'JosefinSans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
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
                                                                      0.02,
                                                            ),
                                                            Text(
                                                              snap[index]
                                                                  ['Date'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.014,
                                                                  fontFamily:
                                                                      'JosefinSans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      151,
                                                                      151,
                                                                      151)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02,
                                                            ),
                                                            Text(
                                                              snap[index]
                                                                  ['Time'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.014,
                                                                  fontFamily:
                                                                      'JosefinSans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      151,
                                                                      151,
                                                                      151)),
                                                            ),
                                                          ]),
                                                          SingleChildScrollView(
                                                            child: Container(
                                                              constraints: BoxConstraints(
                                                                  minHeight:
                                                                      size.height *
                                                                          0.02,
                                                                  maxHeight:
                                                                      size.height *
                                                                          0.025),
                                                              //height: size.height*0.035,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  snap[index][
                                                                      'Comment'],
                                                                  style:
                                                                      TextStyle(
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
                                                                        .secondary,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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

              /*Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Mensajes',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.6),
                          fontSize: size.height * 0.021,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(

                        //offset: Offset(5, 5),
                        color: const Color.fromARGB(255, 235, 235, 235),
                        blurRadius: 15.0,
                        blurStyle: BlurStyle.inner)
                  ]),
                  alignment: Alignment.topCenter,
                  height: size.height * 0.316,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: users.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Cargando',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        );
                      }

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return;
                          }
                        },
                        child: ListView(
                          clipBehavior: Clip.hardEdge,
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return Card(
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 50,
                              shadowColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              color: Color.fromRGBO(255, 255, 255, 1),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: size.height * 0.0,
                                    bottom: size.height * 0.06,
                                    left: 8,
                                    right: 5),
                                child: SizedBox(
                                  height: size.height * 0.057,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: ListTile(
                                      leading: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            foregroundImage: AssetImage(
                                                'assets/img/logo2.png'),
                                            //backgroundImage: AssetImage('assets/icon/logo2.png'),
                                            backgroundColor:
                                                Colors.yellow.shade800,
                                            radius: size.height * 0.023,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (document['User'] == 'La Puerta') {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WidgetTree()),
                                              (_) => false);
                                        }
                                      },
                                      //leading: Icon(Icons.notifications_rounded),
                                      contentPadding: EdgeInsets.only(
                                          bottom: size.height * 0.0009,
                                          right: 5,
                                          left: 5,
                                          top: 0),
                                      iconColor: const Color.fromARGB(
                                          255, 221, 125, 0),
                                      titleAlignment:
                                          ListTileTitleAlignment.center,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.notifications_rounded,
                                            size: size.height * 0.019,
                                          ),
                                          Text(
                                            textAlign: TextAlign.start,
                                            document['User'],
                                            style: TextStyle(
                                                fontSize: size.height * 0.019,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            document['Time'],
                                            style: TextStyle(
                                                fontSize: size.height * 0.012,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        document['Comment'],
                                        style: TextStyle(
                                          fontSize: size.height * 0.018,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),*/
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
