import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lapuerta2/detalles.dart';
import 'package:lapuerta2/detalles_class.dart';

class AdminhomePrincipal extends StatefulWidget {
  AdminhomePrincipal({Key? key}) : super(key: key);
  @override
  State<AdminhomePrincipal> createState() => _AdminhomePrincipalState();
}

class _AdminhomePrincipalState extends State<AdminhomePrincipal> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.09,
        leadingWidth: size.width * 0.17,
        leading: Container(
          padding: EdgeInsets.all(size.width * 0.015),
          width: size.width * 0.2,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(0, 240, 195, 195),
            child: Image.asset(
              'assets/img/logo.png',
              fit: BoxFit.scaleDown,
              scale: size.height * 0.008,
              color: Colors.white,
            ),
          ),
        ),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: Text(
              'Panel de Administrador',
            )),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        actions: [],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          reverse: false,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/recursos'),
                  child: Text(
                    'Editar recursos',
                    style: TextStyle(
                        fontSize: size.height * 0.02, color: Colors.black),
                  )),
              SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('recursos')
                            .snapshots(),
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
                            return Container(
                              width: double.infinity,
                              height: size.height * 0.07777,
                              child: GridView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 0.3),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    columnCount: 1,
                                    child: ScaleAnimation(
                                      duration: Duration(milliseconds: 400),
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetallesHome(
                                                            documentSnapshot:
                                                                documentSnapshot)));
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.width * 0.04)),
                                            elevation: size.height * 0.5,
                                            shadowColor: Colors.black26,
                                            color: Color.fromRGBO(
                                                125, 111, 165, 1),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  size.width * 0.01),
                                              child: Align(
                                                alignment: Alignment.center,
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
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          Text(
                                                            snap[index]['Name'],
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.022,
                                                              fontFamily: '',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          if (snap[index]
                                                                  ['Name'] ==
                                                              'Consejeria')
                                                            InkWell(
                                                              child: Icon(Icons
                                                                  .family_restroom),
                                                            ),
                                                          if (snap[index]
                                                                  ['Name'] ==
                                                              'Comida')
                                                            InkWell(
                                                              child: Icon(Icons
                                                                  .food_bank),
                                                            ),
                                                          if (snap[index]
                                                                  ['Name'] ==
                                                              'Salud')
                                                            InkWell(
                                                              child: Icon(Icons
                                                                  .local_hospital),
                                                            ),
                                                          if (snap[index]
                                                                  ['Name'] ==
                                                              'Abogacia')
                                                            InkWell(
                                                              child: Icon(
                                                                  Icons.work),
                                                            ),
                                                        ]),
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
                            );
                          } else {
                            return const SizedBox();
                          }
                        })
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/clases'),
                  child: Text(
                    'Editar Clases',
                    style: TextStyle(
                        fontSize: size.height * 0.02, color: Colors.black),
                  )),
              SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('clases')
                            .snapshots(),
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
                            return SizedBox(
                              height: size.height * 0.073,
                              width: double.infinity,
                              child: GridView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 0.4),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  return AnimationConfiguration.staggeredGrid(
                                    columnCount: 1,
                                    position: index,
                                    child: ScaleAnimation(
                                      duration: Duration(milliseconds: 400),
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetallesClassHome(
                                                            documentSnapshot:
                                                                documentSnapshot)));
                                          },
                                          child: Card(
                                            borderOnForeground: false,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.width * 0.04)),
                                            elevation: size.height * 0.5,
                                            shadowColor: Colors.black,
                                            color:
                                                Color.fromRGBO(4, 99, 128, 1),
                                            child: SizedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    size.width * 0.01),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snap[index]['Name'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.022,
                                                        fontFamily: '',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 1),
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
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/publicaciones'),
                  child: Text(
                    'Crear Publicaciones',
                    style: TextStyle(
                        fontSize: size.height * 0.02, color: Colors.black),
                  )),
              SizedBox(
                height: size.height * 0.01,
              ),
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .orderBy('Time', descending: true)
                            .snapshots(),
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
                              backgroundColor: Colors.white,
                              displacement: 1,
                              strokeWidth: 3,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.45,
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
                                              onTap: () {},
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.04)),
                                                elevation: size.height * 0.01,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                child: Container(
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          CircleAvatar(
                                                            minRadius:
                                                                size.height *
                                                                    0.015,
                                                            maxRadius:
                                                                size.height *
                                                                    0.015,
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    94,
                                                                    64,
                                                                    112),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['User'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.019,
                                                                fontFamily:
                                                                    'JosefinSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0)
                                                                    .withOpacity(
                                                                        0.9),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            snap[index]['Date'],
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
                                                                      0,
                                                                      0,
                                                                      0)
                                                                  .withOpacity(
                                                                      0.6),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            snap[index]['Time'],
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
                                                                      0,
                                                                      0,
                                                                      0)
                                                                  .withOpacity(
                                                                      0.6),
                                                            ),
                                                          ),
                                                        ]),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            snap[index]
                                                                ['Comment'],
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.0162,
                                                              fontFamily:
                                                                  'Impact',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1)
                                                                  .withOpacity(
                                                                      0.9),
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
}
