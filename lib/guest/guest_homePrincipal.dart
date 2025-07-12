import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lapuerta2/detalles_class.dart';
import 'package:lapuerta2/detalles_image_slider.dart';
import 'package:lapuerta2/onboarding.dart';

final gridItems = [
  'Noticias',
  'Clases',
  'Servicios',
];

class GuesthomePrincipal extends StatefulWidget {
  const GuesthomePrincipal({super.key});
  @override
  State<GuesthomePrincipal> createState() => _GuesthomePrincipalState();
}

class _GuesthomePrincipalState extends State<GuesthomePrincipal> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //late Stream<QuerySnapshot> imageStream;
  late Stream<QuerySnapshot> imageESLstream;
  late Stream<QuerySnapshot> imageRecursoStream;
  late Stream<QuerySnapshot> imageStream;
  late Stream<QuerySnapshot> recursos;
  late Stream<QuerySnapshot> clases;
  late Stream<QuerySnapshot> feedStream;
  int currentSlideIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();
  final int _current = 0;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    var firebase = FirebaseFirestore.instance;
    imageStream = firebase.collection("Image_Slider").snapshots();
    imageESLstream = firebase.collection("Image_Slider_ESL").snapshots();
    imageRecursoStream =
        firebase.collection("Image_Slider_Recurso").snapshots();
    var feed = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('Time', descending: true)
        .snapshots();
    feedStream = feed;
    recursos = firebase.collection('recursos').snapshots();
    clases = firebase.collection('clases').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.0,
        leading: Text(''),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hola,',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Bienvenido',
                          style: TextStyle(
                              fontSize: size.height * 0.027,
                              fontFamily: 'Arial',
                              //fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ), // 👈 your valid data here
                      ),
                    ],
                  ),
                ],
              ),
            )),
        centerTitle: false,
        //titleTextStyle: ,
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
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.logout, size: size.height*0.03,),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OnboardingPage()));
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),

        height: size.height * 0.79,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          reverse: false,
          child: Column(
            children: [
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
                            itemBuilder: (BuildContext context, int position) {
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
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.03)),
                                        elevation: size.height * 0.9,
                                        //shadowColor: Colors.black26,
                                        color: (selectedIndex == position)
                                            ? const Color.fromRGBO(
                                                4, 99, 128, 1)
                                            : Color.fromRGBO(238, 135, 1, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(size.width * 0.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                            size.height * 0.017,
                                                        fontFamily:
                                                            'Arial',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: (selectedIndex ==
                                                                position)
                                                            ? Color.fromARGB(
                                                                255,
                                                                255,
                                                                255,
                                                                255)
                                                            : Color.fromRGBO(
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
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    //color: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  height: size.height * 0.283,
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
                                color: Theme.of(context).colorScheme.tertiary,
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
                                        child: SizedBox(
                                          width: size.width * 0.9,
                                          //height: size.height * 0.24,
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
                                    aspectRatio: size.width*0.0044,
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(children: [
                              
                            ]);
                          }
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
                                        child: SizedBox(
                                          width: size.width * 0.9,
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
                                    aspectRatio: size.width*0.0044,
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(children: [
                              
                            ]);
                          }
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
                                        child: SizedBox(
                                          width: size.width * 0.9,
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
                                    aspectRatio: size.width*0.0044,
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
              
              /*Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '   Recursos',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: size.height * 0.023,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: recursos,
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
                                  return Container(
                                    //width: 200,
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
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.04)),
                                        elevation: size.height * 0.5,
                                        shadowColor: Colors.black26,
                                        color: Color.fromRGBO(125, 111, 165, 1),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
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
                                                        width:
                                                            size.width * 0.01,
                                                      ),
                                                      Text(
                                                        snap[index]['Name'],
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.022,
                                                          fontFamily: '',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              255, 255, 255, 1),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.01,
                                                      ),
                                                      if (snap[index]['Name'] ==
                                                          'Consejeria')
                                                        InkWell(
                                                          child: Icon(Icons
                                                              .family_restroom),
                                                        ),
                                                      if (snap[index]['Name'] ==
                                                          'Comida')
                                                        InkWell(
                                                          child: Icon(
                                                              Icons.food_bank),
                                                        ),
                                                      if (snap[index]['Name'] ==
                                                          'Salud')
                                                        InkWell(
                                                          child: Icon(Icons
                                                              .local_hospital),
                                                        ),
                                                      if (snap[index]['Name'] ==
                                                          'Abogacia')
                                                        InkWell(
                                                          child:
                                                              Icon(Icons.work),
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
                            );
                          } else {
                            return const SizedBox();
                          }
                        })
                  ],
                ),
              ),*/

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '   Clases disponibles',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Arial',
                      fontSize: size.height * 0.025,
                      fontWeight: FontWeight.normal,
                      color: const Color.fromARGB(255, 148, 148, 148)),
                ),
              ),
              SizedBox(height: size.height*0.006,),
              SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: clases,
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
                              height: size.height * 0.414,
                              width: size.width * 0.95,
                              child: GridView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: size.width*0.02,
                                        crossAxisCount: 2,
                                        childAspectRatio: 1.3),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  return GestureDetector(
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
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.04)),
                                      elevation: size.height * 0.5,
                                      shadowColor: Colors.black,
                                      color: Color.fromRGBO(4, 99, 128, 1),
                                      child: Container(
                                    
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(size.width*0.04),
                                            image: DecorationImage(
                                          image:
                                              AssetImage('assets/img/back.png'),
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.low,
                                          opacity: 0.4
                                        )),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                snap[index]['Name'],
                                                style: TextStyle(
                                                  fontSize: size.height * 0.025,
                                                  fontFamily: 'Arial',
                                                  fontWeight: FontWeight.normal,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                              ),
                                            ],
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
              /*Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '   Publicaciones',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: size.height * 0.023,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
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
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .orderBy('Time', descending: false)
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
                                height: size.height * 0.48,
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
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.04)),
                                          elevation: size.height * 0.01,
                                          shadowColor: Colors.black,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
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
                                                          size.height * 0.015,
                                                      maxRadius:
                                                          size.height * 0.015,
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 94, 64, 112),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        snap[index]['User'],
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.019,
                                                          fontFamily:
                                                              'JosefinSans',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color
                                                                  .fromARGB(
                                                                  255, 0, 0, 0)
                                                              .withOpacity(0.9),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Text(
                                                      snap[index]['Date'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.014,
                                                        fontFamily:
                                                            'JosefinSans',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0)
                                                            .withOpacity(0.6),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Text(
                                                      snap[index]['Time'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.014,
                                                        fontFamily:
                                                            'JosefinSans',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0)
                                                            .withOpacity(0.6),
                                                      ),
                                                    ),
                                                  ]),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      snap[index]['Comment'],
                                                      style: TextStyle(
                                                        fontSize: size.height *
                                                            0.0162,
                                                        fontFamily: 'Impact',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Color.fromRGBO(
                                                                0, 0, 0, 1)
                                                            .withOpacity(0.9),
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
              ),*/
              SizedBox(
                height: size.height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
