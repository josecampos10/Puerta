import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lapuerta2/detalles_class.dart';
import 'package:lapuerta2/detalles_image_slider.dart';
import 'package:lapuerta2/mapa_recursos.dart';
import 'package:lapuerta2/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';

final gridItems = [
  'Noticias',
  'Clases',
  'Servicios',
  'Recursos'
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
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final Uri _urlfacebook = Uri.parse('https://www.facebook.com/puertawaco');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> _launchUrlfacebook() async {
    if (!await launchUrl(_urlfacebook)) {
      throw Exception('Could not launch $_urlfacebook');
    }
  }

  final Uri _urlinstagram =
      Uri.parse('https://www.instagram.com/lapuertawaco/');

  Future<void> _launchUrlinstagram() async {
    if (!await launchUrl(_urlinstagram)) {
      throw Exception('Could not launch $_urlinstagram');
    }
  }

  final Uri _urlx = Uri.parse('https://twitter.com/lapuertawaco');

  Future<void> _launchUrlx() async {
    if (!await launchUrl(_urlx)) {
      throw Exception('Could not launch $_urlx');
    }
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunch(phoneUri.toString())) {
        await launch(phoneUri.toString());
      }
    } catch (error) {
      throw ("Cannot dial");
    }
  }

  Future<void> send() async {
  final Email email = Email(
    body: _bodyController.text,
    subject: _subjectController.text,
    recipients: ['info@lapuertawaco.com'],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
    print('Correo enviado con éxito');
  } catch (error) {
    print('Error al enviar correo: $error');
  }

  if (!mounted) return;
}


  Future<void> signOut() async {
    try {
      // Eliminar token de Firestore si el usuario está logueado
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update({'token': FieldValue.delete()});

        // También borra el token local
        await FirebaseMessaging.instance.deleteToken();
      }

      // Finalmente, cerrar sesión
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: CircleBorder(),
        child: Icon(
          Icons.email_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              builder: (context) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(
                    width: size.width,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        Center(
                          child: Container(
                            width: size.width * 0.3,
                            height: size.height * 0.01,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromARGB(255, 195, 195, 195)),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.014,
                        ),
                        Center(
                          child: Text(
                            'Contáctanos'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.035,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                        ),
                        Center(
                          child: Container(
                            //color: Theme.of(context).colorScheme.primary,
                            width: size.width * 0.9,
                            height: size.height * 0.06,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110),
                                        width: 1),
                                    bottom: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110),
                                        width: 1),
                                    left: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110),
                                        width: 1),
                                    right: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110),
                                        width: 1)),
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              style: TextStyle(
                                fontSize: size.height * 0.022,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              cursorHeight: size.height * 0.023,
                              controller: _subjectController,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                labelText: 'Asunto'.tr(),
                                prefixIcon: Icon(Icons.short_text_rounded,
                                    color: const Color.fromARGB(
                                        255, 155, 155, 155)),
                                labelStyle: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontFamily: 'Arial',
                                    color: const Color.fromARGB(
                                        255, 155, 155, 155)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Center(
                          child: Container(
                            width: size.width * 0.9,
                            height: size.height * 0.2,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110),
                                        width: 1),
                                    bottom: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110),
                                        width: 1),
                                    left: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110),
                                        width: 1),
                                    right: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110),
                                        width: 1)),
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              autofocus: false,
                              minLines: 1,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              style: TextStyle(
                                fontSize: size.height * 0.022,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              cursorHeight: size.height * 0.023,
                              controller: _bodyController,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                labelText: 'Mensaje'.tr(),
                                prefixIcon: Icon(Icons.message,
                                    color: const Color.fromARGB(
                                        255, 155, 155, 155)),
                                labelStyle: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontFamily: 'Arial',
                                    color: const Color.fromARGB(
                                        255, 155, 155, 155)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        SizedBox(
                          width: size.width * 0.9,
                          height: size.height * 0.07,
                          child: ElevatedButton(
                              onPressed: () {
                                send();
                                Navigator.pop(context);
                                _bodyController.clear();
                                _subjectController.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 96, 146, 255),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Text(
                                  'Enviar'.tr(),
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: size.height * 0.021,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Arial'),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        /*Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '500 Clay Ave',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: size.height * 0.015,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call,
                              size: size.height * 0.02,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            SizedBox(
                              width: size.width * 0.008,
                            ),
                            InkWell(
                              onTap: () {
                                launchPhoneDialer('2547543503');
                              },
                              child: Text('(254) 754-3503',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          239, 38, 130, 236),
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Arial')),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () => _launchUrlfacebook(),
                                child: Icon(FontAwesomeIcons.facebook)),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            GestureDetector(
                                onTap: () => _launchUrlinstagram(),
                                child: Icon(FontAwesomeIcons.instagram)),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            GestureDetector(
                                onTap: () => _launchUrlx(),
                                child: Icon(FontAwesomeIcons.twitter))
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        )
                      ],
                    ),
                  )),
              context: context);
        },
      ),
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
                        'Hola'.tr(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Bienvenidos'.tr(),
                          style: TextStyle(
                              fontSize: size.height * 0.027,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.bold,
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
            icon: Icon(
              Icons.logout,
              size: size.height * 0.03,
            ),
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

        height: size.height,
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
                                    childAspectRatio: size.height * 0.00045),
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
                                                      gridItems[position].tr(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.014,
                                                        fontFamily: 'Arial',
                                                        fontWeight:
                                                            FontWeight.bold,
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
                  height: size.height * 0.265,
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
                                    aspectRatio: size.height * 0.0022,
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
                            return Column(children: []);
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
                                    aspectRatio: size.height * 0.0022,
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
                            return Column(children: []);
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
                                    aspectRatio: size.height * 0.0022,
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
                      (selectedIndex == 3)
                          ? GestureDetector(
                            onTap: (){
                              Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapaPersonalizadoView()),
    );
                            },
                            child: Container(
                                child: Container(
                                  height: size.height * 0.235,
                                  width: size.width * 0.95,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/img/location.png'),
                                          fit: BoxFit.cover)),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Mapa de Recursos'.tr(), textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.height * 0.025),
                                        ),
                                        SizedBox(width: size.width*0.06,)
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
              Row(
                children: [
                  SizedBox(width: size.width*0.05),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Clases disponibles'.tr(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 148, 148, 148)),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Registro'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                content: Text(
                                  'Para registrarse a una clase por favor acérquese a las oficinas o contáctenos vía teléfono'.tr(),
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
                                        'Cerrar'.tr(),
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
                        color: Theme.of(context).colorScheme.tertiary,
                        size: size.height * 0.026,
                      ))
                ],
              ),
              SizedBox(
                height: size.height * 0.006,
              ),
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
                              height: size.height * 0.356,
                              width: size.width * 0.95,
                              child: GridView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: size.width * 0.02,
                                        crossAxisCount: 2,
                                        childAspectRatio: 1.4),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snap.length,
                                cacheExtent: 1000.0,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['Name'] ==
                                      'ESL Chick-fil-A') {
                                    return const SizedBox
                                        .shrink(); // Oculta este item
                                  }

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
                                      color:
                                          const Color.fromRGBO(4, 99, 128, 1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.04),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/img/back.png'),
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.low,
                                            opacity: 0.4,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  snap[index]['Name'].toString().tr(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.018,
                                                    fontFamily: 'Arial',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
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
